package com.inchecktech.dpm.dsp;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.util.ArrayList;
import java.util.List;

import junit.framework.TestCase;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.EUnit;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.ProcessedDynamicData;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.flex.DPMFlexProxy;

/**
 * Test cases for Acceleration and Velocity overalls calculation <code>DSPDynamicCalculator</code>.
 * 
 * @author ykiulo
 * 
 */
public class DSPDynamicCalculatorTest extends TestCase {

	/* sample rate for the testing */
	private static final int SAMPLE_RATE = 5120;

	/* block size for the testing */
	private static final int BLOCK_SIZE = 8192;

	/* channel id for the testing */	
	private static final int CHANNEL_ID = 1;

	/* Assertion delta */
	private static final double ASSERTION_DELTA = 0.0001;

	/* Acceleration Peak final value */
	private static final double PEAK_A = 2.2608872663975386;

	/* Acceleration RMS final value */
	private static final double RMS_A = 0.860523176045159;

	/* Velocity Peak final value */
	private static final double PEAK_V = 3.1663893596756925;

	/* Velocity RMS final value */
	private static final double RMS_V = 1.5590819740500346;

	/* Not null Error message */
	private static final String ERROR_NOT_NULL = " can not be null.";

	/* Acceleration overall type sign */
	private static final String ACCELERATION_OVERALL_TYPE = "A";

	/* Velocity overall type sign */
	private static final String VELOCITY_OVERALL_TYPE = "V";

	/**
	 * Test case for <code>processData</code>.
	 */
	public void AccelerationAndVelocityOverallsCalculation() {
		testOverallsCalculation(createInputTestDataFromFile());
	}

	/*
	 * Create an instance of <code>DSPCalculator</code> for tests.
	 * 
	 * @return the instance of the <code>DSPCalculator</code> or <code>null</code>
	 */
	private DSPCalculator createDSPCalculator() {
		DSPCalculator calc = DataBucket.getDSPCalculator(CHANNEL_ID);
		if (calc == null) {
			calc = DSPFactory.newDSPCalculator(CHANNEL_ID);
			DataBucket.addOrReplaceDSPCalculator(CHANNEL_ID, calc);
		}

		return calc;
	}
	
	/**
	 * Test case for <code>processData</code> to Band Overalls calculation.
	 */
	public void testBandAccelerationAndVelocityOverallsCalculation() {
		ProcessedDynamicData dataIn = new ProcessedDynamicData(CHANNEL_ID);
		dataIn.setData(createDoubleInputTestDataFromFile());
		dataIn.setSamplingRate(SAMPLE_RATE);

		DSPCalculator calculator = createDSPCalculator();

		try {
			calculator.processData(dataIn, ProcessedData.KEY_SPECTRUM_VEL_RMS, EUnit.FreqHz, EUnit.AccG, DPMFlexProxy.CENTRAL_FREQUENCY_DEFAULT, DPMFlexProxy.FREQUENCY_DEVIATION_DEFAULT);
		} catch (InvalidAlgorithmParameterException exc) {
			System.err.println(exc.getLocalizedMessage());
		}

	}

	/*
	 * Call DSPDynamicCalculator to calculate overalls and verify results.
	 */
	private void testOverallsCalculation(RawData result) {
		ChannelState channelState = null;

		DSPCalculator calc = createDSPCalculator();

		try {
			// turn off debug mode
			((DSPDynamicCalculator) calc).setDebugMode(false);
			((DSPDynamicCalculator) calc).setOverallType(ACCELERATION_OVERALL_TYPE);
			// test and verify Acceleration overalls
			testAndVerifyAccelerationOveralls(calc, channelState, result);

			// test and verify Velocity overalls
			((DSPDynamicCalculator) calc).setOverallType(VELOCITY_OVERALL_TYPE);
			testAndVerifyVelocityOveralls(calc, channelState, result);
		} catch (InvalidAlgorithmParameterException exc) {
			System.err.println(exc.getLocalizedMessage());
		}
	}

