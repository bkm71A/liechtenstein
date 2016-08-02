package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class DeliveryPath implements Serializable{

	private static final long serialVersionUID = 1L;
	public static final int DEFAULT_RETRY_INTERVAL = 1;
	public static final int DEFAULT_RETRY_ATTEMPTS = 1;
	
	private int deliveryId;
	private int deliveryGroupId;
	private int retryInterval;
	private int retryAttempts;
	private int escalationDeliveryId;
	
	private String deliveryType;
	private String deliveryName;
	private String deliveryAddress;
	private String deliveryNotes;
	
	@Override
	public String toString() {

		StringBuilder sb = new StringBuilder("\nDeliveryPath:");
		sb.append("\n\t").append("deliveryId=").append(deliveryId);
		sb.append("\n\t").append("deliveryGroupId=").append(deliveryGroupId);
		sb.append("\n\t").append("retryInterval=").append(retryInterval);
		sb.append("\n\t").append("retryAttempts=").append(retryAttempts);
		sb.append("\n\t").append("retryAttempts=").append(escalationDeliveryId);
		sb.append("\n\t").append("deliveryName=").append(deliveryName);
		sb.append("\n\t").append("deliveryAddress=").append(deliveryAddress);
		sb.append("\n\t").append("deliveryType=").append(deliveryType);
		sb.append("\n\t").append("deliveryNotes=").append(deliveryNotes);
		
		
		return sb.toString();
	}
	
	public int getDeliveryId() {
		return deliveryId;
	}
	public void setDeliveryId(int deliveryId) {
		this.deliveryId = deliveryId;
	}
	public int getDeliveryGroupId() {
		return deliveryGroupId;
	}
	public void setDeliveryGroupId(int deliveryGroupId) {
		this.deliveryGroupId = deliveryGroupId;
	}
	public int getRetryInterval() {
		return retryInterval;
	}
	public void setRetryInterval(int retryInterval) {
		this.retryInterval = retryInterval;
	}
	public int getRetryAttempts() {
		return retryAttempts;
	}
	public void setRetryAttempts(int retryAttempts) {
		this.retryAttempts = retryAttempts;
	}
	public int getEscalationDeliveryId() {
		return escalationDeliveryId;
	}
	public void setEscalationDeliveryId(int escalationDeliveryId) {
		this.escalationDeliveryId = escalationDeliveryId;
	}
	public String getDeliveryName() {
		return deliveryName;
	}
	public void setDeliveryName(String deliveryName) {
		this.deliveryName = deliveryName;
	}
	public String getDeliveryAddress() {
		return deliveryAddress;
	}
	public void setDeliveryAddress(String deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}
	public String getDeliveryNotes() {
		return deliveryNotes;
	}
	public void setDeliveryNotes(String deliveryNotes) {
		this.deliveryNotes = deliveryNotes;
	}

	public String getDeliveryType() {
		return deliveryType;
	}

	public void setDeliveryType(String deliveryType) {
		this.deliveryType = deliveryType;
	}
	


}
