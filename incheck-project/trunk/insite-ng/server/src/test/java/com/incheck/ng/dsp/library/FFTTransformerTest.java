package com.incheck.ng.dsp.library;

import org.junit.Test;

public class FFTTransformerTest {
    private static final double DELTA = 0.0006D;

    @Test
    public void fftTransformTest() throws Exception {
        double srcData[] = DSPLibraryTestUtils.loadDataFromFile("hann_windowed.txt");
        double actual[] = FFTTransformer.fftTransform(srcData);
        double expected[] = DSPLibraryTestUtils.loadDataFromFile("g_spectrum.txt");
        DSPLibraryTestUtils.compareArrays(actual, expected, DELTA);
    }
}
