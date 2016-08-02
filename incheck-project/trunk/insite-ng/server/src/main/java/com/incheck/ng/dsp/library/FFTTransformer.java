package com.incheck.ng.dsp.library;

import java.security.InvalidAlgorithmParameterException;

/**
 * Default implementation of FFT transformation algorithm.
 * Reference: http://www.dsptutor.freeuk.com/analyser/SpectrumAnalyser.html
 * 
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 10/14/2007   Taras Dobrovolsky       Initial release
 */
public final class FFTTransformer {
    
    private FFTTransformer() {
    }

    /**
     * FFT Implementation: http://www.dsptutor.freeuk.com/analyser/SpectrumAnalyser.html
     */
    public static double[] fftTransform(double arrIn[]) throws InvalidAlgorithmParameterException {
        int size = arrIn.length;
        if ((arrIn == null) || size == 0) {
            throw new InvalidAlgorithmParameterException("FFTTransformer: Invalid input array of zero length or Null.\n\t ");
        }
        if ((size & (size - 1)) != 0) {
            throw new InvalidAlgorithmParameterException("FFTTransformer: Input array must be of size 2^n, i.e. Radix 2.\n\t ");
        }
        return fft(arrIn);
    }
    
    // Helper method
    private static int bitrev(int j, int nu) {
        int j2;
        int j1 = j;
        int k = 0;
        for (int i = 1; i <= nu; i++) {
          j2 = (int)Math.floor(j1/2);
          k  = 2*k + j1 - 2*j2;
          j1 = j2;
        }
        return k;
      }

    // Helper method
    private final static double[] fft(double[] x) {
        // assume n is a power of 2
        int n = x.length;
        int nu = (int) (Math.log(n) / Math.log(2));
        int n2 = n / 2;
        int nu1 = nu - 1;
        double[] xre = new double[n];
        double[] xim = new double[n];
        double[] mag = new double[n2];
        double tr, ti, p, arg, c, s;
        for (int i = 0; i < n; i++) {
          xre[i] = x[i];
          xim[i] = 0.0f;
        }
        int k = 0;

        for (int l = 1; l <= nu; l++) {
          while (k < n) {
            for (int i = 1; i <= n2; i++) {
              p = bitrev(k >> nu1, nu);
              arg = 2 * (double) Math.PI * p / n;
              c = (double) Math.cos (arg);
              s = (double) Math.sin (arg);
              tr = xre[k+n2]*c + xim[k+n2]*s;
              ti = xim[k+n2]*c - xre[k+n2]*s;
              xre[k+n2] = xre[k] - tr;
              xim[k+n2] = xim[k] - ti;
              xre[k] += tr;
              xim[k] += ti;
              k++;
            }
            k += n2;
          }
          k = 0;
          nu1--;
          n2 = n2/2;
        }
        k = 0;
        int r;
        while (k < n) {
          r = bitrev (k, nu);
          if (r > k) {
            tr = xre[k];
            ti = xim[k];
            xre[k] = xre[r];
            xim[k] = xim[r];
            xre[r] = tr;
            xim[r] = ti;
          }
          k++;
        }
        mag[0] = (double) (Math.sqrt(xre[0]*xre[0] + xim[0]*xim[0]))/n;
        for (int i = 1; i < n/2; i++) {
          mag[i]= 2 * (double) (Math.sqrt(xre[i]*xre[i] + xim[i]*xim[i]))/n;
        }
        return mag;
      }
}
