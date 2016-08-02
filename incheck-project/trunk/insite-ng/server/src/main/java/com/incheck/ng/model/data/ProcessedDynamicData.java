package com.incheck.ng.model.data;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.incheck.ng.dsp.OverallLevelType;

public abstract class ProcessedDynamicData extends ProcessedData {
    private double[] labels;
    // hash-map of calculated overall values
    protected Map<OverallLevelType, Double> overalls = new HashMap<OverallLevelType, Double>();

    public ProcessedDynamicData(long channelId, double[] data, Date dateTimeStamp, int samplingRate) {
        super(channelId, data, dateTimeStamp, samplingRate);
        init();
    }

    private void init() {
        double startTime = (double) dateTimeStamp.getTime();
        double endTime = (double) (startTime + 1000 * data.length / samplingRate);
        setLabels(0, (endTime - startTime) * 0.001);
        calculateOverallLevels();
    }

    public void setLabels(double min, double max) {
        if (data == null || data.length == 0) {
            return;
        }
        // calculate step
        double step = (max - min) / data.length;
        double curr = min;
        labels = new double[data.length];
        for (int i = 0; i < data.length; i++) {
            labels[i] = curr;
            curr = curr + step;
        }
    }

    public double[] getLabels() {
        return labels;
    }

    private void calculateOverallLevels() {
        if (data == null) {
            return;
        }
        double sumSq = 0;
        double max = Double.MIN_VALUE;
        double min = Double.MAX_VALUE;
        for (double sample : data) {
            sumSq = sumSq + sample * sample;
            if (sample > max) {
                max = sample;
            }
            if (sample < min) {
                min = sample;
            }
        }
        double rms = Math.sqrt(sumSq / data.length); // Calculate RMS
        addOveralls(rms, min, max);
    }

    protected abstract void addOveralls(double rms, double min, double max);

    public Map<OverallLevelType, Double> getOveralls() {
        return overalls;
    }

    /*
     * Get peak value
     * @param min - min value
     * @param max - max value
     * @return (Math.abs(max) > Math.abs(min)) ? Math.abs(max) : Math.abs(min)
     */
    protected double getPeakValue(double min, double max) {
        return (Math.abs(max) > Math.abs(min)) ? Math.abs(max) : Math.abs(min);
    }
    
    public void setData(double[] data) {
        this.data = data;
    }
}
