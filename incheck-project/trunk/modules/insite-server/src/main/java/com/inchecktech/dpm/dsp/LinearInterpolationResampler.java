/**
 * Copyright 2007, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.util.List;
import java.util.Vector;
import com.inchecktech.dpm.beans.ProcessedData;

/**
 * This is the implementation of Resampler using linear interpolation method, which is probably the simplest re-sampling
 * method, but may be sufficient for intended use within DMP module of the system.
 * @author Taras Dobrovolsky Change History: 09/27/2007 Taras Dobrovolsky Initial Release
 */
public class LinearInterpolationResampler implements Resampler {

    /**
     * Implementation of re-sampling method using linear interpolation method. resample(...) methods have different
     * signatures for different applications. See Resampler interface for additional description.
     */
    public List<List<Double>> resample( List<Double> arrIn, int[] arrTrigger, int newLength ) {

        // validate input parameters - just in case
        if( (arrIn.size() != arrTrigger.length) || (arrIn.size() < 2) || (newLength < 2) ) {
            return new Vector<List<Double>>( 0 );
        }

        List<List<Double>> result = new Vector<List<Double>>();
        List<Double> slice = new Vector<Double>();
        for( int i = 0; i < arrTrigger.length; i++ ) { // go through trigger array looking for 1's
            if( arrTrigger[i] == 1 ) { // if 1 found
                if( slice.size() != 0 ) { // we have pre-populated existing slice
                    slice.add( arrIn.get( i ) ); // add last data point to the slice
                    result.add( resample( slice, newLength ) ); // re-sample the slice and add to the results
                    slice.clear(); // clear temp slice vector
                }
                slice.add( arrIn.get( i ) ); // add first data point to the new slice
            }
            else {
                if( slice.size() != 0 ) {
                    slice.add( arrIn.get( i ) ); // add a data point to the non-empty slice
                }
            }
        }
        return result;
    }

    /**
     * Implementation of re-sampling method using linear interpolation method. resample(...) methods have different
     * signatures for different applications. See Resampler interface for additional description.
     */
    public List<Double> resample( List<Double> arrayIn, float resamplingFactor ) {

        // validate input parameters - just in case
        if( (resamplingFactor == 0) || (arrayIn == null) || (arrayIn.size() < 2) ) {
            return new Vector<Double>( 0 );
        }

        // calculate the new length/size for re-sampled output
        int len = (int) (arrayIn.size() / resamplingFactor);

        return resample( arrayIn, len );

    }

    /**
     * The core logic of linear interpolation method. A helper method used by other methods in this re-sampling
     * algorithm implementation.
     * @param arrayIn A single sample data set that needs to be re-sampled.
     * @param newLen The desired length of the re-sampled data set
     * @return Re-sampled data set containing newLength elements
     */
    public List<Double> resample( List<Double> arrayIn, int newLen ) {

        // validate input parameters - just in case
        if( (newLen < 2) || (arrayIn == null) || (arrayIn.size() < 2) ) {
            return new Vector<Double>( 0 );
        }

        // create a new data set of a desired length
        int oldLen = arrayIn.size();
        Vector<Double> resampledArray = new Vector<Double>( newLen );

        // keep the first data point
        resampledArray.add( arrayIn.get( 0 ) );

        int leftIndex;
        double x;
        for( int i = 1; i < (newLen - 1); i++ ) {
            // for each element in the new data set find the closest embracing points
            // from the old data set (closest on the left, closest on the right)
            leftIndex = (i * oldLen) / newLen;

            if( (i * oldLen) % newLen == 0 ) { // special case - exact point match
                resampledArray.add( arrayIn.get( leftIndex ) );
            }
            else { // interpolate - calculate new value for the new data point
                x = ((double) i) * ((double) oldLen) / ((double) newLen);

                try {
                    resampledArray.add( new Double( interpolate( x, (double) leftIndex, // xa
                                                                 arrayIn.get( leftIndex ).doubleValue(), // ya
                                                                 (double) (leftIndex + 1), // xb
                                                                 arrayIn.get( leftIndex + 1 ).doubleValue() ) ) ); // yb
                }
                catch( ArrayIndexOutOfBoundsException e ) {
                }
            }

        }

        // keep the last data point
        resampledArray.add( arrayIn.get( oldLen - 1 ) );

        return resampledArray;
    }

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
    public List<Double> resampleRadix2( List<Double> arrayIn, int oldSamplingRate, int newSamplingRate,
                                        ProcessedData targetProcessedData ) {

        int zeroCnt = 0;
        
        if( newSamplingRate == 0 ) {
            return arrayIn;
        }
        
        float resampleFactor = ((float) oldSamplingRate) / ((float) newSamplingRate);
        List<Double> resampled = resample( arrayIn, resampleFactor );

        int closestRadix2 = DSPUtils.closestRadix2( resampled.size() );

        if( closestRadix2 == resampled.size() ) {
            return resampled;
        }
        else if( closestRadix2 < resampled.size() ) { // remove 'extra' elements from data set
            for( int i = resampled.size(); i > closestRadix2; i-- ) {
                resampled.remove( i - 1 );
            }
        }
        else { // append 0's
            for( int i = resampled.size(); i < closestRadix2; i++ ) {
                resampled.add( new Double( 0 ) );
                zeroCnt++;
            }
        }

        if (targetProcessedData != null) {
            targetProcessedData.setNoOfAppendedZeros( zeroCnt );
        }
        
        return resampled;
    }

    /**
     * Helper method of interpolating a third point from two points. MATH: linear interpolation takes two data points,
     * say (xa,ya) and (xb,yb), and the interpolant is given by: y = ya + (x-xa)(yb-ya)/(xb-xa) at the point (x,y).
     * @return interpolated point: value y for given x
     */
    private double interpolate( double x, double xa, double ya, double xb, double yb ) {
        return ya + ((x - xa) * (yb - ya)) / (xb - xa);
    }

}
