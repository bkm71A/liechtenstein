package com.incheck.ng.dsp.library.simulator;

import static com.incheck.ng.model.ChannelConfigConstant.BLOCK_SIZE;
import static com.incheck.ng.model.ChannelConfigConstant.CONVERTER_BIT_RESOLUTION;
import static com.incheck.ng.model.ChannelConfigConstant.CONVERTER_SENSOR_BIAS_VOLTAGE;
import static com.incheck.ng.model.ChannelConfigConstant.CONVERTER_SENSOR_SENSITIVITY;
import static com.incheck.ng.model.ChannelConfigConstant.MAX_VOLTS;
import static com.incheck.ng.model.ChannelConfigConstant.SAMPLING_RATE;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_ALPHA1;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_ALPHA2;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_ALPHA3;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_ALPHA4;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_ALPHA5;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_ALPHA6;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_ALPHA7;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_ALPHA8;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_BETA2;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_BETA3;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_BETA4;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_BETA5;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_BETA6;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_GAMMA1;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_GAMMA2;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_RANDOM;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_RANDOM_LOWER_LIMIT;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_RANDOM_UPPER_LIMIT;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_SLEEPRATE;
import static com.incheck.ng.model.ChannelConfigConstant.SIM_TICKMOD;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.incheck.ng.dao.ChannelDao;
import com.incheck.ng.model.Channel;
import com.incheck.ng.model.data.RawData;

@SuppressWarnings("unused")
public class DynamicChannel extends Thread {
    private final static Log logger = LogFactory.getLog(DynamicChannel.class);
    private boolean shouldRun = true;
    private long channelId;
    private int sampleSize;
    private int sampleRate;
    private int sleepSeconds;
    private double rpm;
    private boolean[] ticks;
    private boolean addRandom;
    private int tickMod = 20;
    private DynamicDataSumulator sim;
    // Default conversion values, can be redefined in Sensor config (DB or properties file)
    private int maxVoltage = 5;
    private int bitResolution = 16;
    private double sensorSensitivity = 100;
    private double sensorBiasVoltage = 2.5;

    public DynamicChannel(int channelId) {
        logger.debug("init called");
        init(channelId);
    }

    public void init(long channelId) {
        try {
            this.channelId = channelId;
            this.setName("DynamicChannel-" + channelId);
            this.sleepSeconds = 1000 * 2;
            ChannelDao channelDao = null;
            Channel chanel = channelDao.get(channelId);
            Map<String, String> channelConfig = chanel.getChannelConfig();
            sampleSize = Integer.parseInt(channelConfig.get(BLOCK_SIZE));
            rpm = Double.parseDouble(channelConfig.get("com.inchecktech.dpm.sim.rpm"));
            sampleRate = Integer.parseInt(channelConfig.get(SAMPLING_RATE));
            maxVoltage = Integer.parseInt(channelConfig.get(MAX_VOLTS));
            bitResolution = Integer.parseInt(channelConfig.get(CONVERTER_BIT_RESOLUTION));
            sensorSensitivity = Double.parseDouble(channelConfig.get(CONVERTER_SENSOR_SENSITIVITY));
            sensorBiasVoltage = Double.parseDouble(channelConfig.get(CONVERTER_SENSOR_BIAS_VOLTAGE));
            sleepSeconds = Integer.parseInt(channelConfig.get(SIM_SLEEPRATE)) * 1000;
            tickMod = Integer.parseInt(channelConfig.get(SIM_TICKMOD));
            addRandom = Boolean.parseBoolean(channelConfig.get(SIM_RANDOM)); 
            ticks = new boolean[sampleSize];
            sim = new DynamicDataSumulator();
//            sim.setA1(Double.parseDouble(channelConfig.get(SIM_ALPHA1)));
//            sim.setA2(Double.parseDouble(channelConfig.get(SIM_ALPHA2)));
//            sim.setA3(Double.parseDouble(channelConfig.get(SIM_ALPHA3)));
//            sim.setA4(Double.parseDouble(channelConfig.get(SIM_ALPHA4)));
//            sim.setA5(Double.parseDouble(channelConfig.get(SIM_ALPHA5)));
//            sim.setA6(Double.parseDouble(channelConfig.get(SIM_ALPHA6)));
//            sim.setA7(Double.parseDouble(channelConfig.get(SIM_ALPHA7)));
//            sim.setA8(Double.parseDouble(channelConfig.get(SIM_ALPHA8)));
//            sim.setB2(Double.parseDouble(channelConfig.get(SIM_BETA2)));
//            sim.setB3(Double.parseDouble(channelConfig.get(SIM_BETA3)));
//            sim.setB4(Double.parseDouble(channelConfig.get(SIM_BETA4)));
//            sim.setB5(Double.parseDouble(channelConfig.get(SIM_BETA5)));
//            sim.setB6(Double.parseDouble(channelConfig.get(SIM_BETA6)));
//            sim.setG1(Double.parseDouble(channelConfig.get(SIM_GAMMA1)));
//            sim.setG2(Double.parseDouble(channelConfig.get(SIM_GAMMA2)));
//            sim.setSimLowerRandom(Double.parseDouble(channelConfig.get(SIM_RANDOM_LOWER_LIMIT)));
//            sim.setSimUpperRandom(Double.parseDouble(channelConfig.get(SIM_RANDOM_UPPER_LIMIT)));
            logger.debug(this.toString());
            start();
        } catch (NumberFormatException e) {
            logger.fatal("Unable to find one of the required properties in channel_config table for channelid=" + channelId, e);
        }
    }

