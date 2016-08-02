/**
 * Copyright 2007, Incheck, Inc.
 * All Rights Reserved
 *
 * This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended
 * publication of such source code. 
 * 
 */
package com.inchecktech.dpm.dsp;

import java.util.Vector;

/**
 * This is the implementation of Slicer interface.  Implements methods of sampled array 
 * slicing method based on triggers and based on defined overlap percentage. 
 * 
 * @author Taras Dobrovolsky
 * 
 * Change History:
 * 09/25/2007	Natalia Logunova		Initial methods implementation
 * 10/14/2007	Taras Dobrovolsky		Repackaged to use inside factory pattern
 */
public class DefaultSlicer implements Slicer {

	private double 	overlapPercent;
	private int 	lengthForOverlap;
	private int 	numOfSlicesForOverlap;
	
	private int		lengthForTriggers;
	private int		numOfSlicesForTriggers;
	private int		delay;
	
	public void setDelayForTriggersAlg(int delay) {
		this.delay	= delay;
	}
	public void setNumOfSlicesForOverlapAlg(int numOfSlices) {
		this.numOfSlicesForOverlap = numOfSlices;

	}
	public void setNumOfSlicesForTriggerAlg(int numOfSlices) {
		this.numOfSlicesForTriggers = numOfSlices;

	}
	public void setOverlapPercentForOverlapAlg(double overlapPercent) {
		this.overlapPercent = overlapPercent;

	}
	public void setSliceLengthForOverlapAlg(int length) {
		this.lengthForOverlap = length;

	}
	public void setSliceLengthForTriggerAlg(int length) {
		this.lengthForTriggers = length;

	}

	
	/**
	 * This method slices an array of samples into multiple array for averaging.  It does not use
	 * triggers (i.e. tachometer ticks), but rather it uses user defined overlap percentage, and 
	 * user defined radix 2 (2^n) length to define the lengths of output arrays.  Radix 2
	 * is recommended to obtain results ready for FFT transformation.
	 * @param arrIn Array of converted samples  
	 * @return Matrix containing array slices
	 */
	public Vector<Vector<Double>> sliceWithOverlaps(Vector<Double> arrIn) {
		
		int startIndex = 0;
		int endIndex = this.lengthForOverlap - 1;
		int step = (int) Math.floor((1 - (overlapPercent / 100)) * this.lengthForOverlap);
		Vector<Vector<Double>> result = new Vector<Vector<Double>>();

		for (int i = 0; i < this.numOfSlicesForOverlap; i++) {
			Vector<Double> slice = new Vector<Double>();
			try {
				arrIn.get(endIndex);
			} catch (ArrayIndexOutOfBoundsException e) {
				break;
			}
			for (int j = startIndex ; j <= endIndex; j++) {
				slice.add((Double) arrIn.get(j));
			}
			result.add(slice);
			
			startIndex += step;
			endIndex += step;
		}
		return result;
		
	}

	public Vector<Vector<Double>> sliceWithTriggers(Vector<Double> arrIn,
			int[] triggers) {
		// TODO Implement slicing with triggers.  Include delay config parameter
		return null;
	}

}
