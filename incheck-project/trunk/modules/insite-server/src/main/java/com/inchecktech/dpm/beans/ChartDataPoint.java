package com.inchecktech.dpm.beans;

import java.io.Serializable;



public class ChartDataPoint implements Serializable{

	private static final long serialVersionUID = 1L;
	public double y;
	public Double x;
	public Double sev1Upper;
	public Double sev1Lower;
	public Double sev2Upper;
	public Double sev2Lower;

	public int buffersize=0;
	public ChartDataPoint(Double x,double y,double th1,double th2,double th3,double th4) {
		this.x=x;
		this.y=y;
		this.sev1Upper=th1;
		this.sev1Lower=th2;
		this.sev2Upper=th3;
		this.sev2Lower=th4;
		

	}
	public int getBuffersize() {
		return buffersize;
	}
	public void setBuffersize(int buffersize) {
		this.buffersize = buffersize;
	}
	
	
	
	
}
