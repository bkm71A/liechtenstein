/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.security.InvalidAlgorithmParameterException;
import java.util.List;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.DSPCoreDump;
import com.inchecktech.dpm.beans.EUnit;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.flex.DPMFlexProxy;

/**
 * This is the helper class for creating DSPCoreDump for debugging and analysis.
 * <p>
 * @author Taras Dobrovolsky Change History:
 *         <p>
 *         Change History:
 *         <ul>
 *         <li> 04/29/2008 Taras Dobrovolsky Initial Release
 *         </ul>
 */
class DSPDebugger {

    /**
     * Generate extensive debugging data.
     */
    protected static void debugDynamicChannel( DSPCoreDump dspCoreDump, RawData rawData, java.util.Date dateTimeStamp,
                                               ChannelState channelState, UnitConverter unitConverter,
                                               ProcessedData resampledData, Filter highPassFilter,
                                               WeightingAlg weightingAlg, FFTTransformer fftTransformer,
                                               double hpFilterCutoffPreFFTAcc, Integrator integrator,
                                               double hpFilterCutoffPreIntToVel, double hpFilterCutoffPostIntToVel,
                                               double hpFilterCutoffPostIntToDspl, Filter lowPassFilter,
                                               double bearingDemHighPassCuttof, double bearingDemLowPassCuttof,
                                               int hpFilterOrder, int lpFilterOrder, int hpFilterOrderBrnDem,
                                               double bearingDemHighPassCuttofPreFFT, int hpFilterOrderBrnDemPreFFT,
                                               int analysisBandwidth, DSPDynamicCalculator dspDynamicCaluclator,
                                               ProcessedData dataIn, Resampler resampler, int newSamplingRate, Filter dcFilter )
                                                                                                               throws InvalidAlgorithmParameterException {

        // Defines if test cases for engineering unit conversion are included in the dump
        // disable in production release
        boolean debugEUnitConversion = false;

        // Collect Raw Data and Ticks
        dspCoreDump.clear();
        dspCoreDump.setDateTimeStamp( dateTimeStamp );
        dspCoreDump.addMetaData( "Channel Id=" + rawData.getChannelId() );
        dspCoreDump.addMetaData( "DateTime=" + dateTimeStamp.toString() );
        dspCoreDump.addDataSet( rawData.getData(), "Raw Data from DAM" );
        dspCoreDump.addDataSet( rawData.getDataTicks(), "Data Ticks from DAM" );
        dspCoreDump.addMetaData( "Raw Data SR=" + rawData.getSamplingRate() );

        // Collect RPM
        dspCoreDump.addMetaData( "RPM=" + channelState.getRpm() + " Calculated from Ticks SR="
                                 + rawData.getSamplingRate() );

        // Collect other Meta Data
        dspCoreDump.addMetaData( "hpFilterCutoffPreFFTAcc=" + hpFilterCutoffPreFFTAcc );
        dspCoreDump.addMetaData( "hpFilterOrder=" + hpFilterOrder );
        dspCoreDump.addMetaData( "hpFilterCutoffPreIntToVel=" + hpFilterCutoffPreIntToVel );
        dspCoreDump.addMetaData( "hpFilterCutoffPostIntToVel=" + hpFilterCutoffPostIntToVel );
        dspCoreDump.addMetaData( "hpFilterCutoffPostIntToDspl=" + hpFilterCutoffPostIntToDspl );
        dspCoreDump.addMetaData( "bearingDemHighPassCuttof=" + bearingDemHighPassCuttof );
        dspCoreDump.addMetaData( "bearingDemLowPassCuttof=" + bearingDemLowPassCuttof );
        dspCoreDump.addMetaData( "hpFilterOrderBrnDem=" + hpFilterOrderBrnDem );
        dspCoreDump.addMetaData( "lpFilterOrder=" + lpFilterOrder );
        dspCoreDump.addMetaData( "bearingDemHighPassCuttofPreFFT=" + bearingDemHighPassCuttofPreFFT );
        dspCoreDump.addMetaData( "hpFilterOrderBrnDemPreFFT=" + hpFilterOrderBrnDemPreFFT );

        // Collect data converted to EU
        List<Double> euData = unitConverter.convertToGs( rawData.getData() );
        dspCoreDump.addDataSet( euData, "Raw Data Converted To EU" );

        // Collect low-pass filtered data
        dspCoreDump.addDataSet( lowPassFilter.filter( euData, rawData.getSamplingRate(),
                                                      (double) resampledData.getSamplingRate() / 2, lpFilterOrder ),
                                "LP Filtered Data" );

        // Collect re-sampled data
        dspCoreDump.addDataSet( resampledData.getData(), "Resampled Data New SR=" + resampledData.getSamplingRate() );
        dspCoreDump.addDataSet( resampledData.getDataLabels(), "Resampled Data LABELS"
                                                               + resampledData.getSamplingRate() );

        // Calculate and collect data sets usually calculated on-demand
        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumAccel( resampledData, highPassFilter, weightingAlg,
                                                                     fftTransformer, hpFilterCutoffPreFFTAcc, false,
                                                                     hpFilterOrder, analysisBandwidth, dcFilter ).getData(),
                                ProcessedData.KEY_SPECTRUM_ACC_PEAK );
        dspCoreDump
                   .addDataSet(
                                DSPProcessor.calculateSpectrumAccel( resampledData, highPassFilter, weightingAlg,
                                                                     fftTransformer, hpFilterCutoffPreFFTAcc, false,
                                                                     hpFilterOrder, analysisBandwidth, dcFilter ).getDataLabels(),
                                ProcessedData.KEY_SPECTRUM_ACC_PEAK + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumAccel( resampledData, highPassFilter, weightingAlg,
                                                                     fftTransformer, hpFilterCutoffPreFFTAcc, true,
                                                                     hpFilterOrder, analysisBandwidth, dcFilter ).getData(),
                                ProcessedData.KEY_SPECTRUM_ACC_RMS );
        dspCoreDump
                   .addDataSet(
                                DSPProcessor.calculateSpectrumAccel( resampledData, highPassFilter, weightingAlg,
                                                                     fftTransformer, hpFilterCutoffPreFFTAcc, true,
                                                                     hpFilterOrder, analysisBandwidth, dcFilter ).getDataLabels(),
                                ProcessedData.KEY_SPECTRUM_ACC_RMS + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateTimeWaveVel( resampledData, highPassFilter, integrator,
                                                                   hpFilterCutoffPreIntToVel,
                                                                   hpFilterCutoffPostIntToVel, hpFilterOrder, dcFilter )
                                            .getData(), ProcessedData.KEY_TIMEWAVE_VEL );
        dspCoreDump.addDataSet( DSPProcessor.calculateTimeWaveVel( resampledData, highPassFilter, integrator,
                                                                   hpFilterCutoffPreIntToVel,
                                                                   hpFilterCutoffPostIntToVel, hpFilterOrder, dcFilter )
                                            .getDataLabels(), ProcessedData.KEY_TIMEWAVE_VEL + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumVel( resampledData, highPassFilter, weightingAlg,
                                                                   fftTransformer, integrator,
                                                                   hpFilterCutoffPreIntToVel,
                                                                   hpFilterCutoffPostIntToVel, false, hpFilterOrder,
                                                                   analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc ).getData(),
                                ProcessedData.KEY_SPECTRUM_VEL_PEAK );
        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumVel( resampledData, highPassFilter, weightingAlg,
                                                                   fftTransformer, integrator,
                                                                   hpFilterCutoffPreIntToVel,
                                                                   hpFilterCutoffPostIntToVel, false, hpFilterOrder,
                                                                   analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc ).getDataLabels(),
                                ProcessedData.KEY_SPECTRUM_VEL_PEAK + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumVel( resampledData, highPassFilter, weightingAlg,
                                                                   fftTransformer, integrator,
                                                                   hpFilterCutoffPreIntToVel,
                                                                   hpFilterCutoffPostIntToVel, true, hpFilterOrder,
                                                                   analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc ).getData(),
                                ProcessedData.KEY_SPECTRUM_VEL_RMS );
        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumVel( resampledData, highPassFilter, weightingAlg,
                                                                   fftTransformer, integrator,
                                                                   hpFilterCutoffPreIntToVel,
                                                                   hpFilterCutoffPostIntToVel, true, hpFilterOrder,
                                                                   analysisBandwidth, dcFilter, hpFilterCutoffPreFFTAcc ).getData(),
                                ProcessedData.KEY_SPECTRUM_VEL_RMS + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateTimeWaveDispl( resampledData, highPassFilter, integrator,
                                                                     hpFilterCutoffPreIntToVel,
                                                                     hpFilterCutoffPostIntToVel,
                                                                     hpFilterCutoffPostIntToDspl, hpFilterOrder, dcFilter )
                                            .getData(), ProcessedData.KEY_TIMEWAVE_DISPL );
        dspCoreDump.addDataSet( DSPProcessor.calculateTimeWaveDispl( resampledData, highPassFilter, integrator,
                                                                     hpFilterCutoffPreIntToVel,
                                                                     hpFilterCutoffPostIntToVel,
                                                                     hpFilterCutoffPostIntToDspl, hpFilterOrder, dcFilter )
                                            .getDataLabels(), ProcessedData.KEY_TIMEWAVE_DISPL + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumDispl( resampledData, highPassFilter, weightingAlg,
                                                                     fftTransformer, integrator,
                                                                     hpFilterCutoffPreIntToVel,
                                                                     hpFilterCutoffPostIntToVel,
                                                                     hpFilterCutoffPostIntToDspl, false, hpFilterOrder,
                                                                     analysisBandwidth, dcFilter ).getData(),
                                ProcessedData.KEY_SPECTRUM_DISPL_PEAK );
        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumDispl( resampledData, highPassFilter, weightingAlg,
                                                                     fftTransformer, integrator,
                                                                     hpFilterCutoffPreIntToVel,
                                                                     hpFilterCutoffPostIntToVel,
                                                                     hpFilterCutoffPostIntToDspl, false, hpFilterOrder,
                                                                     analysisBandwidth, dcFilter ).getDataLabels(),
                                ProcessedData.KEY_SPECTRUM_DISPL_PEAK + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumDispl( resampledData, highPassFilter, weightingAlg,
                                                                     fftTransformer, integrator,
                                                                     hpFilterCutoffPreIntToVel,
                                                                     hpFilterCutoffPostIntToVel,
                                                                     hpFilterCutoffPostIntToDspl, true, hpFilterOrder,
                                                                     analysisBandwidth, dcFilter ).getData(),
                                ProcessedData.KEY_SPECTRUM_DISPL_RMS );
        dspCoreDump.addDataSet( DSPProcessor.calculateSpectrumDispl( resampledData, highPassFilter, weightingAlg,
                                                                     fftTransformer, integrator,
                                                                     hpFilterCutoffPreIntToVel,
                                                                     hpFilterCutoffPostIntToVel,
                                                                     hpFilterCutoffPostIntToDspl, true, hpFilterOrder,
                                                                     analysisBandwidth, dcFilter ).getDataLabels(),
                                ProcessedData.KEY_SPECTRUM_DISPL_RMS + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateBearingDemod( dataIn, highPassFilter, lowPassFilter,
                                                                    fftTransformer, bearingDemHighPassCuttof,
                                                                    bearingDemLowPassCuttof, false,
                                                                    hpFilterOrderBrnDem, lpFilterOrder,
                                                                    bearingDemHighPassCuttofPreFFT,
                                                                    hpFilterOrderBrnDemPreFFT, analysisBandwidth,
                                                                    resampler, newSamplingRate, dcFilter)
                                            .getData(), ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_PEAK );
        dspCoreDump.addDataSet( DSPProcessor.calculateBearingDemod( dataIn, highPassFilter, lowPassFilter,
                                                                    fftTransformer, bearingDemHighPassCuttof,
                                                                    bearingDemLowPassCuttof, false,
                                                                    hpFilterOrderBrnDem, lpFilterOrder,
                                                                    bearingDemHighPassCuttofPreFFT,
                                                                    hpFilterOrderBrnDemPreFFT, analysisBandwidth,
                                                                    resampler, newSamplingRate, dcFilter)
                                            .getDataLabels(), ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_PEAK + " LABELS" );

        dspCoreDump.addDataSet( DSPProcessor.calculateBearingDemod( dataIn, highPassFilter, lowPassFilter,
                                                                    fftTransformer, bearingDemHighPassCuttof,
                                                                    bearingDemLowPassCuttof, true, hpFilterOrderBrnDem,
                                                                    lpFilterOrder, bearingDemHighPassCuttofPreFFT,
                                                                    hpFilterOrderBrnDemPreFFT, analysisBandwidth,
                                                                    resampler, newSamplingRate, dcFilter)
                                            .getData(), ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_RMS );
        dspCoreDump.addDataSet( DSPProcessor.calculateBearingDemod( dataIn, highPassFilter, lowPassFilter,
                                                                    fftTransformer, bearingDemHighPassCuttof,
                                                                    bearingDemLowPassCuttof, true, hpFilterOrderBrnDem,
                                                                    lpFilterOrder, bearingDemHighPassCuttofPreFFT,
                                                                    hpFilterOrderBrnDemPreFFT, analysisBandwidth,
                                                                    resampler, newSamplingRate, dcFilter)
                                            .getDataLabels(), ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_RMS + " LABELS" );

        // Add overalls trend to the core dump
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_RMS ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_RMS ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_ACC_RMS );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_PEAK ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_PEAK ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_ACC_PEAK );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_DER_PEAK ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_DER_PEAK )
                                                .getData(), ProcessedData.KEY_OVRL_TREND_ACC_DER_PEAK );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_DER_P2P ) != null ) {
            dspCoreDump
                       .addDataSet(
                                    channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_DER_P2P ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_ACC_DER_P2P );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_P2P ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_ACC_P2P ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_ACC_P2P );
        }

        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_RMS ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_RMS ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_VEL_RMS );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_PEAK ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_PEAK ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_VEL_PEAK );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_DER_PEAK ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_DER_PEAK )
                                                .getData(), ProcessedData.KEY_OVRL_TREND_VEL_DER_PEAK );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P ) != null ) {
            dspCoreDump
                       .addDataSet(
                                    channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_VEL_DER_P2P );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_P2P ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_VEL_P2P ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_VEL_P2P );
        }

        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_RMS ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_RMS ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_DSPL_RMS );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_PEAK ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_PEAK ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_DSPL_PEAK );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_DER_PEAK ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_DER_PEAK )
                                                .getData(), ProcessedData.KEY_OVRL_TREND_DSPL_DER_PEAK );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_DER_P2P ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_DER_P2P )
                                                .getData(), ProcessedData.KEY_OVRL_TREND_DSPL_DER_P2P );
        }
        if( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_P2P ) != null ) {
            dspCoreDump.addDataSet( channelState.getProcessedData( ProcessedData.KEY_OVRL_TREND_DSPL_P2P ).getData(),
                                    ProcessedData.KEY_OVRL_TREND_DSPL_P2P );
        }

        /* THIS SECTION PERFORMS TESTS OF UNIT CONVERSION */
        if( debugEUnitConversion ) {

            ProcessedData pData01 = resampledData.deepCopy();
            pData01 = dspDynamicCaluclator.processData( pData01, ProcessedData.KEY_TIMEWAVE_ACC, EUnit.TimeMiliSec,
                                                        EUnit.AccMtrPerSec2, DPMFlexProxy.CENTRAL_FREQUENCY_DEFAULT, DPMFlexProxy.FREQUENCY_DEVIATION_DEFAULT );
            dspCoreDump.addDataSet( pData01.getData(), ProcessedData.KEY_TIMEWAVE_ACC + " in "
                                                       + EUnit.AccMtrPerSec2.symbol() );
            dspCoreDump.addDataSet( pData01.getDataLabels(), ProcessedData.KEY_TIMEWAVE_ACC + " Labels in "
                                                             + EUnit.TimeMiliSec.symbol() );

            ProcessedData pData02 = resampledData.deepCopy();
            pData02 = dspDynamicCaluclator.processData( pData02, ProcessedData.KEY_SPECTRUM_ACC_PEAK, EUnit.FreqCPM,
                                                        EUnit.AccMmSec2, DPMFlexProxy.CENTRAL_FREQUENCY_DEFAULT, DPMFlexProxy.FREQUENCY_DEVIATION_DEFAULT);
            dspCoreDump.addDataSet( pData02.getData(), ProcessedData.KEY_SPECTRUM_ACC_PEAK + " in "
                                                       + EUnit.AccMmSec2.symbol() );
            dspCoreDump.addDataSet( pData02.getDataLabels(), ProcessedData.KEY_SPECTRUM_ACC_PEAK + " Labels in "
                                                             + EUnit.FreqCPM.symbol() );
            
            ProcessedData pData05 = resampledData.deepCopy();
            pData05 = dspDynamicCaluclator.processData( pData05, ProcessedData.KEY_SPECTRUM_ACC_PEAK, EUnit.FreqCPM,
                                                        EUnit.AccInSec2, DPMFlexProxy.CENTRAL_FREQUENCY_DEFAULT, DPMFlexProxy.FREQUENCY_DEVIATION_DEFAULT );
            dspCoreDump.addDataSet( pData05.getData(), ProcessedData.KEY_SPECTRUM_ACC_PEAK + " in "
                                                       + EUnit.AccInSec2.symbol() );
            dspCoreDump.addDataSet( pData05.getDataLabels(), ProcessedData.KEY_SPECTRUM_ACC_PEAK + " Labels in "
                                                             + EUnit.FreqCPM.symbol() );

            ProcessedData pData03 = resampledData.deepCopy();
            pData03 = dspDynamicCaluclator.processData( pData03, ProcessedData.KEY_SPECTRUM_VEL_PEAK, EUnit.FreqHz,
                                                        EUnit.VelMmSec, DPMFlexProxy.CENTRAL_FREQUENCY_DEFAULT, DPMFlexProxy.FREQUENCY_DEVIATION_DEFAULT );
            dspCoreDump.addDataSet( pData03.getData(), ProcessedData.KEY_SPECTRUM_VEL_PEAK + " in "
                                                       + EUnit.VelMmSec.symbol() );
            dspCoreDump.addDataSet( pData03.getDataLabels(), ProcessedData.KEY_SPECTRUM_VEL_PEAK + " Labels in "
                                                             + EUnit.FreqHz.symbol() );

            ProcessedData pData04 = resampledData.deepCopy();
            pData04 = dspDynamicCaluclator.processData( pData04, ProcessedData.KEY_TIMEWAVE_DISPL, EUnit.TimeSec,
                                                        EUnit.DisplMm, DPMFlexProxy.CENTRAL_FREQUENCY_DEFAULT, DPMFlexProxy.FREQUENCY_DEVIATION_DEFAULT );
            dspCoreDump.addDataSet( pData04.getData(), ProcessedData.KEY_TIMEWAVE_DISPL + " in "
                                                       + EUnit.DisplMm.symbol() );
            dspCoreDump.addDataSet( pData04.getDataLabels(), ProcessedData.KEY_TIMEWAVE_DISPL + " Labels in "
                                                             + EUnit.TimeSec.symbol() );

        }

    }
}
