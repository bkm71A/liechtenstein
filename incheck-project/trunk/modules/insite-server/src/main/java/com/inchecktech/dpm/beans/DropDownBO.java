package com.inchecktech.dpm.beans;

public class DropDownBO {

	private String label;
	private int data;
	
	public DropDownBO(String label, int data) {
		super();
		this.label = label;
		this.data = data;
	}
	
	public DropDownBO() {
		
	}
	
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public int getData() {
		return data;
	}
	public void setData(int data) {
		this.data = data;
	}
	
	
}
