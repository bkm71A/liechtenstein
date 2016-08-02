package com.incheck.ng.model.data;

import java.io.Serializable;
import java.util.Date;

public class RawData implements Serializable {
    private static final long serialVersionUID = 4284291331827671506L;
    private final Date dateTimeStamp = new Date();
    private long channelId;
    private int samplingRate;
    private int[] data;
    private boolean[] dataTicks;

    public boolean[] getDataTicks() {
        return dataTicks;
    }

    public void setDataTicks(boolean[] dataTicks) {
        this.dataTicks = dataTicks;
    }

    public RawData(long channelId, int samplingRate, int[] data) {
        this.channelId = channelId;
        this.samplingRate = samplingRate;
        this.data = data;
    }

    public long getChannelId() {
        return channelId;
    }

    public void setChannelId(long channelId) {
        this.channelId = channelId;
    }

    public int getSamplingRate() {
        return samplingRate;
    }

    public void setSamplingRate(int samplingRate) {
        this.samplingRate = samplingRate;
    }

    public int[] getData() {
        return data;
    }

    public void setData(int[] data) {
        this.data = data;
    }

    public Date getDateTimeStamp() {
        return dateTimeStamp;
    }
}
