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
 * This interface defines method signatures for implementing weighting or windowing methods.
 * 
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 10/14/2007	Taras Dobrovolsky		Initial Release
 */
public interface WeightingAlg {
	
	/**
	 * Apply weighting (or windowing) to the passed in array.  Weighting methods
	 * include: Hanning window function, Hamming window function, Blackman window funtion,
	 * Flat window function.  Specific method that is being used should be configurable per
	 * channel.   
	 * @param arrIn sampled converted Vector array of volts or G's
	 */
	public abstract void weight(List<Double> arrInOut);

}
