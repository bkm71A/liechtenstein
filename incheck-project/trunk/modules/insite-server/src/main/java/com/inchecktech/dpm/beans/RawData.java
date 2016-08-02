/**
 * Copyright 2007, Incheck, Inc.
 * All Rights Reserved
 *
 * This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended
 * publication of such source code. 
 * 
 */
package com.inchecktech.dpm.beans;

import java.io.Serializable;

/**
 * This object represents a unprocessed/raw data set of data bins (points) read from DAM.  
 * Data bins should not be converted to Voltage - DSPCalculator will perform the conversion.
 * 
 * TODO: Add more data fields and meta data as needed
 * 
 * @author Taras Dobrovolsky
 * 
 * Change History:
 * 11/03/2007	Taras Dobrovolsky	Changed get/set methods for dataTicks to be public
 */
public class RawData implements Serializable {
	
	 static final long serialVersionUID = 7237103996368254793L;
	
	/**
	 * Default constructor that takes no parameters.  
	 */
	private RawData() {
		super();
	}
	
	public RawData(int channelId) {
		this();
		this.channelId = channelId;
	}
	
	// TODO: Add more meta data so the client will have enough info to plot
	// different types of graph with proper labels and scales. 
	// Leave it simple for the prototype.
	
	// PRIVATE PROPERTIES
	// meta-data
	private int  	channelId;
	private int		samplingRate;
	
	// data and ticks
	private int[] data;
	private boolean[] dataTicks;
	
	private java.util.Date dateTimeStamp = new java.util.Date(System.currentTimeMillis());

	/**
	 * Get unique identifier of a channel.
	 * @return the channelId
	 */
	public int getChannelId() {
		return channelId;
	}

	/**
	 * Set unique identifier of a channel.
	 * @param channelId the channelId to set
	 */
	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}

	/**
	 * Get sampling rate read from controller
	 * @return the samplingRate
	 */
	public int getSamplingRate() {
		return samplingRate;
	}

	/**
	 * Set sampling rate read from controller
	 * @param samplingRate the samplingRate to set
	 */
	public void setSamplingRate(int samplingRate) {
		this.samplingRate = samplingRate;
	}

	/**
	 * Get the data points for calculations.  Assume that they are equally spaced.
	 * TODO: confirm the assumption with Yuri.
	 * @return the data
	 */
	public int[] getData() {
		return data;
	}

	/**
	 * Set the data points.  Assume that they are equally spaced.
	 * @param data the data to set
	 */
	public void setData(int[] data) {
		this.data = data;
	}

	/**
	 * Get data ticks (tachometer ticks)
	 * @return the dataTicks
	 */
	public boolean[] getDataTicks() {
		return dataTicks;
	}

	/**
	 * Set data ticks (tachometer ticks)
	 * @param dataTicks the dataTicks to set
	 */
	public void setDataTicks(boolean[] dataTicks) {
		this.dataTicks = dataTicks;
	}
	
	/**
	 * @return the dateTimeStamp
	 */
	public java.util.Date getDateTimeStamp() {
		return dateTimeStamp;
	}

	/**
	 * @param dateTimeStamp the dateTimeStamp to set
	 */
	public void setDateTimeStamp(java.util.Date dateTimeStamp) {
		this.dateTimeStamp = dateTimeStamp;
	}
	
	/**
	 * @return the dateTimeStamp in milliseconds since 1970
	 */
	public long getDateTimeStampMillis() {
		if (dateTimeStamp == null) return 0;
		else return dateTimeStamp.getTime();
	}

	/**
	 * @param dateTimeStamp the dateTimeStamp to set in milliseconds since 1970
	 */
	public void setDateTimeStampMillis(long millis) {
		this.dateTimeStamp = new java.util.Date(millis);
	}

}
