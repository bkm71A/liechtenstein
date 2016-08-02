package com.incheck.ng.dsp.library;

import java.security.InvalidAlgorithmParameterException;
import java.util.Date;

import com.incheck.ng.dsp.Filter;
import com.incheck.ng.model.data.AccelerationByFrequencyData;
import com.incheck.ng.model.data.VelocityByFrequencyData;
import com.incheck.ng.model.data.VelocityByTimeData;

public class DSPProcessor {
    /**
     * @param dataIn
     * @param integrator
     * @return AccelerationByTimeData
     * @throws InvalidAlgorithmParameterException 
     */
    public static VelocityByTimeData calculateTimeWaveVel(long channelId,double[] dataIn, int samplingRate, Date dateTimeStamp,
            int noOfAppendedZeros, Filter dcFilter) throws InvalidAlgorithmParameterException {
        
        double integratedData[] = Integrator.integrateTDAccellerationToVelocity(dataIn, samplingRate, noOfAppendedZeros);
        return new VelocityByTimeData(channelId,dcFilter.filter(integratedData, samplingRate), dateTimeStamp, samplingRate);
    }
    
    public static AccelerationByFrequencyData calculateSpectrumAccel(long channelId,double[] dataIn, int samplingRate, WeightingAlg weightingAlg,
            Filter dcFilter, Date dateTimeStamp) throws InvalidAlgorithmParameterException {
       
        double[] filteredData = dcFilter.filter(dataIn, samplingRate);
        // ////////////////////////////////////////////////////////////////////////
        // 1.5 Apply Windowing Method; Default: Hanning Window
        weightingAlg.weight(filteredData); // weighting performed in place
        // ////////////////////////////////////////////////////////////////////////
        // 1.6 FFT for Acceleration Output Range: [0, result / 1.28]
        // EX: 512 a 400 lines (for block size = 1024)
        double[] spectrum = FFTTransformer.fftTransform(filteredData);
        AccelerationByFrequencyData processedData = new AccelerationByFrequencyData(channelId, spectrum, dateTimeStamp, samplingRate);
        double step = ((double) samplingRate / (double) dataIn.length);
        processedData.setLabels(0, step * (processedData.getData().length));
        return processedData;
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
    public static VelocityByFrequencyData calculateSpectrumVel(long channelId,double[] dataIn, int samplingRate, WeightingAlg weightingAlg,
            Filter dcFilter, Date dateTimeStamp) throws InvalidAlgorithmParameterException {

        double dynData[] = calculateSpectrumAccel2(dataIn, samplingRate, weightingAlg, dcFilter);
        dynData = Integrator.integrateFDAccellerationToVelocity(dynData, samplingRate, dynData);
        VelocityByFrequencyData processedData = new VelocityByFrequencyData(channelId, dynData, dateTimeStamp, samplingRate);
        // step = sampling_rate (before FFT) / block_size (before FFT)
        // last_point = step * (number of data points)
        double step = (double) ((double) samplingRate / (double) dataIn.length);
        processedData.setLabels(0, step * (dynData.length));
        // TODO quickfix restore labels
        double[] labels = processedData.getLabels();
        int arrayLengthDifference = dynData.length - labels.length;
        if (arrayLengthDifference > 0) {
            dynData = new double[labels.length];
            System.arraycopy(processedData.getData(), 0, dynData, 0, labels.length);
            processedData.setData(dynData);
        }
        // end TODO quickfix
        return processedData;
    }

    protected static double[] calculateSpectrumAccel2(double[] dataIn, int samplingRate, WeightingAlg weightingAlg,
           Filter dcFilter) throws InvalidAlgorithmParameterException {
        double[] filteredData = dcFilter.filter(dataIn, samplingRate);
        weightingAlg.weight(filteredData); // weighting performed in place
        return FFTTransformer.fftTransform(filteredData);
    }
}
