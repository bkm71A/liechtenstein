/**
 * Copyright 2007, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.beans;

import java.io.Serializable;

import java.util.Vector;
import java.util.HashMap;

/**
 * This class represents a state of a channel (sensor) at a given point of time. The intend is to consolidate static,
 * raw and processed dynamic data, alerts, overall levels etc. in a single object passed from DPM to a client.
 * @author Taras Dobrovolsky
 */
public class ChannelState implements Serializable {

    static final long       serialVersionUID     = -5127618251972248965L;
    public static final int CHANNEL_TYPE_DYNAMIC = 1;
    public static final int CHANNEL_TYPE_STATIC  = 2;

    /**
     * Default constructor that takes no arguments
     */
    private ChannelState( ) {
        super();
    }

    /**
     * Constructor that takes channelId as a parameter
     * @param channelId channelId to set
     * @param channelType channelType, 1 - dynamic channel, 2 - static channel
     */
    public ChannelState( int channelId, int channelType ) {
        this();
        this.channelId = channelId;
        this.channelType = channelType;
        methodKeys = new Vector<String>();
        processedData = new HashMap<String, ProcessedData>();

    }

    @Override
    public String toString( ) {

        StringBuilder sb = new StringBuilder();

        sb.append( "ChannelState:" ).append( "\n" ).append( "channelId:" + channelId ).append( "\n" )
          .append( "channelType:" + channelType ).append( "\n" ).append( "methodKeys:" + methodKeys ).append( "\n" )
          .append( "dataTicks:" + dataTicks ).append( "\n" ).append( "rpm:" + rpm ).append( "\n" )
          .append( "processedData:" + processedData );

        return sb.toString();
    }

    private int                            channelId;
    private int                            channelType;
    private Double                         rpm;
    private boolean[]                      dataTicks;

    // private data fields
    private Vector<String>                 methodKeys;
    private HashMap<String, ProcessedData> processedData;
    private java.util.Date                 dateTimeStamp = new java.util.Date( System.currentTimeMillis() );

    private String                         overallTrendKey = ProcessedData.KEY_OVRL_TREND_ACC_RMS;
    
    private String                         overallKey      = ProcessedData.KEY_OVRL_SUBTYPE_RMS;

    /* Sign of using channel state */
    private boolean 						inUse;
    
    /**
	 * @return the inUse
	 */
	public boolean isInUse() {
		return inUse;
	}

	/**
	 * @param inUse the inUse to set
	 */
	public void setInUse(boolean inUse) {
		this.inUse = inUse;
	}

	/**
     * @return the methodKeys
     */
    public Vector<String> getMethodKeys( ) {
        return methodKeys;
    }

    /**
     * @param methodKeys the methodKeys to set
     */
    public void setMethodKeys( Vector<String> methodKeys ) {
        this.methodKeys = methodKeys;
    }

    /**
     * Gets a processed data object for the specified key
     * @return the processedData
     */
    public ProcessedData getProcessedData( String key ) {
        return processedData.get( key );
    }

    /**
     * Gets a hash-map of all available ProcessedData objects
     * @return the processedData - hash-map of all available ProcessedData objects
     */
    public HashMap<String, ProcessedData> getProcessedData( ) {
        return processedData;
    }

    /**
     * @return the channelId
     */
    public int getChannelId( ) {
        return channelId;
    }

    /**
     * @param channelId the channelId to set
     */
    public void setChannelId( int channelId ) {
        this.channelId = channelId;
    }

    /**
     * Add a calculation method key to keys
     * @param method
     */
    private void addMethodKey( String method ) {
        if( methodKeys == null ) {
            methodKeys = new Vector<String>();
        }
        methodKeys.add( method );
    }

    /**
     * Add a processed dynamic data with the specified key
     * @param method key (i.e. calculation method description)
     * @param dynData processed data object
     */
    public void addProcessedData( String method, ProcessedData dynData ) {
        if( processedData == null ) {
            processedData = new HashMap<String, ProcessedData>();
        }
        processedData.put( method, dynData );
        addMethodKey( method );
    }

    /**
     * Utility method to clear the content of all objects
     */
    public void clear( ) {
        this.channelId = 0;
        methodKeys.clear();
        processedData.clear();
    }

    /**
     * @return the channelType, 1 - dynamic channel, 2 - static channel
     */
    public int getChannelType( ) {
        return channelType;
    }

