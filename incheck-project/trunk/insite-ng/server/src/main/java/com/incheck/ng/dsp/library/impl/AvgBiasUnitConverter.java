package com.incheck.ng.dsp.library.impl;
/** 
 * Copyright 2007, Incheck, Inc.
 * All Rights Reserved
 *
 * This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended
 * publication of such source code. 
 * 
 */

import java.util.Vector;

import com.incheck.ng.dsp.library.UnitConverter;

/**
 * This is the implementation of UnitCOnverter using formula:
 *  ((MAX_VOLTAGE * number) / POW(2, BIT_RESOLUTION)) - BIAS_VOLTAGE;
 *      WHERE 
 *          MAX_VOLTAGE = 5
 *          BIT_RESOLUTION = 16
 *          BIAS_VOLTAGE = AVEGARE OF ALL DATA POINTS
 * 
 * @author Taras Dobrovolsky
 * 
 * Change History:
 * 10/27/2007   Taras Dobrovolsky       Initial release
 */
public class AvgBiasUnitConverter implements UnitConverter {
    
    private int maxVoltage = 5;
    private int bitResolution = 16;
    private double sensorSensitivity = 100.0;
    private double sensorBiasVoltage = 2.5;
    private double sensorGain = 1;
    private double sensorOffset = 0;
    
    public AvgBiasUnitConverter(int maxVoltage, int bitResolution, double sensorSensitivity, double sensorBiasVoltage, double sensorGain,
            double sensorOffset) {
        this.maxVoltage = maxVoltage;
        this.bitResolution = bitResolution;
        this.sensorSensitivity = sensorSensitivity;
        this.sensorBiasVoltage = sensorBiasVoltage;
        this.sensorGain = sensorGain;
        this.sensorOffset = sensorOffset;
    }


    /**
     * One of the implementation of sampled data conversion from integers into volts.
     * ((MAX_VOLTAGE * number) / pow(2, BIT_RESOLUTION)) - SENSOR_BIAS;
     *      WHERE 
     *          MAX_VOLTAGE = 5
     *          BIT_RESOLUTION = 16 
     *          SENSOR_BIAS = AVERAGE OF ALL DATA POINTS
     */
    public Vector<Double> convertToVolts(int[] arrIn) {
        
        if ((arrIn == null) || (arrIn.length == 0)) {
            return new Vector<Double>(0);
        }
        
        Vector<Double> convertedValues = new Vector<Double>(arrIn.length);
        
        double sum = 0, volts;
        for (int i=0; i<arrIn.length; i++) {
            volts = convertIntToVolts(arrIn[i]);
            sum = sum + volts;
            convertedValues.add(volts);
        }
        
        // calculate bias (average)
        double bias = sum / arrIn.length;
        
        // adjust for bias
        for (int i=0; i< convertedValues.size(); i++) {
            convertedValues.set(i, convertedValues.elementAt(i) - bias);
        }
        
        return convertedValues;
        
    }
    

    /**
     * Convert sampled Vector array of volts into G's of Doubles.  (volts -> G's).
     * Conversion to G's depends on sensor sensitivity measured in mv/g, and should
     * be configurable per channel as different sensors may be used. 
     * @param arrIn sampled Vector array of volts
     */
    public Vector<Double> convertVoltsToGs(Vector<Double> arrIn) {
        
        if ((arrIn == null) || (arrIn.size() == 0)) {
            return new Vector<Double>(0);
        }
        
        Vector<Double> convertedValues = new Vector<Double>(arrIn.size());
        
        for (int i=0; i<arrIn.size(); i++) {
            convertedValues.add((arrIn.elementAt(i)/(sensorSensitivity * sensorGain)) * 1000 - sensorOffset);
        }
        
        return convertedValues;
        
    }

//    public double[] convertToGs(double arrIn[]) {
//        if ((arrIn == null) || (arrIn.length == 0)) {
//            return new double[0];
//        }
//        int size = arrIn.length;
//        double[] convertedValues = new double[size];
//        double sum = 0;
//        System.arraycopy(arrIn, 0, convertedValues, 0, size);
//        for (int i = 0; i < size; i++) {
//            sum += arrIn[i];
//        }
//        // calculate bias (average)
//        double bias = sum / size;
//        // adjust for bias then convert to G's using sensor sensitivity
//        // configuration setting
//        for (int i = 0; i < convertedValues.length; i++) {
//            convertedValues[i] = ((convertedValues[i] - bias) / (sensorSensitivity * sensorGain)) * 1000 - sensorOffset;
//        }
//        return convertedValues;
//    }
    /**
     * Convert sampled array of integers into G's of Doubles.  (Int -> volts -> G's).
     * Conversion to G's depends on sensor sensitivity measured in mv/g, and should
     * be configurable per channel as different sensors may be used. 
     * @param arrIn sampled array of integers
     */
    public double[] convertToGs(int[] arrIn) {
        if ((arrIn == null) || (arrIn.length == 0)) {
            return new double[0];
        }
        double convertedValues[] = new double[arrIn.length];

        double sum = 0, volts;
        for (int i = 0; i < arrIn.length; i++) {
            volts = convertIntToVolts(arrIn[i]);
            sum = sum + volts;
            convertedValues[i] = volts;
        }
        // calculate bias (average)
        double bias = sum / arrIn.length;
        // adjust for bias then convert to G's using sensor sensitivity
        // configuration setting
        for (int i = 0; i < convertedValues.length; i++) {
            convertedValues[i] = ((convertedValues[i] - bias) / (sensorSensitivity * sensorGain)) * 1000 - sensorOffset;
        }
        return convertedValues;
    }    
    /**
     * Helper method that converts a single value from integer into volts.
     * @param number sampled integer
     * @return converted number in volts
     */
    private double convertIntToVolts(int number) {
        return ((maxVoltage * number) / Math.pow(2, bitResolution));
    }


    /**
     * @return the maxVoltage
     */
    public int getMaxVoltage() {
        return maxVoltage;
    }


    /**
     * @param maxVoltage the maxVoltage to set
     */
    public void setMaxVoltage(int maxVoltage) {
        this.maxVoltage = maxVoltage;
    }


    /**
     * @return the bitResolution
     */
    public int getBitResolution() {
        return bitResolution;
    }


    /**
     * @param bitResolution the bitResolution to set
     */
    public void setBitResolution(int bitResolution) {
        this.bitResolution = bitResolution;
    }


    /**
     * @return the sensorSensitivity
     */
    public double getSensorSensitivity() {
        return sensorSensitivity;
    }


    /**
     * @param sensorSensitivity the sensorSensitivity to set
     */
    public void setSensorSensitivity(double sensorSensitivity) {
        this.sensorSensitivity = sensorSensitivity;
    }


    /**
     * @return the sensorBiasVoltage
     */
    public double getSensorBiasVoltage() {
        return sensorBiasVoltage;
    }


    /**
     * @param sensorBiasVoltage the sensorBiasVoltage to set
     */
    public void setSensorBiasVoltage(double sensorBiasVoltage) {
        this.sensorBiasVoltage = sensorBiasVoltage;
    }


    public double getSensorGain() {
        return sensorGain;
    }


    public void setSensorGain(double sensorGain) {
        this.sensorGain = sensorGain;
    }


    public double getSensorOffset() {
        return sensorOffset;
    }


    public void setSensorOffset(double sensorOffset) {
        this.sensorOffset = sensorOffset;
    }
    
        

}
