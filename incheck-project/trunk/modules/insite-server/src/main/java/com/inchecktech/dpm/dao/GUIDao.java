package com.inchecktech.dpm.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

public class GUIDao implements Serializable {
	private static final long serialVersionUID = 6745837937009646553L;

	public class SensorInfo implements Serializable
	{
		private static final long serialVersionUID = 6132975026196794229L;
		private String sensorId;
		private String type;
		private String vendorId;
		
		public String getSensorId() {
			return sensorId;
		}
		public void setSensorId(String sensorId) {
			this.sensorId = sensorId;
		}
		public String getType() {
			return type;
		}
		public void setType(String type) {
			this.type = type;
		}
		public String getVendorId() {
			return vendorId;
		}
		public void setVendorId(String vendorId) {
			this.vendorId = vendorId;
		}
		
	}

	public class ChannelInfo implements Serializable
	{
		private static final long serialVersionUID = -855972942631650054L;
		private String channelId;
		private String type;
		private SensorInfo sensor;
		
		public String getChannelId() {
			return channelId;
		}
		public void setChannelId(String channelId) {
			this.channelId = channelId;
		}
		public SensorInfo getSensor() {
			return sensor;
		}
		public void setSensor(SensorInfo sensor) {
			this.sensor = sensor;
		}
		public String getType() {
			return type;
		}
		public void setType(String type) {
			this.type = type;
		}
		
	}

	public class DeviceInfo implements Serializable
	{
		private static final long serialVersionUID = -8691090501258867486L;
		private String deviceID;
		private String type;
		private String mac;
		private HashMap fastChannels; //Stores Channel Objects(key = channelId)
		private HashMap slowChannels;
		
		public String getDeviceID() {
			return deviceID;
		}
		public void setDeviceID(String deviceID) {
			this.deviceID = deviceID;
		}
		public String getMac() {
			return mac;
		}
		public void setMac(String mac) {
			this.mac = mac;
		}
		public HashMap getSlowChannels() {
			return slowChannels;
		}
		public void setSlowChannels(HashMap slowChannels) {
			this.slowChannels = slowChannels;
		}
		public String getType() {
			return type;
		}
		public void setType(String type) {
			this.type = type;
		}
		public void setFastChannels(HashMap fastChannels) {
			this.fastChannels = fastChannels;
		}
		
	}
		
	@SuppressWarnings("serial")
	public class SystemConfiguration implements Serializable
	{
		private HashMap device; //Stores DeviceInfo objects (key = deviceID)

			public HashMap getDevice() {
				return device;
			}

			public void setDevice(HashMap device) {
				this.device = device;
			}
	}

	public class DynamicSample implements Serializable
	{
		private static final long serialVersionUID = -4132426674476450798L;
		private String deviceID; // identifies the device
		private String channelId; // identifies the channel (as well as sensor)
		private int sampleStartTime;
		private int sampleLength;
		private int samplingRate;
		private String triggerType;
		private String unitType;
		private ArrayList value;
		
		public String getChannelId() {
			return channelId;
		}
		public void setChannelId(String channelId) {
			this.channelId = channelId;
		}
		public String getDeviceID() {
			return deviceID;
		}
		public void setDeviceID(String deviceID) {
			this.deviceID = deviceID;
		}
		public int getSampleLength() {
			return sampleLength;
		}
		public void setSampleLength(int sampleLength) {
			this.sampleLength = sampleLength;
		}
		public int getSampleStartTime() {
			return sampleStartTime;
		}
		public void setSampleStartTime(int sampleStartTime) {
			this.sampleStartTime = sampleStartTime;
		}
		public int getSamplingRate() {
			return samplingRate;
		}
		public void setSamplingRate(int samplingRate) {
			this.samplingRate = samplingRate;
		}
		public String getTriggerType() {
			return triggerType;
		}
		public void setTriggerType(String triggerType) {
			this.triggerType = triggerType;
		}
		public String getUnitType() {
			return unitType;
		}
		public void setUnitType(String unitType) {
			this.unitType = unitType;
		}
		public ArrayList getValue() {
			return value;
		}
		public void setValue(ArrayList value) {
			this.value = value;
		}
	}

	public class StaticSample implements Serializable
	{
		private static final long serialVersionUID = -9125971301804125575L;
		private String deviceID; // identifies the device
		private String channelId; // identifies the channel (as well as sensor)
		private int sampleStartTime;
		private int sampleLength;
		private String unitType;
		private ArrayList value;
		public String getChannelId() {
			return channelId;
		}
		public void setChannelId(String channelId) {
			this.channelId = channelId;
		}
		public String getDeviceID() {
			return deviceID;
		}
		public void setDeviceID(String deviceID) {
			this.deviceID = deviceID;
		}
		public int getSampleLength() {
			return sampleLength;
		}
		public void setSampleLength(int sampleLength) {
			this.sampleLength = sampleLength;
		}
		public int getSampleStartTime() {
			return sampleStartTime;
		}
		public void setSampleStartTime(int sampleStartTime) {
			this.sampleStartTime = sampleStartTime;
		}
		public String getUnitType() {
			return unitType;
		}
		public void setUnitType(String unitType) {
			this.unitType = unitType;
		}
		public ArrayList getValue() {
			return value;
		}
		public void setValue(ArrayList value) {
			this.value = value;
		}
	}
	
	public class Alarm implements Serializable
	{
		private static final long serialVersionUID = 2480968835706460744L;
		private String alarmDesc; 
		private String Severity; 
		private int sampleStartTime;
		private int sampleLength;
		
		public String getAlarmDesc() {
			return alarmDesc;
		}
		public void setAlarmDesc(String alarmDesc) {
			this.alarmDesc = alarmDesc;
		}
		public int getSampleLength() {
			return sampleLength;
		}
		public void setSampleLength(int sampleLength) {
			this.sampleLength = sampleLength;
		}
		public int getSampleStartTime() {
			return sampleStartTime;
		}
		public void setSampleStartTime(int sampleStartTime) {
			this.sampleStartTime = sampleStartTime;
		}
		public String getSeverity() {
			return Severity;
		}
		public void setSeverity(String severity) {
			Severity = severity;
		}
	}
	
	public class SysConfgRequest implements Serializable
	{
		private static final long serialVersionUID = -8810156594234361848L;
		private int requestType; //1 = All Channels; 2 = only channels indicated		
		private ArrayList channelsRequested;
		
		public ArrayList getChannelsRequested() {
			return channelsRequested;
		}
		public void setChannelsRequested(ArrayList channelsRequested) {
			this.channelsRequested = channelsRequested;
		}
		public int getRequestType() {
			return requestType;
		}
		public void setRequestType(int requestType) {
			this.requestType = requestType;
		}
	}


}
