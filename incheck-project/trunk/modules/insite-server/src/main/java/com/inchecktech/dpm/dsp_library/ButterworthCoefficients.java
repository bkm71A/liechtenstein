package com.inchecktech.dpm.dsp_library;

import java.util.HashMap;
import java.util.Map;

public class ButterworthCoefficients {
    /**
     * This is hardcoded Butterworth coefficients for 6-pole Butterworth filter
     * for sampling rate of 44100 per second
     * 
     */
    public static final Map<Integer, Butterworth6PoleCoefficientSet> hardcodedSixPole44100Map = new HashMap<Integer, Butterworth6PoleCoefficientSet>();
    static {
        Butterworth6PoleCoefficientSet coefficientArray[] = {
            new Butterworth6PoleCoefficientSet(512,256,new double[]{0.000329439,0.000324189,0.000321233},new double[]{-1.979983403,-1.948429235,-1.930665416},new double[]{0.981301159,0.94972599,0.931950349}),
            new Butterworth6PoleCoefficientSet(1280,640,new double[]{0.00202939,0.001951559,0.001909283},new double[]{-1.945834273,-1.871207986,-1.830672922},new double[]{0.953951831,0.879014222,0.838310055}),
            new Butterworth6PoleCoefficientSet(2560,1280,new double[]{0.007919864,0.007349143,0.007055598},new double[]{-1.878654147,-1.743274639,-1.67364355},new double[]{0.910333603,0.772671211,0.701865944}),
            new Butterworth6PoleCoefficientSet(5120,2560,new double[]{0.03011156,0.026266304,0.024462741},new double[]{-1.710521782,-1.492087599,-1.389634148},new double[]{0.830968021,0.597152814,0.487485113}),
            new Butterworth6PoleCoefficientSet(12800,6400,new double[]{0.160926772,0.124341419,0.109914663},new double[]{-1.01656282,-0.785455785,-0.694323005},new double[]{0.660269906,0.282821461,0.133981656}),
            new Butterworth6PoleCoefficientSet(25600,12800,new double[]{0.499852383,0.371066199,0.323016917},new double[]{0.400147483,0.297050111,0.258585156},new double[]{0.599262047,0.187214684,0.033482513})
            };
        for (int j = 0; j < coefficientArray.length; j++) {
            hardcodedSixPole44100Map.put(coefficientArray[j].f0, coefficientArray[j]);
        }
    }
    
    public static class Butterworth6PoleCoefficientSet {
        public int sr;
        public int f0;
        public double b[];
        public double a1[];
        public double a2[];

        public Butterworth6PoleCoefficientSet(int sr, int f0, double[] b, double[] a1, double[] a2) {
            super();
            this.sr = sr;
            this.f0 = f0;
            this.b = b;
            this.a1 = a1;
            this.a2 = a2;
        }
    }
}
