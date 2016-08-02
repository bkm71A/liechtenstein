package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class Band implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int bandId;
	private double bandCoefficient;
	private double startFreq;
	private double endFreq;
	private String bandName;
	private boolean active;
	
	public int getBandId() {
		return bandId;
	}
	public void setBandId(int bandId) {
		this.bandId = bandId;
	}
	public double getBandCoefficient() {
		return bandCoefficient;
	}
	public void setBandCoefficient(double bandCoefficient) {
		this.bandCoefficient = bandCoefficient;
	}
	public double getStartFreq() {
		return startFreq;
	}
	public void setStartFreq(double startFreq) {
		this.startFreq = startFreq;
	}
	public double getEndFreq() {
		return endFreq;
	}
	public void setEndFreq(double endFreq) {
		this.endFreq = endFreq;
	}
	public String getBandName() {
		return bandName;
	}
	public void setBandName(String bandName) {
		this.bandName = bandName;
	}
	public boolean isActive() {
		return active;
	}
	public void setActive(boolean active) {
		this.active = active;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nBand:");
		sb.append("\n\t").append("bandId=").append(bandId);
		sb.append("\n\t").append("bandCoefficient=").append(bandCoefficient);
		sb.append("\n\t").append("startFreq=").append(startFreq).append("\n");
		sb.append("\n\t").append("endFreq=").append(endFreq).append("\n");
		sb.append("\n\t").append("active=").append(active).append("\n");
		
		return sb.toString();
	}
}
