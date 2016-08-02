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

import com.inchecktech.dpm.beans.ProcessedData;

/**
 * This interface defines method signatures for implementing integration algorithms:
 * 	Acceleration into Velocity in Time Domain
 *  Acceleration into Velocity in Frequency Domain
 *  Velocity into Displacement in Time Domain
 *  Velocity into Displacement in Frequency Domain
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 10/10/2007	Taras Dobrovolsky		Initial Release
 */
public interface Integrator {

	/**
	 * This method integrates sampled data in Time Domain to obtain velocity values from acceleration values.
	 * @param arrIn input array 
	 * @param sampleRate Channel sampling rate
	 * @param noOfAppendedZeros Number of zeros's that were appended to the data set during re-sampling to radix 2.
	 *     It is used to adjust the range of values that need to be integrated.
	 * @return array of integrated values
	 */
	List<Double> integrateTDAccellerationToVelocity(List<Double> arrIn, int sampleRate, int noOfAppendedZeros);
	
	/**
	 * This method integrates sampled data in Frequency Domain to obtain displacement values from velocity values.
	 * @param arrIn input array 
	 * @param sampleRate Channel sampling rate
	 * @param noOfAppendedZeros Number of zeros's that were appended to the data set during re-sampling to radix 2.
     *     It is used to adjust the range of values that need to be integrated.
	 * @return array of integrated values
	 */
	List<Double> integrateTDVelocityToDisplacement(List<Double> arrIn, int sampleRate, int noOfAppendedZeros);
	
	/**
	 * This method integrates sampled data in Frequency Domain to obtain velocity values from acceleration values.
	 * @param arrIn input array
	 * @param origSampleRate original sampling rate 
	 * @param accelerationSpectrum Acceleration spectrum to process
	 * @return array of integrated values
	 */
	List<Double> integrateFDAccellerationToVelocity(List<Double> arrIn, int origSamplingRate, ProcessedData accelerationSpectrum);
	
	/**
	 * This method integrates sampled data in Frequency Domain to obtain displacement values from velocity values.
	 * @param arrIn input array 
	 * @param noOfAppendedZeros Number of zeros's that were appended to the data set during re-sampling to radix 2.
     *     It is used to adjust the range of values that need to be integrated.
	 * @return array of integrated values
	 */
	List<Double> integrateFDVelocityToDisplacement(List<Double> arrIn, int noOfAppendedZeros);
}
