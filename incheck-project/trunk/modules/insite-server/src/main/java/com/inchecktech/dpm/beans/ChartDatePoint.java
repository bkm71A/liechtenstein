package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.Date;

public class ChartDatePoint implements Serializable{

	private static final long serialVersionUID = 1L;
	public double y;
	public Date x;
	public ChartDatePoint(Date x,double y) {
		this.x=x;
		this.y=y;

	}
	
	
}
