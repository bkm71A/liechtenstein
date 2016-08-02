package com.incheck.ng.model.data;

import java.util.Date;

import com.incheck.ng.dsp.library.EUnit;

public abstract class ProcessedData {
    protected final long channelId;
    protected double[] data;
    protected final int samplingRate;
    // engineering units for X and Y
    private EUnit xEUnit;
    private EUnit yEUnit;
    private String engineeringUnits;
    protected final Date dateTimeStamp;

    public ProcessedData(long channelId, double[] data, Date dateTimeStamp, int samplingRate) {
        this.channelId = channelId;
        this.data = data;
        this.dateTimeStamp = dateTimeStamp;
        this.samplingRate = samplingRate;
    }

    public long getChannelId() {
        return channelId;
    }

    public double[] getData() {
        return data;
    }

    public EUnit getXEUnit() {
        return xEUnit;
    }

    public void setXEUnit(EUnit unit) {
        xEUnit = unit;
    }

    public EUnit getYEUnit() {
        return yEUnit;
    }

    public void setYEUnit(EUnit unit) {
        yEUnit = unit;
    }

    public int getSamplingRate() {
        return samplingRate;
    }

    public String getEngineeringUnits() {
        return engineeringUnits;
    }

    public void setEngineeringUnits(String engineeringUnits) {
        this.engineeringUnits = engineeringUnits;
    }

    public Date getDateTimeStamp() {
        return dateTimeStamp;
    }
}
