/**
 * Copyright 2007, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.security.InvalidAlgorithmParameterException;
import java.util.List;

/**
 * This interface defines method signatures for implementing digital filter algorithms.
 * @author Taras Dobrovolsky Change History: 12/19/2007 Taras Dobrovolsky Initial release
 */
public interface Filter {

    /**
     * This method performs digital filtering, either high-pass or low-pass.
     * @param arrIn sampled converted values for filtering operation
     * @param samplingRate sampling rate used to collect sampled data
     * @return digitally filtered array
     */
    public abstract List<Double> filter( List<Double> arrIn, int samplingRate )
                                                                              throws InvalidAlgorithmParameterException;

    /**
     * This method performs digital filtering, either high-pass or low-pass.
     * @param arrIn sampled converted values for filtering operation
     * @param samplingRate sampling rate used to collect sampled data
     * @param cutoffFreq filter cutoff frequency
     * @return digitally filtered array
     */
    public abstract List<Double> filter( List<Double> arrIn, int samplingRate, double cutoffFreq )
                                                                                                throws InvalidAlgorithmParameterException;

    /**
     * This method performs digital filtering, either high-pass or low-pass.
     * @param arrIn sampled converted values for filtering operation
     * @param samplingRate sampling rate used to collect sampled data
     * @param cutoffFreq filter cutoff frequency
     * @param optParam1 optional filter parameter. For instance filter order.
     * @return digitally filtered array
     */
    public abstract List<Double> filter( List<Double> arrIn, int samplingRate, double cutoffFreq, int optParam1 )
                                                                                                                 throws InvalidAlgorithmParameterException;

    /**
     * @return the cutoffFreq Currently set cutoff frequency used by a filter.
     */
    public abstract double getCutoffFreq( );

    /**
     * @param cutoffFreq the cutoffFreq in Hz to set. Set to -1 to disable a filter effect
     */
    public abstract void setCutoffFreq( double cutoffFreq );

}
