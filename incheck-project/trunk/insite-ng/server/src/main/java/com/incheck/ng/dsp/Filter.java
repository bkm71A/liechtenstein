package com.incheck.ng.dsp;

import java.security.InvalidAlgorithmParameterException;

/**
 * This interface defines method signatures for implementing digital filter
 * algorithms.
 * 
 * @author Taras Dobrovolsky Change History: 12/19/2007 Taras Dobrovolsky
 *         Initial release
 */
public interface Filter {

    /**
     * This method performs digital filtering, either high-pass or low-pass.
     * 
     * @param arrIn
     *            sampled converted values for filtering operation
     * @param samplingRate
     *            sampling rate used to collect sampled data
     * @return digitally filtered array
     */
    double[] filter(double arrIn[], int samplingRate) throws InvalidAlgorithmParameterException;

    /**
     * This method performs digital filtering, either high-pass or low-pass.
     * 
     * @param arrIn
     *            sampled converted values for filtering operation
     * @param samplingRate
     *            sampling rate used to collect sampled data
     * @param cutoffFreq
     *            filter cutoff frequency
     * @return digitally filtered array
     */
    double[] filter(double arrIn[], int samplingRate, double cutoffFreq) throws InvalidAlgorithmParameterException;

    /**
     * This method performs digital filtering, either high-pass or low-pass.
     * 
     * @param arrIn
     *            sampled converted values for filtering operation
     * @param samplingRate
     *            sampling rate used to collect sampled data
     * @param cutoffFreq
     *            filter cutoff frequency
     * @param optParam1
     *            optional filter parameter. For instance filter order.
     * @return digitally filtered array
     */
    double[] filter(double arrIn[], int samplingRate, double cutoffFreq, int optParam1) throws InvalidAlgorithmParameterException;

    /**
     * @return the cutoffFreq Currently set cutoff frequency used by a filter.
     */
    double getCutoffFreq();

    /**
     * @param cutoffFreq
     *            the cutoffFreq in Hz to set. Set to -1 to disable a filter
     *            effect
     */
    void setCutoffFreq(double cutoffFreq);
}
