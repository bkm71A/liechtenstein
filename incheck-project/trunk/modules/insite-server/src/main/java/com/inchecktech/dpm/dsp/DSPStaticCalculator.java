/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.util.Map;
import java.util.LinkedList;
import java.util.Vector;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.DSPCoreDump;
import com.inchecktech.dpm.beans.EUnit;
import com.inchecktech.dpm.beans.ProcessedStaticData;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.config.ChannelConfigFactory;
import com.inchecktech.dpm.dao.DataBucket;

/**
 * This is the DSP static calculator engine configurable per channel. Threads servicing DAM modules should create own
 * instances.
 * <p>
 * @author Taras Dobrovolsky
 * @author Alex Forkosh
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>11/07/2007 Taras Dobrovolsky Initial release
 *         <li>11/09/2007 Taras Dobrovolsky Added averaging, added recent trend buffer
 *         <li>11/12/2007 Alex Forkosh Changed constructor access level from protected to public
 *         <li>11/20/2007 Taras Dobrovolsky Changed constructor method from public t0 protected. Caller should use
 *         DSPFactory.newDSPCalculator() method to instantiate a calculator object
 *         <li>04/25/2008 Taras Dobrovolsky Minor code changes to support on-demand client requested data processing
 *         </ul>
 */
public final class DSPStaticCalculator implements DSPCalculator {

    int                        channelId;

    private int                recentTrendBufferSize = 100;
    private LinkedList<Double> recentTrend;
    private LinkedList<Double> recentTrendLabels;

    private int                noOfDataBinsToAverage = 10;

    private String             primaryEU;

    private UnitConverter      unitConverter;

    // debug mode flag, set to false by default
    private boolean            debugMode             = false;
    private DSPCoreDump        dspCoreDump;

    /**
     * Callers should not use default constructor, but rather use constructor that will allow them to specify channelId:
     * DSPCalculator(int channelId);
     */
    private DSPStaticCalculator( ) {
        super();
    }

    /**
     * Constructor to be used by callers to instantiate the object with configurations defined for the provided channel
     * @param channelId Channel Id that this calculator object will serve
     */
    protected DSPStaticCalculator( int channelId )
                                                  throws FileNotFoundException, IOException, Exception {
        this();
        init( channelId );
    }

