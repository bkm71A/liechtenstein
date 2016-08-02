package com.inchecktech.dpm.beans;

import java.io.Serializable;

import com.inchecktech.dpm.config.ChannelConfig;

public class Channel implements Serializable {

	private static final long serialVersionUID = 1L;
	private int channelId;
	private int sensorId;
	private int deviceId;
	private int channelType=0;
	private String measureType="N/A";
	private int deviceChannelId;
	private int sensorChannelId;
	private double scOffset;
	private double scGain;
	private String comments;
	private String description;
	private boolean enabled;
	ChannelConfig channelConfig;
	
	public int getChannelId() {
		return channelId;
	}
	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}
	public int getSensorId() {
		return sensorId;
	}
	public void setSensorId(int sensorId) {
		this.sensorId = sensorId;
	}
	public int getDeviceId() {
		return deviceId;
	}
	public void setDeviceId(int deviceId) {
		this.deviceId = deviceId;
	}
	public int getChannelType() {
		return channelType;
	}
	public void setChannelType(int channelType) {
		this.channelType = channelType;
	}
	public int getDeviceChannelId() {
		return deviceChannelId;
	}
	public void setDeviceChannelId(int deviceChannelId) {
		this.deviceChannelId = deviceChannelId;
	}
	public int getSensorChannelId() {
		return sensorChannelId;
	}
	public void setSensorChannelId(int sensorChannelId) {
		this.sensorChannelId = sensorChannelId;
	}
	public double getScOffset() {
		return scOffset;
	}
	public void setScOffset(double scOffset) {
		this.scOffset = scOffset;
	}
	public double getScGain() {
		return scGain;
	}
	public void setScGain(double scGain) {
		this.scGain = scGain;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public boolean isEnabled() {
		return enabled;
	}
	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	public ChannelConfig getChannelConfig() {
		return channelConfig;
	}
	public void setChannelConfig(ChannelConfig channelConfig) {
		this.channelConfig = channelConfig;
	}
	
	public String getMeasureType() {
		return measureType;
	}
	public void setMeasureType(String measureType) {
		this.measureType = measureType;
	}
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nChannel:");
		sb.append("\n\t").append("channelId=").append(channelId);
		sb.append("\n\t").append("sensorId=").append(sensorId);
		sb.append("\n\t").append("deviceId=").append(deviceId).append("\n");
		sb.append("\n\t").append("channelType=").append(channelType).append("\n");
		sb.append("\n\t").append("measureType=").append(measureType).append("\n");
		sb.append("\n\t").append("deviceChannelId=").append(deviceChannelId).append("\n");
		sb.append("\n\t").append("sensorChannelId=").append(sensorChannelId).append("\n");
		sb.append("\n\t").append("scOffset=").append(scOffset).append("\n");
		sb.append("\n\t").append("scGain=").append(scGain).append("\n");
		sb.append("\n\t").append("comments=").append(comments).append("\n");
		sb.append("\n\t").append("description=").append(description).append("\n");
		sb.append("\n\t").append("enabled=").append(enabled).append("\n");
		
		return sb.toString();
	}
}