package com.incheck.ng.dsp.library;

import static org.junit.Assert.assertEquals;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class DSPLibraryTestUtils {
    private final static String DATA_FILE_DIRECTORY = "src/test/resources/test-data/";

    public static double[] loadDataFromFile(String fileName) throws Exception {
        List<Double> dataList = new ArrayList<Double>();
        DataInputStream in = new DataInputStream(new FileInputStream(DATA_FILE_DIRECTORY + fileName));
        BufferedReader br = new BufferedReader(new InputStreamReader(in));
        String strLine;
        // Read File Line By Line
        while ((strLine = br.readLine()) != null) {
            String trimmed = strLine.trim();
            // Number sign # starts comments
            if (trimmed.length() > 0 && !trimmed.startsWith("#")) {
                dataList.add(new Double(trimmed));
            }
        }
        // Close the input stream
        in.close();
        double data[] = new double[dataList.size()];
        for (int j = 0; j < dataList.size(); j++) {
            data[j] = dataList.get(j).doubleValue();
        }
        return data;
    }

    public static void compareArrays(double actual[], double expected[], double delta) {
        assertEquals(actual.length, expected.length);
        for (int j = 0; j < expected.length; j++) {
            assertEquals(String.format("Calculations mismatch row number-,actual-,expected-", j, actual[j], expected[j]), actual[j],
                    expected[j], delta);
        }
    }
}
