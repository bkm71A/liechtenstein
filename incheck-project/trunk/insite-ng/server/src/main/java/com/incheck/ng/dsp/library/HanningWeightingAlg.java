package com.incheck.ng.dsp.library;

/**
 * This class implements Hanning weighting or windowing methods.
 * 
 * @author Taras Dobrovolsky
 * 
 *         Change History: 09/25/2007 Natalia Logunova Initial algorithm
 *         implementation 10/14/2007 Taras Dobrovolsky Repackaged to use factory
 *         pattern
 */
public class HanningWeightingAlg implements WeightingAlg {

    private final static int SCALING_COEFFICIENT = 2;

    /**
     * Hanning weighting or windowing method. Weighting performed in place
     * without creating a new Vector object.
     */
    public void weight(double arrInOut[]) {
        int N = arrInOut.length;
        for (int n = 0; n < arrInOut.length; n++) {
            double multiplier = 0.5 - 0.5 * Math.cos(2 * Math.PI * n / N);
            arrInOut[n] = arrInOut[n] * multiplier * SCALING_COEFFICIENT;
        }
    }
}