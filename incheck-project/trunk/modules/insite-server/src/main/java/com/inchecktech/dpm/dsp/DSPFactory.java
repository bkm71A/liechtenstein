/**
 * Copyright 2007, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.util.Map;
import java.util.Vector;

import com.inchecktech.dpm.config.ChannelConfigFactory;

/**
 * The class is part of the pluggable factory pattern for DSP (Digital Signal Processing) algorithms. As the system
 * evolves, better methods for processing and analyzing digitized sample data will be implemented, and this factory
 * design pattern will allow easily change algorithms and methods without impacting other system components.
 * DSPConfiguration.properties will contain configuration parameters to fine-tune DSP (Digital Signal Processing)
 * algorithms for use in DPM engine. Developers, please refer to the Resampler interface and
 * LinearInterpolationResampler implementing class for details on how to implement other pluggable algorithms.
 * @author Taras Dobrovolsky Change History: 09/27/2007 Taras Dobrovolsky Initial Release 10/14/2007 Taras Dobrovolsky
 *         Added methods for creating UnitConverter and Integrator instances 11/07/2007 Taras Dobrovolsky Added
 *         additional methods for instantiating dynamic/static calculators 12/30/2007 Taras Dobrovolsky Added additional
 *         methods for instantiating high/low-pass filters
 */

public class DSPFactory {

