package com.inchecktech.dpm.simulator;

import java.util.Date;
import java.util.Map;

import com.inchecktech.dpm.alarmEngine.AlarmEngine;
import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.dsp.DSPFactory;
import com.inchecktech.dpm.persistence.PersistChannelConfig;
import com.inchecktech.dpm.persistence.PersistTreeNode;
import com.inchecktech.dpm.utils.HashUtil;
import com.inchecktech.dpm.utils.Logger;

/**
 * The following properties need to be defined in DB:
 * "com.inchecktech.dpm.sim.samplesize" "com.inchecktech.dpm.sim.samplerate"
 * "com.inchecktech.dpm.sim.sleeprate" "com.inchecktech.dpm.sim.upperLimit"
 * "com.inchecktech.dpm.sim.lowerLimit"
 */
public class StaticChannel extends Thread {

	private static final Logger logger = new Logger(StaticChannel.class);
	private int channelId;
	private double lowerLimit;
	private double upperLimit;
	private int sampleRate;
	private boolean shouldRun = true;
	private int sleepSeconds;
	public static final int SAMPLE_SIZE = 1024;
	
	private int[] getStaticData(){
		int []retval = HashUtil.getRandom(lowerLimit, upperLimit, SAMPLE_SIZE);
		return retval;
	}

	public StaticChannel(int channelId) {

		try {

			this.channelId = channelId;
			this.setName("StaticChannel-" + channelId);

			Map<String, String> props = PersistChannelConfig
					.readChannelConfig(channelId);

			this.sampleRate = Integer.parseInt(props
					.get("com.inchecktech.dpm.sim.samplerate"));
			this.upperLimit = Double.parseDouble(props
					.get("com.inchecktech.dpm.sim.upperLimit"));
			this.lowerLimit = Double.parseDouble(props
					.get("com.inchecktech.dpm.sim.lowerLimit"));
			this.sleepSeconds = Integer.parseInt(props
					.get("com.inchecktech.dpm.sim.sleeprate")) * 1000;


			this.start();

		} catch (NumberFormatException e) {
			logger
					.error(
							"Unable to find one of the required properties in channel_config table for channelid="
									+ channelId, e);
		}

	}

	@Override
	public void run() {
		logger.info("Enter " + this.getName());
		while (shouldRun) {
			try {
				ICNode node = DataBucket.getICNode(channelId);
				node.setIncomingDataTimestamp(new Date());
				if (node == null) {
					logger.warn("CHANNEL ID " + channelId
							+ " is not defined....  skipping");
					continue;

				} else {
					node.setSamplingRate(sampleRate);
				}
				
				DSPCalculator calc = DataBucket.getDSPCalculator(channelId);

				if (calc == null) {
					calc = DSPFactory.newDSPCalculator(channelId);
					DataBucket.addOrReplaceDSPCalculator(channelId, calc);
				}
				
				RawData raw = new RawData(channelId);
				raw.setChannelId(channelId);
				raw.setSamplingRate(sampleRate);
				raw.setDateTimeStamp(new java.util.Date(System
						.currentTimeMillis()));
				PersistTreeNode.updateNodeIncomingDataTimestamp(node.getId(), raw.getDateTimeStamp());
				raw.setData(getStaticData());
				ChannelState st = calc.processData(raw, null);

				OverallLevels levels = st.getPrimaryProcessedData().getOveralls();
				
				for (String key : levels.getKeys()){
					logger.debug("\n ************************************************");
					logger.debug("st=" + levels.getOverall(key) + " key=" + key);
					logger.debug("\n ************************************************");
				}
				
				DataBucket.putChannelState(node.getChannelid(), st);
				node.setProcessedDataKeysString(st.getProcessedData().keySet());

				try {
					AlarmEngine alarmEngine = DataBucket
							.getAlarmEngine(channelId);

					if (alarmEngine == null) {
						alarmEngine = new AlarmEngine();
						alarmEngine.initAlarmEngine(node);

						DataBucket.addOrReplaceAlarmEngine(channelId,
								alarmEngine);
					}
					alarmEngine.evaluateThresholds(st);

				} catch (Exception ex) {
					logger.error("Exception in Alarm Engine: ", ex);
				}
				
				logger.debug("UPDATE STARTED ON STAT CHANNEL " + channelId);
				DataBucket.updateNotifier.notifyUpdate(node);
				logger.debug("UPDATE ENDED ON STAT CHANNEL " + channelId);
				sleep(sleepSeconds);
			} catch (Throwable e) {
				logger.error("Exception occured in StaticChannel:\n", e);
			}// and global try
		}// end while
	}// end method
}