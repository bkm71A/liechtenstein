package com.inchecktech.dpm.notifications;

import java.io.Serializable;

public class Notification implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private int notifyId;
	private int channelId;
	private int eventId;
	private char notifyType;

	
	public int getNotifyId() {
		return notifyId;
	}
	public void setNotifyId(int notifyId) {
		this.notifyId = notifyId;
	}
	public int getChannelId() {
		return channelId;
	}
	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}
	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	public char getNotifyType() {
		return notifyType;
	}
	public void setNotifyType(char notifyType) {
		this.notifyType = notifyType;
	}

	
	@Override
	public String toString() {

		StringBuilder sb = new StringBuilder("\nNotification:");
		sb.append("\n\t").append("notifyId=").append(notifyId);
		sb.append("\n\t").append("channelId=").append(channelId);
		sb.append("\n\t").append("eventId=").append(eventId);
		sb.append("\n\t").append("notifyType=").append(notifyType);
		
		return sb.toString();
	}

	
	
}
