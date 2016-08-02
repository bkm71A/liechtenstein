/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.security.InvalidAlgorithmParameterException;
import java.util.List;
import java.util.Vector;

/**
 * Butterworth Digital Filter Implementation - Low Pass Filter. This is a Butterworth algorithm implementation that
 * allows to define filter order.
 * <p>
 * @author Taras Dobrovolsky
 * @author Yuri Khazanov
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>06/12/2008 Taras Dobrovolsky Initial release
 *         </ul>
 */
public class ButterLowPassFilterOrd implements Filter {

    private double     cutoffFreq           = -1;

    private static int DEFAULT_FILTER_ORDER = 6;

    /**
     * This method performs low-pass digital filtering.
     * @param x sampled converted values for filtering operation
     * @param samplingRate sampling rate used to collect sampled data
     * @return digitally filtered array
     */
    public List<Double> filter( List<Double> x, int samplingRate ) throws InvalidAlgorithmParameterException {
        return filter( x, samplingRate, this.cutoffFreq, DEFAULT_FILTER_ORDER );
    }

    /**
     * This method performs low-pass digital filtering.
     * @param x sampled converted values for filtering operation
     * @param samplingRate sampling rate used to collect sampled data
     * @param cutoffFreq Filter cutoff frequency
     * @return digitally filtered array
     */
    public List<Double> filter( List<Double> x, int samplingRate, double cutoffFreq )
                                                                                     throws InvalidAlgorithmParameterException {
        return filter( x, samplingRate, cutoffFreq, DEFAULT_FILTER_ORDER );
    }

    /**
     * This method performs low-pass (LP) digital filtering using Butterworth method with specified filter order.
     * @param y Input array (sampled data set)
     * @param s Sampling rate in Hz
     * @param f Filter cutoff frequency in Hz
     * @param st Filter order
     * @return Returns HP filtered array of the same size as input array y
     * @throws InvalidAlgorithmParameterException
     */
    public List<Double> filter( List<Double> y, int s, double f, int st ) throws InvalidAlgorithmParameterException {

        // validate input parameters just in case
        if( (y == null) || y.size() < 2 ) {
            throw new InvalidAlgorithmParameterException(
                                                          "com.incheck.dpm.dsp.ButterLowPassFilterOrd: Invalid input array of zero length or Null.\n\t " );
        }
        if( f <= 0 ) { // do not perform filtering if cutoff frequency < 0
            return y;
        }
        if( s <= 0 ) { // do not perform filtering if sampling rate < 0
            return y;
        }

        // validate filter order parameter
        if( (st % 2 != 0) || (st < 2) ) {
            throw new InvalidAlgorithmParameterException(
                                                          "com.incheck.dpm.dsp.ButterLowPassFilterOrd: Invalid filter order parameter.\n\t " );
        }

        // calculate cutoff frequency in rad/sec
        double Qc = Math.tan( Math.PI * ((double) f / (double) s) );

        // calculate number of stages from the filter order
        int j = st / 2;
        int i, k;

        // coefficients for multiple stages
        double coeff[] = new double[j];
        double alpha[] = new double[j];
        double b0[] = new double[j];
        double b1[] = new double[j];
        double b2[] = new double[j];
        double a1[] = new double[j];
        double a2[] = new double[j];

        // calculate filter coefficients for each stage
        for( i = 0; i < j; i++ ) {
            coeff[i] = ((double) (st + 1 + j * 2)) / ((double) (2 * st));
            alpha[i] = 2 * Math.cos( coeff[i] * Math.PI );
            b0[i] = (Qc * Qc) / (Qc * Qc - alpha[i] * Qc + 1);
            b1[i] = 2 * (Qc * Qc) / (Qc * Qc - alpha[i] * Qc + 1);
            b2[i] = b0[i];
            a1[i] = 2 * (Qc * Qc - 1) / (Qc * Qc - alpha[i] * Qc + 1);
            a2[i] = (Qc * Qc + alpha[i] * Qc + 1) / (Qc * Qc - alpha[i] * Qc + 1);
        }

        // create temporary arrays used in stages, initialize
        int h = y.size();
        double v[] = new double[h];
        double x[] = new double[h];

        for( i = 0; i < h; i++ ) {
            x[i] = y.get( i );
        }

        v[0] = y.get( 0 );
        v[1] = y.get( 1 );

        // Main recursive cycle - calculation stages
        for( i = 0; i < j; i++ ) {
            x[0] = x[h - 2]; // assign x[0], x[1] from the back of the array
            x[1] = x[h - 1];

            for( k = 2; k < x.length; k++ ) { // calculate the temporary array
                v[k] = (b0[i] * x[k] + b1[i] * x[k - 1] + b2[i] * x[k - 2]) - (a1[i] * v[k - 1] + a2[i] * v[k - 2]);
            }

            v[0] = v[h - 2]; // assign v[0], v[1] from the back of the array
            v[1] = v[h - 1];

            for( k = 2; k < x.length; k++ ) { // calculates a recursive pass
                v[k] = (b0[i] * x[k] + b1[i] * x[k - 1] + b2[i] * x[k - 2]) - (a1[i] * v[k - 1] + a2[i] * v[k - 2]);
            }

            for( k = 0; k < x.length; k++ ) { // results of the recursive pass becomes input for the next pass
                x[k] = v[k];
            }
        }

        Vector<Double> out = new Vector<Double>( h );
        for( i = 0; i < h; i++ ) {
            out.add( v[i] );
        }

        return out;
    }

    /**
     * @return the cutoffFreq Currently set cutoff frequency used by a filter in Hz.
     */
    public double getCutoffFreq( ) {
        return cutoffFreq;
    }

    /**
     * @param cutoffFreq the cutoffFreq in Hz to set. Set to -1 to disable a filter effect
     */
    public void setCutoffFreq( double cutoffFreq ) {
        this.cutoffFreq = cutoffFreq;

    }

}