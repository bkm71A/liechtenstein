package com.inchecktech.dpm.simulator;

import java.util.Date;
import java.util.Map;

import com.inchecktech.dpm.alarmEngine.AlarmEngine;
import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.dsp.DSPConstants;
import com.inchecktech.dpm.dsp.DSPFactory;
import com.inchecktech.dpm.persistence.PersistChannelConfig;
import com.inchecktech.dpm.persistence.PersistTreeNode;
import com.inchecktech.dpm.utils.Logger;

/**
 * The following properties need to be defined in DB: "com.inchecktech.dpm.sim.samplesize" "com.inchecktech.dpm.sim.rpm"
 * "com.inchecktech.dpm.sim.samplerate" "com.inchecktech.dpm.sim.sleeprate" "com.inchecktech.dpm.sim.tickmod" Update
 * History:
 * <ul>
 * <p>
 * <li>06/05/2008 Taras Dobrovolsky Changed sampling rate, block size keys to use 'real' DAM keys
 */
public class DynamicChannel extends Thread {

    private static final Logger  logger            = new Logger( DynamicChannel.class );

    private boolean              shouldRun         = true;
    private int                  channelId;
    private int                  sampleSize;
    private int                  sampleRate;
    private int                  sleepSeconds;
    private double               rpm;
    private boolean[]            ticks;
    private boolean              addRandom;
    private int                  tickMod           = 20;
    private DynamicDataSumulator sim;

    // Default conversion values, can be redefined in Sensor config (DB or properties file)
    private int                  maxVoltage        = 5;
    private int                  bitResolution     = 16;
    private double               sensorSensitivity = 100;
    private double               sensorBiasVoltage = 2.5;

    /**
     * @param channelId
     */
    public DynamicChannel( int channelId ) {
        logger.debug( "init called" );
        init( channelId );

    }

