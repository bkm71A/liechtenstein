package com.inchecktech.dpm.dsp;

import java.util.HashMap;
import java.util.List;

import com.inchecktech.dpm.beans.Band;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.persistence.PersistBands;
import com.inchecktech.dpm.utils.Logger;

public class BandCalculator {

    private static final Logger logger = new Logger(BandCalculator.class);

    /**
     * 
     * @param channelId
     * @return HashMap of bandId and the overallValue for that band.
     */
    public static HashMap<Integer, Double> getBandOveralls(ProcessedData spectrumData) {
        HashMap<Integer, Double> retval = new HashMap<Integer, Double>();
        int channelId = spectrumData.getChannelId();
        logger.debug("getBandOveralls for channelId: " + channelId);
        List<Band> bands = PersistBands.getBandsForChannel(channelId);
        if (null != bands) {
            for (Band b : bands) {
                retval.put(b.getBandId(), getRmsForBand(b, spectrumData));
            }
        }
        logger.debug("getBandOveralls returned: " + retval);
        return retval;
    }

    @SuppressWarnings("unused")
    private static double getMaxForBand(Band band, List<Double> data) {
        double max = Double.NaN;

        getSubArray(band.getStartFreq(), band.getEndFreq(), data);
        for (Double d : data) {
            if (d >= max) {
                max = d;
            }
        }

        logger.debug("getMaxForBand returned: " + max);
        return max;
    }

    /**
     * 
     * @param data
     * @return
     */
    private static double getRmsForBand(Band band, ProcessedData spectrumData) {
        List<Double> data = spectrumData.getData();
        double rms;
        double sum = 0d; // NaN will not work here
        double timeConst = (((double) data.size() * 2d) / (double) spectrumData.getSamplingRate());
        int startIndex = Math.round((float) (band.getStartFreq() * timeConst));
        int endIndex = Math.round((float) (band.getEndFreq() * timeConst));
        for (int i = startIndex; i <= endIndex; i++) {
            sum = sum + data.get(i) * data.get(i); // less processing than Math.pow()
        }
        rms = Math.sqrt(sum*0.5*0.6667);
        return rms;
    }

    /**
     * 
     * @param start
     * @param end
     * @param data
     */
    private static void getSubArray(double start, double end, List<Double> data) {
        for (Double d : data) {
            if (d >= start && d <= end) {
                data.remove(d);
            }
        }
    }
}
