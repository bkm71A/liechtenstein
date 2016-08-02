package com.incheck.ng.dsp.library;

/**
 * This interface defines method signatures for implementing weighting or
 * windowing methods.
 * 
 * @author Taras Dobrovolsky
 * 
 *         Change History: 10/14/2007 Taras Dobrovolsky Initial Release
 */
public interface WeightingAlg {

    /**
     * Apply weighting (or windowing) to the passed in array. Weighting methods
     * include: Hanning window function, Hamming window function, Blackman
     * window funtion, Flat window function. Specific method that is being used
     * should be configurable per channel.
     * @param arrIn
     *            sampled converted array of volts or G's
     */
    public abstract void weight(double arrInOut[]);
}