    public void init( int channelId ) {
        try {
            this.channelId = channelId;
            this.setName( "DynamicChannel-" + channelId );
            this.sleepSeconds=1000*2;

            Map<String, String> props = PersistChannelConfig.readChannelConfig( channelId );
            
            try{
            	this.sampleSize = Integer.parseInt(props.get("com.inchecktech.dpm.dam.BlockSize"));
            }catch (Exception e){}
            
            try{
            	this.rpm = Double.parseDouble(props.get( "com.inchecktech.dpm.sim.rpm"));
            }catch (Exception e){}
            
            try{
            	this.sampleRate = Integer.parseInt(props.get( "com.inchecktech.dpm.dam.SamplingRate"));
            }catch (Exception e){}
            
            try{
            	this.sleepSeconds = Integer.parseInt( props.get( "com.inchecktech.dpm.sim.sleeprate")) * 1000;
            }catch (Exception e){}
            

            try{
            	this.tickMod = Integer.parseInt(props.get("com.inchecktech.dpm.sim.tickmod"));
            }catch (Exception e){}
            
            try{
            	this.addRandom = Boolean.parseBoolean(props.get("com.inchecktech.dpm.sim.random"));
            }catch (Exception e){}


            // TD: Added these values initializations from to properly simulate integer values coming from the
            // controller
            // We need to perform reverse what DSP DefaultUnitConverter is doing
            // set sensor configuration parameters for unit conversion
            try {
                this.maxVoltage = Integer.parseInt( props.get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_MAXVOLTS ) );
            }
            catch( Exception e ) {
                // do nothing - use default values
            }
            try {
                this.bitResolution = Integer.parseInt( props.get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_BITRES ) );
            }
            catch( Exception e ) {
                // do nothing - use default values
            }
            try {
                this.sensorSensitivity = Double
                                               .parseDouble( props
                                                                  .get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_SENCITVTY ) );
            }
            catch( Exception e ) {
                // do nothing - use default values
            }
            try {
                this.sensorBiasVoltage = Double
                                               .parseDouble( props
                                                                  .get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_BIASVOLT ) );
            }
            
            catch( Exception e ) {
                // do nothing - use default values
            }

            this.ticks = new boolean[sampleSize];
            this.sim = new DynamicDataSumulator();
            
            try{
            	
            	sim.setA1(Double.parseDouble(props.get("com.inchecktech.dpm.sim.alpha1")));
            	sim.setA2(Double.parseDouble(props.get("com.inchecktech.dpm.sim.alpha2")));
            	sim.setA3(Double.parseDouble(props.get("com.inchecktech.dpm.sim.alpha3")));
            	sim.setA4(Double.parseDouble(props.get("com.inchecktech.dpm.sim.alpha4")));
            	sim.setA5(Double.parseDouble(props.get("com.inchecktech.dpm.sim.alpha5")));
            	sim.setA6(Double.parseDouble(props.get("com.inchecktech.dpm.sim.alpha6")));
            	sim.setA7(Double.parseDouble(props.get("com.inchecktech.dpm.sim.alpha7")));   	
            	sim.setA8(Double.parseDouble(props.get("com.inchecktech.dpm.sim.alpha8")));
            	
            	sim.setB2(Double.parseDouble(props.get("com.inchecktech.dpm.sim.beta2")));
            	sim.setB3(Double.parseDouble(props.get("com.inchecktech.dpm.sim.beta3")));
            	sim.setB4(Double.parseDouble(props.get("com.inchecktech.dpm.sim.beta4")));
            	sim.setB5(Double.parseDouble(props.get("com.inchecktech.dpm.sim.beta5")));
            	sim.setB6(Double.parseDouble(props.get("com.inchecktech.dpm.sim.beta6")));
            	
            	sim.setG1(Double.parseDouble(props.get("com.inchecktech.dpm.sim.gamma1")));
            	sim.setG2(Double.parseDouble(props.get("com.inchecktech.dpm.sim.gamma2")));
            	
            	sim.setSimLowerRandom(Double.parseDouble(props.get("com.inchecktech.dpm.sim.random.lowerLimit")));
            	sim.setSimUpperRandom(Double.parseDouble(props.get("com.inchecktech.dpm.sim.random.upperLimit")));
            	
            }catch(Exception e){
            	if (null != e){
            		logger.error(e);
            	}
            }
            
            logger.debug(this.toString());
            this.start();

        }
        catch( NumberFormatException e ) {
            logger.error( "Unable to find one of the required properties in channel_config table for channelid="
                          + channelId, e );
        }

    }

    @Override
    public void run( ) {
        logger.info( "Enter " + this.getName() );
        while( shouldRun ) {

            ticks[0] = true;
            for( int i = 1; i < sampleSize; i++ ) {
                ticks[i] = (i % tickMod == 0) ? true : false;
            }

            ICNode node = DataBucket.getICNode( channelId );
            node.setIncomingDataTimestamp(new Date());
            
            if( node == null ) {
                logger.warn( "CHANNEL ID " + channelId + " is not defined....  skipping" );
                continue;

            }

            node.setSamplingRate( sampleRate );
            try {
                DSPCalculator calc = DataBucket.getDSPCalculator( channelId );

                if( calc == null ) {
                    calc = DSPFactory.newDSPCalculator( channelId );
                    DataBucket.addOrReplaceDSPCalculator( channelId, calc );
                }

                logger.debug( "SampRate=" + sampleRate + " for " + channelId );
                RawData raw = new RawData( channelId );
                raw.setChannelId( channelId );
                raw.setSamplingRate( sampleRate );
                raw.setDateTimeStamp( new java.util.Date( System.currentTimeMillis() ) );
                PersistTreeNode.updateNodeIncomingDataTimestamp(node.getId(), raw.getDateTimeStamp());
                raw.setDataTicks( ticks );
                raw.setData( sim.getSimDataInt( sampleSize, rpm, new Double( sampleRate ), addRandom,
                                                sensorSensitivity, bitResolution, maxVoltage, sensorBiasVoltage ) );

                // logger.debug("RAW DATA LENNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN=" + raw.getData().length);

                ChannelState st = calc.processData( raw, null );

                if( calc.isDebugMode() ) { // TD: DEBUG MODE - STORE DSP CORE
                    // DUMP FOR THE CHANNEL
                    DataBucket.putDSPCoreDump( calc.getDspCoreDump().getChannelId(), calc.getDspCoreDump() );
                }

                DataBucket.putChannelState( node.getChannelid(), st );
                node.setProcessedDataKeysString( st.getProcessedData().keySet() );

                try {
                    AlarmEngine alarmEngine = DataBucket.getAlarmEngine( channelId );

                    if( alarmEngine == null ) {
                        alarmEngine = new AlarmEngine();
                        alarmEngine.initAlarmEngine( node );

                        DataBucket.addOrReplaceAlarmEngine( channelId, alarmEngine );
                    }

                    alarmEngine.evaluateThresholds( st );

                }
                catch( Exception ex ) {
                    logger.error( "Exception in Alarm Engine: ", ex );
                }
                logger.debug( "UPDATE STARTED ON DYN CHANNEL " + channelId );
                DataBucket.updateNotifier.notifyUpdate( node );
                logger.debug( "UPDATE ENDED ON DYN CHANNEL " + channelId );

                sleep( sleepSeconds );

            }
            catch( Throwable e ) {
                logger.error( "Exception occured in DynamicChannel", e );
                e.printStackTrace();
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