    /**
     * Initialize algorithm sub-engines
     * @param channelId channelId this calculator engine will serve
     * @throws RuntimeException if the method cannot instantiate a class specified in configuration file that implements
     *             interfaces
     */
    private void init( int channelId ) throws RuntimeException {

        Map<String, String> configProps = ChannelConfigFactory.readChannelConfig( channelId );

        this.channelId = channelId;

        try {
            recentTrendBufferSize = Integer
                                           .parseInt( configProps
                                                                 .get( DSPConstants.CONFIG_STATIC_CH_RECENT_TREND_BUFFER_SIZE ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPStaticCalculator: CHANNEL # " + this.channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_STATIC_CH_RECENT_TREND_BUFFER_SIZE
                                        + ": Must be numeric and defined in database.\n\t " + e );
        }
        try {
            noOfDataBinsToAverage = Integer
                                           .parseInt( configProps
                                                                 .get( DSPConstants.CONFIG_STATIC_CH_NO_OF_DATA_BINS_TO_AVERAGE ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPStaticCalculator: CHANNEL # " + this.channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_STATIC_CH_NO_OF_DATA_BINS_TO_AVERAGE
                                        + ": Must be numeric and defined in database.\n\t " + e );
        }
        try {
            primaryEU = configProps.get( DSPConstants.CONFIG_STATIC_CH_PRIMARY_EU );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPStaticCalculator: CHANNEL # " + this.channelId
                                        + ": Configuration Parameter Error " + DSPConstants.CONFIG_STATIC_CH_PRIMARY_EU
                                        + ": Must be defined in database.\n\t " + e );
        }

        recentTrend = new LinkedList<Double>();
        recentTrendLabels = new LinkedList<Double>();

        unitConverter = DSPFactory.newUnitConverter( channelId, configProps );

        int debug = 0;
        try {
            debug = Integer.parseInt( configProps.get( DSPConstants.CONFIG_CH_DEBUG_MODE ) );
        }
        catch( Exception e ) { /* do nothing - assume the channel is not in debug mode */
        }
        if( debug == 0 ) {
            this.debugMode = false;
        }
        else {
            this.debugMode = true;
        }
        if( this.debugMode ) {
            dspCoreDump = new DSPCoreDump( channelId );
        }
    }

    
    public ChannelState processData( RawData rawData, String[] methods ) throws InvalidAlgorithmParameterException,
                                                                        RuntimeException {

        ChannelState channelState = null;

        try {

            java.util.Date dateTimeStamp = new java.util.Date( System.currentTimeMillis() );
            rawData.setDateTimeStamp( dateTimeStamp );

            if( debugMode ) { // COLLECT DATA FOR ANALYSIS
                dspCoreDump.clear();
                dspCoreDump.setDateTimeStamp( dateTimeStamp );
                dspCoreDump.addMetaData( "Channel Id=" + rawData.getChannelId() );
                dspCoreDump.addMetaData( "DateTime=" + dateTimeStamp.toString() );
                dspCoreDump.addDataSet( rawData.getData(), "Raw Data from DAM" );
            }
            
            channelState = DataBucket.getChannelState(rawData.getChannelId());
			if (channelState == null) {
				channelState = new ChannelState(rawData.getChannelId(), ChannelState.CHANNEL_TYPE_STATIC);
			}
			
            if( rawData == null || rawData.getData().length == 0 ) {
                return channelState;
            }

            // convert data to engineering units
            ProcessedStaticData data = new ProcessedStaticData( rawData.getChannelId() );
            data.setSamplingRate( rawData.getSamplingRate() );
            data.setEU( primaryEU );
            data.setDateTimeStamp( dateTimeStamp );
            data.setData( unitConverter.convertToGs( rawData.getData() ) ); // convert to engineering units

            if( debugMode ) { // COLLECT DATA FOR ANALYSIS
                dspCoreDump.addDataSet( unitConverter.convertToVolts( rawData.getData() ),
                                        "Raw Data Converted To Volts" );
                dspCoreDump.addDataSet( unitConverter.convertToGs( rawData.getData() ), "Raw Data Converted To EU" );
            }

            OverallLevels overalls = new OverallLevels( rawData.getChannelId() );

            // average of the first N data points
            double sum = 0, avg;
            int i;
            for( i = 0; (i < noOfDataBinsToAverage) && (i < data.getData().size()); i++ ) {
                sum = sum + data.getData().get( i );
            }
            avg = sum / i;
            overalls.addOverall( primaryEU, new Double( avg ) );

            if( debugMode ) { // COLLECT DATA FOR ANALYSIS
                dspCoreDump.addMetaData( "Average Value EU=" + avg );
            }
            
            // add calculated value to the recent trend queue, and add a time label
            recentTrend.add( new Double( avg ) );
            recentTrendLabels.add( new Double( dateTimeStamp.getTime() ) );
            
            LinkedList<Double> newTrend = new LinkedList<Double>();
            LinkedList<Double> newTrendLbl = new LinkedList<Double>();

            // remove elements older than specified buffer limit in seconds
            for (int k = 0; k < recentTrendLabels.size(); k++) {
                if (recentTrendLabels.get( k ) > (dateTimeStamp.getTime() - recentTrendBufferSize * 1000)) {
                    newTrend.add( recentTrend.get( k ) );
                    newTrendLbl.add( recentTrendLabels.get( k ) );
                }
            }
            
            recentTrend = newTrend;
            recentTrendLabels = newTrendLbl;

            Vector<Double> vec = new Vector<Double>( recentTrend.size() );
            for( int j = 0; j < recentTrend.size(); j++ ) {
                vec.add( new Double( recentTrend.get( recentTrend.size() - j - 1 ) ) );
            }

            Vector<Double> labels = new Vector<Double>( recentTrendLabels.size() );
            for( int j = 0; j < recentTrendLabels.size(); j++ ) {
                labels.add( new Double( recentTrendLabels.get( recentTrendLabels.size() - j - 1 ) ) );
            }

            data.setOveralls( overalls );
            data.setData( vec );
            data.setDataLabels( labels );

            data.setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_MS );
            data.setMeasurementType( ProcessedData.MEASUREMENT_TYPE_ABSOLUTE );
            
            // TODO: TLD (If there are any other sensor types - make robust to handle)
            // Use com.inchecktech.dpm.dsp.ChannelPrimaryEngineeringUnits configuration parameter
            data.setYEUnit( EUnit.TempC );
            data.setXEUnit( EUnit.TimeMiliSec );

            channelState.addProcessedData( ProcessedData.KEY_TREND, data );
            channelState.setOverallTrendKey( ProcessedData.KEY_TREND );

            if( debugMode ) { // COLLECT DATA FOR ANALYSIS
                dspCoreDump.addDataSet( data.getData(), "Resent Trend EU w Buffer Size " + recentTrendBufferSize );
            }

        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPStaticCalculator: CHANNEL # " + this.channelId
                                        + ": Error processing static channel data from the controller.\n\t " + e );
        }

        return channelState;
    }

    /**
     * For static channels this method does not apply any processing to the input data set, and returns it unchanged.
     */
    @Deprecated
    public ProcessedData processData( ProcessedData data, String calcMethod )
                                                                             throws InvalidAlgorithmParameterException,
                                                                             RuntimeException {
        return data;
    }
    
    /**
     * For static channels this method does not apply any processing to the input data set, and returns it unchanged.
     */
    public ProcessedData processData( ProcessedData data, String calcMethod, EUnit xUnitTarget, EUnit yUnitTarget, double centralFrequency, int frequencyDeviation )
                                                                             throws InvalidAlgorithmParameterException,
                                                                             RuntimeException {
        data.convertToEUnitsX( xUnitTarget );
        data.convertToEUnitsY( yUnitTarget );
        return data;
    }

    public void reload( ) throws RuntimeException {
        init( this.channelId );
    }

    /**
     * Check if the current DSP Calculator object runs in debug mode
     * @return the debugMode
     */
    public boolean isDebugMode( ) {
        return debugMode;
    }

    /**
     * Returns the latest DSPCoreDump object containing data for analysis/debugging
     * @return the dspCoreDump
     */
    public DSPCoreDump getDspCoreDump( ) {
        return dspCoreDump;
    }

    /**
     * Returns the key for the primary/default ProcessedData object (99% of the time it will be acceleration for dynamic
     * channel, and trend for static). Hard-coded for static channel.
     * @return the key for the primary/default ProcessedData object
     */
    public String getPrimaryProcessedDataKey( ) {
        return ProcessedData.KEY_TREND;
    }

    /**
     * @see com.inchecktech.dpm.dsp.DSPCalculator#getChannelId()
     */
    public int getChannelId() {
    	return this.channelId;
    }
}
