/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */

package com.inchecktech.dpm.dsp;

/**
 * The class containing DSP constants. Use to avoid hard-coding.
 * @author Taras Dobrovolsky
 */
public class DSPConstants {

    public static final String CONFIG_STATIC_CH_RECENT_TREND_BUFFER_SIZE          = "com.inchecktech.dpm.dsp.recentTrendBufferSize";
    public static final String CONFIG_STATIC_CH_TREND_TIME_LIMIT_SEC              = "com.inchecktech.dpm.dsp.Dashboard.Time.Limit";
    public static final String CONFIG_STATIC_CH_NO_OF_DATA_BINS_TO_AVERAGE        = "com.inchecktech.dpm.dsp.noOfDataBinsToAverage";
    public static final String CONFIG_STATIC_CH_PRIMARY_EU                        = "com.inchecktech.dpm.dsp.ChannelPrimaryEngineeringUnits";
    public static final String CONFIG_CH_DEBUG_MODE                               = "com.inchecktech.dpm.dsp.DebugMode";

    public static final String CONFIG_DYNAMIC_RESAMPLER_IMPL                      = "com.inchecktech.dpm.dsp.Resampler.ImplementationClass";
    public static final String CONFIG_DYNAMIC_UCONVERTER_IMPL                     = "com.inchecktech.dpm.dsp.UnitConverter.ImplementationClass";
    public static final String CONFIG_DYNAMIC_INTEGRATOR_IMPL                     = "com.inchecktech.dpm.dsp.Integrator.ImplementationClass";
    public static final String CONFIG_DYNAMIC_WEIGHT_ALG_IMPL                     = "com.inchecktech.dpm.dsp.WieghtingAlg.ImplementationClass";
    public static final String CONFIG_DYNAMIC_SLICER_IMPL                         = "com.inchecktech.dpm.dsp.Slicer.ImplementationClass";
    public static final String CONFIG_DYNAMIC_FFT_IMPL                            = "com.inchecktech.dpm.dsp.FFTTransformer.ImplementationClass";
    public static final String CONFIG_DYNAMIC_HP_FILTER_IMPL                      = "com.inchecktech.dpm.dsp.HighPassFilter.ImplementationClass";
    public static final String CONFIG_DYNAMIC_LP_FILTER_IMPL                      = "com.inchecktech.dpm.dsp.LowPassFilter.ImplementationClass";

    public static final String CONFIG_DYNAMIC_CH_UNITCONV_MAXVOLTS                = "com.inchecktech.dpm.dsp.UnitConverter.MaxVolts";
    public static final String CONFIG_DYNAMIC_CH_UNITCONV_BITRES                  = "com.inchecktech.dpm.dsp.UnitConverter.BitResolution";
    public static final String CONFIG_DYNAMIC_CH_UNITCONV_SENCITVTY               = "com.inchecktech.dpm.dsp.UnitConverter.SensorSensitivity";
    public static final String CONFIG_DYNAMIC_CH_UNITCONV_BIASVOLT                = "com.inchecktech.dpm.dsp.UnitConverter.SensorBiasVoltage";
    public static final String CONFIG_DYNAMIC_CH_UNITCONV_GAIN                    = "com.inchecktech.dpm.dsp.UnitConverter.SensorGain";
    public static final String CONFIG_DYNAMIC_CH_UNITCONV_OFFSET                  = "com.inchecktech.dpm.dsp.UnitConverter.SensorOffset";

    public static final String CONFIG_DYNAMIC_CH_HPFILTER_CUTOFF                  = "com.inchecktech.dpm.dsp.HighPassFilter.CutoffFrequency";
    public static final String CONFIG_DYNAMIC_CH_LPFILTER_CUTOFF                  = "com.inchecktech.dpm.dsp.LowPassFilter.CutoffFrequency";

    public static final String CONFIG_CH_TYPE                                     = "com.inchecktech.dpm.dsp.ChannelType";

    public static final int    CONFIG_CH_TYPE_DYNAMIC                             = 1;
    public static final int    CONFIG_CH_TYPE_STATIC                              = 2;

    public static final String CONFIG_DYNAMIC_CH_SLICER_OVERLAP_PERCENT           = "com.inchecktech.dpm.dsp.Slicer.overlapPercent";
    public static final String CONFIG_DYNAMIC_CH_SLICER_OVERLAP_LEN               = "com.inchecktech.dpm.dsp.Slicer.lengthForOverlap";
    public static final String CONFIG_DYNAMIC_CH_SLICER_NO_OF_SLICES              = "com.inchecktech.dpm.dsp.Slicer.numOfSlicesForOverlap";
    public static final String CONFIG_DYNAMIC_CH_SLICER_LEN_FOR_TRIGGERS          = "com.inchecktech.dpm.dsp.Slicer.lengthForTriggers";
    public static final String CONFIG_DYNAMIC_CH_SLICER_NO_SLICES_TRG             = "com.inchecktech.dpm.dsp.Slicer.numOfSlicesForTriggers";
    public static final String CONFIG_DYNAMIC_CH_SLICER_DELAY                     = "com.inchecktech.dpm.dsp.Slicer.delay";

