package com.inchecktech.dpm.config;

import java.io.Serializable;

public class ConfigGroup implements Serializable{

	
	private static final long serialVersionUID = 1L;
	private int configGroupId;
	private String configGroupName;
	private String configGroupDescription;
	
	public int getConfigGroupId() {
		return configGroupId;
	}
	public void setConfigGroupId(int configGroupId) {
		this.configGroupId = configGroupId;
	}
	public String getConfigGroupName() {
		return configGroupName;
	}
	public void setConfigGroupName(String configGroupName) {
		this.configGroupName = configGroupName;
	}
	public String getConfigGroupDescription() {
		return configGroupDescription;
	}
	public void setConfigGroupDescription(String configGroupDescription) {
		this.configGroupDescription = configGroupDescription;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nConfigGroup:");
		sb.append("\n\t").append("configGroupId=").append(configGroupId);
		sb.append("\n\t").append("configGroupName=").append(configGroupName);
		sb.append("\n\t").append("configGroupDescription=").append(configGroupDescription).append("\n");
		return sb.toString();
	}
	
}
