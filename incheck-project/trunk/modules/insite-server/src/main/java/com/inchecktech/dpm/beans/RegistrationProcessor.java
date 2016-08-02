package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class RegistrationProcessor implements Serializable{

	private static final long serialVersionUID = 1L;
	public static final int STATUS_SUCCESS=0;
	public static final int STATUS_WARNING=1;
	public static final int STATUS_ERROR=2;
		
	private int status;
	private String message;
	
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

}
