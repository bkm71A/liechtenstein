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
import java.util.Vector;

import com.inchecktech.dpm.beans.ProcessedData;

/**
 * Various utility methods used by DSP engine
 * @author Taras Dobrovolsky
 *
 */
public class DSPUtils {

	public static List<Double> scaleToRMS(List<Double> arrIn) {
		
		if (arrIn == null) {
			return null;
		}
		
		List<Double> arrOut = new Vector<Double>(arrIn.size());
		
		for (int i=0; i < arrIn.size(); i++) {
			arrOut.add(arrIn.get(i)* Math.sqrt(2) / 2);
		}
		
		return arrOut;
	}
	
	public static void setLabels(ProcessedData data, double min, double max) {
		if (data == null || data.getData() == null || data.getData().size() == 0) {
			return;
		}
		
		// calculate step
		double step = (max - min) / data.getData().size();
		double curr = min;
		Vector<Double> labels = new Vector<Double>();
		
		for (int i=0; i < data.getData().size(); i++) {
			labels.add(new Double(curr));
			curr = curr + step;
		}
		
		data.setDataLabels(labels);
		
	}
	
	/**
	 * Finds the closest Radix 2 (i.e. power of 2) number
	 * @param num the number for which the closest power of 2 needs to be found
	 */
	public static int closestRadix2(int num) {
		if (num <= 3) {
			return 2;
		}
		
		int prev = 2;
		int next = 4;
		
		while (next <= num) {
			prev = next;
			next = next * 2;
		}
		
		if (next == num) {
			return num;
		} 
		else if (prev == num) {
			return prev; 
		}
		else if ((next - num) < (num - prev)) {
			return next;
		}
		else {
			return prev;
		}
		
	}
	
	/**
	 * Apply ABS() absolute value function to all elements in a data set
	 * @param data
	 * @return The same vector with all positive elements 
	 */
	public static List<Double> abs(List<Double> data) {
		if (data == null) {
			return null;
		}
		
		for (int i=0; i < data.size(); i++) {
			if (data.get(i) != null) {
				data.set(i, Math.abs(data.get(i)));
			} else {
				data.set(i, 0D);
			}
		}
		
		return data;
	}
	
	/**
	 * In place multiplication of all list elements by a factor.
	 * @param data list of double values
	 * @param factor multiplication factor
	 * @return data list with all elements multiplied by a factor
	 */
	public static List<Double> multiplyByFactor(List<Double> data, double factor) {
	    if (data == null) {
            return null;
        }
	    
	    if (factor == 1.0) { // no need to multiply by 1.0
	        return data;
	    }
        
        for (int i=0; i < data.size(); i++) {
            if (data.get(i) != null) {
                data.set(i, data.get(i) * factor);
            }
        }
        
        return data;
	}
}
