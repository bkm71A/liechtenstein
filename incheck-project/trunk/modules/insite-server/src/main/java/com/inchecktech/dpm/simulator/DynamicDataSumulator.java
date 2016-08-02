package com.inchecktech.dpm.simulator;

import java.io.Serializable;
import java.util.Random;

import com.inchecktech.dpm.utils.Logger;

public class DynamicDataSumulator implements Serializable {

	private static final long serialVersionUID = 1L;

	@SuppressWarnings("unused")
	private static final Logger logger = new Logger(DynamicDataSumulator.class);
	public static final int SECONDS = 60;

	private double A1 = 1D;
	private double A2 = 3D / 4D;
	private double A3 = 2D / 3D;
	private double A4 = 1D / 2D;
	private double A5 = 1D / 2D;
	private double A6 = .25D;
	private double A7 = 1D / 4D;
	private double A8 = 1D / 4D;

	private double B2 = 2d;
	private double B3 = 3d;
	private double B4 = 4d;
	private double B5 = 13.5d;
	private double B6 = 27d;

	private double G1 = 16000d * Math.PI;
	private double G2 = 3000d * Math.PI;

	private double simLowerRandom = 0D;
	private double simUpperRandom = 3D;

	
	public DynamicDataSumulator() {
	}

	public DynamicDataSumulator(double alpha[], double beta[], double gamma[],
			double simLRandom, double simURandom) {
		if (null != alpha && alpha.length==8) {
			A1 = alpha[0];
			A2 = alpha[1];
			A3 = alpha[2];
			A4 = alpha[3];
			A5 = alpha[4];
			A6 = alpha[5];
			A7 = alpha[6];
			A8 = alpha[7];
		}
		
		if (null != beta && beta.length==5) {
			B2 = beta[0];
			B3 = beta[1];
			B4 = beta[2];
			B5 = beta[3];
			B6 = beta[4];			
		}
		
		if (null != gamma && gamma.length==2) {
			G1 = gamma[0];
			G2 = gamma[1];
		}
		
		simLowerRandom=simLRandom;
		simUpperRandom=simURandom;

	}

	/**
	 * @param rpm
	 * @return omega = 2*pi(rpm/60)
	 */
	private double getOmega(Double rpm) {
		double omega = 2D * Math.PI * (rpm / SECONDS);
		return omega;
	}

	/**
	 * @param start
	 * @param end
	 * @return somewhat random number in the given range
	 */
	private double getRandom(double start, double end) {
		Random rnd = new Random();
		double s = rnd.nextDouble() * end + start;
		return s;
	}

	/**
	 * @param rpm
	 * @param seconds
	 * @param samplingRate
	 * @param addRandom
	 * @return Double
	 */
	private Double simulate(Double rpm, Double seconds, Double samplingRate,
			boolean addRandom) {

		Double result = A1
				* Math.sin(getOmega(rpm) * seconds / samplingRate)
				+ ((A2) * (Math
						.sin(B2 * getOmega(rpm) * seconds / samplingRate)))
				+ ((A3) * (Math
						.sin(B3 * getOmega(rpm) * seconds / samplingRate)))
				+ ((A4) * (Math
						.sin(B4 * getOmega(rpm) * seconds / samplingRate)))
				+ ((A5) * (Math
						.sin(B5 * getOmega(rpm) * seconds / samplingRate)))
				+ ((A6) * (Math.sin(B6 * getOmega(rpm) * seconds / samplingRate + (3D * Math.PI) / 2D)))
				+ ((A7) * (Math.sin(G1 * seconds / samplingRate)))
				+ ((A8) * (Math.sin(G2 * seconds / samplingRate)));

		if (addRandom) {
			double x = simUpperRandom;
			result = result + getRandom(simLowerRandom, x) - x / 2;
		}

		return result;
	}

	/**
	 * @param sampleSize
	 * @param rpm
	 * @param samplingRate
	 * @return array of double
	 */
	public double[] getSimDataDouble(int sampleSize, Double rpm,
			Double samplingRate) {
		double[] retval = new double[sampleSize];
		for (int i = 0; i < sampleSize; i++) {
			retval[i] = simulate(rpm, i + 1D, samplingRate, true);
		}

		return retval;
	}

	/**
	 * @param sampleSize
	 * @param rpm
	 * @param samplingRate
	 * @return array of ints
	 */
	public int[] getSimDataInt(int sampleSize, Double rpm, Double samplingRate,
			boolean addRandom, double sensorSensitivity, int bitResolution,
			int maxVoltage, double sensorBiasVoltage) {
		int[] retval = new int[sampleSize];
		for (int i = 0; i < sampleSize; i++) {
			retval[i] = new Double(((simulate(rpm, i + 1D, samplingRate,
					addRandom)
					* sensorSensitivity / 1000) * Math.pow(2, bitResolution))
					/ maxVoltage).intValue();
		}

		return retval;
	}

	public double getA1() {
		return A1;
	}

	public void setA1(double a1) {
		A1 = a1;
	}

	public double getA2() {
		return A2;
	}

	public void setA2(double a2) {
		A2 = a2;
	}

	public double getA3() {
		return A3;
	}

	public void setA3(double a3) {
		A3 = a3;
	}

	public double getA4() {
		return A4;
	}

	public void setA4(double a4) {
		A4 = a4;
	}

	public double getA5() {
		return A5;
	}

	public void setA5(double a5) {
		A5 = a5;
	}

	public double getA6() {
		return A6;
	}

	public void setA6(double a6) {
		A6 = a6;
	}

	public double getA7() {
		return A7;
	}

	public void setA7(double a7) {
		A7 = a7;
	}

	public double getA8() {
		return A8;
	}

	public void setA8(double a8) {
		A8 = a8;
	}

	public double getB2() {
		return B2;
	}

	public void setB2(double b2) {
		B2 = b2;
	}

	public double getB3() {
		return B3;
	}

	public void setB3(double b3) {
		B3 = b3;
	}

	public double getB4() {
		return B4;
	}

	public void setB4(double b4) {
		B4 = b4;
	}

	public double getB5() {
		return B5;
	}

	public void setB5(double b5) {
		B5 = b5;
	}

	public double getB6() {
		return B6;
	}

	public void setB6(double b6) {
		B6 = b6;
	}

	public double getG1() {
		return G1;
	}

	public void setG1(double g1) {
		G1 = g1;
	}

	public double getG2() {
		return G2;
	}

	public void setG2(double g2) {
		G2 = g2;
	}

	public double getSimLowerRandom() {
		return simLowerRandom;
	}

	public void setSimLowerRandom(double simLowerRandom) {
		this.simLowerRandom = simLowerRandom;
	}

	public double getSimUpperRandom() {
		return simUpperRandom;
	}

	public void setSimUpperRandom(double simUpperRandom) {
		this.simUpperRandom = simUpperRandom;
	}

}
