package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class Unit implements Serializable{
	
	private static final long serialVersionUID = 1L;
	public static final int UNIT_FPS=3;
	
	private int unitId;
	private String unitType;
	private String unit;
	private String description;
	
	public String getUnitType() {
		return unitType;
	}

	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Unit (int unitId){
		this.unitId=unitId;
	}

	public int getUnitId() {
		return unitId;
	}

	public void setUnitId(int unitId) {
		this.unitId = unitId;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nUnit:");
		sb.append("\n\t").append("unitId=").append(unitId);
		sb.append("\n\t").append("unitType=").append(unitType);
		sb.append("\n\t").append("unit=").append(unit).append("\n");
		sb.append("\n\t").append("description=").append(description).append("\n");
		return sb.toString();
	}

}
