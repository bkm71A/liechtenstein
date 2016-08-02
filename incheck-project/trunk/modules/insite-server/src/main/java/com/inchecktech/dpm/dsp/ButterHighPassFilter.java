/**
 * Copyright 2007, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.security.InvalidAlgorithmParameterException;
import java.util.List;
import java.util.Vector;

/**
 * Butterworth Digital Filter Implementation - High Pass Filter This is a 6-th order Butterworth algorithm
 * implementation using method documented in "Shock and Vibration Signal Analysis" by Tom Irvine. pp. 85-88
 * @author Taras Dobrovolsky Change History:n 12/17/2007 Taras Dobrovolsky Initial release
 */
public class ButterHighPassFilter implements Filter {

    private static final double alpha1     = 2 * Math.cos( 7 * Math.PI / 12 ); // used in the first stage
    private static final double alpha2     = 2 * Math.cos( 9 * Math.PI / 12 ); // used in the second stage
    private static final double alpha3     = 2 * Math.cos( 11 * Math.PI / 12 ); // used in the third stage

    private double              cutoffFreq = -1;

    /**
     * This method performs high-pass digital filtering.
     * @param x sampled converted values for filtering operation
     * @param samplingRate sampling rate used to collect sampled data
     * @return digitally filtered array
     */
    public List<Double> filter( List<Double> x, int samplingRate ) throws InvalidAlgorithmParameterException {

        return filter( x, samplingRate, this.cutoffFreq );

    }

    /**
     * This method performs high-pass digital filtering.
     * @param x sampled converted values for filtering operation
     * @param samplingRate sampling rate used to collect sampled data
     * @param cutoffFreq Filter cutoff frequency
     * @param optParam1 not used in this filter implementation
     * @return digitally filtered array
     */
    public List<Double> filter( List<Double> x, int samplingRate, double cutoffFreq, int optParam1 )
                                                                                                    throws InvalidAlgorithmParameterException {

        return filter( x, samplingRate, cutoffFreq );

    }

    /**
     * This method performs high=pass digital filtering.
     * @param x sampled converted values for filtering operation
     * @param samplingRate sampling rate used to collect sampled data
     * @param cutoffFreq Filter cutoff frequency
     * @return digitally filtered array
     */
    public List<Double> filter( List<Double> x, int samplingRate, double cutoffFreq )
                                                                                     throws InvalidAlgorithmParameterException {

        // validate input parameters just in case
        if( (x == null) || x.size() == 0 ) {
            throw new InvalidAlgorithmParameterException(
                                                          "com.incheck.dpm.dsp.ButterHighPassFilter: Invalid input array of zero length or Null.\n\t " );
        }
        if( cutoffFreq <= 0 ) {
            return x;
        }
        if( samplingRate <= 0 ) {
            return x;
        }

        // calculate Omega(c) pp. 82 formula 14-17
        double Qc = Math.tan( Math.PI * cutoffFreq / samplingRate );

        // calculate high-pass filter coefficients for three stages
        // STAGE 1 coefficients
        double a11 = 2 * (Qc * Qc - 1) / (1 - alpha1 * Qc + Qc * Qc);
        double a12 = (1 + alpha1 * Qc + Qc * Qc) / (1 - alpha1 * Qc + Qc * Qc);
        double b10 = 1 / (1 - alpha1 * Qc + Qc * Qc);
        double b11 = (-2) * b10;
        double b12 = b10;

        // STAGE 2 coefficients
        double a21 = 2 * (Qc * Qc - 1) / (1 - alpha2 * Qc + Qc * Qc);
        double a22 = (1 + alpha2 * Qc + Qc * Qc) / (1 - alpha2 * Qc + Qc * Qc);
        double b20 = 1 / (1 - alpha2 * Qc + Qc * Qc);
        double b21 = (-2) * b20;
        double b22 = b20;

        // STAGE 3 coefficients
        double a31 = 2 * (Qc * Qc - 1) / (1 - alpha3 * Qc + Qc * Qc);
        double a32 = (1 + alpha3 * Qc + Qc * Qc) / (1 - alpha3 * Qc + Qc * Qc);
        double b30 = 1 / (1 - alpha3 * Qc + Qc * Qc);
        double b31 = (-2) * b30;
        double b32 = b30;

        // initialize intermediate arrays, and set all elements to 0's
        int i = 0;
        int k = x.size();
        Vector<Double> y1 = new Vector<Double>( k );
        for( i = 0; i < k; i++ ) {
            y1.add( x.get( i ) );
        }
        Vector<Double> y2 = new Vector<Double>( k );
        for( i = 0; i < k; i++ ) {
            y2.add( x.get( i ) );
        }
        Vector<Double> y3 = new Vector<Double>( k );
        for( i = 0; i < k; i++ ) {
            y3.add( x.get( i ) );
        }

        // STAGE #1
        for( i = 2; i < k; i++ ) {
            y1.set( i, b10 * x.get( i ) + b11 * x.get( i - 1 ) + b12 * x.get( i - 2 )
                       - ((a11 * y1.get( i - 1 ) + a12 * y1.get( i - 2 ))) );
        }

        // STAGE #2
        for( i = 2; i < k; i++ ) {
            y2.set( i, b20 * y1.get( i ) + b21 * y1.get( i - 1 ) + b22 * y1.get( i - 2 )
                       - ((a21 * y2.get( i - 1 ) + a22 * y2.get( i - 2 ))) );
        }

        // STAGE #3
        for( i = 2; i < k; i++ ) {
            y3.set( i, b30 * y2.get( i ) + b31 * y2.get( i - 1 ) + b32 * y2.get( i - 2 )
                       - ((a31 * y3.get( i - 1 ) + a32 * y3.get( i - 2 ))) );
        }

        return y3;
    }

    /**
     * @return the cutoffFreq Currently set cutoff frequency used by a filter.
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
