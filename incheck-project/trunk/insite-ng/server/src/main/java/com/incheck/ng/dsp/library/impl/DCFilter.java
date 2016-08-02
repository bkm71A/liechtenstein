package com.incheck.ng.dsp.library.impl;

import java.security.InvalidAlgorithmParameterException;

import com.incheck.ng.dsp.Filter;

/**
 * DC Filter Implementation. NOTE: To fit the DSP calculator architecture,
 * cutoffFreq is used to store / pass N - smoothing factor parameter,
 * configurable, default is 500
 * 
 * @author Taras Dobrovolsky Change History: 08/25/2009 Taras Dobrovolsky
 *         Initial release
 */
public class DCFilter implements Filter {

    // N - smoothing factor, configurable, default is 500
    private double cutoffFreq = 500.0;

    /**
     * @return Currently set smoothing factor used by a filter.
     */
    public double getCutoffFreq() {
        return cutoffFreq;
    }

    /**
     * @param Set
     *            smoothing factor to be used by DC filter algorithm.
     */
    public void setCutoffFreq(double cutoffFreq) {
        this.cutoffFreq = cutoffFreq;
    }

    /**
     * Exponential Moving Average.
     * 
     * @param data
     *            input array
     * @param n
     *            constant specified in the configuration (i.e. 120)
     * @param dataMean
     *            mean of the input array
     * @return exponential moving average array
     */
    private double[] ema(double data[], int n, double dataMean) {
        if ((data == null) || (data.length <= 1)) { // input data validation
            return data;
        }
        double[] out = new double[data.length];
        out[0] = dataMean;
        double alpha = (double) 2.0 / ((double) (n + 1));
        for (int i = 1; i < data.length; i++) {
            out[i] = alpha * data[i - 1] + (1.0 - alpha) * out[i - 1];
        }
        return out;
    }

    /**
     * Reversed Exponential Moving Average.
     * 
     * @param data
     *            input array
     * @param n
     *            constant specified in the configuration (i.e. 120)
     * @param dataMean
     *            mean of the input array
     * @return reversed exponential moving average array
     */
    private double[] revEma(double data[], int n, double dataMean) {
        if ((data == null) || (data.length <= 1)) { // input data validation
            return data;
        }
        double[] out = new double[data.length];
        out[data.length - 1] = dataMean;
        double alpha = (double) 2.0 / ((double) (n + 1));
        for (int i = data.length - 1; i > 0; i--) {
            out[i - 1] = alpha * data[i] + (1.0 - alpha) * out[i];
        }
        return out;
    }

    /**
     * Cent Exponential Moving Average.
     * 
     * @param data
     *            input array
     * @param n
     *            constant specified in the configuration (i.e. 120)
     * @return reversed exponential moving average array
     */
    private double[] centEma(double data[], int n) {
        if ((data == null) || (data.length <= 1)) { // input data validation
            return data;
        }
        double[] out = new double[data.length];
        double mean = mean(data);
        double[] ema = ema(data, n, mean);
        double[] revEma = revEma(data, n, mean);
        for (int i = 0; i < data.length; i++) {
            out[i] = (ema[i] + revEma[i]) / 2.0D;
        }
        return out;
    }

    /**
     * Calculate the mean of the list
     * 
     * @param x
     * @return mean
     */
    private double mean(double x[]) {
        if ((x == null) || (x.length < 1)) { // input data validation
            return 0.0;
        }
        double sum = 0.0;
        int size = x.length;
        for (int i = 0; i < size; i++) {
            sum = sum + x[i];
        }
        return sum / (double) (size);
    }

    /**
     * This method performs DC filtering.
     * 
     * @param x
     *            sampled converted values for filtering operation
     * @param samplingRate
     *            not used - ignore
     * @param cutoffFreq
     *            This parameter is a smoothing factor parameter
     * @return digitally filtered array
     */
    public double[] filter(double x[], int samplingRate, double cutoffFreq) throws InvalidAlgorithmParameterException {
        int n = (int) this.cutoffFreq; // use default / currently set smoothing
        // parameter
        if (cutoffFreq >= 2) {
            n = (int) cutoffFreq; // overwrite default if user provides
            // smoothing factor as a valid parameter
        }
        double out[] = new double[x.length];
        double cema[] = centEma(x, n);
        for (int i = 0; i < x.length; i++) {
            out[i] = x[i] - cema[i];
        }
        return out;
    }

    /**
     * This method performs DC filtering.
     * 
     * @param x
     *            sampled converted values for filtering operation
     * @param samplingRate
     *            not used - ignore
     * @return digitally filtered array
     */
    public double[] filter(double x[], int samplingRate) throws InvalidAlgorithmParameterException {
        return filter(x, samplingRate, this.cutoffFreq);
    }

    /**
     * This method performs DC filtering.
     * 
     * @param x
     *            sampled converted values for filtering operation
     * @param samplingRate
     *            not used - ignore
     * @param cutoffFreq
     *            This parameter is a smoothing factor parameter
     * @param optParam1
     *            Optional parameter not used in this implementation of the
     *            filter
     * @return digitally filtered array
     */
    public double[] filter(double x[], int samplingRate, double cutoffFreq, int optParam1) throws InvalidAlgorithmParameterException {
        return filter(x, samplingRate, cutoffFreq);
    }
}