    @Override
    public void run() {
        logger.info("Enter " + this.getName());
        while (shouldRun) {
            ticks[0] = true;
            for (int i = 1; i < sampleSize; i++) {
                ticks[i] = (i % tickMod == 0) ? true : false;
            }
            // ICNode node = DataBucket.getICNode( channelId );
            // node.setIncomingDataTimestamp(new Date());
            //            
            // if( node == null ) {
            // logger.warn( "CHANNEL ID " + channelId +
            // " is not defined....  skipping" );
            // continue;
            //
            // }
            // node.setSamplingRate( sampleRate );
            try {
                // DSPCalculator calc = DataBucket.getDSPCalculator( channelId
                // );
                //
                // if( calc == null ) {
                // calc = DSPFactory.newDSPCalculator( channelId );
                // DataBucket.addOrReplaceDSPCalculator( channelId, calc );
                // }
                RawData raw = new RawData(channelId, sampleRate, null);
           
                // PersistTreeNode.updateNodeIncomingDataTimestamp(node.getId(),
                // raw.getDateTimeStamp());
                // raw.setDataTicks( ticks );
                // raw.setData( sim.getSimDataInt( sampleSize, rpm, new Double(
                // sampleRate ), addRandom,
                // sensorSensitivity, bitResolution, maxVoltage,
                // sensorBiasVoltage ) );
                //
                //
                // ChannelState st = calc.processData( raw, null );
                // DataBucket.putChannelState( node.getChannelid(), st );
                // node.setProcessedDataKeysString(
                // st.getProcessedData().keySet() );
                //
                // try {
                // AlarmEngine alarmEngine = DataBucket.getAlarmEngine(
                // channelId );
                //
                // if( alarmEngine == null ) {
                // alarmEngine = new AlarmEngine();
                // alarmEngine.initAlarmEngine( node );
                //
                // DataBucket.addOrReplaceAlarmEngine( channelId, alarmEngine );
                // }
                // alarmEngine.evaluateThresholds( st );
                // }
                // catch( Exception ex ) {
                // logger.error( "Exception in Alarm Engine: ", ex );
                // }
                logger.debug("UPDATE STARTED ON DYN CHANNEL " + channelId);
                // DataBucket.updateNotifier.notifyUpdate( node );
                logger.debug("UPDATE ENDED ON DYN CHANNEL " + channelId);
                sleep(sleepSeconds);
            } catch (Throwable e) {
                logger.error("Exception occured in DynamicChannel", e);
            }
        }
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("\nDynamicChannel:");
        sb.append("\n\t").append("channelId=").append(channelId);
        sb.append("\n\t").append("sampleSize=").append(sampleSize);
        sb.append("\n\t").append("sleepSeconds=").append(sleepSeconds).append("\n");
        sb.append("\n\t").append("rpm=").append(rpm).append("\n");
        sb.append("\n\t").append("ticks=").append(ticks).append("\n");
        sb.append("\n\t").append("addRandom=").append(addRandom).append("\n");
        sb.append("\n\t").append("tickMod=").append(tickMod).append("\n");
        sb.append("\n\t").append("maxVoltage=").append(maxVoltage).append("\n");
        sb.append("\n\t").append("bitResolution=").append(bitResolution).append("\n");
        sb.append("\n\t").append("sensorSensitivity=").append(sensorSensitivity).append("\n");
        sb.append("\n\t").append("sensorBiasVoltage=").append(sensorBiasVoltage).append("\n");
        return sb.toString();
    }
}
