package com.inchecktech.dpm.config;

import java.io.Serializable;

public class ConfigType implements Serializable {

	private static final long serialVersionUID = 1L;
	private int configTypeId;
	private String configTypeName;
	private String configTypeDescription;
	
	public int getConfigTypeId() {
		return configTypeId;
	}
	public void setConfigTypeId(int configTypeId) {
		this.configTypeId = configTypeId;
	}
	public String getConfigTypeName() {
		return configTypeName;
	}
	public void setConfigTypeName(String configTypeName) {
		this.configTypeName = configTypeName;
	}
	public String getConfigTypeDescription() {
		return configTypeDescription;
	}
	public void setConfigTypeDescription(String configTypeDescription) {
		this.configTypeDescription = configTypeDescription;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nConfigType:");
		sb.append("\n\t").append("configTypeId=").append(configTypeId);
		sb.append("\n\t").append("configTypeName=").append(configTypeName);
		sb.append("\n\t").append("configTypeDescription=").append(configTypeDescription).append("\n");
		return sb.toString();
	}
}
