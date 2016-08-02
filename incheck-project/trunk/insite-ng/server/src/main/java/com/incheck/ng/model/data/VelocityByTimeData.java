package com.incheck.ng.model.data;

import java.util.Date;

import com.incheck.ng.dsp.OverallLevelType;
import com.incheck.ng.dsp.library.EUnitConverter;
import com.incheck.ng.dsp.library.PhysicalDomain;

/**
 * Velocity By Time
 */
public class VelocityByTimeData extends ProcessedDynamicData {

    public VelocityByTimeData(long channelId, double[] data, Date dateTimeStamp, int samplingRate) {
        super(channelId, data, dateTimeStamp, samplingRate);
        setXEUnit(EUnitConverter.getDefaultUnit(PhysicalDomain.Time));
        setYEUnit(EUnitConverter.getDefaultUnit(PhysicalDomain.Velocity));
    }

    protected void addOveralls(double rms, double min, double max) {
        overalls.put(OverallLevelType.KEY_VEL_RMS, rms);
        overalls.put(OverallLevelType.KEY_VEL_PEAK, getPeakValue(min, max));
        overalls.put(OverallLevelType.KEY_VEL_PEAK_TO_PEAK, max - min);
    }
}
