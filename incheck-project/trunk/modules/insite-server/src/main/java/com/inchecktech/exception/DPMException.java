//package com.inchecktech.exception;
//
//import java.io.Serializable;
//
//public class DPMException extends Exception implements Serializable {
//
//	private static final long serialVersionUID = -4362927392012235393L;
//	private int messageId;
//
//	public DPMException(String message, int messageId) {
//		super(message);
//		setMessageId(messageId);
//
//	}
//
//	public DPMException(String message, Throwable t) {
//		super(message, t);
//
//	}
//
//	public DPMException(String message, int messageId, Throwable t) {
//		super(message, t);
//		setMessageId(messageId);
//	}
//
//	public int getMessageId() {
//		return messageId;
//	}
//
//	private void setMessageId(int messageId) {
//		this.messageId = messageId;
//	}
//
//
//
//}
