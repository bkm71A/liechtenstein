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

/**
 * This interface defines method signatures for implementing unit conversion algorithms: samples to volts,
 * samples to Gs.
 * 
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 10/08/2007	Taras Dobrovolsky		Initial Release
 * 10/14/2007 	Taras Dobrovolsky		Added conversion to G's methods
 * 10/19/2007	Taras Dobrovolsky		Added sensor bias adjustment to calculations
 */
public interface UnitConverter {
	
	/**
	 * Convert sampled array of integers into Vector of Doubles 
	 * @param arrIn sampled array of integers
	 */
	public abstract Vector<Double> convertToVolts(int[] arrIn);
	
	/**
	 * Convert sampled array of integers into G's of Doubles.  (Int -> volts -> G's).
	 * Conversion to G's depends on sensor sensitivity measured in mv/g, and should
	 * be configurable per channel as different sensors may be used. 
	 * @param arrIn sampled array of integers
	 */
	public abstract Vector<Double> convertToGs(int[] arrIn);
	
	/**
	 * Convert sampled Vector array of volts into G's of Doubles.  (volts -> G's).
	 * Conversion to G's depends on sensor sensitivity measured in mv/g, and should
	 * be configurable per channel as different sensors may be used.
	 * If there is no need to keep Volts results, use convertToGs() method intead
	 * to convert integers into Gs. 
	 * @param arrIn sampled Vector array of volts
	 */
	public abstract Vector<Double> convertVoltsToGs(Vector<Double> arrIn);

	/**
	 * Convert sampled Vector array of volts into G's of Doubles.  (volts -> G's).
	 * Conversion to G's depends on sensor sensitivity measured in mv/g, and should
	 * be configurable per channel as different sensors may be used.
	 * If there is no need to keep Volts results, use convertToGs() method intead
	 * to convert integers into Gs. 
	 * @param arrIn sampled Vector array of volts
	 */
	public Vector<Double> convertToGs(List<Double> arrIn);

	/**
	 * Set maximum volts the sensor can produce
	 * @param max_voltage the mAX_VOLTAGE to set
	 */
	public abstract void setMaxVoltage(int maxVoltage);

	/**
	 * Set the bit resolution for converting to volts
	 * @param bit_resolution the bIT_RESOLUTION to set
	 */
	public abstract void setBitResolution(int bitResolution);

	/**
	 * Set sensor sensitivity in millivolts per G 
	 * @param sensor_sencitivity the sENSOR_SENCITIVITY to set
	 */
	public abstract void setSensorSensitivity(double sensorSensitivity);
	
	/**
	 * Set sensor bias voltage in VOLTS (it's 2.5 V if a sensor is perfectly calibrated) 
	 * @param sensorBiasVoltage sensor bias voltage in VOLTS
	 */
	public abstract void setSensorBiasVoltage(double sensorBiasVoltage);
	
	/**
	 * Gets the current value of Max Voltage config parameter (5V by default)
	 * @return current value of Max Voltage config parameter (5V by default)
	 */
	public abstract int getMaxVoltage();
	
	/**
	 * Gets the bit resolution (i.e. how many bits are used for storing a single sensor read) 
	 * @return Return the current bit resolution (16 by default)
	 */
	public abstract int getBitResolution();
	
	/**
	 * Get current sensor sensitivity config parameter in MILLIVOLTS (i.e. 100 mv/G)
	 * @return Get current sensor sensitivity config parameter in MILLIVOLTS (i.e. 100 mv/G)
	 */
	public abstract double getSensorSensitivity();
	
	/**
	 * Get the current sensor bias voltage parameter
	 * @return current sensor bias voltage parameter (by defulat in perfect world perfectly calibrated 
	 * sensor's bias is 2.5 VOLTS)
	 */
	public abstract double getSensorBiasVoltage();
	
	/**
	 * Get the current sensor gain in 
	 * @return sensor gain
	 */
	public abstract double getSensorGain();

	/**
	 * Set sensor gain (deafult = 1)
	 * @param sensorGain
	 */
	public abstract void setSensorGain(double sensorGain);

	/**
	 * Get current sensor offset
	 * @return current sensor offset
	 */
	public abstract double getSensorOffset();

	/**
	 * Set sensor offset (default = 0)
	 * @param sensorOffset
	 */
	public abstract void setSensorOffset(double sensorOffset);
	

}
