package com.inchecktech.dpm.network.parser;

import com.inchecktech.dpm.network.parser.JsonFieldNameConstants.DAM_MESSAGE_TYPE;

public class IncomingData extends DamMessage {
    private int deviceChannelId;
    private int samplingRate;
    private int rpm;
    private String unit;
    private int samplingSize;
    private byte[] byteData;
    private double[] doubleData;

    public DAM_MESSAGE_TYPE getDamMessageType() {
        return DAM_MESSAGE_TYPE.DATA;
    }

    public int getDeviceChannelId() {
        return deviceChannelId;
    }

    public void setDeviceChannelId(int deviceChannelId) {
        this.deviceChannelId = deviceChannelId;
    }

    public int getSamplingRate() {
        return samplingRate;
    }

    public void setSamplingRate(int samplingRate) {
        this.samplingRate = samplingRate;
    }

    public int getRpm() {
        return rpm;
    }

    public void setRpm(int rpm) {
        this.rpm = rpm;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getSamplingSize() {
        return samplingSize;
    }

    public void setSamplingSize(int samplingSize) {
        this.samplingSize = samplingSize;
    }

    public byte[] getByteData() {
        return byteData;
    }

    public void setByteData(byte[] byteData) {
        this.byteData = byteData;
    }

    public double[] getDoubleData() {
        return doubleData;
    }

    public void setDoubleData(double[] doubleData) {
        this.doubleData = doubleData;
    }
}