    /**
     * This method creates an instance of the Resampler class. It is part of the DSP Factory pattern that allows
     * multiple implementations/methods
     * @param channelId channel unique identifier.
     * @return An instance of a class/algorithm that implements Resampler interface
     * @throws RuntimeException if the method cannot instantiate a class specified in configuration file that implements
     *             Resampler interface
     */
    public static Resampler newResampler( int channelId, Map<String, String> configProps ) throws RuntimeException {

        try {

            Class<?> resamplerClass;

            resamplerClass = Class.forName( configProps.get( DSPConstants.CONFIG_DYNAMIC_RESAMPLER_IMPL ) );
            return (Resampler) resamplerClass.newInstance();

        }
        catch( Exception e3 ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # " + channelId
                                        + ": Error creating an instance of Resampler class.\n\t "
                                        + "Check the following configuration parameter: "
                                        + DSPConstants.CONFIG_DYNAMIC_RESAMPLER_IMPL + "\n\t" + e3 );
        }

    }

    /**
     * This method creates an instance of the UnitConverter class. It is part of the DSP Factory pattern that allows
     * multiple implementations/methods
     * @param channelId channel unique identifier.
     * @return An instance of a class/algorithm that implements UnitConverter interface
     * @throws RuntimeException if the method cannot instantiate a class specified in configuration file that implements
     *             UnitConverter interface
     */
    public static UnitConverter newUnitConverter( int channelId, Map<String, String> configProps )
                                                                                                  throws RuntimeException {

        try {

            Class<?> ucClass;

            ucClass = Class.forName( configProps.get( DSPConstants.CONFIG_DYNAMIC_UCONVERTER_IMPL ) );
            UnitConverter converter = (UnitConverter) ucClass.newInstance();

            int maxVolts, bitResolution;
            double sensorSensitivity, sensorBiasVoltage, sensorGain, sensorOffset;

            // set sensor configuration parameters for unit conversion
            try {
                maxVolts = Integer.parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_MAXVOLTS ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_MAXVOLTS
                                            + ": Must be numeric (integer) and defined in database.\n\t " + e );
            }
            try {
                bitResolution = Integer.parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_BITRES ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_BITRES
                                            + ": Must be numeric (integer) and defined in database.\n\t " + e );
            }
            try {
                sensorSensitivity = Double
                                          .parseDouble( configProps
                                                                   .get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_SENCITVTY ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_SENCITVTY
                                            + ": Must be numeric (double) and defined in database.\n\t " + e );
            }
            try {
                sensorBiasVoltage = Double
                                          .parseDouble( configProps
                                                                   .get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_BIASVOLT ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_BIASVOLT
                                            + ": Must be numeric (double) and defined in database.\n\t " + e );
            }
            try {
                sensorGain = Double.parseDouble( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_GAIN ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_GAIN
                                            + ": Must be numeric (double) and defined in database.\n\t " + e );
            }
            try {
                sensorOffset = Double.parseDouble( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_OFFSET ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_UNITCONV_OFFSET
                                            + ": Must be numeric (double) and defined in database.\n\t " + e );
            }

            converter.setMaxVoltage( maxVolts );
            converter.setBitResolution( bitResolution );
            converter.setSensorSensitivity( sensorSensitivity );
            converter.setSensorBiasVoltage( sensorBiasVoltage );
            converter.setSensorGain( sensorGain );
            converter.setSensorOffset( sensorOffset );

            return converter;

        }
        catch( Exception e3 ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # " + channelId
                                        + ": Error creating an instance of UnitConverter class.\n\t "
                                        + "Check the following configuration parameter: "
                                        + DSPConstants.CONFIG_DYNAMIC_UCONVERTER_IMPL + "\n\t" + e3 );

        }

    }

    /**
     * This method creates an instance of the Integrator class. It is part of the DSP Factory pattern that allows
     * multiple implementations/methods
     * @param channelId channel unique identifier.
     * @return An instance of a class/algorithm that implements Integrator interface
     * @throws Runtime Exception if the method cannot instantiate a class specified in configuration file that
     *             implements Integrator interface
     */
    public static Integrator newIntegrator( int channelId, Map<String, String> configProps ) throws RuntimeException {

        try {

            Class<?> integratorClass;

            integratorClass = Class.forName( configProps.get( DSPConstants.CONFIG_DYNAMIC_INTEGRATOR_IMPL ) );
            return (Integrator) integratorClass.newInstance();

        }
        catch( Exception e3 ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # " + channelId
                                        + ": Error creating an instance of Integrator class.\n\t "
                                        + "Check the following configuration parameter: "
                                        + DSPConstants.CONFIG_DYNAMIC_INTEGRATOR_IMPL + "\n\t" + e3 );
        }

    }

    /**
     * This method creates an instance of the Integrator class. It is part of the DSP Factory pattern that allows
     * multiple implementations/methods
     * @param channelId channel unique identifier.
     * @return An instance of a class/algorithm that implements Integrator interface
     * @throws RuntimeException if the method cannot instantiate a class specified in configuration file that implements
     *             WeightingAlg interface
     */
    public static WeightingAlg newWeightingAlg( int channelId, Map<String, String> configProps )
                                                                                                throws RuntimeException {

        try {

            Class<?> weightingClass;

            weightingClass = Class.forName( configProps.get( DSPConstants.CONFIG_DYNAMIC_WEIGHT_ALG_IMPL ) );
            return (WeightingAlg) weightingClass.newInstance();

        }
        catch( Exception e3 ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # " + channelId
                                        + ": Error creating an instance of WeightingAlg class.\n\t "
                                        + "Check the following configuration parameter: "
                                        + DSPConstants.CONFIG_DYNAMIC_WEIGHT_ALG_IMPL + "\n\t" + e3 );
        }

    }

    /**
     * This method creates an instance of a Slicer class. It is part of the DSP Factory pattern that allows multiple
     * implementations/methods
     * @param channelId channel unique identifier.
     * @return An instance of a class/algorithm that implements Slicer interface
     * @throws RuntimeException if the method cannot instantiate a class specified in configuration file that implements
     *             Slicer interface
     */
    public static Slicer newSlicer( int channelId, Map<String, String> configProps ) throws RuntimeException {

        try {

            Class<?> ucClass;

            ucClass = Class.forName( configProps.get( DSPConstants.CONFIG_DYNAMIC_SLICER_IMPL ) );
            Slicer slicer = (Slicer) ucClass.newInstance();

            double overlapPercent;
            int lengthForOverlap, numOfSlicesForOverlap, lengthForTriggers, numOfSlicesForTriggers, delay;

            // set sensor configuration parameters for unit conversion
            try {
                overlapPercent = Double
                                       .parseDouble( configProps
                                                                .get( DSPConstants.CONFIG_DYNAMIC_CH_SLICER_OVERLAP_PERCENT ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_SLICER_OVERLAP_PERCENT
                                            + ": Must be numeric (double) and defined in database.\n\t " + e );
            }
            try {
                lengthForOverlap = Integer
                                          .parseInt( configProps
                                                                .get( DSPConstants.CONFIG_DYNAMIC_CH_SLICER_OVERLAP_LEN ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_SLICER_OVERLAP_LEN
                                            + ": Must be numeric (integer) and defined in database.\n\t " + e );
            }
            try {
                numOfSlicesForOverlap = Integer
                                               .parseInt( configProps
                                                                     .get( DSPConstants.CONFIG_DYNAMIC_CH_SLICER_NO_OF_SLICES ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_SLICER_NO_OF_SLICES
                                            + ": Must be numeric (integer) and defined in database.\n\t " + e );
            }
            try {
                lengthForTriggers = Integer
                                           .parseInt( configProps
                                                                 .get( DSPConstants.CONFIG_DYNAMIC_CH_SLICER_LEN_FOR_TRIGGERS ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_SLICER_LEN_FOR_TRIGGERS
                                            + ": Must be numeric (integer) and defined in database.\n\t " + e );
            }
            try {
                numOfSlicesForTriggers = Integer
                                                .parseInt( configProps
                                                                      .get( DSPConstants.CONFIG_DYNAMIC_CH_SLICER_NO_SLICES_TRG ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_SLICER_NO_SLICES_TRG
                                            + ": Must be numeric (integer) and defined in database.\n\t " + e );
            }
            try {
                delay = Integer.parseInt( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_SLICER_DELAY ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_SLICER_DELAY
                                            + ": Must be numeric (integer) and defined in database.\n\t " + e );
            }

            slicer.setOverlapPercentForOverlapAlg( overlapPercent );
            slicer.setSliceLengthForOverlapAlg( lengthForOverlap );
            slicer.setNumOfSlicesForOverlapAlg( numOfSlicesForOverlap );
            slicer.setSliceLengthForTriggerAlg( lengthForTriggers );
            slicer.setNumOfSlicesForTriggerAlg( numOfSlicesForTriggers );
            slicer.setDelayForTriggersAlg( delay );

            return slicer;

        }
        catch( Exception e3 ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # " + channelId
                                        + ": Error creating an instance of Slicer class.\n\t "
                                        + "Check the following configuration parameter: "
                                        + DSPConstants.CONFIG_DYNAMIC_SLICER_IMPL + "\n\t" + e3 );
        }

    }

    /**
     * This method creates an instance of the FFTTRansformer class. It is part of the DSP Factory pattern that allows
     * multiple implementations/methods
     * @param channelId channel unique identifier.
     * @return An instance of a class/algorithm that implements FFTTransformer interface
     * @throws RuntimeException if the method cannot instantiate a class specified in configuration file that implements
     *             FFTTransformer interface
     */
    public static FFTTransformer newFFTTransformer( int channelId, Map<String, String> configProps )
                                                                                                    throws RuntimeException {

        try {

            Class<?> ucClass;

            ucClass = Class.forName( configProps.get( DSPConstants.CONFIG_DYNAMIC_FFT_IMPL ) );
            FFTTransformer transformer = (FFTTransformer) ucClass.newInstance();

            return transformer;

        }
        catch( Exception e3 ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # " + channelId
                                        + ": Error creating an instance of FFTTransformer class.\n\t "
                                        + "Check the following configuration parameter: "
                                        + DSPConstants.CONFIG_DYNAMIC_FFT_IMPL + "\n\t" + e3 );
        }

    }

    /**
     * This method creates an instance of a Filter class. It is part of the DSP Factory pattern that allows multiple
     * implementations/methods
     * @param channelId channel unique identifier.
     * @return An instance of a class/algorithm that implements Filter interface
     * @throws RuntimeException if the method cannot instantiate a class specified in configuration file that implements
     *             Slicer interface
     */
    public static Filter newHighPassFilter( int channelId, Map<String, String> configProps ) throws RuntimeException {

        try {

            Class<?> ucClass;

            ucClass = Class.forName( configProps.get( DSPConstants.CONFIG_DYNAMIC_HP_FILTER_IMPL ) );
            Filter filter = (Filter) ucClass.newInstance();

            double cutoffFreq;

            // set cutoff frequency
            try {
                cutoffFreq = Double.parseDouble( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_CUTOFF ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_HPFILTER_CUTOFF
                                            + ": Must be numeric and defined in database.\n\t " + e );
            }

            filter.setCutoffFreq( cutoffFreq );

            return filter;

        }
        catch( Exception e3 ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # " + channelId
                                        + ": Error creating an instance of HP Filter class.\n\t "
                                        + "Check the following configuration parameter: "
                                        + DSPConstants.CONFIG_DYNAMIC_HP_FILTER_IMPL + "\n\t" + e3 );
        }

    }

    /**
     * This method creates an instance of a Filter class. It is part of the DSP Factory pattern that allows multiple
     * implementations/methods
     * @param channelId channel unique identifier.
     * @return An instance of a class/algorithm that implements Filter interface
     * @throws RuntimeException if the method cannot instantiate a class specified in configuration file that implements
     *             Slicer interface
     */
    public static Filter newLowPassFilter( int channelId, Map<String, String> configProps ) throws RuntimeException {

        try {

            Class<?> ucClass;

            ucClass = Class.forName( configProps.get( DSPConstants.CONFIG_DYNAMIC_LP_FILTER_IMPL ) );
            Filter filter = (Filter) ucClass.newInstance();

            double cutoffFreq;

            // set cutoff frequency
            try {
                cutoffFreq = Double.parseDouble( configProps.get( DSPConstants.CONFIG_DYNAMIC_CH_LPFILTER_CUTOFF ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error "
                                            + DSPConstants.CONFIG_DYNAMIC_CH_LPFILTER_CUTOFF
                                            + ": Must be numeric (double) and defined in database.\n\t " + e );
            }

            filter.setCutoffFreq( cutoffFreq );

            return filter;

        }
        catch( Exception e3 ) {
            throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # " + channelId
                                        + ": Error creating an instance of LP Filter class.\n\t "
                                        + "Check the following configuration parameter: "
                                        + DSPConstants.CONFIG_DYNAMIC_LP_FILTER_IMPL + "\n\t" + e3 );
        }

    }

    /**
     * Averages values of passed in vectors. The matrix contains vector slices. The slices must be of the same length.
     * @param matrix Vector of Vector of Doubles
     * @return averaged vector
     */
    public static Vector<Double> average( Vector<Vector<Double>> matrix ) {

        Vector<Double> averagedVector = new Vector<Double>();
        int vectorSize = (matrix.get( 0 )).size();
        for( int i = 0; i < vectorSize; i++ ) {
            double sum = 0;
            for( Vector<Double> v : matrix ) {
                sum += (Double) v.get( i );
            }
            if( matrix.size() != 0 ) {
                averagedVector.add( sum / matrix.size() );
            }
        }
        return averagedVector;

    }

    /**
     * Helper method that creates an instance of DSPDynamicCalculator or DSPStaticCalculator for a given channel. 
     * @param channelId Unique channel id for which DSP calculator is being created
     * @param channelType 
     * @return DSPCalculator object - either DSPStaticCalculator or DSPDynamicCalculator configured from the parameters
     *         specified in the database.
     * @throws RuntimeException if object can't be instantiated due to mis-confiiguration or other runtime problems
     *             (i.e. database is down, network is down etc.). Check runtime logs for detailed trace for
     *             troubleshooting.
     */
    private static DSPCalculator newDSPCalculator( int channelId, int channelType ) throws RuntimeException {

        try {
            if( channelType == DSPConstants.CONFIG_CH_TYPE_DYNAMIC ) {
                return new DSPDynamicCalculator( channelId );
            }
            else { // static channel
                return new DSPStaticCalculator( channelId );
            }
        }
        catch( Exception e3 ) {
            throw new RuntimeException(
                                        "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # "
                                                + channelId
                                                + ": Error creating an instance of DSPCalculator class.  Check configuration parameters.\n\t "
                                                + e3 );
        }

    }

    /**
     * Create an instance of DSPDynamicCalculator or DSPStaticCalculator for a given channel. Channel type (static or
     * dynamic) is defined in the database.
     * @param channelId Unique channel id for which DSP calculator is being created
     * @return DSPCalculator object - either DSPStaticCalculator or DSPDynamicCalculator configured from the parameters
     *         specified in the database.
     * @throws RuntimeException if object can't be instantiated due to mis-confiiguration or other runtime problems
     *             (i.e. database is down, network is down etc.). Check runtime logs for detailed trace for
     *             troubleshooting.
     */
    public static DSPCalculator newDSPCalculator( int channelId ) throws RuntimeException {

        try {
            Map<String, String> configProps = ChannelConfigFactory.readChannelConfig( channelId );

            int channelType;

            try {
                channelType = Integer.parseInt( configProps.get( DSPConstants.CONFIG_CH_TYPE ) );
            }
            catch( Exception e ) {
                throw new RuntimeException( "com.incheck.dpm.dsp.DSPFactory: CHANNEL # " + channelId
                                            + ": Configuration Parameter Error " + DSPConstants.CONFIG_CH_TYPE
                                            + ": Must be numeric (integer) 0 or 1 and defined in database.\n\t " + e );
            }

            return newDSPCalculator( channelId, channelType );

        }
        catch( Exception e3 ) {
            throw new RuntimeException(
                                        "com.incheck.dpm.dsp.DSPFactory: : CHANNEL # "
                                                + channelId
                                                + ": Error creating an instance of DSPCalculator class.  Check configuration parameters.\n\t "
                                                + e3 );
        }

    }

}
