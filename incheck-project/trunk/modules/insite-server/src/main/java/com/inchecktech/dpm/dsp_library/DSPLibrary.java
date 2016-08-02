package com.inchecktech.dpm.dsp_library;


public class DSPLibrary {
    /**
     * @param x
     * @param b
     * @param a1
     * @param a2
     * @return
     */
    public static double[] butterworthSixPoleFilter(double x[], double b[], double a1[], double a2[]) {
        if (x.length < 4 || b.length != 3 || a1.length != 3 || a2.length != 3) {
            throw new UnsupportedOperationException(String.format("Incorrect filter arguments : x.length=%d;b.length=%d;a1.length=%d;a2.length=%d.", x.length,
                    b.length, a1.length, a2.length));
        }
        double xt[] = new double[x.length + 2];
        double v[] = new double[x.length + 2];
        xt[0] = x[0];
        xt[1] = x[0];
        v[0] = x[0];
        v[1] = x[0];
        for (int i = 0; i < x.length; i++) {
            xt[i + 2] = x[i];
        }
        for (int j = 0; j < b.length; j++) {
            for (int k = 2; k < xt.length; k++) {
                v[k] = (b[j] * xt[k] + 2 * b[j] * xt[k - 1] + b[j] * xt[k - 2]) - (a1[j] * v[k - 1] + a2[j] * v[k - 2]);
                x[k - 2] = v[k];
            }
            System.arraycopy(v, 0, xt, 0, v.length);
        }
        return x;
    }

    /**
     * @param x
     * @param asr
     * @param sr
     * @return
     */
    public static double[] downSample(double x[], int asr, int sr) {
        double r = (double) asr / (double) sr;
        int newLength = (int) Math.floor(x.length / r);
        double v[] = new double[newLength];
        for (int j = 0; j < newLength; j++) {
            int low = (int) Math.floor(j * r);
            int heigh = (int) Math.ceil(j * r);
            v[j] = x[low] + (j * r - low) * (x[heigh] - x[low]);
        }
        return v;
    }
}