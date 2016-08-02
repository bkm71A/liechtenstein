/**
 * Copyright 2007, Incheck, Inc.
 * All Rights Reserved
 *
 * This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended
 * publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.security.InvalidAlgorithmParameterException;
import java.util.List;
import java.util.Vector;

/**
 * Default implementation of FFT transformation algorithm.
 * Reference: http://www.dsptutor.freeuk.com/analyser/SpectrumAnalyser.html
 * 
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 10/14/2007	Taras Dobrovolsky		Initial release
 */
public class DefaultFFTTransformer implements FFTTransformer {

	private int n, nu;
	
	/**
	 * FFT Implementation: http://www.dsptutor.freeuk.com/analyser/SpectrumAnalyser.html
	 */
	public List<Double> FFTTransform(List<Double> arrIn)
			throws InvalidAlgorithmParameterException {

		if ((arrIn == null) || arrIn.size() == 0) {
			throw new InvalidAlgorithmParameterException("com.incheck.dpm.dsp.DefaultFFTTrenaformer: Invalid input array of zero length or Null.\n\t ");
		}
		
		int size = arrIn.size();
		if ((size & (size - 1)) != 0) {
			throw new InvalidAlgorithmParameterException("com.incheck.dpm.dsp.DefaultFFTTrenaformer: Input array must be of size 2^n, i.e. Radix 2.\n\t ");
		}

		// convert Vector to array
		double[] arr = new double[size];
		for (int i=0; i<size; i++) {
			arr[i] = arrIn.get(i);
		}
		
		double[] outArr = fft(arr);
		
		Vector<Double> results = new Vector<Double>(outArr.length);
		
		for (int i=0; i < (outArr.length/*/1.28 + 1*/); i++) {
			results.add(outArr[i]);
		}
		
		return results;
		
	}
	
	// Helper method
	private int bitrev(int j) {

	    int j2;
	    int j1 = j;
	    int k = 0;
	    for (int i = 1; i <= nu; i++) {
	      j2 = (int)Math.floor(j1/2);
	      k  = 2*k + j1 - 2*j2;
	      j1 = j2;
	    }
	    return k;
	  }

	// Helper method
	 private final double[] fft(double[] x) {
	    // assume n is a power of 2
	    n = x.length;
	    nu = (int)(Math.log(n)/Math.log(2));
	    int n2 = n/2;
	    int nu1 = nu - 1;
	    double[] xre = new double[n];
	    double[] xim = new double[n];
	    double[] mag = new double[n2];
	    double tr, ti, p, arg, c, s;
	    for (int i = 0; i < n; i++) {
	      xre[i] = x[i];
	      xim[i] = 0.0f;
	    }
	    int k = 0;

	    for (int l = 1; l <= nu; l++) {
	      while (k < n) {
	        for (int i = 1; i <= n2; i++) {
	          p = bitrev (k >> nu1);
	          arg = 2 * (double) Math.PI * p / n;
	          c = (double) Math.cos (arg);
	          s = (double) Math.sin (arg);
	          tr = xre[k+n2]*c + xim[k+n2]*s;
	          ti = xim[k+n2]*c - xre[k+n2]*s;
	          xre[k+n2] = xre[k] - tr;
	          xim[k+n2] = xim[k] - ti;
	          xre[k] += tr;
	          xim[k] += ti;
	          k++;
	        }
	        k += n2;
	      }
	      k = 0;
	      nu1--;
	      n2 = n2/2;
	    }
	    k = 0;
	    int r;
	    while (k < n) {
	      r = bitrev (k);
	      if (r > k) {
	        tr = xre[k];
	        ti = xim[k];
	        xre[k] = xre[r];
	        xim[k] = xim[r];
	        xre[r] = tr;
	        xim[r] = ti;
	      }
	      k++;
	    }

	    mag[0] = (double) (Math.sqrt(xre[0]*xre[0] + xim[0]*xim[0]))/n;
	    for (int i = 1; i < n/2; i++) {
	      mag[i]= 2 * (double) (Math.sqrt(xre[i]*xre[i] + xim[i]*xim[i]))/n;
	    }
	    return mag;
	  }

}
