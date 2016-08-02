package com.inchecktech.dpm.config;

import java.util.List;
import java.util.Map;

import com.inchecktech.dpm.alarmEngine.AlarmEngine;
import com.inchecktech.dpm.beans.Channel;
import com.inchecktech.dpm.beans.Device;
import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.persistence.PersistChannelConfig;
import com.inchecktech.dpm.persistence.PersistDeviceConfig;
import com.inchecktech.dpm.persistence.PersistSpecAnalysisConfig;
import com.inchecktech.dpm.utils.Logger;

public class ChannelConfigFactory {
	private static final Logger logger = new Logger(ChannelConfigFactory.class);

	/**
	 * 
	 * @param channelConfigItem
	 * @return
	 */
	public static Status updateConfigItem(ChannelConfigItem channelConfigItem) {
		return PersistChannelConfig.updateOverrideConfigItem(channelConfigItem
				.getChannel_id(), channelConfigItem.getProperty_id(),
				channelConfigItem.getPropertyValue());
	}

	/**
	 * 
	 * @param config
	 * @return
	 */
	public static Status updateConfigItems(ChannelConfig config) {
		Status status = new Status();
		for (ChannelConfigItem item : config.getChannelConfigItems()) {
			status = updateConfigItem(item);
		}
		return status;
	}

	public static ChannelConfig getChannelConfig(List<String> channelTypes) {
		return PersistChannelConfig.getChannelConfig(channelTypes);
	}

	public static ChannelConfig getChannelConfig(int channelId) {
		return PersistChannelConfig.getChannelConfig(channelId);
	}

	@Deprecated
	public static Map<String, String> readChannelConfig(int channelId) {
		return PersistChannelConfig.readChannelConfig(channelId);
	}

	/**
	 * 
	 * @param config
	 * @return
	 */
	public static Status updateSpectrumConfig(SpectrumAnalysisConfig config) {
		Status status = PersistSpecAnalysisConfig.updateSpecForChannel(config);
		DSPCalculator dspCalculator = DataBucket.getDSPCalculator(config.getChannelId());
		if (dspCalculator != null) {
			dspCalculator.reload();
		} else {
			logger
					.error("Can not reload DSPCalculator. The DSPCalculator for channel: "
							+ config.getChannelId() + " is null.");
		}
		AlarmEngine al = DataBucket.getAlarmEngine(config.getChannelId());
		try {
			al.reloadThresholds();
		} catch (Exception e) {
			logger
					.error("An error occured while reloading alarm thresholds",
							e);
		}
		return status;

	}

	/**
	 * 
	 * @param macAddress
	 * @return
	 */
	public static Device getDevice(String macAddress) {
		Device device = PersistDeviceConfig.getDevice(macAddress);

		for (Channel channel : device.getChannels()) {
			channel.setChannelConfig(ChannelConfigFactory
					.getChannelConfig(channel.getChannelId()));
		}

		return device;
	}

}