package com.inchecktech.dpm.beans;

public enum DeviceOperation {
	
	CON("CON"),
	
	DISCON("DISCON");
	
	private String id;
	
    private DeviceOperation(String id){
		this.id = id;
	}

	public String getId() {
		return id;
	}
}