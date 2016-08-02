package com.inchecktech.dpm.network.parser;

import com.inchecktech.dpm.network.parser.JsonFieldNameConstants.DAM_MESSAGE_TYPE;

public abstract class DamMessage {
    private int protocolVersion;
    private String deviceId;
    private long timeStamp;

    public int getProtocolVersion() {
        return protocolVersion;
    }

    public void setProtocolVersion(int protocolVersion) {
        this.protocolVersion = protocolVersion;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public long getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(long timeStamp) {
        this.timeStamp = timeStamp;
    }

    public abstract DAM_MESSAGE_TYPE getDamMessageType();
}