	/*
	 * Create input <code>RawData</code> test data from file.
	 * 
	 * @return test instance of <code>RawData</code>.
	 */
	private RawData createInputTestDataFromFile() {
		RawData result = new RawData(CHANNEL_ID);
		try {
			BufferedReader in = new BufferedReader(new FileReader("target/test-classes/testData.txt"));
			String str;
			int[] tmpData = new int[BLOCK_SIZE];
			int i = 0;
			while ((str = in.readLine()) != null) {
				Double dTmp = new Double(str);
				dTmp = dTmp * Math.pow(2, 16) / 5d;
				tmpData[i++] = dTmp.intValue();
			}
			in.close();

			/*
			 * test output for(int j = 0; j < tmpData.length; j++){ System.out.println("+" + j + ":" + tmpData[j]); }
			 * test output
			 */

			result.setData(tmpData);
			result.setSamplingRate(SAMPLE_RATE);
			fillTicks(result);
		} catch (IOException exc) {
			System.err.println(exc.getLocalizedMessage());
		}

		return result;
	}

	/*
	 * Create input <code>RawData</code> test data from file.
	 * 
	 * @return test instance of <code>RawData</code>.
	 */
	private List<Double> createDoubleInputTestDataFromFile() {
		List<Double> result = new ArrayList<Double>(BLOCK_SIZE);
		try {
			BufferedReader in = new BufferedReader(new FileReader("target/test-classes/testData.txt"));
			String str;
			while ((str = in.readLine()) != null) {
				Double dTmp = new Double(str);
				result.add(dTmp);
			}
			in.close();
		} catch (IOException exc) {
			System.err.println(exc.getLocalizedMessage());
		}

		return result;
	}

	/*
	 * Test case for Acceleration overalls
	 * 
	 * @param calc - instance of <code>DSPDynamicCalculator</code>
	 * 
	 * @param channelState - channel state
	 * 
	 * @param result - raw data
	 * 
	 * @throws InvalidAlgorithmParameterException - possible exception
	 */
	private void testAndVerifyAccelerationOveralls(DSPCalculator calc, ChannelState channelState, RawData result)
	        throws InvalidAlgorithmParameterException {
		// run the dynamic calculation...
		channelState = calc.processData(result, null);

		// verify acceleration overalls
		verifyOveralls(channelState, ACCELERATION_OVERALL_TYPE);
	}

	/*
	 * Test case for Velocity overalls
	 * 
	 * @param calc - instance of <code>DSPDynamicCalculator</code>
	 * 
	 * @param channelState - channel state
	 * 
	 * @param result - raw data
	 * 
	 * @throws InvalidAlgorithmParameterException - possible exception
	 */
	private void testAndVerifyVelocityOveralls(DSPCalculator calc, ChannelState channelState, RawData result)
	        throws InvalidAlgorithmParameterException {
		// run the dynamic calculation...
		channelState = calc.processData(result, null);

		// verify acceleration overalls
		verifyOveralls(channelState, VELOCITY_OVERALL_TYPE);
	}

	/*
	 * Verify test data
	 * 
	 * @param channelState
	 */
	private void verifyOveralls(ChannelState channelState, final String overallType) {
		assertNotNull(ChannelState.class.getCanonicalName() + ERROR_NOT_NULL, channelState);
		ProcessedData processedData = channelState.getPrimaryProcessedData();
		assertNotNull(ProcessedData.class.getCanonicalName() + ERROR_NOT_NULL, processedData);
		OverallLevels overalls = processedData.getOveralls();
		assertNotNull(OverallLevels.class.getCanonicalName() + ERROR_NOT_NULL, overalls);

		assertEquals((ACCELERATION_OVERALL_TYPE.equals(overallType)) ? PEAK_A : PEAK_V, overalls
		        .getOverall("Accel Peak"), ASSERTION_DELTA);
		assertEquals((ACCELERATION_OVERALL_TYPE.equals(overallType)) ? RMS_A : RMS_V, overalls.getOverall("Accel_Rms"),
		        ASSERTION_DELTA);
	}

	/*
	 * Fill ticks
	 * 
	 * @param result
	 */
	private void fillTicks(RawData result) {
		boolean[] ticks = new boolean[SAMPLE_RATE];
		ticks[0] = true;
		for (int i = 1; i < SAMPLE_RATE; i++) {
			ticks[i] = (i % 20 == 0) ? true : false;
		}
		result.setDataTicks(ticks);
	}
	
	/*
	 * Aux method to write <code>ProcessedDynamicData</code> data to file
	 * @param dataIn - instance of <code>ProcessedDynamicData</code>
	 * @param fileName - full path to the file.
	 */
	public static void writeDoubleProcessedDynamicDataToFile(ProcessedDynamicData dataIn, final String fileName) {
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(fileName));
			for (int i = 0; i < dataIn.getData().size(); i++) {
				out.write(dataIn.getData().get(i).toString());
				out.write("\n");
			}
			out.close();
		} catch (IOException e) {
		}
	}
}
