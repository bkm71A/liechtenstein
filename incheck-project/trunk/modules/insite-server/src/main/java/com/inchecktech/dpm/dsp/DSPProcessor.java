/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */

package com.inchecktech.dpm.dsp;

import java.security.InvalidAlgorithmParameterException;
import java.util.List;

import com.inchecktech.dpm.beans.PhysicalDomain;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.ProcessedDynamicData;
import com.inchecktech.dpm.utils.Logger;

/**
 * This is the helper class containing static methods for processing/converting/calculating ProcessedData objects into
 * caller requested format.
 * @author Taras Dobrovolsky Change History:
 *         <li> 04/19/2008 Taras Dobrovolsky Initial Release
 *         <li> 04/24/2008 Taras Dobrovolsky Defect Fixes
 *         <li> 04/29/2008 Taras Dobrovolsky Defect Fixes
 */
class DSPProcessor {
    
    @SuppressWarnings("unused")
    private static final Logger logger                         = new Logger( DSPProcessor.class );

    /**
     * @param dataIn
     * @param highPassFilter
     * @param weightingAlg
     * @param fftTransformer
     * @param hpFilterCutoffPreFFTAcc
     * @param scaleToRMS
     * @return
     * @throws InvalidAlgorithmParameterException
     */
    protected static ProcessedData calculateSpectrumAccel( ProcessedData dataIn, Filter highPassFilter,
                                                           WeightingAlg weightingAlg, FFTTransformer fftTransformer,
                                                           double hpFilterCutoffPreFFTAcc, boolean scaleToRMS,
                                                           int hpFilterOrder, int analysisBandwidth, Filter dcFilter )
                                                                                                     throws InvalidAlgorithmParameterException {

        if( (dataIn == null) || !(dataIn instanceof ProcessedDynamicData) )
            return dataIn;

        // //////////////////////////////////////////////////////////////////////////////////////////
        // REPLACED BY DC FILTER AS OF 09/10/2009
        // 1.4B Apply High-Pass filter with cutoff frequency 2 Hz (default/configurable) before FFT
        // ProcessedDynamicData dataOut = (ProcessedDynamicData) dataIn.deepCopy();
        // dataOut.setData( highPassFilter.filter( dataIn.getData(), dataIn.getSamplingRate(), hpFilterCutoffPreFFTAcc,
        //                                        hpFilterOrder ) );
        
        // //////////////////////////////////////////////////////////////////////////////////////////
        // 1.4B DC Filter
        ProcessedDynamicData dataOut = (ProcessedDynamicData) dataIn.deepCopy();
        
        dataOut.setData( dcFilter.filter( dataIn.getData(), dataIn.getSamplingRate() ) );
        
        // ////////////////////////////////////////////////////////////////////////
        // 1.5 Apply Windowing Method; Default: Hanning Window
        weightingAlg.weight( dataOut.getData() ); // weighting performed in place

        // ////////////////////////////////////////////////////////////////////////
        // 1.6 FFT for Acceleration Output Range: [0, result / 1.28]
        // EX: 512 a 400 lines (for block size = 1024)
        dataOut.setData( fftTransformer.FFTTransform( dataOut.getData() ) );
        
        /*
        if( scaleToRMS ) {
            dataOut.setData( DSPUtils.scaleToRMS( dataOut.getData() ) ); // scale to RMS
        }*/

        // step = sampling_rate (before FFT) / block_size (before FFT)
        // last_point = step * (number of data points)
        double step = (double) ((double) dataIn.getSamplingRate() / (double) dataIn.getData().size());
        DSPUtils.setLabels( dataOut, 0, step * (dataOut.getData().size()) );

        dataOut.setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_HZ );
        dataOut.setMeasurementType( ProcessedData.MEASUREMENT_TYPE_ABSOLUTE );

