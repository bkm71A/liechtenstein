package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.Date;
import java.util.Map;

public class UserSession implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private String sessionId;
	//private int userid;
	private String userName;
	private Date createDate;
	private Date modifiedDate;	
	private Map<String, Object> attributes;
	private String delim = ";";
	
	@Override
	public String toString() {
		StringBuilder str = new StringBuilder("USERSESSION:");
		str.append("sessionid=")
		.append(sessionId)
		.append(delim)
		//.append("userid=")
		//.append(userid)
		//.append(delim)
		.append("userName=")
		.append(userName)
		.append(delim)
		.append("createDate=")
		.append(createDate)
		.append(delim)
		.append("modifyDate=")
		.append(modifiedDate)
		.append(delim)
		.append("attributes=")
		.append(attributes);
		
		return str.toString();
		
	}
	
	public UserSession(String sessionID){
		this.sessionId=sessionID;
	}
	
	public UserSession(String userName, String sessionID){
		this.sessionId = sessionID;
		this.userName = userName;
	}
	
	public UserSession(String userName, String sessionID, Date createDate){
		this.sessionId = sessionID;
		this.userName = userName;
		this.createDate = createDate;
	}

	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Date getModifiedDate() {
		return modifiedDate;
	}
	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}
	public Map<String, Object> getAttributes() {
		return attributes;
	}
	public void setAttributes(Map<String, Object> attributes) {
		this.attributes = attributes;
	}

//	public int getUserid() {
//		return userid;
//	}
//
//	public void setUserid(int userid) {
//		this.userid = userid;
//	}

	public String getSessionId() {
		return sessionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	
}
