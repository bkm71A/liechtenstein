package com.incheck.ng.model.data;

import static com.incheck.ng.model.ChannelConfigConstant.RECENT_TREND_BUFFER_SIZE;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.incheck.ng.dsp.OverallLevelType;
import com.incheck.ng.model.DataType;

/**
 * This class represents a state of a channel at a given point of time. The
 * intend is to consolidate static, raw and processed dynamic data, alerts,
 * overall levels etc. in a single object passed from DPM to a client.
 * 
 * @author Taras Dobrovolsky
 */
public class ChannelState implements Serializable {
    private static final long serialVersionUID = -1478196208628918422L;
    private final long channelId;
    private final Date timeStamp;
    private final double rpm;
    private final boolean[] dataTicks;
    private Map<String, ProcessedData> processedData = new HashMap<String, ProcessedData>();
    private Map<DataType,List<Double>> overallsRecentTrend = new HashMap<DataType,List<Double>>();
    private Map<DataType,List<Double>> overallsRecentTrendLbl = new HashMap<DataType,List<Double>>();    
    private List<String> methodKeys = new ArrayList<String>();
    private String overallKey = DataConstant.KEY_OVRL_SUBTYPE_RMS;

    public ChannelState(long channelId, Date timeStamp, double rpm, boolean[] dataTicks) {
        this.channelId = channelId;
        this.timeStamp = timeStamp;
        this.rpm = rpm;
        this.dataTicks = dataTicks;
        overallsRecentTrend.put(DataType.ACCELERATION_BY_TIME, new LinkedList<Double>());
        overallsRecentTrend.put(DataType.ACCELERATION_BY_FREQUENCY, new LinkedList<Double>());
        overallsRecentTrend.put(DataType.VELOCITY_BY_TIME, new LinkedList<Double>());
        overallsRecentTrend.put(DataType.VELOCITY_BY_FREQUENCY, new LinkedList<Double>());
    }

    public long getChannelId() {
        return channelId;
    }

    public Date getTimeStamp() {
        return timeStamp;
    }

    public double getRpm() {
        return rpm;
    }

    public boolean[] getDataTicks() {
        return dataTicks;
    }

    public Map<String, ProcessedData> getProcessedData() {
        return processedData;
    }

    public String getOverallKey() {
        return overallKey;
    }

    public void setOverallKey(String overallKey) {
        this.overallKey = overallKey;
    }
    
    public void addRecentOverallsTrend(
            ProcessedDynamicData processedData, double timeLabel,Map<String, String> channelConfig ) {
        DataType dataType = null;
        OverallLevelType overallType = null;
        String key = null;
        if (processedData instanceof AccelerationByTimeData) {
            dataType = DataType.ACCELERATION_BY_TIME;
            overallType = OverallLevelType.KEY_ACCEL_RMS;
            key = DataConstant.KEY_OVRL_TREND_ACC_RMS;
        }
        if (processedData instanceof VelocityByTimeData) {
            dataType = DataType.VELOCITY_BY_TIME;
            overallType = OverallLevelType.KEY_VEL_RMS;
            key = DataConstant.KEY_OVRL_TREND_VEL_RMS;
        }
        if (processedData instanceof AccelerationByFrequencyData) {
            dataType = DataType.ACCELERATION_BY_FREQUENCY;
            overallType = OverallLevelType.KEY_ACCEL_PEAK;
            key = DataConstant.KEY_OVRL_TREND_ACC_PEAK;
        }
        if (processedData instanceof VelocityByFrequencyData) {
            dataType = DataType.VELOCITY_BY_FREQUENCY;
            overallType = OverallLevelType.KEY_VEL_PEAK;
            key = DataConstant.KEY_OVRL_TREND_VEL_PEAK;
        }
        int recentTrendBufferSize = Integer.parseInt(channelConfig.get(RECENT_TREND_BUFFER_SIZE));
//        String primaryEU = channelConfig.get(PRIMARY_CHANNEL_ENGINEERING_UNITS);
        List<Double> recentTrend = overallsRecentTrend.get(dataType);
        List<Double> recentTrendLbl = overallsRecentTrendLbl.get(dataType);
        // add calculated value to the recent trend queue
        recentTrend.add(new Double(processedData.getOveralls().get(overallType)));
        // add a label calculated value to the recent trend queue
        recentTrendLbl.add(new Double(timeLabel));
        List<Double> labels = new Vector<Double>();
        LinkedList<Double> newTrend = new LinkedList<Double>();
        LinkedList<Double> newTrendLbl = new LinkedList<Double>();
        // remove elements older than specified buffer limit in seconds
        for (int i = 0; i < recentTrendLbl.size(); i++) {
            if (recentTrendLbl.get(i) > (timeLabel - recentTrendBufferSize * 1000)) {
                newTrend.add(recentTrend.get(i));
                newTrendLbl.add(recentTrendLbl.get(i));
            }
        }
        double[] data = new double[newTrend.size()];
        for (int j = 0; j < data.length; j++) {
            data[j] = (double) (newTrend.get(newTrend.size() - j - 1));
        }
        for (int j = 0; j < newTrendLbl.size(); j++) {
            labels.add(new Double(newTrendLbl.get(newTrendLbl.size() - j - 1)));
        }
        recentTrend = newTrend;
        recentTrendLbl = newTrendLbl;
        ProcessedStaticData staticData = new ProcessedStaticData(channelId, data, timeStamp, 1);
// TODO      staticData.setEU( primaryEU );
// TODO       staticData.setDataLabels( labels );
// TODO        staticData.setOveralls( overalls );
// TODO       staticData.setMeasurementUnit( DataConstant.MEASUREMENT_UNIT_MS );
// TODO       staticData.setMeasurementType( DataConstant.MEASUREMENT_TYPE_ABSOLUTE );
        addProcessedData(key, staticData);
    }
    
    /**
     * Add a processed dynamic data with the specified key
     * @param method key (i.e. calculation method description)
     * @param dynData processed data object
     */
    public void addProcessedData( String method, ProcessedData data ) {
        processedData.put( method, data );
        addMethodKey( method );
    }
    
    /**
     * Add a calculation method key to keys
     * @param method
     */
    private void addMethodKey( String method ) {
        methodKeys.add( method );
    }
}