    /**
     * @param channelType the channelType to set, 1 - dynamic channel, 2 - static channel
     */
    public void setChannelType( int channelType ) {
        this.channelType = channelType;
    }

    /**
     * @return the rpm
     */
    public Double getRpm( ) {
        return rpm;
    }

    /**
     * @param rpm the rpm to set
     */
    public void setRpm( Double rpm ) {
        this.rpm = rpm;
    }

    /**
     * @return the dataTicks - Tachometer ticks if available
     */
    public boolean[] getDataTicks( ) {
        return dataTicks;
    }

    /**
     * @param dataTicks the dataTicks to set - Tachometer ticks if available
     */
    public void setDataTicks( boolean[] dataTicks ) {
        this.dataTicks = dataTicks;
    }

    /**
     * Gets a processed data in Primary Engineering Units (persistence layer, and alarm engine usage)
     * @return the processedData
     */
    public ProcessedData getPrimaryProcessedData() {
        if (processedData.containsKey(ProcessedData.KEY_TIMEWAVE_ACC)) {
            return processedData.get(ProcessedData.KEY_TIMEWAVE_ACC);
        }
        if (processedData.containsKey(ProcessedData.KEY_SPECTRUM_ACC_PEAK)) {// this seems to be missing, I need this
                                                                             // one for the bands
            return processedData.get(ProcessedData.KEY_SPECTRUM_ACC_PEAK);
        }
        if (processedData.containsKey(ProcessedData.KEY_TREND)) {
            return processedData.get(ProcessedData.KEY_TREND);
        }
        if (processedData.containsKey(ProcessedData.KEY_TIMEWAVE_VEL)) {// this seems to be missing, added for symmetry
            return processedData.get(ProcessedData.KEY_TIMEWAVE_VEL);
        }
        if (processedData.containsKey(ProcessedData.KEY_SPECTRUM_VEL_PEAK)) {
            return processedData.get(ProcessedData.KEY_SPECTRUM_VEL_PEAK);
        }
        if (this.processedData.containsKey(ProcessedData.KEY_OVRL_TREND_ACC_RMS)) {
            return processedData.get(ProcessedData.KEY_OVRL_TREND_ACC_RMS);
        }
        if (this.processedData.containsKey(ProcessedData.KEY_OVRL_TREND_ACC_PEAK)) {
            return processedData.get(ProcessedData.KEY_OVRL_TREND_ACC_PEAK);
        }
        if (this.processedData.containsKey(ProcessedData.KEY_OVRL_TREND_VEL_RMS)) {
            return processedData.get(ProcessedData.KEY_OVRL_TREND_VEL_RMS);
        }
        if (this.processedData.containsKey(ProcessedData.KEY_OVRL_TREND_VEL_PEAK)) {
            return processedData.get(ProcessedData.KEY_OVRL_TREND_VEL_PEAK);
        }
        return null;
    }

    /**
     * Gets primary overall trend data
     * @return the processedData object containing primary overall trend
     */

    public ProcessedData getOverallTrendData(String overallKey) {
        if( processedData.containsKey( overallKey ) ) {
            return processedData.get( overallKey );
        }
        else
            return null;
    }

    /**
     * @return the dateTimeStamp
     */
    public java.util.Date getDateTimeStamp( ) {
        return dateTimeStamp;
    }

    /**
     * @param dateTimeStamp the dateTimeStamp to set
     */
    public void setDateTimeStamp( java.util.Date dateTimeStamp ) {
        this.dateTimeStamp = dateTimeStamp;
    }

    /**
     * @return the dateTimeStamp in milliseconds since 1970
     */
    public long getDateTimeStampMillis( ) {
        if( dateTimeStamp == null )
            return 0;
        else
            return dateTimeStamp.getTime();
    }

    /**
     * @param dateTimeStamp the dateTimeStamp to set in milliseconds since 1970
     */
    public void setDateTimeStampMillis( long millis ) {
        this.dateTimeStamp = new java.util.Date( millis );
    }

    /**
     * Returns the key for primary overall trend data
     * @return the overallTrendKey
     */
    public String getOverallTrendKey( ) {
        return this.overallTrendKey;
    }

    /**
     * @param overallTrendKey the overallTrendKey to set
     */
    public void setOverallTrendKey( String overallTrendKey ) {
        this.overallTrendKey = overallTrendKey;
    }

    public String getOverallKey( ) {
        return overallKey;
    }

    public void setOverallKey( String overallKey ) {
        this.overallKey = overallKey;
    }

}
