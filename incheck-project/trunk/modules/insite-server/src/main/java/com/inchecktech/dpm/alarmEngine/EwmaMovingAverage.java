/**
 * 
 */
package com.inchecktech.dpm.alarmEngine;

/**
 * Implements 'exponentially weighted moving average' algorithm.
 * 
 * @see http://en.wikipedia.org/wiki/Weighted_moving_average#Weighted_moving_average
 * @author Slava Kovalenko
 */
public class EwmaMovingAverage {
	private double yt_1 = Double.NaN;

	private double st = Double.NaN;

	/**
	 * The degree of weighing decrease is expressed as a constant smoothing
	 * factor alpha, a number between 0 and 1, where 1 - is no smothing at all.
	 */
	private double smothingFactor = 0.05;

	public EwmaMovingAverage() {
	}

	public EwmaMovingAverage(double smothingFactor) {
		if (smothingFactor < 0.0 || smothingFactor > 1.0) {
			throw new IllegalArgumentException(
					"Smoothing Factor should be within 0.0 - 1.0 range. Attempted value="
							+ smothingFactor);
		}
		this.smothingFactor = smothingFactor;
	}

	public void setNext(double value) {
		double st_1 = st;
		// if first point, then weighted moving average is undefined
		if (!Double.isNaN(yt_1)) {
			if (Double.isNaN(st_1)) {
				st_1 = yt_1;
			}
			st = smothingFactor * yt_1 + (1.0 - smothingFactor) * st_1;
		}
		yt_1 = value;
	}

	/**
	 * @return exponential moving average (EMA), sometimes also called an
	 *         exponentially weighted moving average (EWMA).
	 */
	public double getWeightedMovingAverage() {
		return st;
	}

	/**
	 * The degree of weighing decrease is expressed as a constant smoothing
	 * factor alpha, a number between 0 and 1. alpha may be expressed as a
	 * percentage, so a smoothing factor of 10% is equivalent to alpha=0.1.
	 * 
	 * @param smothingFactor
	 *            a number between 0 and 1. alpha may be expressed as a
	 *            percentage, so a smoothing factor of 10% is equivalent to
	 *            alpha=0.1.
	 */
	public void setSmothingFactor(double smothingFactor) {
		if (smothingFactor < 0.0 || smothingFactor > 1.0) {
			throw new IllegalArgumentException(
					"Smoothing Factor should be within 0.0 - 1.0 range. Attempted value="
							+ smothingFactor);
		}		
		this.smothingFactor = smothingFactor;
		// flip values, start from begining
		yt_1 = Double.NaN;
		st = Double.NaN;
	}
}
