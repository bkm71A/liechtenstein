package com.inchecktech.dpm.alarmEngine;

import junit.framework.TestCase;

import org.junit.Test;

public class EwmaMovingAverageTest extends TestCase {
	// just some meaningless data
	private final static double channelValues[] = { 0.07100953, 0.07085138,
			0.07176381, 0.07037403, 0.07052976, 0.07095643, 0.07126999,
			0.07014741, 0.07076289, 0.07113248, 0.07046693, 0.07035888,
			0.07156147, 0.07071503, 0.07066817, 0.06956585, 0.06963626,
			0.06967858, 0.07152901, 0.06974582, 0.06979493, 0.07068015,
			0.07101345, 0.07102963, 0.07022407, 0.0705079, 0.06948253,
			0.07066933, 0.07068026, 0.07062863, 0.0707259, 0.07069135,
			0.07111126, 0.07053176 };

	@Test
	public final void testSmothing() {
		validateRange(0.5, 0.06979, 0.07135, channelValues);
		validateRange(0.1, 0.07043, 0.071071, channelValues);
		validateRange(1.0, 0.06948, 0.071764, channelValues);
		// now try high frequency noise over low frequency signal
		final int SAMPLE_SIZE = 200;
		double signalValues[] = new double[SAMPLE_SIZE];
		for (int j = 0; j < SAMPLE_SIZE; j++) {
			signalValues[j] = Math.sin(Math.PI * ((double) j) / 100.0 + 0.3)
					+ 0.1 * Math.sin(Math.PI * ((double) j) / 5.0 + 0.6);
		}
		validateDeviation(0.9, 0.011, signalValues);
		validateDeviation(0.5, 0.078, signalValues);
		validateDeviation(0.1, 0.362, signalValues);
		validateDeviation(0.01, 1.205, signalValues);

	}

	private static void validateDeviation(double alpha, double deviation,
			double values[]) {
		EwmaMovingAverage movinAverage = new EwmaMovingAverage(alpha);
		for (int j = 0; j < values.length; j++) {
			movinAverage.setNext(values[j]);
			double avg = movinAverage.getWeightedMovingAverage();
			if (!Double.isNaN(avg)) {
				assertTrue(Math.abs(avg - values[j - 1]) < deviation);
			}
		}
	}

	private static void validateRange(double alpha, double min, double max,
			double values[]) {
		EwmaMovingAverage movinAverage = new EwmaMovingAverage(alpha);
		for (double value : values) {
			movinAverage.setNext(value);
			double avg = movinAverage.getWeightedMovingAverage();
			if (!Double.isNaN(avg)) {
				assertTrue(avg >= min && avg <= max);
			}
		}
	}
}
