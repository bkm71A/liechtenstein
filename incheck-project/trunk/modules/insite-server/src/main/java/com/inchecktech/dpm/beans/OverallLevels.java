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
import java.util.HashMap;
import java.util.Vector;

/**
 * An object representing calculated overall channel levels for different engineering units.
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 11/06/2007	Taras Dobrovolsky	Modified the bean to hold overall in a hash table
 * 01/23/2008 	Taras Dobrovolsky	Added date-time stamp to the object
 */
public class OverallLevels implements Serializable {
	
	static final long serialVersionUID = -7928825774396293721L;
	
	// public static constants
	public final static String KEY_ACCEL_RMS = "Accel_Rms";
	public final static String KEY_ACCEL_PEAK = "Accel Peak";
	public final static String KEY_DERIVED_PEAK = "Derived Peak";
	public final static String KEY_DERIVED_PEAK_TO_PEAK = "Derived Peak To Peak";
	public final static String KEY_ACCEL_PEAK_TO_PEAK = "Accel Peak To Peak";
	public final static String KEY_VEL_RMS = "Vel_Rms";
	public final static String KEY_VEL_PEAK = "Vel Peak";
	public final static String KEY_VEL_PEAK_TO_PEAK = "Vel Peak To Peak";

	/**
	 * Default constructor that takes no arguments
	 */
	private OverallLevels() {
		super();
	}
	
	/**
	 * Constructor that takes all object properties as parameters. 
	 */
	public OverallLevels(int channelId) {
		this();
		this.channelId = channelId;
		
		overalls = new HashMap<String, Double>();		
	}
	
	/**
	 * Utility method to clear the content of all objects
	 */
	public void clear() {
		overalls.clear();
		
	}

	// PRIVATE PROPERTIES
	private int    channelId;
	public HashMap<String,Double> overalls;  	// hash-map of calculated overall values
	private java.util.Date dateTimeStamp = new java.util.Date(System.currentTimeMillis());
	
	/**
	 * Get unique identifier of a channel that overall values were calculated for.
	 * @return the channelId
	 */
	public int getChannelId() {
		return channelId;
	}

	/**
	 * Set unique identifier of a channel that overall values were calculated for.
	 * @param channelId the channelId to set
	 */
	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}
	
	/**
	 * Lookup overall value for a given key.  Will return null if the value has not been found.  Use
	 * getKeys() method to get the list of all keys.
	 * @param key - RMS, P2P etc.  Use getKeys() method to obtain all keys for calculated overalls
	 * @return
	 */
	public Double getOverall(String key) {
		return overalls.get(key);
	}
	
	public void setOverall(String key, Double value) {
		overalls.put(key, value);
	}
	
	public void addOverall(String key, Double value) {
		overalls.put(key, value);
	}
	
	public Vector<String> getKeys() {
		return new Vector<String>(overalls.keySet());
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
	
	private static final String delim = ";";
	@Override
	public String toString() {
		
		StringBuilder str = new StringBuilder("OverallLevels:");
		str.append("channelId=").append(channelId).append(delim)
		.append("overalls size =" + overalls.size()).append(delim)
		.append("date=").append(dateTimeStamp).append(delim);
		return str.toString();
	}
	
}
