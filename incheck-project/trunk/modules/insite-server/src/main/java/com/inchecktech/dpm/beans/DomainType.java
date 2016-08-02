package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class DomainType implements Serializable {

	private static final long serialVersionUID = 1L;
	public static final String DOMAIN_ACC="ACC";
	public static final String DOMAIN_VEL="VEL";
	public static final String DOMAIN_DIS="DIS";
	private String domainType;
	
	public DomainType(){
		
	}
	
	public DomainType(String domainType){
		this.domainType=domainType;
	}

	public String getDomainType() {
		return domainType;
	}

	public void setDomainType(String domainType) {
		this.domainType = domainType;
	}
}
