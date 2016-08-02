package com.inchecktech.dpm.network;

import java.nio.ByteBuffer;
import java.util.ArrayList;

public class DAMDataMessage {
	
	private int dpmChannelId;
	private int damChannelId;
	private int samplingRate;
	private int numOfSamples;
	private long timeStamp;
	private ByteBuffer data;
	private long timeOffset;
	private String controllerId;
	private long messageId;
	private boolean isLastMessage;
	private String dataType;
	private int bytesToRead;
	private  ArrayList<int[]> arrayofintarrays;
	
	public ArrayList<int[]> getArrayofintarrays() {
		return arrayofintarrays;
	}

	public void setArrayofintarrays(ArrayList<int[]> arrayofintarrays) {
		this.arrayofintarrays = arrayofintarrays;
	}

	public DAMDataMessage(String header) {
		String headerLines[]=header.split("\n");
		controllerId=headerLines[0].trim().split(" ")[1];
		messageId=Long.parseLong(headerLines[1].trim().split(":")[1]);
		samplingRate=Integer.parseInt(headerLines[2].trim().split(":")[1]);
		numOfSamples=Integer.parseInt(headerLines[3].trim().split(":")[1]);
		damChannelId=Integer.parseInt(headerLines[4].trim().split(":")[1]);
		dataType=headerLines[5].trim().split(":")[1];
		bytesToRead=Integer.parseInt(headerLines[6].trim().split(":")[1]);
		isLastMessage=Boolean.parseBoolean(headerLines[7].trim().split(":")[1]);
		timeStamp=Long.parseLong(headerLines[8].trim().split(":")[1]);
		timeOffset=Long.parseLong(headerLines[9].trim().split(":")[1]);
		
	}

	public int getDpmChannelId() {
		return dpmChannelId;
	}

	public void setDpmChannelId(int dpmChannelId) {
		this.dpmChannelId = dpmChannelId;
	}

	public int getDamChannelId() {
		return damChannelId;
	}

	public void setDamChannelId(int damChannelId) {
		this.damChannelId = damChannelId;
	}

	public int getSamplingRate() {
		return samplingRate;
	}

	public void setSamplingRate(int samplingRate) {
		this.samplingRate = samplingRate;
	}

	public int getNumOfSamples() {
		return numOfSamples;
	}

	public void setNumOfSamples(int numOfSamples) {
		this.numOfSamples = numOfSamples;
	}

	public long getTimeStamp() {
		return timeStamp;
	}

	public void setTimeStamp(long timeStamp) {
		this.timeStamp = timeStamp;
	}

	public ByteBuffer getData() {
		return data;
	}

	public void setData(ByteBuffer data) {
		this.data = data;
	}

	public long getTimeOffset() {
		return timeOffset;
	}

	public void setTimeOffset(long timeOffset) {
		this.timeOffset = timeOffset;
	}

	public String getControllerId() {
		return controllerId;
	}

	public void setControllerId(String controllerId) {
		this.controllerId = controllerId;
	}

	public long getMessageId() {
		return messageId;
	}

	public void setMessageId(long messageId) {
		this.messageId = messageId;
	}

	public boolean isLastMessage() {
		return isLastMessage;
	}

	public void setLastMessage(boolean isLastMessage) {
		this.isLastMessage = isLastMessage;
	}

	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public int getBytesToRead() {
		return bytesToRead;
	}

	public void setBytesToRead(int bytesToRead) {
		this.bytesToRead = bytesToRead;
	}
	
	
	

}
