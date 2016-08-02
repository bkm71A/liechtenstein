                                                                     
                                                                     
                                                                     
                                             
/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.DSPCoreDump;
import com.inchecktech.dpm.beans.EUnit;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.PhysicalDomain;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.ProcessedDynamicData;
import com.inchecktech.dpm.beans.ProcessedStaticData;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.config.ChannelConfigFactory;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.flex.DPMFlexProxy;
import com.inchecktech.dpm.utils.Logger;

/**
 * This is the DSP dynamic calculator engine configurable per channel. Threads servicing DAM modules should create own
 * instances.
 * <p>
 * @author Taras Dobrovolsky
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>11/07/2007 Taras Dobrovolsky Initial release
 *         <li>11/03/2007 Taras Dobrovolsky Added RPM calculations
 *         <li>11/07/2007 Major changes to calculations
 *         <li>11/12/2007 Alex Forkosh Changed constructor access level from protected to public
 *         <li>11/20/2007 Taras Dobrovolsky Changed constructor method from public t0 protected. Caller should use
 *         DSPFactory.newDSPCalculator() method to instantiate a calculator object
 *         <li>01/13/2008 - 01/20/2008 Taras Dobrovolsky Major adjustments to calculations
 *         <li>04/24/2008 - 04/29/2008 Taras Dobrovolsky Added a new method for calculations on-demand from GUI. Major
 *         code changes.
 *         <li>08/31/2008 Taras Dobrovolsky Changed the data stamping logic - data/time is used from provided RawData object
 *         </ul>
 */
public class DSPDynamicCalculator implements DSPCalculator {

    private static final Logger logger                         = new Logger( DSPDynamicCalculator.class );

    // private calculation algorithms
    private Resampler           resampler;
    private UnitConverter       unitConverter;
    private WeightingAlg        weightingAlg;
    private FFTTransformer      fftTransformer;
    private Integrator          integrator;
    private Filter              highPassFilter;
    private Filter              lowPassFilter;  
    private Filter				dcFilter;

    // private additional configuration parameters
    int                         channelId;
    // default to 1, used in RPM calculations
    private int                 ticksPerRevolution             = 1;

    // Channel engineering units (99% it will be 'A' - Acceleration)
    String                      primaryEU;

    // Sampling rate used for calculations
    private int                 newSamplingRate                = 2048;

    // optional filter order parameters
    private int                 hpFilterOrder                  = 2;
    private int                 hpFilterOrderBrnDem            = 6;
    private int                 hpFilterOrderBrnDemPreFFT      = 2;
    private int                 lpFilterOrder                  = 6;

    // high-pass filter cutoff frequencies
    private double              hpFilterCutoffPreIntToVel      = 2D;
    private double              hpFilterCutoffPostIntToVel     = 2D;
    private double              hpFilterCutoffPostIntToDspl    = 2D;
    private double              hpFilterCutoffPreFFTAcc        = 2D;

    // Bearing Demodulation High and Low Pass Filters Cutoff Frequencies
    private double              bearingDemHighPassCuttof       = 800D;
    private double              bearingDemLowPassCuttof        = 800D;
    private double              bearingDemHighPassCuttofPreFFT = 2D;

    // Overalls buffer in seconds: only one overall type per channel is allowed
    private int                 recentTrendBufferSize          = 2000;

    private LinkedList<Double>  overallsRecentTrendPeakAccel;
	private LinkedList<Double>  overallsRecentTrendRMSAccel;
	private LinkedList<Double>  overallsRecentTrendPeakVel;
	private LinkedList<Double>  overallsRecentTrendRMSVel;
	
    private LinkedList<Double>  overallsRecentTrendLblPeakAccel;
	private LinkedList<Double>  overallsRecentTrendLblRMSAccel;
	private LinkedList<Double>  overallsRecentTrendLblPeakVel;
	private LinkedList<Double>  overallsRecentTrendLblRMSVel;

    // Overalls type to calculate in idle client-less mode: Acceleration, Velocity, Displacement
    private String              overallType;
    private String              overallSubType;

    // The key for default processed data object
    private String              primaryProcessedDataKey;

    private int                 analysisBandwidth              = 1000;

    // Adjustment factors for frequency and gain
    private double              adjFactorFreq                  = 1D;
    private double              adjFactorGain                  = 1D;

    // debug mode flag, set to false by default
    private boolean             debugMode                      = false;
    private DSPCoreDump         dspCoreDump;
    
    // settings for DC Filtering - global per channel
    private int 				dcFltrSmoothingFactor			= 500;

    /**
     * Callers should not use default constructor, but rather use constructor that will allow them to specify channelId:
     * DSPCalculator(int channelId);
     */
    private DSPDynamicCalculator( ) {
        super();
    }

    /**
     * Constructor to be used by callers to instantiate the object with configurations defined for the provided channel
     * @param channelId Channel Id that this calculator object will serve
     */
    protected DSPDynamicCalculator( int channelId )
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

        // load configuration properties from database
        Map<String, String> configProps = ChannelConfigFactory.readChannelConfig( channelId );

        resampler = DSPFactory.newResampler( channelId, configProps );
        unitConverter = DSPFactory.newUnitConverter( channelId, configProps );
        weightingAlg = DSPFactory.newWeightingAlg( channelId, configProps );
        fftTransformer = DSPFactory.newFFTTransformer( channelId, configProps );
        integrator = DSPFactory.newIntegrator( channelId, configProps );

        highPassFilter = DSPFactory.newHighPassFilter( channelId, configProps );
        lowPassFilter = DSPFactory.newLowPassFilter( channelId, configProps );
        
        dcFilter	  = new DCFilter();

