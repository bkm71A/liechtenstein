package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.Date;

public class HistoryDataPoint implements Serializable {
    private static final long serialVersionUID = 1L;
    public float minValue;
    public float maxValue;
    public float avgValue;
    public Date x;
    public String overallType;
    public HistoryDataPoint(Date x, float minValue, float maxValue, float avgValue, String overallType) {
        this.x=x;
        this.minValue=minValue;
        this.maxValue=maxValue;
        this.avgValue=avgValue;
        this.overallType=overallType;
    }
}
