package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class Status implements Serializable{
	
	private static final long serialVersionUID = 1L;
	public static final int STATUS_SUCCESS=0;
	public static final int STATUS_WARNING=1;
	public static final int STATUS_ERROR=2;

	private int status;
	private String message;
	private Object object;
	
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public Object getObject() {
		return object;
	}
	public void setObject(Object object) {
		this.object = object;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nStatus:");
		sb.append("\n\t").append("status=").append(status);
		sb.append("\n\t").append("message=").append(message);
		return sb.toString();
	}

}
