package com.inchecktech.dpm.notifications;

import java.util.Date;

public class EmailNotification extends Notification {


	private static final long serialVersionUID = 1L;

	private String fromName;
	private String toAddress;
	private String messageValue;
	private String oldSeverty;
	private String newSeverity;
	private String location;
	private String deliveryStatus;
	private Date notifyTimestamp;
	
	public String getFromName() {
		return fromName;
	}
	public void setFromName(String fromName) {
		this.fromName = fromName;
	}
	public String getToAddress() {
		return toAddress;
	}
	public void setToAddress(String toAddress) {
		this.toAddress = toAddress;
	}
	public String getMessageValue() {
		return messageValue;
	}
	public void setMessageValue(String messageValue) {
		this.messageValue = messageValue;
	}
	public String getOldSeverty() {
		return oldSeverty;
	}
	public void setOldSeverty(String oldSeverty) {
		this.oldSeverty = oldSeverty;
	}
	public String getNewSeverity() {
		return newSeverity;
	}
	public void setNewSeverity(String newSeverity) {
		this.newSeverity = newSeverity;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getDeliveryStatus() {
		return deliveryStatus;
	}
	public void setDeliveryStatus(String deliveryStatus) {
		this.deliveryStatus = deliveryStatus;
	}
	public Date getNotifyTimestamp() {
		return notifyTimestamp;
	}
	public void setNotifyTimestamp(Date notifyTimestamp) {
		this.notifyTimestamp = notifyTimestamp;
	}
	
	@Override
	public String toString() {

		StringBuilder sb = new StringBuilder("\nEmailNotification:");
		sb.append(super.toString());
		sb.append("\n\t").append("fromName=").append(fromName);
		sb.append("\n\t").append("toAddress=").append(toAddress);
		sb.append("\n\t").append("messageValue=").append(messageValue);
		sb.append("\n\t").append("oldSeverty=").append(oldSeverty);
		
		sb.append("\n\t").append("newSeverity=").append(newSeverity);
		sb.append("\n\t").append("location=").append(location);
		sb.append("\n\t").append("deliveryStatus=").append(deliveryStatus);
		sb.append("\n\t").append("notifyTimestamp=").append(notifyTimestamp);
		
		return sb.toString();
	}

}
