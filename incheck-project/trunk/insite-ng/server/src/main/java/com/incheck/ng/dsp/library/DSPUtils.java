package com.incheck.ng.dsp.library;

public class DSPUtils {
    /**
     * In place multiplication of all list elements by a factor.
     * @param data list of double values
     * @param factor multiplication factor
     * @return data list with all elements multiplied by a factor
     */
    public static double[] multiplyByFactor(double[] data, double factor) {
        if (data == null) {
            return null;
        }
        if (factor == 1.0) { // no need to multiply by 1.0
            return data;
        }
        for (int i = 0; i < data.length; i++) {
            data[i] *= factor;
        }
        return data;
    }
    
    /**
     * Helper method to calculate RPMs using tachometer ticks data
     * @param dataTicks array of tachometer ticks
     * @param samplingRate channel sampling rate
     * @return RPM (Revolutions Per Minute)
     */
    public static double calculateRPM(boolean[] dataTicks, int samplingRate, int ticksPerRevolution) {
        if (dataTicks == null || dataTicks.length < 1) {
            return 0D;
        }
        double rpm = 0D;
        // skip the first subset (if it's not full - i.e.
        // 00000'1000000000100001'000)
        int i = 0;
        while (!dataTicks[i] && (i < dataTicks.length)) {
            i++;
        }
        // loop through data ticks - skip first and second subsets if they are
        // partial
        int counter = 0;
        int rpmCounter = 0;
        double sumOfRpms = 0D;
        for (int j = i; j < dataTicks.length; j++) {
            if (dataTicks[j] && counter != 0) { // calculate RPM, reset counter
                double r = samplingRate * 60D / (ticksPerRevolution * counter);
                rpmCounter++;
                sumOfRpms = sumOfRpms + r;
                counter = 0;
            }
            counter++;
        }
        // calculate RPM average
        if (rpmCounter > 0) {
            rpm = sumOfRpms / rpmCounter;
        }
        return rpm;
    }
}
