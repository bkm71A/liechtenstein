/**
 * Copyright 2007, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.util.List;
import com.inchecktech.dpm.beans.ProcessedData;

/**
 * This interface defines method signatures for implementing re-sampling algorithms.
 * @author Taras Dobrovolsky Change History: 09/27/2007 Taras Dobrovolsky Initial Release 10/20/2007 Taras Dobrovolsky
 *         Added a method to resample an array into a new desired size
 */
public interface Resampler {

    /**
     * Slice and re-sample an array of data points into a matrix. One array contains actual measurements, and the
     * trigger array contains tachometer ticks that are used for slicing.
     * @param arrIn array/vector of measurements
     * @param arrTrigger array/vector of tachometer ticks
     * @param newLength desired length of re-sampled slices
     * @return Matrix of re-sampled arrays of a size newLength each
     */
    public abstract List<List<Double>> resample( List<Double> arrIn, int[] arrTrigger, int newLength );

    /**
     * Re-sample an array of data points into a new array of either bigger or smaller size. resamplingFactor parameter
     * determines whether the input array will expand or contract.
     * @param arrIn array of measurements
     * @param resamplingFactor desired re-sampling factor. 2.7f will down-sample/contract, 0.7f will up-sample/expand
     * @return array of re-sampled measurements. New array size will be floor(array length/resamplingFactor)
     */
    public abstract List<Double> resample( List<Double> arrIn, float resamplingFactor );

    /**
     * Re-sample an array of data points into a new array of a desired size
     * @param arrayIn A single sample data set that needs to be re-sampled.
     * @param newLen The desired length of the re-sampled data set
     * @return Re-sampled data set containing newLength elements
     */
    public abstract List<Double> resample( List<Double> arrayIn, int newLen );

    /**
     * Re-sample an array of data points into a new array with the new sampling rate. Append 0's or remove data points
     * to obtain radix 2 array
     * @param arrayIn A single sample data set that needs to be re-sampled.
     * @param oldSamplingRate Original sampling rate of data set
     * @param newSamplingRate New desired sampling rate of output data set
     * @param targetProcessedData ProcessedData object that will store re-sampled data set.  This re-sampling method
     *         will set the number of appended zero's properly, so other calculation methods will know how to deal with it.
     * @return an array of the closest radix 2 size array for new desired sampling rate. If output data set contains
     *         less elements to be of the closest radix 2 data set, then the method will append 0's. If output data set
     *         contains more elements, the elements will be removed to make an output array of radix 2 size (i.e. power
     *         of 2)
     */
    public abstract List<Double> resampleRadix2( List<Double> arrayIn, int oldSamplingRate, int newSamplingRate,
                                                 ProcessedData targetProcessedData );

}
