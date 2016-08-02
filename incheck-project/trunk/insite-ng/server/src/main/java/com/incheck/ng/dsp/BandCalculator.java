package com.incheck.ng.dsp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.incheck.ng.model.Band;
import com.incheck.ng.model.data.ProcessedData;

public class BandCalculator {

    private final static Log log = LogFactory.getLog(BandCalculator.class);

    /**
     * @param channelId
     * @return Map of bandId and the overallValue for that band.
     */
    public static Map<Long, Double> getBandOveralls(ProcessedData spectrumData, List<Band> bands) {
        Map<Long, Double> retval = new HashMap<Long, Double>();
        long channelId = spectrumData.getChannelId();
        log.debug("getBandOveralls for channelId: " + channelId);
        if (null != bands) {
            for (Band band : bands) {
                retval.put(band.getId(), getRmsForBand(band, spectrumData));
            }
        }
        log.debug("getBandOveralls returned: " + retval);
        return retval;
    }

    private static double getRmsForBand(Band band, ProcessedData spectrumData) {
        double data[] = spectrumData.getData();
        double sum = 0d;
        double timeConst = (((double) data.length * 2d) / (double) spectrumData.getSamplingRate());
        int startIndex = Math.round((float) (band.getStartFrequency() * timeConst));
        int endIndex = Math.round((float) (band.getEndFrequency() * timeConst));
        for (int i = startIndex; i <= endIndex; i++) {
            sum = sum + data[i] * data[i]; // less processing than Math.pow()
        }
        return Math.sqrt(sum * 0.5 * 0.6667);
    }
}
