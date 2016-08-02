package com.inchecktech.dpm.config;

import java.io.Serializable;

import com.inchecktech.dpm.beans.Unit;

public class ConfigItem implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	private int property_id;
	private String propertyName;
	private String propertyValue;
	private String description;
	private String defaultValue;
	private String dataType;
	private Unit unit;
	
	public int getProperty_id() {
		return property_id;
	}
	public void setProperty_id(int property_id) {
		this.property_id = property_id;
	}
	public String getPropertyName() {
		return propertyName;
	}
	public void setPropertyName(String propertyName) {
		this.propertyName = propertyName;
	}
	public String getPropertyValue() {
		return propertyValue;
	}
	public void setPropertyValue(String propertyValue) {
		this.propertyValue = propertyValue;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDefaultValue() {
		return defaultValue;
	}
	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}
	public String getDataType() {
		return dataType;
	}
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	public Unit getUnit() {
		return unit;
	}
	public void setUnit(Unit unit) {
		this.unit = unit;
	}
	
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nConfigItem:");
		sb.append("\n\t").append("property_id=").append(property_id);
		sb.append("\n\t").append("propertyName=").append(propertyName);
		sb.append("\n\t").append("propertyValue=").append(propertyValue);
		sb.append("\n\t").append("description=").append(description);
		sb.append("\n\t").append("defaultValue=").append(defaultValue).append("\n");
		sb.append("\n\t").append("dataType=").append(dataType).append("\n");
		sb.append("\n\t").append("unit=").append(unit).append("\n");
		return sb.toString();
	}

}
