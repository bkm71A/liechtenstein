/**
 * Copyright 2007, Incheck, Inc.
 * All Rights Reserved
 *
 * This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended
 * publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.util.List;

/**
 * This class implements Hamming weighting or windowing methods.
 * 
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 09/25/2007	Natalia Logunova		Initial algorithm implementation
 * 10/14/2007	Taras Dobrovolsky		Repackaged to use factory pattern
 */
public class HammingWeightingAlg implements WeightingAlg {
	
	private final static int SCALING_COEFFICIENT = 2;

	/**
	 * Hamming weighting or windowing method.  Weighting performed in place without
	 * creating a new Vector object.
	 */
	public void weight(List<Double> arrInOut) {
		int n = 0;
		int N = arrInOut.size();
		for (Double number : arrInOut) {
			double multiplier = 0.54 - 0.46 * Math.cos(2 * Math.PI * n / N);
			arrInOut.set(n, number * multiplier * SCALING_COEFFICIENT);
			n++;
		}

	}

}
