/**
 * Copyright 2007, Incheck, Inc.
 * All Rights Reserved
 *
 * This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended
 * publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.util.Vector;

/**
 * This interface defines method signatures for implementing slicing algorithms.
 * 
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 10/14/2007 	Taras Dobrovolsky		Initial release
 */
public interface Slicer {
	
	/**
	 * This method slices an array of samples into multiple array for averaging.  It uses
	 * triggers (i.e. tachometer ticks), user defined trigger delays (positive or negative), and 
	 * user defined radix 2 (2^n) length to define the lengths of output arrays.  Radix 2
	 * is recommended to obtain results ready for FFT transformation.
	 * @param arrIn Array of converted samples  
	 * @param triggers Array of triggers (tochometer ticks), 0's or 1's
	 * @return Matrix containing array slices
	 */
	public abstract Vector<Vector<Double>> sliceWithTriggers(Vector<Double> arrIn, int[] triggers);
	
	/**
	 * This method slices an array of samples into multiple array for averaging.  It does not use
	 * triggers (i.e. tachometer ticks), but rather it uses user defined overlap percentage, and 
	 * user defined radix 2 (2^n) length to define the lengths of output arrays.  Radix 2
	 * is recommended to obtain results ready for FFT transformation.
	 * @param arrIn Array of converted samples  
	 * @return Matrix containing array slices
	 */
	public abstract Vector<Vector<Double>> sliceWithOverlaps(Vector<Double> arrIn);
	
	/**
	 * Set overlap percentage for slicing algorithm that uses overlapping.
	 * Used in method sliceWithOverlaps() 
	 * @param overlapPercent slices overlap percentage
	 */
	public abstract void setOverlapPercentForOverlapAlg(double overlapPercent);
	/**
	 * Set the length of output slices for slicing algorithm that uses overlapping.
	 * Used in method sliceWithOverlaps()
	 * @param length slices length (radix 2 [i.e. 2^n])
	 */
	public abstract void setSliceLengthForOverlapAlg(int length);
	/**
	 * Set desired number of slices for overlapping algorithm.
	 * Used in method sliceWithOverlaps()
	 * @param numOfSlices desired number of slices
	 */
	public abstract void setNumOfSlicesForOverlapAlg(int numOfSlices);
	
	/**
	 * Set slices length for slicing algorithm that uses triggers.
	 * Used in method sliceWithTriggers() 
	 * @param length slices length (radix 2 [i.e. 2^n])
	 */
	public abstract void setSliceLengthForTriggerAlg(int length);
	/**
	 * Set desired number of slices for slicing algorithm that uses triggers.
	 * Used in method sliceWithTriggers() 
	 * @param numOfSlices desired number of slices
	 */
	public abstract void setNumOfSlicesForTriggerAlg(int numOfSlices);
	/**
	 * Set trigger delay (negative or positive) for slicing algorithm that uses triggers.
	 * Used in method sliceWithTriggers() 
	 * @param delay
	 */
	public abstract void setDelayForTriggersAlg(int delay);

}