        dataOut.setXEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Frequency ) );
        dataOut.setYEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Acceleration ) );

        return dataOut;
    }

    /**
     * @param dataIn
     * @param highPassFilter
     * @param integrator
     * @param hpFilterCutoffPreIntToVel
     * @param hpFilterCutoffPostIntToVel
     * @return
     * @throws InvalidAlgorithmParameterException
     */
    protected static ProcessedData calculateTimeWaveVel( ProcessedData dataIn, Filter highPassFilter,
                                                         Integrator integrator, double hpFilterCutoffPreIntToVel,
                                                         double hpFilterCutoffPostIntToVel, int hpFilterOrder, Filter dcFilter )
                                                                                                               throws InvalidAlgorithmParameterException {
        if( (dataIn == null) || !(dataIn instanceof ProcessedDynamicData) )
            return dataIn;

        // ///////////////////////////////////////////////////////////////////////
        // REPLACED BY DC FILTER AS OF 09/10/2009
        // 2.5 Apply High-Pass Filter to the result set obtained in Step 1.4
        // Cutoff Frequency = 1Hz (Default, but configurable)
        // Sampling Rate = Resampled Sampling Rate
        // ProcessedDynamicData dynData25 = ((ProcessedDynamicData) dataIn).deepCopy();
        // dynData25.setData( highPassFilter.filter( dynData25.getData(), dataIn.getSamplingRate(),
        //                                           hpFilterCutoffPreIntToVel, hpFilterOrder ) );
        
        // ///////////////////////////////////////////////////////////////////////
        // 2.5 Apply DC Filter to the result set obtained in Step 1.4
/* Ticket #20: 1.4 Calculate time Wave velocity data: In according to the new algorithm we don't need to dc-filtering before the integration: start*/
// the dcFilter has been moved to level up.        
        //ProcessedDynamicData dynData25 = ((ProcessedDynamicData) dataIn).deepCopy();
        //dynData25.setData( dcFilter.filter( dynData25.getData(), dataIn.getSamplingRate() ) );
/* Ticket #20: 1.4 Calculate time Wave velocity data: In according to the new algorithm we don't need to dc-filtering before the integration: end*/    	                        

        // ///////////////////////////////////////////////////////////////////////
        // 2.6 Integration to Velocity
        // * DO NOT DO ADJUSTMENT USING INTEGRATION CONSTANT
        ProcessedDynamicData dynData26 = ((ProcessedDynamicData) dataIn).deepCopy();
        dynData26
                 .setData( integrator
                                     .integrateTDAccellerationToVelocity( dynData26.getData(), dataIn.getSamplingRate(), dataIn.getNoOfAppendedZeros() ) );

        // ///////////////////////////////////////////////////////////////////////
        // REPLACED BY DC FILTER AS OF 09/10/2009
        // 2.7 Apply High-Pass Filter
        // Cutoff Frequency = 2Hz (Default, but configurable)
        // Sampling Rate = Resampled Sampling Rate
        // ProcessedDynamicData dynData27 = dynData26.deepCopy();
        // dynData27.setData( highPassFilter.filter( dynData27.getData(), dataIn.getSamplingRate(),
        //                                          hpFilterCutoffPostIntToVel, hpFilterOrder ) );
        
        // ///////////////////////////////////////////////////////////////////////
        // 2.7 Apply DC Filter
        // Cutoff Frequency = 2Hz (Default, but configurable)
        // Sampling Rate = Resampled Sampling Rate
        ProcessedDynamicData dynData27 = dynData26.deepCopy();
        dynData27.setData( dcFilter.filter( dynData27.getData(), dataIn.getSamplingRate() ) );

        double startTime = (double) dataIn.getDateTimeStamp().getTime();
        double endTime = (double) (startTime + 1000 * dataIn.getData().size() / dataIn.getSamplingRate());
        DSPUtils.setLabels( dynData27, 0, (endTime - startTime) * 0.001 );

        dynData27.setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_MS );
        dynData27.setMeasurementType( ProcessedData.MEASUREMENT_TYPE_DELTA );

        dynData27.setXEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Time ) );
        dynData27.setYEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Velocity ) );

        return dynData27;
    }

    /**
     * @param dataIn
     * @param highPassFilter
     * @param weightingAlg
     * @param fftTransformer
     * @param integrator
     * @param hpFilterCutoffPreIntToVel
     * @param hpFilterCutoffPostIntToVel
     * @param scaleToRMS
     * @return
     * @throws InvalidAlgorithmParameterException
     */
    protected static ProcessedData calculateSpectrumVel( ProcessedData dataIn, Filter highPassFilter,
                                                         WeightingAlg weightingAlg, FFTTransformer fftTransformer,
                                                         Integrator integrator, double hpFilterCutoffPreIntToVel,
                                                         double hpFilterCutoffPostIntToVel, boolean scaleToRMS,
                                                         int hpFilterOrder, int analysisBandwidth, Filter dcFilter, double hpFilterCutoffPreFFTAcc)
                                                                                                   throws InvalidAlgorithmParameterException {
        if( (dataIn == null) || !(dataIn instanceof ProcessedDynamicData) ) {
            return dataIn;
        }
        
        ProcessedDynamicData dynData = (ProcessedDynamicData)calculateSpectrumAccel(dataIn, highPassFilter, weightingAlg, fftTransformer, hpFilterCutoffPreFFTAcc, scaleToRMS, hpFilterOrder, analysisBandwidth, dcFilter).deepCopy();
        // TODO quickfix restore labels
		List<Double> labels = dynData.getDataLabels();
		dynData.setData(integrator.integrateFDAccellerationToVelocity(dynData.getData(), dataIn.getSamplingRate(), dynData));

		int arrayLengthDifference = dynData.getData().size() - labels.size();
		for (int j = 0; j < arrayLengthDifference; j++) {
			dynData.getData().remove(dynData.getData().size() - 1);
		}
		dynData.setDataLabels(labels);
		// end TODO quickfix
        /*
		 * ProcessedDynamicData dynData27 = (ProcessedDynamicData)
		 * calculateTimeWaveVel( dataIn, highPassFilter, integrator,
		 * hpFilterCutoffPreIntToVel, hpFilterCutoffPostIntToVel, hpFilterOrder,
		 * dcFilter );
		 *  //
		 * //////////////////////////////////////////////////////////////////////// //
		 * 2.8 Apply Windowing Method; Default: Hanning Window
		 * weightingAlg.weight( dynData27.getData() ); // weighting performed in
		 * place
		 *  //
		 * //////////////////////////////////////////////////////////////////////// //
		 * 2.9 FFT for Velocity Output Range: [0, result / 1.28] // EX: 512
		 * 400 lines (for sampling rate = 1024) ProcessedDynamicData dynData28 =
		 * dynData27.deepCopy(); dynData28.setData( fftTransformer.FFTTransform(
		 * dynData28.getData() ) );
		 * 
		 * dynData28.setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_HZ );
		 * dynData28.setMeasurementType( ProcessedData.MEASUREMENT_TYPE_ABSOLUTE );
		 * 
		 * if( scaleToRMS ) { dynData28.setData( DSPUtils.scaleToRMS(
		 * dynData28.getData() ) ); // scale to RMS }
		 * 
		 * double step = (double) ((double) dataIn.getSamplingRate() / (double)
		 * dataIn.getData().size()); DSPUtils.setLabels( dynData28, 0, step *
		 * (dynData28.getData().size()) ); // DSPUtils.setLabels( dynData28, 0,
		 * analysisBandwidth + (double)(double) analysisBandwidth /
		 * (double)(dynData28.getData().size() - 1) );
		 */
        dynData.setXEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Frequency ) );
        dynData.setYEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Velocity ) );
        return dynData;
    }

    /**
     * @param dataIn
     * @param highPassFilter
     * @param integrator
     * @param hpFilterCutoffPreIntToVel
     * @param hpFilterCutoffPostIntToVel
     * @param hpFilterCutoffPostIntToDspl
     * @return
     * @throws InvalidAlgorithmParameterException
     */
    protected static ProcessedData calculateTimeWaveDispl( ProcessedData dataIn, Filter highPassFilter,
                                                           Integrator integrator, double hpFilterCutoffPreIntToVel,
                                                           double hpFilterCutoffPostIntToVel,
                                                           double hpFilterCutoffPostIntToDspl, int hpFilterOrder, Filter dcFilter )
                                                                                                                  throws InvalidAlgorithmParameterException {
        if( (dataIn == null) || !(dataIn instanceof ProcessedDynamicData) )
            return dataIn;

        double startTime = (double) dataIn.getDateTimeStamp().getTime();
        double endTime = (double) (startTime + 1000 * dataIn.getData().size() / dataIn.getSamplingRate());

        ProcessedDynamicData dynData37 = (ProcessedDynamicData) calculateTimeWaveVel( dataIn, highPassFilter,
                                                                                      integrator,
                                                                                      hpFilterCutoffPreIntToVel,
                                                                                      hpFilterCutoffPostIntToVel,
                                                                                      hpFilterOrder, dcFilter );

        // ////////////////////////////////////////////////////////////////////////
        // 3.8 Integration to Displacement
        // * DO NOT DO ADJUSTMENT USING INTEGRATION CONSTANT
        dynData37
                 .setData( integrator.integrateTDVelocityToDisplacement( dynData37.getData(), dataIn.getSamplingRate(), dataIn.getNoOfAppendedZeros() ) );

        // ///////////////////////////////////////////////////////////////////////
        // 3.9 Apply High-Pass Filter
        // Cutoff Frequency = 2Hz (Default, but configurable)
        // Sampling Rate = Resampled Sampling Rate
        /*yk (12/01/09): dynData37.setData( highPassFilter.filter( dynData37.getData(), dataIn.getSamplingRate(),
                                                  hpFilterCutoffPostIntToDspl, hpFilterOrder ) );
		*/
        DSPUtils.setLabels( dynData37, 0, (endTime - startTime) * 0.001 );

        dynData37.setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_MS );
        dynData37.setMeasurementType( ProcessedData.MEASUREMENT_TYPE_DELTA );

        dynData37.setXEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Time ) );
        dynData37.setYEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Displacement ) );

        return dynData37;

    }

    /**
     * @param dataIn
     * @param highPassFilter
     * @param weightingAlg
     * @param fftTransformer
     * @param integrator
     * @param hpFilterCutoffPreIntToVel
     * @param hpFilterCutoffPostIntToVel
     * @param hpFilterCutoffPostIntToDspl
     * @param scaleToRMS
     * @return
     * @throws InvalidAlgorithmParameterException
     */
    protected static ProcessedData calculateSpectrumDispl( ProcessedData dataIn, Filter highPassFilter,
                                                           WeightingAlg weightingAlg, FFTTransformer fftTransformer,
                                                           Integrator integrator, double hpFilterCutoffPreIntToVel,
                                                           double hpFilterCutoffPostIntToVel,
                                                           double hpFilterCutoffPostIntToDspl, boolean scaleToRMS,
                                                           int hpFilterOrder, int analysisBandwidth, Filter dcFilter )
                                                                                                     throws InvalidAlgorithmParameterException {
        if( (dataIn == null) || !(dataIn instanceof ProcessedDynamicData) )
            return dataIn;

        ProcessedDynamicData dynData38 = (ProcessedDynamicData) calculateTimeWaveDispl( dataIn, highPassFilter,
                                                                                        integrator,
                                                                                        hpFilterCutoffPreIntToVel,
                                                                                        hpFilterCutoffPostIntToVel,
                                                                                        hpFilterCutoffPostIntToDspl,
                                                                                        hpFilterOrder, dcFilter );
        // ////////////////////////////////////////////////////////////////////////
        // 3.10 Apply Windowing Method; Default: Hanning Window
        weightingAlg.weight( dynData38.getData() ); // weighting performed in place

        // ////////////////////////////////////////////////////////////////////////
        // 3.11 FFT for Displacement Output Range: [0, result / 1.28]
        // EX: 512 400 lines (for sampling rate = 1024)
        dynData38.setData( fftTransformer.FFTTransform( dynData38.getData() ) );

        dynData38.setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_HZ );
        dynData38.setMeasurementType( ProcessedData.MEASUREMENT_TYPE_ABSOLUTE );

        if( scaleToRMS ) {
            dynData38.setData( DSPUtils.scaleToRMS( dynData38.getData() ) ); // scale to RMS
        }

        double step = (double) ((double) dataIn.getSamplingRate() / (double) dataIn.getData().size());
        DSPUtils.setLabels( dynData38, 0, step * (dynData38.getData().size()) );
        // DSPUtils.setLabels( dynData38, 0, analysisBandwidth + (double)(double) analysisBandwidth / (double)(dynData38.getData().size() - 1) );

        dynData38.setXEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Frequency ) );
        dynData38.setYEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Displacement ) );

        return dynData38;

    }

    /**
     * @param dataIn
     * @param highPassFilter
     * @param lowPassFilter
     * @param fftTransformer
     * @param bearingDemHighPassCuttof
     * @param bearingDemLowPassCuttof
     * @param scaleToRMS
     * @return
     * @throws InvalidAlgorithmParameterException
     */
    protected static ProcessedData calculateBearingDemod( ProcessedData dataIn, Filter highPassFilter,
                                                          Filter lowPassFilter, FFTTransformer fftTransformer,
                                                          double bearingDemHighPassCuttof,
                                                          double bearingDemLowPassCuttof, boolean scaleToRMS,
                                                          int hpFilterOrderBrnDem, int lpFilterOrder,
                                                          double bearingDemHighPassCuttofPreFFT,
                                                          int hpFilterOrderBrnDemPreFFT, int analysisBandwidth,
                                                          Resampler resampler, int newSamplingRate, Filter dcFilter)
                                                                                                                throws InvalidAlgorithmParameterException {
        if( (dataIn == null) || !(dataIn instanceof ProcessedDynamicData) )
            return dataIn;

        // ////////////////////////////////////////////////////////////////////////
        // BEARING DEMODULATION CALCULATIONS
        // 4.5 Apply High-Pass filter
        ProcessedDynamicData dynData45 = (ProcessedDynamicData) dataIn.deepCopy();
        /*yk (12/01/09): dynData45.setData( highPassFilter.filter( dynData45.getData(), dataIn.getSamplingRate(),
                                                  bearingDemHighPassCuttof, hpFilterOrderBrnDem ) );
         */
        // 4.6 Apply ABS() - absolute value function
        dynData45.setData( DSPUtils.abs( dynData45.getData() ) );

        // REPLACED BY DC FILTER AS OF 09/10/2009
        // 4.7 Apply Low-Pass filter
        // dynData45.setData( lowPassFilter.filter( dynData45.getData(), dataIn.getSamplingRate(),
        //                                         bearingDemLowPassCuttof, lpFilterOrder ) );
        
        // 4.7 Apply Low-Pass filter
        dynData45.setData( dcFilter.filter( dynData45.getData(), dataIn.getSamplingRate() ) );

        // REPLACED BY DC FILTER AS OF 09/10/2009
        // 4.8 Apply High-Pass filter @2Hz (default, but configurable inDB)
        // dynData45.setData( highPassFilter.filter( dynData45.getData(), dataIn.getSamplingRate(),
        //                                          bearingDemHighPassCuttofPreFFT, hpFilterOrderBrnDemPreFFT ) );
        
        // 4.8 Apply High-Pass filter @2Hz (default, but configurable inDB)
        /*yk (12/01/09): dynData45.setData( dcFilter.filter( dynData45.getData(), dataIn.getSamplingRate() ) );
         * */
        
        // 4.8.5 TODO: Apply re-sampling here to new sampling rate
        ProcessedDynamicData dynData46 = dynData45.deepCopy();
        dynData46.setSamplingRate( newSamplingRate );
        dynData46.setDateTimeStamp( dynData45.getDateTimeStamp() );
        /*yk (12/01/09): dynData46.setData( resampler.resampleRadix2( dynData45.getData(), dynData45.getSamplingRate(), newSamplingRate, dynData46 ) );
         */
        dynData46.setData(dynData45.getData());
        		
        double step = (double) ((double) dynData46.getSamplingRate() / (double) dynData46.getData().size());
        
        // 4.9 Apply FFT to convert to spectrum
        dynData46.setData( fftTransformer.FFTTransform( dynData46.getData() ) );

        dynData46.setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_HZ );
        dynData46.setMeasurementType( ProcessedData.MEASUREMENT_TYPE_ABSOLUTE );

        if( scaleToRMS ) {
            dynData46.setData( DSPUtils.scaleToRMS( dynData46.getData() ) ); // scale to RMS
        }
        
        DSPUtils.setLabels( dynData46, 0, step * (dynData46.getData().size()) );
        // DSPUtils.setLabels( dynData45, 0, analysisBandwidth + (double) (double) analysisBandwidth / (double) (dynData45.getData().size() - 1) );

        dynData46.setXEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Frequency ) );
        dynData46.setYEUnit( EUnitConverter.getDefaultUnit( PhysicalDomain.Acceleration ) );

        return dynData46;

    }

}
