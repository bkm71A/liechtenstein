package com.incheck.ng.model.data;

import java.util.Date;
import java.util.Map;

import com.incheck.ng.dsp.OverallLevelType;
import com.incheck.ng.dsp.library.EUnitConverter;
import com.incheck.ng.dsp.library.PhysicalDomain;

/**
 * Wave Form Data : Acceleration By Time
 */
public class AccelerationByTimeData extends ProcessedDynamicData {
    private Map<Long, Double> accBandOveralls;
    private Map<Long, Double> velBandOveralls;
    
    public AccelerationByTimeData(long channelId, double[] data, Date dateTimeStamp, int samplingRate) {
        super(channelId, data, dateTimeStamp, samplingRate);
        setXEUnit(EUnitConverter.getDefaultUnit(PhysicalDomain.Time));
        setYEUnit(EUnitConverter.getDefaultUnit(PhysicalDomain.Acceleration));
    }

    protected void addOveralls(double rms, double min, double max) {
        overalls.put(OverallLevelType.KEY_ACCEL_RMS, rms);
        overalls.put(OverallLevelType.KEY_ACCEL_PEAK, getPeakValue(min, max));
        overalls.put(OverallLevelType.KEY_ACCEL_PEAK_TO_PEAK, max - min);
    }

    public Map<Long, Double> getAccBandOveralls() {
        return accBandOveralls;
    }

    public void setAccBandOveralls(Map<Long, Double> accBandOveralls) {
        this.accBandOveralls = accBandOveralls;
    }

    public Map<Long, Double> getVelBandOveralls() {
        return velBandOveralls;
    }

    public void setVelBandOveralls(Map<Long, Double> velBandOveralls) {
        this.velBandOveralls = velBandOveralls;
    }
}