    public static final String CONFIG_DYNAMIC_CH_RPMCALC_TICKSPERREV              = "com.inchecktech.dpm.dsp.RPMCalculator.ticksPerRevolution";
    public static final String CONFIG_DYNAMIC_CH_PRIMARY_EU                       = "com.inchecktech.dpm.dsp.ChannelPrimaryEngineeringUnits";
    public static final String CONFIG_DYNAMIC_CH_FFT_RADIX2_LEN                   = "com.inchecktech.dpm.dsp.FFTTransformer.fftRadix2Length";
    public static final String CONFIG_DYNAMIC_CH_CALC_SAMPL_RATE                  = "com.inchecktech.dpm.dsp.CalculationsSamplingRate";

    public static final String CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER            = "com.inchecktech.dpm.dsp.HighPassFilter.FilterOrder";
    public static final String CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER_BD         = "com.inchecktech.dpm.dsp.HighPassFilter.FilterOrder.BearinDem";
    public static final String CONFIG_DYNAMIC_CH_HPFILTER_FILTER_ORDER_BD_PFFT    = "com.inchecktech.dpm.dsp.HighPassFilter.FilterOrder.BearinDem.PreFFT";
    public static final String CONFIG_DYNAMIC_CH_LPFILTER_FILTER_ORDER            = "com.inchecktech.dpm.dsp.LowPassFilter.FilterOrder";

    public static final String CONFIG_DYNAMIC_CH_HPFILTER_PREFFTACC_CUTOFF        = "com.inchecktech.dpm.dsp.HighPassFilter.PreFFTAcc.Cutoff";
    public static final String CONFIG_DYNAMIC_CH_HPFILTER_PREINTTOVEL_CUTOFF      = "com.inchecktech.dpm.dsp.HighPassFilter.PreIntToVel.Cutoff";
    public static final String CONFIG_DYNAMIC_CH_HPFILTER_POSTINTTOVEL_CUTOFF     = "com.inchecktech.dpm.dsp.HighPassFilter.PostIntToVel.Cutoff";
    public static final String CONFIG_DYNAMIC_CH_HPFILTER_PREINTTODISPL_CUTOFF    = "com.inchecktech.dpm.dsp.HighPassFilter.PreIntToDspl.Cutoff";

    public static final String CONFIG_DYNAMIC_CH_RECENT_TREND_BUFFER_SZ           = "com.inchecktech.dpm.dsp.recentTrendBufferSize";
    public static final String CONFIG_DYNAMIC_CH_TREND_TIME_LIMIT_SEC             = "com.inchecktech.dpm.dsp.Dashboard.Time.Limit";
    public static final String CONFIG_DYNAMIC_CH_OVERALLS_TYPE                    = "com.inchecktech.dpm.dsp.overallsToCalc";
    public static final String CONFIG_DYNAMIC_CH_OVERALLS_SUB_TYPE                = "com.inchecktech.dpm.dsp.overallsSubType";

    public static final String CONFIG_DYNAMIC_CH_BRNG_DEM_HIGH_PASS_FILTER_CUTOFF = "com.inchecktech.dpm.dsp.BearingDem.HighPassFilter.Cutoff";
    public static final String CONFIG_DYNAMIC_CH_BRNG_DEM_LOW_PASS_FILTER_CUTOFF  = "com.inchecktech.dpm.dsp.BearingDem.LowPassFilter.Cutoff";
    public static final String CONFIG_DYNAMIC_CH_BRNG_DEM_PASS_FILTER_CUTOFF_PFFT = "com.inchecktech.dpm.dsp.BearingDem.HighPassFilter.Cutoff.PreFFT";

    public static final String CONFIG_DYNAMIC_CH_DEFAULT_PROC_DATA_KEY            = "com.inchecktech.dpm.dsp.defaultProcessedDataKey";

    public static final String CONFIG_DYNAMIC_CH_ANALYSIS_BANDWIDTH               = "com.inchecktech.dpm.dam.AnalysisBandwidth";

    public static final String CONFIG_DYNAMIC_CH_ADJ_FACTOR_FREQ                  = "com.inchecktech.dpm.dsp.AdjustmentFactorFreq";
    public static final String CONFIG_DYNAMIC_CH_ADJ_FACTOR_GAIN                  = "com.inchecktech.dpm.dam.AdjustmentFactorGain";
    
    public static final String CONFIG_DYNAMIC_CH_DCFILTER_SMOOTHING_FACTOR		  = "com.inchecktech.dpm.dsp.DCFilter.SmoothingFactor";
    
    /** Name of controller configuration file */
    public static final String CONFIG_FILE_NAME = "dpm_mail";

    /** Mail alarm notification address from */
    public static final String MAIL_ALARM_ADDRESS_FROM = "mail.alarm.address.from";

    /** Mail alarm notification address to */
    public static final String MAIL_ALARM_ADDRESS_TO = "mail.alarm.address.to";

    /** Mail alarm notification subject */
    public static final String MAIL_ALARM_SUBJECT = "mail.alarm.subject";
    
    /** The Constant ALERT_DATE_PATTERN. */
    public static final String ALERT_DATE_PATTERN = "mail.alarm.alert.date.format";
    
    /** Mail alarm validation error message */
    public static final String MAIL_ALARM_VALIDATION_ERROR_MESSAGE = "mail.alarm.validation.error.message";
    
    /** Mail alarm notification time interval*/
    public static final String MAIL_ALARM_NOTIFICATION_TIME_INTERVAL = "mail.alarm.period.seconds";
}
