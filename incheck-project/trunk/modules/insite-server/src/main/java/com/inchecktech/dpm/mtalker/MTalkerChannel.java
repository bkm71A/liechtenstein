package com.inchecktech.dpm.mtalker;

import java.util.Map;

import com.inchecktech.dpm.alarmEngine.AlarmEngine;
import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.dsp.DSPFactory;
import com.inchecktech.dpm.persistence.PersistChannelConfig;
import com.inchecktech.dpm.utils.Logger;

public class MTalkerChannel extends Thread {

    private static final Logger logger       = new Logger( MTalkerChannel.class );

    private boolean             shouldRun    = true;
    private int                 sleepSeconds = 30;

    private String              fileDir      = "c:\\mtalker\\queue";
    private String              fileName     = "mtalker.dat";

    private int                 channelId;
    
    private double              freqAdjFactor = 1.0;

    private MTalkerFileReader   fileReader   = new MTalkerFileReader();

    public MTalkerChannel( int channelId ) {
        logger.debug( "MTalker channel initialized.  Channel Id: " + channelId );
        init( channelId );
    }

    public void init( int channelId ) {

        this.channelId = channelId;
        this.setName( "MTalkerChannel-" + channelId );

        Map<String, String> props = PersistChannelConfig.readChannelConfig( channelId );

        try {
            this.sleepSeconds = Integer.parseInt( props.get( "mtalker.sleeprate" ) );
        }
        catch( Exception e ) {
            // do nothing - use default values
        }
        try {
            if (props.get( "mtalker.file.dir" ) != null) {
                this.fileDir = props.get( "mtalker.file.dir" );
            }
        }
        catch( Exception e ) {
            // do nothing - use default values
        }
        try {
            if (props.get( "mtalker.file.name" ) != null) {
                this.fileName = props.get( "mtalker.file.name" );
            }
        }
        catch( Exception e ) {
            // do nothing - use default values
        }
        
        try {
            this.freqAdjFactor = Double.parseDouble( props.get( "mtalker.freqAdjFactor" ) );
        }
        catch( Exception e ) {
            // do nothing - use default values
        }

        logger.debug( this.toString() );
        this.start();

    }

    @Override
    public void run( ) {

        logger.info( "Enter " + this.getName() );

        while( shouldRun ) {

            ICNode node = DataBucket.getICNode( channelId );

            if( node == null ) {
                logger.warn( "CHANNEL ID " + channelId + " is not defined....  skipping" );
                continue;

            }

            try {
                DSPCalculator calc = DataBucket.getDSPCalculator( channelId );

                if( calc == null ) {
                    calc = DSPFactory.newDSPCalculator( channelId );
                    DataBucket.addOrReplaceDSPCalculator( channelId, calc );
                }

                RawData raw = fileReader.loadData( fileDir, fileName, channelId, freqAdjFactor );

                if( raw != null ) {
                    
                    node.setSamplingRate( raw.getSamplingRate() );

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
                    
                }

                sleep( sleepSeconds * 1000 );

            }
            catch( Throwable e ) {
                logger.error( "Exception occured in MTalkerChannel ", e );
                e.printStackTrace();
            }
        }
    }

    @Override
    public String toString( ) {
        StringBuilder sb = new StringBuilder( "\nMTalkerChannel:" );
        sb.append( "\n\t" ).append( "channelId=" ).append( channelId );
        sb.append( "\n\t" ).append( "fileDir=" ).append( fileDir );
        sb.append( "\n\t" ).append( "fileName=" ).append( fileName );
        sb.append( "\n\t" ).append( "sleepSeconds=" ).append( sleepSeconds ).append( "\n" );
        return sb.toString();
    }

}
