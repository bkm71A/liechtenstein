/**
 * Copyright 2009, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.security.InvalidAlgorithmParameterException;
import java.util.List;
import java.util.Vector;

/**
 * DC Filter Implementation. NOTE: To fit the DSP calculator architecture,
 * cutoffFreq is used to store / pass N - smoothing factor parameter,
 * configurable, default is 500
 * 
 * @author Taras Dobrovolsky Change History: 08/25/2009 Taras Dobrovolsky
 *         Initial release
 */
public class DCFilter implements Filter {

	// N - smoothing factor, configurable, default is 500
	private double cutoffFreq = 500.0;

	/**
	 * @return Currently set smoothing factor used by a filter.
	 */
	public double getCutoffFreq() {
		return cutoffFreq;
	}

	/**
	 * @param Set
	 *            smoothing factor to be used by DC filter algorithm.
	 */
	public void setCutoffFreq(double cutoffFreq) {
		this.cutoffFreq = cutoffFreq;
	}

	/**
	 * Exponential Moving Average.
	 * 
	 * @param data
	 *            input array
	 * @param n
	 *            constant specified in the configuration (i.e. 120)
	 * @param dataMean
	 * 			  mean of the input array
	 * @return exponential moving average array
	 */
	private List<Double> ema(List<Double> data, int n, double dataMean) {

		if ((data == null) || (data.size() <= 1)) { // input data validation
			return data;
		}

		List<Double> out = createList(data.size());
		out.set(0, dataMean);

		double alpha = (double) 2.0 / ((double) (n + 1));

		for (int i = 1; i < data.size(); i++) {
			out.set(i, alpha * data.get(i - 1).doubleValue() + (1.0 - alpha)
					* out.get(i - 1));
		}

		return out;

	}

	/**
	 * Reversed Exponential Moving Average.
	 * 
	 * @param data
	 *            input array
	 * @param n
	 *            constant specified in the configuration (i.e. 120)
	 * @param dataMean
	 * 			  mean of the input array
	 * @return reversed exponential moving average array
	 */
	private List<Double> revEma(List<Double> data, int n, double dataMean) {

		if ((data == null) || (data.size() <= 1)) { // input data validation
			return data;
		}

		List<Double> out = createList(data.size());
		out.set(data.size() - 1, dataMean);

		double alpha = (double) 2.0 / ((double) (n + 1));

		for (int i = data.size() - 1; i > 0; i--) {
			out.set(i - 1, alpha * data.get(i).doubleValue() + (1.0 - alpha)
					* out.get(i));
		}

		return out;

	}

	/**
	 * Cent Exponential Moving Average.
	 * 
	 * @param data
	 *            input array
	 * @param n
	 *            constant specified in the configuration (i.e. 120)
	 * @return reversed exponential moving average array
	 */
	private List<Double> centEma(List<Double> data, int n) {

		if ((data == null) || (data.size() <= 1)) { // input data validation
			return data;
		}

		List<Double> out = createList(data.size());
		
		double mean = mean(data);

		List<Double> ema = ema(data, n, mean);
		List<Double> revEma = revEma(data, n, mean);

		for (int i = 0; i < data.size(); i++) {
			out.set(i, (ema.get(i).doubleValue() + revEma.get(i).doubleValue())
					/ ((double) 2.0));
		}

		return out;
	}

	/**
	 * Create and initialize list of a given size with all elements set to 0's
	 * 
	 * @param size
	 *            The size of the new list
	 * @return The list containing requested number of elements all set to 0's
	 */
	private List<Double> createList(int size) {
		List<Double> out = new Vector<Double>(size);
		for (int i = 0; i < size; i++) { // initialize List
			out.add(0.0);
		}
		return out;
	}

	/**
	 * Calculate the mean of the list
	 * 
	 * @param x
	 * @return mean
	 */
	private double mean(List<Double> x) {

		if ((x == null) || (x.size() < 1)) { // input data validation
			return 0.0;
		}

		double sum = 0.0;
		int size = x.size();
		for (int i = 0; i < size; i++) {
			sum = sum + x.get(i).doubleValue();
		}

		double mean = (double) (sum / (double) (size));

		return mean;
	}

	/**
	 * This method performs DC filtering.
	 * 
	 * @param x
	 *            sampled converted values for filtering operation
	 * @param samplingRate
	 *            not used - ignore
	 * @param cutoffFreq
	 *            This parameter is a smoothing factor parameter
	 * @return digitally filtered array
	 */
	public List<Double> filter(List<Double> x, int samplingRate,
			double cutoffFreq) throws InvalidAlgorithmParameterException {

		// validate input parameters just in case
		if ((x == null) || x.size() <= 0) {
			throw new InvalidAlgorithmParameterException(
					"com.incheck.dpm.dsp.DCFilter: Invalid input array of zero length or Null.\n\t ");
		}
		int n = (int) this.cutoffFreq; // use default / currently set smoothing
		// parameter
		if (cutoffFreq >= 2) {
			n = (int) cutoffFreq; // overwrite default if user provides
			// smoothing factor as a valid parameter
		}

		List<Double> out = createList(x.size());
		List<Double> cema = centEma(x, n);

		for (int i = 0; i < x.size(); i++) {
			out.set(i, x.get(i).doubleValue() - (cema.get(i).doubleValue()));
		}

		return out;
	}

	/**
	 * This method performs DC filtering.
	 * 
	 * @param x
	 *            sampled converted values for filtering operation
	 * @param samplingRate
	 *            not used - ignore
	 * @return digitally filtered array
	 */
	public List<Double> filter(List<Double> x, int samplingRate)
			throws InvalidAlgorithmParameterException {

		return filter(x, samplingRate, this.cutoffFreq);

	}

	/**
	 * This method performs DC filtering.
	 * 
	 * @param x
	 *            sampled converted values for filtering operation
	 * @param samplingRate
	 *            not used - ignore
	 * @param cutoffFreq
	 *            This parameter is a smoothing factor parameter
	 * @param optParam1
	 *            Optional parameter not used in this implementation of the
	 *            filter
	 * @return digitally filtered array
	 */
	public List<Double> filter(List<Double> x, int samplingRate,
			double cutoffFreq, int optParam1)
			throws InvalidAlgorithmParameterException {

		return filter(x, samplingRate, cutoffFreq);

	}

}
