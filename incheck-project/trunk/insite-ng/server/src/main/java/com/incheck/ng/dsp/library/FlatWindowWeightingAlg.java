package com.incheck.ng.dsp.library;

/**
 * This class implements Flat Window weighting or windowing methods.
 * 
 * @author Taras Dobrovolsky
 * 
 *         Change History: 09/25/2007 Natalia Logunova Initial algorithm
 *         implementation 10/14/2007 Taras Dobrovolsky Repackaged to use factory
 *         pattern
 */
public class FlatWindowWeightingAlg implements WeightingAlg {

    private final static int SCALING_COEFFICIENT = 4;

    /**
     * Flat Window weighting or windowing method. Weighting performed in place
     * without creating a new Vector object.
     */
    public void weight(double arrInOut[]) {
        int N = arrInOut.length;
        for (int n = 0; n < arrInOut.length; n++) {
            double multiplier = 0.2156 - 0.4160 * Math.cos(2 * Math.PI * n / N) + 0.2781 * Math.cos(4 * Math.PI * n / N) - 0.0836
                    * Math.cos(6 * Math.PI * n / N) + 0.0069 * Math.cos(8 * Math.PI * n / N);
            arrInOut[n] = arrInOut[n] * multiplier * SCALING_COEFFICIENT;
        }
    }
}
