package com.incheck.ng.model.data;

import java.util.Date;

import com.incheck.ng.dsp.OverallLevelType;
import com.incheck.ng.dsp.library.EUnitConverter;
import com.incheck.ng.dsp.library.PhysicalDomain;

/**
 * Spectrum Data : Velocity By Frequency
 */
public class VelocityByFrequencyData extends ProcessedDynamicData {
    private String measurementType;
    public VelocityByFrequencyData(long channelId, double[] data, Date dateTimeStamp, int samplingRate) {
        super(channelId, data, dateTimeStamp, samplingRate);
        setMeasurementType(DataConstant.MEASUREMENT_TYPE_ABSOLUTE);
        setXEUnit(EUnitConverter.getDefaultUnit(PhysicalDomain.Frequency));
        setYEUnit(EUnitConverter.getDefaultUnit(PhysicalDomain.Velocity));
    }

    protected void addOveralls(double rms, double min, double max) {
        overalls.put(OverallLevelType.KEY_VEL_RMS, rms);
        overalls.put(OverallLevelType.KEY_VEL_PEAK, getPeakValue(min, max));
        overalls.put(OverallLevelType.KEY_VEL_PEAK_TO_PEAK, max - min);
    }
    
    public String getMeasurementType() {
        return measurementType;
    }

    public void setMeasurementType(String measurementType) {
        this.measurementType = measurementType;
    }
}
