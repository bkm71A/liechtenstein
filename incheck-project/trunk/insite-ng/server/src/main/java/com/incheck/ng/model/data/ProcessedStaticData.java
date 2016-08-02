package com.incheck.ng.model.data;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.incheck.ng.dsp.library.EUnit;

public class ProcessedStaticData extends ProcessedData {

    private Map<String, Double> overalls = new HashMap<String, Double>();
    
    public ProcessedStaticData(long channelId, double[] data, Date dateTimeStamp, int samplingRate) {
        super(channelId, data, dateTimeStamp, samplingRate);
        setYEUnit(EUnit.TempC);
        setXEUnit(EUnit.TimeMiliSec);
//  TODO  setMeasurementUnit( ProcessedData.MEASUREMENT_UNIT_MS );
//        setMeasurementType( ProcessedData.MEASUREMENT_TYPE_ABSOLUTE );
    }

    public Map<String, Double> getOveralls() {
        return overalls;
    }

    public void addOverall(String name, Double overall) {
        overalls.put(name, overall);
    }
}
