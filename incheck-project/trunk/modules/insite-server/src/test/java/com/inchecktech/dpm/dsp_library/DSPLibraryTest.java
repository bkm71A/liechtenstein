package com.inchecktech.dpm.dsp_library;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.inchecktech.dpm.dsp_library.ButterworthCoefficients.Butterworth6PoleCoefficientSet;

public class DSPLibraryTest {
    private static final int SAMPLING_RATES[] = { 512, 1280, 2560, 5120, 12800, 25600 };
    private static final double DELTA = 0.00008;
    private static final int SAMPLE_SAMPLING_RATE = 44100;

    private enum DATA_TYPE {
        input, filtered, resampled
    };

    @Test
    public void dspLibraryTest() throws NumberFormatException, IOException {
        for (int j = SAMPLING_RATES.length - 1; j >= 0; j--) {
            butterworthSixPoleFilterTestForCornerFrequency(SAMPLING_RATES[j]);
        }
    }
    
    private void butterworthSixPoleFilterTestForCornerFrequency(int samplingRate) throws NumberFormatException, IOException {
        double data[] = readDataFile(samplingRate, DATA_TYPE.input);
        int cornerFrequency = samplingRate/2;
         Butterworth6PoleCoefficientSet coefficients = ButterworthCoefficients.hardcodedSixPole44100Map.get(cornerFrequency);
        if (coefficients == null) {
            throw new IllegalArgumentException("No Butterworth coefficients for cornerFrequency=" + cornerFrequency + " is found !!!");
        }
        double filteredResults[] = DSPLibrary.butterworthSixPoleFilter(data, coefficients.b, coefficients.a1, coefficients.a2);
        double filteredSample[] = readDataFile(samplingRate, DATA_TYPE.filtered);
        compareArrays(filteredResults, filteredSample);
        downSampleTest(filteredResults,samplingRate);
    }

    private void downSampleTest(double filteredData[], int samplingRate) throws NumberFormatException, IOException {
        double resampledResults[] = DSPLibrary.downSample(filteredData, SAMPLE_SAMPLING_RATE, samplingRate);
        double resampled[] = readDataFile(samplingRate, DATA_TYPE.resampled);
        compareArrays(resampledResults, resampled);
    }
    
    private double[] readDataFile(int samplingRate, DATA_TYPE dataType) throws NumberFormatException, IOException {
        String fileName = "./dsp-library-data/" + dataType + "-" + samplingRate + ".csv";
        BufferedReader reader = new BufferedReader(new InputStreamReader(this.getClass().getClassLoader().getResourceAsStream(fileName)));
        String value = "";
        List<Double> dataList = new ArrayList<Double>();
        try {
            while ((value = reader.readLine()) != null) {
                if (value.trim().length() > 0) {
                    dataList.add(new Double(value.trim()));
                }
            }
        } finally {
            reader.close();
        }
        return toDoubleArray(dataList);
    }

    double[] toDoubleArray(List<Double> list) {
        double[] ret = new double[list.size()];
        for (int i = 0; i < ret.length; i++) {
            ret[i] = list.get(i);
        }
        return ret;
    }

    private void compareArrays(double array1[], double array2[]) {
        Assert.assertTrue(array1.length == array2.length);
        for (int j = 0; j < array1.length; j++) {
            Assert.assertTrue(Math.abs(array1[j] - array2[j]) < DELTA);
        }
    }
}
