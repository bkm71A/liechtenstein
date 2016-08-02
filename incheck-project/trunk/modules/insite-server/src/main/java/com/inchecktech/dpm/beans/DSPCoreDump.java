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
import java.util.List;
import java.util.Vector;

/**
 * This class represents an extended state of a channel (sensor) at a given point of time.
 * 
 * The intend is to utilize this class for debugging DSP calculations.
 *
 * @author Taras Dobrovolsky
 *
 */
public class DSPCoreDump implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/**
	 * Default constructor that takes no arguments
	 */
	private DSPCoreDump() {
		super();
	}
	
	/**
	 * Public constructor to create an object for a specific channel
	 * @param channelId channelId to set
	 */
	public DSPCoreDump(int channelId) {
		this();
		this.channelId = channelId;
		dataSets = new Vector<List<Double>>(0);
		dataSetLabels = new Vector<String>(0);
		metaData = new Vector<String>(0);
	}
	
	private int  	channelId;
	private List<List<Double>> dataSets;
	private List<String> dataSetLabels;
	private List<String> metaData;
	private java.util.Date dateTimeStamp = new java.util.Date(System.currentTimeMillis());
	
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
	 * @return the channelId
	 */
	public int getChannelId() {
		return channelId;
	}

	/**
	 * @param channelId the channelId to set
	 */
	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}

	/**
	 * @return the dataSets Raw and processed data sets for debugging, calc evaluation
	 * integers are converted to doubles
	 */
	public List<List<Double>> getDataSets() {
		return dataSets;
	}

	/**
	 * @param dataSets the dataSets to set Raw and processed data sets for debugging, calc evaluation
	 * integers are converted to doubles
	 */
	public void setDataSets(List<List<Double>> dataSets) {
		this.dataSets = dataSets;
	}

	/**
	 * @return the dataSetLabels Data set labels containing description of data sets under
	 * the same index
	 */
	public List<String> getDataSetLabels() {
		return dataSetLabels;
	}

	/**
	 * @param dataSetLabels the dataSetLabels to set Data set labels containing description of data sets under
	 * the same index
	 */
	public void setDataSetLabels(Vector<String> dataSetLabels) {
		this.dataSetLabels = dataSetLabels;
	}

	/**
	 * @return the metaData Additional meta data useful for debugging purposes
	 */
	public List<String> getMetaData() {
		return metaData;
	}

	/**
	 * @param metaData the metaData to set Additional meta data useful for debugging purposes
	 */
	public void setMetaData(Vector<String> metaData) {
		this.metaData = metaData;
	}
	
	/**
	 * Utility method to clear 
	 */
	public void clear() {
		dataSets = new Vector<List<Double>>(0);
		dataSetLabels = new Vector<String>(0);
		metaData = new Vector<String>(0);
	}
	
	/**
	 * Add data set to the core dump useful for analysis/debugging
	 * @param data Data set to add to the DSP core dump for analysis
	 * @param label Data set label that explains the data
	 */
	public void addDataSet(List<Double> data, String label) {
		
		if (data == null) return;
		
		this.dataSets.add(data);
		this.dataSetLabels.add(label);
	}
	
	/**
	 * Add data set to the core dump useful for analysis/debugging
	 * Convert integers to doubles
	 * @param data Data set to add to the DSP core dump for analysis
	 * @param label Data set label that explains the data
	 */
	public void addDataSet(int[] data, String label) {
		
		if (data == null) return;
		
		Vector<Double> dt = new Vector<Double>();
		
		for (int i=0; i<data.length; i++) {
			dt.add(new Double(data[i]));
		}
		
		this.dataSets.add(dt);
		this.dataSetLabels.add(label);
	}
	
	/**
	 * Add data set to the core dump useful for analysis/debugging
	 * Convert integers to doubles
	 * @param data Data set to add to the DSP core dump for analysis
	 * @param label Data set label that explains the data
	 */
	public void addDataSet(boolean[] data, String label) {
		
		if (data == null) return;
		
		Vector<Double> dt = new Vector<Double>();
		
		for (int i=0; i<data.length; i++) {
			if (data[i])
				dt.add(new Double(1));
			else
				dt.add(new Double(0));
		}
		
		this.dataSets.add(dt);
		this.dataSetLabels.add(label);
	}
	
	/**
	 * Add meta data fact to the DSP core dump useful for analysis
	 * @param metaDataFact
	 */
	public void addMetaData(String metaDataFact) {
		if (metaDataFact == null) return;
		this.metaData.add(metaDataFact);
	}
	
	/**
	 * Utility method that returns then length of the biggest data set
	 * @return the length of the biggest data set
	 */
	public int getMaxDataSetLength() {
		if (dataSets == null) return 0;
		
		int max = 0;
		for (int i=0; i<dataSets.size(); i++) {
			if ( (dataSets.get(i) != null) && (dataSets.get(i).size() > max) )
				max = dataSets.get(i).size();
		}
		return max;
	}

}