        // load additional configuration parameters
        try {
            ticksPerRevolution = Integer
                                        .parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_RPMCALC_TICKSPERREV ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_RPMCALC_TICKSPERREV
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }
        try {
            primaryEU = configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_PRIMARY_EU );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_PRIMARY_EU
                                        + ": Must be and defined in database.\n\t " + e );
        }
        try {
            newSamplingRate = Integer.parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_CALC_SAMPL_RATE ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_CALC_SAMPL_RATE
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }

        // load high-pass filter cutoff frequencies for calculation steps
        try {
            hpFilterCutoffPreFFTAcc = Double
                                            .parseDouble( configProps
                                                                     .get( DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_PREFFTACC_CUTOFF ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_PREFFTACC_CUTOFF
                                        + ": Must be numeric (double) and defined in database.\n\t " + e );
        }
        try {
            hpFilterCutoffPreIntToVel = Double
                                              .parseDouble( configProps
                                                                       .get( DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_PREINTTOVEL_CUTOFF ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_PREINTTOVEL_CUTOFF
                                        + ": Must be numeric (double) and defined in database.\n\t " + e );
        }
        try {
            hpFilterCutoffPostIntToVel = Double
                                               .parseDouble( configProps
                                                                        .get( DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_POSTINTTOVEL_CUTOFF ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_POSTINTTOVEL_CUTOFF
                                        + ": Must be numeric (double) and defined in database.\n\t " + e );
        }
        try {
            hpFilterCutoffPostIntToDspl = Double
                                                .parseDouble( configProps
                                                                         .get( DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_PREINTTODISPL_CUTOFF ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_PREINTTODISPL_CUTOFF
                                        + ": Must be numeric (double) and defined in database.\n\t " + e );
        }

        // Bearing Demodulation High and Low Pass Filters Cutoff Frequencies
        try {
            bearingDemHighPassCuttof = Double
                                             .parseDouble( configProps
                                                                      .get( DSPConstants.CONFIG_DYNAMIC_CH_BRNG_DEM_HIGH_PASS_FILTER_CUTOFF ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_BRNG_DEM_HIGH_PASS_FILTER_CUTOFF
                                        + ": Must be numeric (double) and defined in database.\n\t " + e );
        }
        try {
            bearingDemLowPassCuttof = Double
                                            .parseDouble( configProps
                                                                     .get( DSPConstants.CONFIG_DYNAMIC_CH_BRNG_DEM_LOW_PASS_FILTER_CUTOFF ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_BRNG_DEM_LOW_PASS_FILTER_CUTOFF
                                        + ": Must be numeric (double) and defined in database.\n\t " + e );
        }
        try {
            bearingDemHighPassCuttofPreFFT = Double
                                                   .parseDouble( configProps
                                                                            .get( DSPConstants.CONFIG_DYNAMIC_CH_BRNG_DEM_PASS_FILTER_CUTOFF_PFFT ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_BRNG_DEM_PASS_FILTER_CUTOFF_PFFT
                                        + ": Must be numeric (double) and defined in database.\n\t " + e );
        }

        // load/initialize parameters for overalls recent trend
        try {
            recentTrendBufferSize = Integer
                                           .parseInt( configProps
                                                                 .get( DSPConstants.CONFIG_DYNAMIC_CH_RECENT_TREND_BUFFER_SZ ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_RECENT_TREND_BUFFER_SZ
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }

        try {
            overallType = configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_OVERALLS_TYPE );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_OVERALLS_TYPE
                                        + ": Must be and defined in database.\n\t " + e );
        }

        // check that the overall configuration parameters is specified correctly
        if( (overallType == null)
            || (!overallType.equals( ProcessedData.EU_ACCELERATION_ABBR )
                && !overallType.equals( ProcessedData.EU_VELOCITY_ABBR ) && !overallType
                                                                                        .equals( ProcessedData.EU_DISPLACEMENT_ABBR )) ) {

            overallType = ProcessedData.EU_ACCELERATION_ABBR; // set default to acceleration
            logger.error( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                          + ": Configuration Parameter Error " + DSPConstants.CONFIG_DYNAMIC_CH_OVERALLS_TYPE
                          + ": Must be and defined in database with one of the following keys: "
                          + ProcessedData.EU_ACCELERATION_ABBR + "," + ProcessedData.EU_VELOCITY_ABBR + ","
                          + ProcessedData.EU_DISPLACEMENT_ABBR + ".  Using default value "
                          + ProcessedData.EU_ACCELERATION_ABBR + " .\n\t " );
        }

        try {
            overallSubType = configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_OVERALLS_SUB_TYPE );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_OVERALLS_SUB_TYPE
                                        + ": Must be and defined in database.\n\t " + e );
        }

        // check that the overall configuration parameters is specified correctly
        if( (overallSubType == null)
            || (!overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_RMS )
                && !overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_PEAK )
                && !overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_DER_PEAK )
                && !overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_DER_P2P ) && !overallSubType
                                                                                                      .equals( ProcessedData.KEY_OVRL_SUBTYPE_P2P )) ) {

            overallSubType = ProcessedData.KEY_OVRL_SUBTYPE_RMS; // set default to RMS
            logger.error( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                          + ": Configuration Parameter Error " + DSPConstants.CONFIG_DYNAMIC_CH_OVERALLS_SUB_TYPE
                          + ": Must be and defined in database with one of the following keys: "
                          + ProcessedData.KEY_OVRL_SUBTYPE_RMS + "," + ProcessedData.KEY_OVRL_SUBTYPE_PEAK + ","
                          + ProcessedData.KEY_OVRL_SUBTYPE_DER_PEAK + "," + ProcessedData.KEY_OVRL_SUBTYPE_DER_P2P
                          + "," + ProcessedData.KEY_OVRL_SUBTYPE_P2P + ".  Using default value "
                          + ProcessedData.KEY_OVRL_SUBTYPE_RMS + " .\n\t " );
        }

        // key for the default processed data set
        try {
            primaryProcessedDataKey = configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_DEFAULT_PROC_DATA_KEY );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_DEFAULT_PROC_DATA_KEY
                                        + ": Must be and defined in database.\n\t " + e );
        }

        // check that the key for the default processed data set parameter is specified correctly
        if( (primaryProcessedDataKey == null)
            || (!primaryProcessedDataKey.equals( ProcessedData.KEY_TIMEWAVE_ACC )
                && !primaryProcessedDataKey.equals( ProcessedData.KEY_TIMEWAVE_VEL ) && !primaryProcessedDataKey
                                                                                                                .equals( ProcessedData.KEY_TIMEWAVE_DISPL )) ) {

            primaryProcessedDataKey = ProcessedData.KEY_TIMEWAVE_ACC; // set default to acceleration
            logger.error( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                          + ": Configuration Parameter Error " + DSPConstants.CONFIG_DYNAMIC_CH_DEFAULT_PROC_DATA_KEY
                          + ": Must be and defined in database with one of the following keys: "
                          + ProcessedData.KEY_TIMEWAVE_ACC + "," + ProcessedData.KEY_TIMEWAVE_VEL + ","
                          + ProcessedData.KEY_TIMEWAVE_DISPL + "," + ".  Using default value "
                          + ProcessedData.KEY_TIMEWAVE_ACC + " .\n\t " );
        }

        // load filter order parameters
        try {
            hpFilterOrder = Integer.parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }
        if( hpFilterOrder % 2 != 0 ) {
            hpFilterOrder = 2; // set default value
            logger.error( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                          + ": Configuration Parameter Error " + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER
                          + ": Must be and defined in database with one of the following values: 2, 4, 6, 8, 10, 12 "
                          + ".  Using default value 2 .\n\t " );
        }

        try {
            lpFilterOrder = Integer.parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_LPFILTER_FILTER_ORDER ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_LPFILTER_FILTER_ORDER
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }
        if( lpFilterOrder % 2 != 0 ) {
            lpFilterOrder = 6; // set default value
            logger.error( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                          + ": Configuration Parameter Error " + DSPConstants.CONFIG_DYNAMIC_CH_LPFILTER_FILTER_ORDER
                          + ": Must be and defined in database with one of the following values: 2, 4, 6, 8, 10, 12 "
                          + ".  Using default value 6 .\n\t " );
        }

        try {
            hpFilterOrderBrnDem = Integer
                                         .parseInt( configProps
                                                               .get( DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER_BD ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER_BD
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }
        if( hpFilterOrderBrnDem % 2 != 0 ) {
            hpFilterOrderBrnDem = 6; // set default value
            logger.error( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                          + ": Configuration Parameter Error "
                          + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER_BD
                          + ": Must be and defined in database with one of the following values: 2, 4, 6, 8, 10, 12 "
                          + ".  Using default value 6 .\n\t " );
        }

        try {
            hpFilterOrderBrnDemPreFFT = Integer
                                               .parseInt( configProps
                                                                     .get( DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER_BD_PFFT ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER_BD_PFFT
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }
        if( hpFilterOrderBrnDemPreFFT % 2 != 0 ) {
            hpFilterOrderBrnDemPreFFT = 2; // set default value
            logger.error( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                          + ": Configuration Parameter Error "
                          + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER_BD_PFFT
                          + ": Must be and defined in database with one of the following values: 2, 4, 6, 8, 10, 12 "
                          + ".  Using default value 6 .\n\t " );
        }

        overallsRecentTrendPeakAccel = new LinkedList<Double>();
		overallsRecentTrendRMSAccel = new LinkedList<Double>();
		overallsRecentTrendPeakVel = new LinkedList<Double>();
		overallsRecentTrendRMSVel = new LinkedList<Double>();
		
        overallsRecentTrendLblPeakAccel = new LinkedList<Double>();
		overallsRecentTrendLblRMSAccel = new LinkedList<Double>();
		overallsRecentTrendLblPeakVel = new LinkedList<Double>();
		overallsRecentTrendLblRMSVel = new LinkedList<Double>();

        try {
            analysisBandwidth = Integer.parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_ANALYSIS_BANDWIDTH ) );
        }
        catch( Exception e ) {
            analysisBandwidth = 1000;
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_ANALYSIS_BANDWIDTH
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }

        // Adjustment factors for frequency and gain
        try {
            adjFactorFreq = Double.parseDouble( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_ADJ_FACTOR_FREQ ) );
        }
        catch( Exception e ) {
            throw new RuntimeException(
                                        "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # "
                                                + channelId
                                                + ": Configuration Parameter Error "
                                                + DSPConstants.CONFIG_DYNAMIC_CH_ADJ_FACTOR_FREQ
                                                + ": Must be numeric (double) and defined in database.  Using default value of 1.0 \n\t "
                                                + e );
        }
        try {
            adjFactorGain = Double.parseDouble( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_ADJ_FACTOR_GAIN ) );
        }
        catch( Exception e ) {
            throw new RuntimeException(
                                        "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # "
                                                + channelId
                                                + ": Configuration Parameter Error "
                                                + DSPConstants.CONFIG_DYNAMIC_CH_ADJ_FACTOR_GAIN
                                                + ": Must be numeric (double) and defined in database.  Using default value of 1.0 \n\t "
                                                + e );
        }
        
        
        // Smoothing factor for DC Filter
        try {
            dcFltrSmoothingFactor = Integer.parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_DCFILTER_SMOOTHING_FACTOR ) );
        }
        catch( Exception e ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPDynamicCalculator: CHANNEL # " + channelId
                                        + ": Configuration Parameter Error "
                                        + DSPConstants.CONFIG_DYNAMIC_CH_DCFILTER_SMOOTHING_FACTOR
                                        + ": Must be numeric (integer) and defined in database.\n\t " + e );
        }
        dcFilter.setCutoffFreq((int) dcFltrSmoothingFactor); 
        

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

        this.channelId = channelId;
    }

    /**
     * Re-initialize algorithm sub-engines based on new configuration settings looked up from the database.
     * @throws Exception
     */
    public void reload( ) throws RuntimeException {
        init( this.channelId );
    }

    /**
     * This method calculates overall channel levels from the input array. Calculate Overall Levels: RMS:
     * SQRT(SUM[i=0,N-1](x(i)^2)/N) REF 4.7.1 Accel Peak: max(abs(x)) REF 4.7.3 Peak: RMS * SQRT(2) REF 4.7.2
     * Peak-to-Peak-Derived: 2 * SQRT(2) * RMS REF 4.7.4 Peak-to-Peak-True: max(x[i]) - min(x[i]) | i=0 to N REF 47.5
     * @param data Dynamic data that has been converted to proper units.
     * @return Calculated overall levels
     */
    private OverallLevels calculateOverallLevels( ProcessedData data, int overallSign , boolean bands, int samplingRate, double centralFrequency, int deviation) {

        //OverallLevels overalls = new OverallLevels( this.channelId );

        if( (data == null) || (data.getData() == null) || (data.getData().size() < 1) ) {
            logger
                  .debug( "ALERTSTEST: empty pants because of (data == null) || (data.getData() == null) || (data.getData().size() < 1)" );
            return new OverallLevels( this.channelId );
        }
        else {
            logger.debug( "ALERTSTEST: no issues with pants" );
        }

        List<Double> samples = data.getData();

        // loop through sample data bins: calculate sum, max and min
        double sumSq = 0;
        double max = samples.get( 0 );
        double min = samples.get( 0 );
        double rms = 0;
//        if(!bands){
        for( Double sample : samples ) {
            sumSq = sumSq + sample * sample;
            if( sample > max ) {
                max = sample;
            }
            if( sample < min ) {
                min = sample;
            }
        }

        rms = Math.sqrt( sumSq / samples.size() ); // Calculate RMS
//		} else {
//			// calculate Time constant
//			double timeConst = (((double)samples.size() *2) /(double)samplingRate);
//			
//			// calculate frequency deviations
//			final double friquencyDeviation = (centralFrequency * deviation)/100;
//			final double lowFriquency = centralFrequency - friquencyDeviation;
//			final double hightFriquency = centralFrequency + friquencyDeviation;
//			
//			// calculate low/high indexes
//			final double lowIndex = Math.floor(lowFriquency * timeConst);
//			final double highIndex = Math.ceil(hightFriquency * timeConst);
//			
//			for(int i = (int)lowIndex; i < (int)highIndex; i++){
//	        	sumSq += (Math.pow(samples.get(i), 2)/2);
//			}
//	       rms = Math.sqrt(sumSq);
//	       
//	       // find peak value
//	       for( Double sample : samples ) {
//	            if( sample > max ) {
//	                max = sample;
//	            }
//	            if( sample < min ) {
//	                min = sample;
//	            }
//	        }
//		}
        OverallLevels overalls = data.getOveralls();
        if(overalls == null){
        	overalls = new OverallLevels( this.channelId );
        }
		if (overallSign == 0) {
			addAccelerationOverall(rms, min, max, overalls);
			addVelocityOverall(rms, min, max, overalls);
		} else if (overallSign == 1) {
			addAccelerationOverall(rms, min, max, overalls);
		} else if (overallSign == 2) {
			addVelocityOverall(rms, min, max, overalls);
		} else {
			logger.error("Overall sign: " + overallSign + " is not supported.");
		}

        return overalls;
    }

    /*
     * Get peak value
     * @param min - min value
     * @param max - max value
     * @return (Math.abs(max) > Math.abs(min)) ? Math.abs(max) : Math.abs(min)
     */
    private double getPeakValue(double min, double max){
    	return (Math.abs(max) > Math.abs(min)) ? Math.abs(max) : Math.abs(min); 
    }
    
    private void addAccelerationOverall(double rms, double min, double max, OverallLevels overalls) {
		overalls.addOverall(OverallLevels.KEY_ACCEL_RMS, rms);
		logger.debug("ALERTSTEST: added RMS of " + rms + " for  channel " + channelId);
		overalls.addOverall(OverallLevels.KEY_ACCEL_PEAK, getPeakValue(min, max));
		overalls.addOverall(OverallLevels.KEY_ACCEL_PEAK_TO_PEAK, max - min); // Calculate Acceleration Peak To Peak    	
    }
    
    private void addVelocityOverall(double rms, double min, double max, OverallLevels overalls) {
		overalls.addOverall(OverallLevels.KEY_VEL_RMS, rms);
		logger.debug("ALERTSTEST: added RMS of " + rms + " for  channel " + channelId);
		overalls.addOverall(OverallLevels.KEY_VEL_PEAK, getPeakValue(min, max));
		overalls.addOverall(OverallLevels.KEY_VEL_PEAK_TO_PEAK, max - min); // Calculate Acceleration Peak To Peak
    }
    /**
     * Helper method to calculate RPMs using tachometer ticks data
     * @param dataTicks array of tachometer ticks
     * @param samplingRate channel sampling rate
     * @return RPM (Revolutions Per Minute)
     */
    private Double calculateRPM( boolean[] dataTicks, int samplingRate ) {

        // error checking - just in case
        if( dataTicks == null || dataTicks.length < 1 ) {
            return new Double( 0 );
        }

        Double rpm = new Double( 0 );

        try {
            // skip the first subset (if it's not full - i.e. 00000'1000000000100001'000)
            int i = 0;
            while( !dataTicks[i] && (i < dataTicks.length) ) {
                i++;
            }

            // loop through data ticks - skip first and second subsets if they are partial
            Vector<Double> rpms = new Vector<Double>();
            int counter = 0;
            Double sumOfRpms = new Double( 0 );
            for( int j = i; j < dataTicks.length; j++ ) {
                if( dataTicks[j] && counter != 0 ) { // calculate RPM, reset counter
                    Double r = new Double( samplingRate * 60 / (this.ticksPerRevolution * counter) );
                    rpms.add( r );
                    sumOfRpms = sumOfRpms + r;
                    counter = 0;
                }
                counter++;
            }

            // calculate RPM average
            if( rpms.size() != 0 ) {
                rpm = sumOfRpms / rpms.size();
            }

        }
        catch( Exception e ) { /* do nothing - return default 0 */
        }

        return rpm;

    }

    /**
     * For dynamic channels this method calculates minimum outputs: RMS, one default overall, and re-sampled time
     * waveform
     */
 public ChannelState processData( RawData rawData, String[] methods ) throws InvalidAlgorithmParameterException {
/* Ticket #20: 1.1 apply DC Filter: start */
    	// can we apply the filter without the sampling rate?
/* Ticket #20: 1.1 apply DC Filter: end */    	
    	
/* Ticket #20: 1.1 timeWaveFormData;timeStamp;samplingRate;channelId: start */
    	// 1.1.1 Sample rate calculation
        rawData.setSamplingRate( (int) Math.round( rawData.getSamplingRate() * adjFactorFreq ) );

        // 1.1.2 Create a channelState
        ChannelState channelState =  DataBucket.getChannelState(rawData.getChannelId());
        if(channelState == null){
            channelState = new ChannelState( rawData.getChannelId(), ChannelState.CHANNEL_TYPE_DYNAMIC );        	
        }

        // calculate dateTime stamp
        java.util.Date dateTimeStamp = rawData.getDateTimeStamp();

        // 1.1.3. set the dateTime stamp to the channel state
        channelState.setDateTimeStamp( dateTimeStamp );
    	
/* Ticket #20: 1.2 timeWaveFormData;timeStamp;samplingRate;channelId: end */    	
    
/* Ticket #20: 1.3 undocumented processing: start */    	        
        // 1.3.1 Calculate RPM - Use initial sampling rate, initial data set, initial ticks
        channelState.setRpm( calculateRPM( rawData.getDataTicks(), rawData.getSamplingRate() ) ); // Calculate RPM
        channelState.setDataTicks( rawData.getDataTicks() );

        // 1.3.2 Convert volts to primary engineering units for the channel
        // This is the primary data set that needs to be store in the database
        ProcessedDynamicData dynData = new ProcessedDynamicData( rawData.getChannelId() );
        dynData.setSamplingRate( rawData.getSamplingRate() );
        dynData.setEU( primaryEU );
        dynData.setDateTimeStamp( dateTimeStamp );
        // convert to volts
        dynData.setData( unitConverter.convertToGs( rawData.getData() ) );

        // Adjust gain by a configurable gain factor
        dynData.setData( DSPUtils.multiplyByFactor( dynData.getData(), adjFactorGain ) );

        // 1.3.3 Create calculate BandOveralls, Overalls, Sampling Rate, Time stamp, EUnits...
        ProcessedDynamicData dynData14 = (ProcessedDynamicData) preProcessData( dynData );        

        // 1.3.4 DC Filter here
        dynData14.setData( dcFilter.filter( dynData.getData(), dynData.getSamplingRate() ) );

/* Ticket #20: 1.3 undocumented processing: end */    	                
        double startTime = (double) dateTimeStamp.getTime();

       
        // ////////////////////////////////////////////////////////////////////////////////////
        // Calculate overalls for specific domain: Acceleration, Velocity, Displacement
        channelState.setOverallKey( overallSubType );
		
		//////////////////////////////////////////////
		//Start Added by YK 4/2/12
		//Acceleration Overalls
        int overallSign = 1;
		dynData14.setOveralls( calculateOverallLevels( dynData14, overallSign, false, rawData.getSamplingRate(), 0d, 0) );
		
		//Velocity Overalls
		overallSign = 2;
		ProcessedData dynData15 = DSPProcessor.calculateTimeWaveVel( dynData14, highPassFilter, integrator,
                                                                         hpFilterCutoffPreIntToVel,
                                                                         hpFilterCutoffPostIntToVel, hpFilterOrder, dcFilter );
		dynData14.setOveralls( calculateOverallLevels( (ProcessedDynamicData) dynData15, overallSign, false, rawData.getSamplingRate(), 0d, 0 ) );
		
		//Acceleration BandOveralls
		ProcessedData spectrumData14 = DSPProcessor.calculateSpectrumAccel( dynData14, highPassFilter, weightingAlg,
                                                           fftTransformer, hpFilterCutoffPreFFTAcc, false,
                                                           hpFilterOrder, analysisBandwidth, dcFilter );
		dynData14.setAccBandOveralls(BandCalculator.getBandOveralls(spectrumData14));
		
		//Velocity BandOveralls
		
		ProcessedData spectrumData15 = DSPProcessor.calculateSpectrumVel( dynData14, highPassFilter, weightingAlg,
                                                         fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                         hpFilterCutoffPostIntToVel, false, hpFilterOrder,
                                                         analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc );
		dynData14.setVelBandOveralls(BandCalculator.getBandOveralls(spectrumData15));
		
		//End Added by YK 4/2/12
		/////////////////////////////////////////////
		
       // if( overallType.equals( ProcessedData.EU_VELOCITY_ABBR ) ) { // Velocity
        	
			// add the Acceleration Overall (AO) only if we have no any Velocity Overall(VO)
        	
            // Convert the data into Velocity domain then calculate overalls
            /*ProcessedData dynData15 = DSPProcessor.calculateTimeWaveVel( dynData14, highPassFilter, integrator,
                                                                         hpFilterCutoffPreIntToVel,
                                                                         hpFilterCutoffPostIntToVel, hpFilterOrder, dcFilter );
			*/
        /* Calculate Acceleration and Velocity Overalls Section */
            // Calculate Overall levers 
            //dynData14.setOveralls( calculateOverallLevels( (ProcessedDynamicData) dynData15, overallSign, false, rawData.getSamplingRate(), 0d, 0 ) );

           // if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_RMS ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrendRMSVel, dynData14.getOveralls(),
                                        OverallLevels.KEY_VEL_RMS, ProcessedData.KEY_OVRL_TREND_VEL_RMS,
                                        overallsRecentTrendLblRMSVel, startTime );
            //    channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_VEL_RMS );
            //}
            // Calculate Velocity Peak 
            //else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_PEAK ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrendPeakVel, dynData14.getOveralls(),
                                        OverallLevels.KEY_VEL_PEAK, ProcessedData.KEY_OVRL_TREND_VEL_PEAK,
                                        overallsRecentTrendLblPeakVel, startTime );
            //    channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_VEL_PEAK );
            //}
         /*   else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_DER_PEAK ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_DERIVED_PEAK, ProcessedData.KEY_OVRL_TREND_VEL_DER_PEAK,
                                        overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_VEL_DER_PEAK );
            }
            else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_DER_P2P ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_DERIVED_PEAK_TO_PEAK,
                                        ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P, overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P );
            }
            else {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_TRUE_PEAK_TO_PEAK, ProcessedData.KEY_OVRL_TREND_VEL_P2P,
                                        overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_VEL_P2P );
            }*/

        //}
		/*
        else if( overallType.equals( ProcessedData.EU_DISPLACEMENT_ABBR ) ) { // Displacement

            // Convert the data into Velocity domain then calculate overalls
            ProcessedData dynData15 = DSPProcessor.calculateTimeWaveDispl( dynData14, highPassFilter, integrator,
                                                                           hpFilterCutoffPreIntToVel,
                                                                           hpFilterCutoffPostIntToVel,
                                                                           hpFilterCutoffPostIntToDspl, hpFilterOrder, dcFilter );

            // Calculate OVERALLS for Velocity
            dynData14.setOveralls( calculateOverallLevels( (ProcessedDynamicData) dynData15 ) );

            if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_RMS ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_RMS, ProcessedData.KEY_OVRL_TREND_DSPL_RMS,
                                        overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_DSPL_RMS );
            }
            else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_PEAK ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_TRUE_PEAK, ProcessedData.KEY_OVRL_TREND_DSPL_PEAK,
                                        overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_DSPL_PEAK );
            }
            else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_DER_PEAK ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_DERIVED_PEAK, ProcessedData.KEY_OVRL_TREND_DSPL_DER_PEAK,
                                        overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_DSPL_DER_PEAK );
            }
            else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_DER_P2P ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_DERIVED_PEAK_TO_PEAK,
                                        ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P, overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P );
            }
            else {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_TRUE_PEAK_TO_PEAK, ProcessedData.KEY_OVRL_TREND_DSPL_P2P,
                                        overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_DSPL_P2P );
            }

        }*/
        //else { // Acceleration (default)
            // Calculate OVERALLS for Acceleration
			//if (!channelState.getProcessedData().containsKey(ProcessedData.KEY_SPECTRUM_VEL_PEAK)) {
				// add the Acceleration Overall (AO) only if we have no any Velocity Overall(VO)  
            //dynData14.setOveralls( calculateOverallLevels( dynData14, overallSign, false, rawData.getSamplingRate(), 0d, 0) );

            //if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_RMS ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrendRMSAccel, dynData14.getOveralls(),
                                        OverallLevels.KEY_ACCEL_RMS, ProcessedData.KEY_OVRL_TREND_ACC_RMS,
                                        overallsRecentTrendLblRMSAccel, startTime );
            //    channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_ACC_RMS );
            //}
            //else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_PEAK ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrendPeakAccel, dynData14.getOveralls(),
                                        OverallLevels.KEY_ACCEL_PEAK, ProcessedData.KEY_OVRL_TREND_ACC_PEAK,
                                        overallsRecentTrendLblPeakAccel, startTime );
            //    channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_ACC_PEAK );
            //}
            /*
            else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_DER_PEAK ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_DERIVED_PEAK, ProcessedData.KEY_OVRL_TREND_ACC_DER_PEAK,
                                        overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_ACC_DER_PEAK );
            }
            else if( overallSubType.equals( ProcessedData.KEY_OVRL_SUBTYPE_DER_P2P ) ) {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_DERIVED_PEAK_TO_PEAK,
                                        ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P, overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P );
            }
            else {
                addRecentOverallsTrend( channelState, overallsRecentTrend, dynData14.getOveralls(),
                                        OverallLevels.KEY_TRUE_PEAK_TO_PEAK, ProcessedData.KEY_OVRL_TREND_ACC_P2P,
                                        overallsRecentTrendLbl, startTime );
                channelState.setOverallTrendKey( ProcessedData.KEY_OVRL_TREND_ACC_P2P );
            }*/
        	//}
        //}

        dynData.setOveralls( dynData14.getOveralls() );

        double endTime = (double) (startTime + 1000 * rawData.getData().length / rawData.getSamplingRate());
        DSPUtils.setLabels( dynData, 0, (endTime - startTime) * 0.001 );
        dynData.setYEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Acceleration ) ); // data
        dynData.setXEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Time ) ); // labels
        /* Ticket #20: the 'addProcessedData' method has called before in the 'addRecentOverallsTrend' START*/ 
        channelState.addProcessedData( ProcessedData.KEY_TIMEWAVE_ACC, dynData14); // store not re-sampled data
        /* Ticket #20: the 'addProcessedData' method has called before in the 'addRecentOverallsTrend' END*/ 
        // Collect/dump data for analysis/debugging
        if( debugMode ) {
            DSPDebugger.debugDynamicChannel( dspCoreDump, rawData, dateTimeStamp, channelState, unitConverter,
                                             dynData14, highPassFilter, weightingAlg, fftTransformer,
                                             hpFilterCutoffPreFFTAcc, integrator, hpFilterCutoffPreIntToVel,
                                             hpFilterCutoffPostIntToVel, hpFilterCutoffPostIntToDspl, lowPassFilter,
                                             bearingDemHighPassCuttof, bearingDemLowPassCuttof, hpFilterOrder,
                                             lpFilterOrder, hpFilterOrderBrnDem, bearingDemHighPassCuttofPreFFT,
                                             hpFilterOrderBrnDemPreFFT, analysisBandwidth, this,
                                             dynData, resampler, newSamplingRate, dcFilter);
        }

        return channelState;

    }
    /**
     * Get overall type.
     * Uses for test purposes only.
     * @return the overall type
     */
    public String getOverallType() {
    	return overallType;
    }

    /**
     * Set overall type.
     * Uses for test purposes only.
     * @param overallType - overall type to set
     */
	public void setOverallType(String overallType) {
    	this.overallType = overallType;
    }

	/*
     * Utility method used to add overalls to the recent trend list, and add the list to channel state
     */
    private void addRecentOverallsTrend( ChannelState channelState, LinkedList<Double> recentTrend,
                                         OverallLevels overalls, String overallKey, String key,
                                         LinkedList<Double> recentTrendLbl, double timeLabel ) {

        // add calculated value to the recent trend queue
        recentTrend.add( new Double( overalls.getOverall( overallKey ) ) );
        // add a label calculated value to the recent trend queue
        recentTrendLbl.add( new Double( timeLabel ) );

        Vector<Double> vec = new Vector<Double>();
        Vector<Double> labels = new Vector<Double>();
        
        LinkedList<Double> newTrend = new LinkedList<Double>();
        LinkedList<Double> newTrendLbl = new LinkedList<Double>();
        
        // remove elements older than specified buffer limit in seconds
        for (int i = 0; i < recentTrendLbl.size(); i++) {
            if (recentTrendLbl.get( i ) > (timeLabel - recentTrendBufferSize * 1000)) {
                newTrend.add( recentTrend.get( i ) );
                newTrendLbl.add( recentTrendLbl.get( i ) );
            }
        }
                
        for( int j = 0; j < newTrend.size(); j++ ) {
            vec.add( new Double( newTrend.get( newTrend.size() - j - 1 ) ) );
        }      
        
        for( int j = 0; j < newTrendLbl.size(); j++ ) {
            labels.add( new Double( newTrendLbl.get( newTrendLbl.size() - j - 1 ) ) );
        }
        
        recentTrend = newTrend;
        //overallsRecentTrend = newTrend;
        recentTrendLbl = newTrendLbl;
        //overallsRecentTrendLbl = newTrendLbl;
        
        ProcessedStaticData data = new ProcessedStaticData( this.channelId );
        data.setSamplingRate( 1 );
        data.setEU( this.primaryEU );
        data.setDateTimeStamp( channelState.getDateTimeStamp() );
        data.setData( vec );
        data.setDataLabels( labels );
        data.setOveralls( overalls );

        data.setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_MS );
        data.setMeasurementType( ProcessedData.MEASUREMENT_TYPE_ABSOLUTE );

        channelState.addProcessedData( key, data );

    }

    /**
     * For dynamic channels this method is used for on-demand user requested calculations. Input data must be in Time
     * Wave Acceleration format.
     
    @Deprecated
    public ProcessedData processData( ProcessedData dataIn, String calcMethod )
                                                                               throws InvalidAlgorithmParameterException,
                                                                               RuntimeException {

        // basic validation of input parameters
        if( (dataIn == null) || (calcMethod == null) ) {
            return dataIn;
        }

        if( calcMethod.equals( ProcessedData.KEY_TIMEWAVE_ACC ) ) {
            return preProcessData( dataIn );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_ACC_PEAK ) ) {
            return DSPProcessor.calculateSpectrumAccel( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                        fftTransformer, hpFilterCutoffPreFFTAcc, false, hpFilterOrder,
                                                        analysisBandwidth, dcFilter );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_ACC_RMS ) ) {
            return DSPProcessor.calculateSpectrumAccel( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                        fftTransformer, hpFilterCutoffPreFFTAcc, true, hpFilterOrder,
                                                        analysisBandwidth, dcFilter );
        }
        else if( calcMethod.equals( ProcessedData.KEY_TIMEWAVE_VEL ) ) {
            return DSPProcessor.calculateTimeWaveVel( preProcessData( dataIn ), highPassFilter, integrator,
                                                      hpFilterCutoffPreIntToVel, hpFilterCutoffPostIntToVel,
                                                      hpFilterOrder, dcFilter );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_VEL_PEAK ) ) {
            return DSPProcessor.calculateSpectrumVel( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                      fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                      hpFilterCutoffPostIntToVel, false, hpFilterOrder,
                                                      analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_VEL_RMS ) ) {
            return DSPProcessor.calculateSpectrumVel( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                      fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                      hpFilterCutoffPostIntToVel, true, hpFilterOrder,
                                                      analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc );
        }
        else if( calcMethod.equals( ProcessedData.KEY_TIMEWAVE_DISPL ) ) {
            return DSPProcessor.calculateTimeWaveDispl( preProcessData( dataIn ), highPassFilter, integrator,
                                                        hpFilterCutoffPreIntToVel, hpFilterCutoffPostIntToVel,
                                                        hpFilterCutoffPostIntToDspl, hpFilterOrder, dcFilter );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_DISPL_PEAK ) ) {
            return DSPProcessor.calculateSpectrumDispl( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                        fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                        hpFilterCutoffPostIntToVel, hpFilterCutoffPostIntToDspl, false,
                                                        hpFilterOrder, analysisBandwidth, dcFilter );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_DISPL_RMS ) ) {
            return DSPProcessor.calculateSpectrumDispl( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                        fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                        hpFilterCutoffPostIntToVel, hpFilterCutoffPostIntToDspl, true,
                                                        hpFilterOrder, analysisBandwidth, dcFilter );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_PEAK ) ) {
            return DSPProcessor.calculateBearingDemod( preProcessData( dataIn ), highPassFilter, lowPassFilter,
                                                       fftTransformer, bearingDemHighPassCuttof,
                                                       bearingDemLowPassCuttof, false, hpFilterOrderBrnDem,
                                                       lpFilterOrder, bearingDemHighPassCuttofPreFFT,
                                                       hpFilterOrderBrnDemPreFFT, analysisBandwidth,
                                                       resampler, newSamplingRate, dcFilter);
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_RMS ) ) {
            return DSPProcessor.calculateBearingDemod( preProcessData( dataIn ), highPassFilter, lowPassFilter,
                                                       fftTransformer, bearingDemHighPassCuttof,
                                                       bearingDemLowPassCuttof, true, hpFilterOrderBrnDem,
                                                       lpFilterOrder, bearingDemHighPassCuttofPreFFT,
                                                       hpFilterOrderBrnDemPreFFT, analysisBandwidth,
                                                       resampler, newSamplingRate, dcFilter);
        }

        // unknown key/method - do not process return default
        return dataIn;

    }*/

    /**
     * For dynamic channels this method is used for on-demand user requested calculations. Input data must be in Time
     * Wave Acceleration format.
     */
    public ProcessedData processData( ProcessedData dataIn, String calcMethod, EUnit xUnitTarget, EUnit yUnitTarget, double centralFrequency, int deviation )
                                                                                                                     throws InvalidAlgorithmParameterException,
                                                                                                                     RuntimeException {
        // basic validation of input parameters
        if( (dataIn == null) || (calcMethod == null) ) {
            return dataIn;
        }

        ProcessedData dataOut = dataIn;
        int overallSign = 0;
        if(DPMFlexProxy.SPECTRUM_ACCELERATION_PEAK_KEY.equalsIgnoreCase(calcMethod)){
        	overallSign = 1;
        }else if(DPMFlexProxy.TIME_WAVEFORM_ACCELERATION_KEY.equalsIgnoreCase(calcMethod)){
        	overallSign = 1;
        }else if(DPMFlexProxy.SPECTRUM_VELOCITY_KEY.equalsIgnoreCase(calcMethod)){
        	overallSign = 2;
        }else if(DPMFlexProxy.TIME_WAVEFORM_VELOCITY_KEY.equalsIgnoreCase(calcMethod)){
        	overallSign = 2;
        }
        if (ProcessedData.KEY_TIMEWAVE_ACC.equalsIgnoreCase(calcMethod)
                || ProcessedData.KEY_SPECTRUM_ACC_PEAK.equalsIgnoreCase(calcMethod)
                || ProcessedData.KEY_SPECTRUM_ACC_RMS.equalsIgnoreCase(calcMethod)
        ) {
            overallSign = 1;
        }
        if (ProcessedData.KEY_TIMEWAVE_VEL.equalsIgnoreCase(calcMethod)
                || ProcessedData.KEY_SPECTRUM_VEL_PEAK.equalsIgnoreCase(calcMethod)
                || ProcessedData.KEY_SPECTRUM_VEL_RMS.equalsIgnoreCase(calcMethod)
        ) {
            overallSign = 2;
        } 
        
        java.util.Date dateTimeStamp = dataOut.getDateTimeStamp();
        ChannelState channelState =  DataBucket.getChannelState(dataOut.getChannelId());
        if(channelState == null){
            channelState = new ChannelState( dataOut.getChannelId(), 1 );        	
        }
        channelState.setDateTimeStamp( dateTimeStamp );

        
        ///
        /*Vector<Double> tmpVector = new Vector<Double>(dataIn.getData().size());
        for(int i = 0; i < dataIn.getData().size(); i++){
        	tmpVector.add(i, dataIn.getData().get(i));
        }
        ((ProcessedDynamicData)dataOut).setData(unitConverter.convertVoltsToGs(tmpVector));
        *////
        //dynData.setData( unitConverter.convertToGs( dataIn.getData() ) );
        
        /// !!! ((ProcessedDynamicData)dataIn).setData( unitConverter.convertToGs(dataIn.getData() ) );
        
        
        if( calcMethod.equals( ProcessedData.KEY_TIMEWAVE_ACC ) ) {
            dataOut = preProcessData( dataIn );
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
       		((ProcessedDynamicData)dataOut).setOveralls( calculateOverallLevels( (ProcessedDynamicData) dataOut, overallSign, true, dataIn.getSamplingRate(), 29.375d, 5 ));
       		channelState.setOverallKey(ProcessedData.KEY_TIMEWAVE_ACC);
       		channelState.addProcessedData(ProcessedData.KEY_TIMEWAVE_ACC, dataOut);
            
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_ACC_PEAK ) ) {
            dataOut = DSPProcessor.calculateSpectrumAccel( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                           fftTransformer, hpFilterCutoffPreFFTAcc, false,
                                                           hpFilterOrder, analysisBandwidth, dcFilter );
            //calculating band overalls
            ((ProcessedDynamicData)dataOut).setAccBandOveralls(BandCalculator.getBandOveralls(dataOut));
            //calculating regular overalls
            ((ProcessedDynamicData)dataOut).setOveralls( calculateOverallLevels( dataIn, overallSign, true, dataIn.getSamplingRate(), 29.375d, 5 ));
            channelState.setOverallKey(ProcessedData.KEY_SPECTRUM_ACC_PEAK);
            channelState.addProcessedData(ProcessedData.KEY_SPECTRUM_ACC_PEAK, dataOut);
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_ACC_RMS ) ) {
            dataOut = DSPProcessor.calculateSpectrumAccel( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                           fftTransformer, hpFilterCutoffPreFFTAcc, true,
                                                           hpFilterOrder, analysisBandwidth, dcFilter );
            ((ProcessedDynamicData)dataOut).setOveralls( calculateOverallLevels( dataIn, overallSign, true, dataIn.getSamplingRate(), 29.375d, 5 ));
            channelState.setOverallKey(ProcessedData.KEY_SPECTRUM_ACC_RMS);
            channelState.addProcessedData(ProcessedData.KEY_SPECTRUM_ACC_RMS, dataOut);
            
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }
        else if( calcMethod.equals( ProcessedData.KEY_TIMEWAVE_VEL ) ) {
            dataOut = DSPProcessor.calculateTimeWaveVel( preProcessData( dataIn ), highPassFilter, integrator,
                                                         hpFilterCutoffPreIntToVel, hpFilterCutoffPostIntToVel,
                                                         hpFilterOrder, dcFilter );
            ((ProcessedDynamicData)dataOut).setOveralls( calculateOverallLevels( dataOut, overallSign, true, dataIn.getSamplingRate(), 29.375d, 5 ));
            channelState.setOverallKey(ProcessedData.KEY_TIMEWAVE_VEL);
            channelState.addProcessedData(ProcessedData.KEY_TIMEWAVE_VEL, dataOut);
            
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_VEL_PEAK ) ) {
            dataOut = DSPProcessor.calculateSpectrumVel( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                         fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                         hpFilterCutoffPostIntToVel, false, hpFilterOrder,
                                                         analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc );
            ProcessedData velTimeData = DSPProcessor.calculateTimeWaveVel( preProcessData( dataIn ), highPassFilter, integrator,
                                                         hpFilterCutoffPreIntToVel, hpFilterCutoffPostIntToVel,
                                                         hpFilterOrder, dcFilter );  
            //calculating band overalls
            ((ProcessedDynamicData)dataOut).setVelBandOveralls(BandCalculator.getBandOveralls(dataOut));    
            //calculating regular overalls
            ((ProcessedDynamicData)dataOut).setOveralls( calculateOverallLevels( velTimeData, overallSign, true, dataIn.getSamplingRate(), centralFrequency, deviation ));
            channelState.setOverallKey(ProcessedData.KEY_SPECTRUM_VEL_PEAK);
            channelState.addProcessedData(ProcessedData.KEY_SPECTRUM_VEL_PEAK, dataOut);
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_VEL_RMS ) ) {
            dataOut = DSPProcessor.calculateSpectrumVel( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                         fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                         hpFilterCutoffPostIntToVel, true, hpFilterOrder,
                                                         analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc );
            ProcessedData velTimeData = DSPProcessor.calculateTimeWaveVel( preProcessData( dataIn ), highPassFilter, integrator,
                                                         hpFilterCutoffPreIntToVel, hpFilterCutoffPostIntToVel,
                                                         hpFilterOrder, dcFilter );
            ((ProcessedDynamicData)dataOut).setOveralls( calculateOverallLevels( velTimeData, overallSign, true, dataIn.getSamplingRate(), centralFrequency, deviation ));
            channelState.setOverallKey(ProcessedData.KEY_SPECTRUM_VEL_RMS);
            channelState.addProcessedData(ProcessedData.KEY_SPECTRUM_VEL_PEAK, dataOut);
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }
/* SLAVA This is not currently used
        else if( calcMethod.equals( ProcessedData.KEY_TIMEWAVE_DISPL ) ) {
            dataOut = DSPProcessor.calculateTimeWaveDispl( preProcessData( dataIn ), highPassFilter, integrator,
                                                           hpFilterCutoffPreIntToVel, hpFilterCutoffPostIntToVel,
                                                           hpFilterCutoffPostIntToDspl, hpFilterOrder, dcFilter );
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_DISPL_PEAK ) ) {
            dataOut = DSPProcessor.calculateSpectrumDispl( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                           fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                           hpFilterCutoffPostIntToVel, hpFilterCutoffPostIntToDspl,
                                                           false, hpFilterOrder, analysisBandwidth, dcFilter );
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_DISPL_RMS ) ) {
            dataOut = DSPProcessor.calculateSpectrumDispl( preProcessData( dataIn ), highPassFilter, weightingAlg,
                                                           fftTransformer, integrator, hpFilterCutoffPreIntToVel,
                                                           hpFilterCutoffPostIntToVel, hpFilterCutoffPostIntToDspl,
                                                           true, hpFilterOrder, analysisBandwidth, dcFilter );
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }*//*
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_PEAK ) ) {
            dataOut = DSPProcessor.calculateBearingDemod( dataIn, highPassFilter, lowPassFilter, fftTransformer,
                                                          bearingDemHighPassCuttof, bearingDemLowPassCuttof, false,
                                                          hpFilterOrderBrnDem, lpFilterOrder,
                                                          bearingDemHighPassCuttofPreFFT, hpFilterOrderBrnDemPreFFT,
                                                          analysisBandwidth, resampler, newSamplingRate, dcFilter );
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }
        else if( calcMethod.equals( ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_RMS ) ) {
            dataOut = DSPProcessor.calculateBearingDemod( dataIn, highPassFilter, lowPassFilter, fftTransformer,
                                                          bearingDemHighPassCuttof, bearingDemLowPassCuttof, true,
                                                          hpFilterOrderBrnDem, lpFilterOrder,
                                                          bearingDemHighPassCuttofPreFFT, hpFilterOrderBrnDemPreFFT,
                                                          analysisBandwidth, resampler, newSamplingRate, dcFilter );
            dataOut.convertToEUnitsX( xUnitTarget );
            dataOut.convertToEUnitsY( yUnitTarget );
        }*/

        // unknown key/method - do not process return default
		DataBucket.putChannelState(dataOut.getChannelId(), channelState);
        return dataOut;

    }

    /**
     * Check if the current DSP Calculator object runs in debug mode
     * @return the debugMode
     */
    public boolean isDebugMode( ) {
        return debugMode;
    }

    /**
     * Turn on/off the debug mode.
     * For test purposes only
     * @param debugMode
     */
    public void setDebugMode(boolean debugMode) {
    	this.debugMode = debugMode;
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
     * channel, and trend for static). The value for dynamic channel is looked up from the database.
     * @return the key for the primary/default ProcessedData object
     */
    public String getPrimaryProcessedDataKey( ) {
        return primaryProcessedDataKey;
    }

    /**
     * Pre=Process dynamic data by applying low-pass filter and re-sampling
     * @param data
     * @param channelId
     * @param originalSamplingRate
     * @param dateTimeStamp
     * @return
     * @throws InvalidAlgorithmParameterException
     */
    private ProcessedData preProcessData( ProcessedData data ) throws InvalidAlgorithmParameterException {
// TODO: the method needs to be re-factored: as body of the method is only re-set  fields of the 'ProcessedDynamicData'. when called from ChannelState processData( RawData rawData, String[] methods )
        if( (data == null) || (!(data instanceof ProcessedDynamicData)) ) {
            return data;
        }

        ProcessedData dataIn = data.deepCopy();

        // /////////////////////////////////////////////////////////////////////////
        // 1.3 Apply Low-Pass Filter
        // Cutoff Frequency = 1/2 * NEW_SAMPLING_RATE
        // Sampling Rate = OLD_SAMPLING_RATE
        /*
        ProcessedDynamicData dynData13 = new ProcessedDynamicData( channelId );
        dynData13.setSamplingRate( dataIn.getSamplingRate() );
        dynData13.setEU( primaryEU );
        dynData13.setDateTimeStamp( dataIn.getDateTimeStamp() );
        */
        /*yk (12/01/09): adjust for the algorithm 
        dynData13.setData( lowPassFilter.filter( dataIn.getData(), dataIn.getSamplingRate(),
                                                 (double) newSamplingRate / 2, lpFilterOrder ) );
         */
        /*
        dynData13.setData(dataIn.getData());
        */
        // /////////////////////////////////////////////////////////////////////////
        // 1.4 Re-sample to NEW_SAMPLING_RATE
        // Number of Samples in New Data Set = N * NEW_SAMPLING_RATE / OLD_SAMPLING_RATE
        // (adjust to be 2^N)
        ProcessedDynamicData dynData14 = new ProcessedDynamicData(channelId);
        dynData14.setSamplingRate( dataIn.getSamplingRate() );
        dynData14.setEU( primaryEU );
        dynData14.setDateTimeStamp( dataIn.getDateTimeStamp() );
        //yk (12/01/09): dynData14.setData( resampler.resampleRadix2( dynData13.getData(), dataIn.getSamplingRate(), newSamplingRate, dynData14 ) );
        dynData14.setData(dataIn.getData());

        dynData14.setOveralls( dataIn.getOveralls() );

        double startTime = (double) dataIn.getDateTimeStamp().getTime();
        double endTime = (double) (startTime + 1000 * dataIn.getData().size() / dataIn.getSamplingRate());

        DSPUtils.setLabels( dynData14, 0, (endTime - startTime) * 0.001 );
        dynData14.setYEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Acceleration ) ); // data
        dynData14.setXEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Time ) ); // labels
        /*
//        if (null != dynData14 && null != data.getData()){
//        	dynData14.setAccBandOveralls(BandCalculator.getBandOveralls(data));
//        }
         */
        return dynData14;
    }

    /**
     * @see com.inchecktech.dpm.dsp.DSPCalculator#getChannelId()
     */
    public int getChannelId() {
    	return this.channelId;
    }
}
