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

/**
 * This interface defines method signatures for implementing FFT transformation algorithms.
 * 
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 10/14/2007 	Taras Dobrovolsky		Initial release
 */
public interface FFTTransformer {

	/**
	 * This method performs FFT transformation. 
	 * Most of the implementation algorithms expect Radix 2 (2^n) length of the input array
	 * @param arrIn sampled converted values for FFT transformation 
	 * @return FFT transformed array
	 */
	public abstract List<Double> FFTTransform(List<Double> arrIn) throws InvalidAlgorithmParameterException ;
	
}
