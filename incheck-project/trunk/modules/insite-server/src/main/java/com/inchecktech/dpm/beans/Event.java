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
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * This class is a simple Java bean representing a system generated Event.
 * @author Leo B.
 *
 */
public class Event implements Serializable {
	public static final SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yy HH:mm:ss");
	
	static final long serialVersionUID = -6194613137040613879L;

	public User getAckuser() {
		return ackuser;
	}

	public void setAckuser(User ackuser) {
		this.ackuser = ackuser;
	}

	/**
	 * This constructor takes all attributes of the object as parameters.
	 */
	public Event (int eId, int channelId, String channelLocation, String overall_tr_type, int severity, String desc, String longDecs,
			long timeStamp, double event_tr_lower_bound, double event_tr_upper_bound, double threshold_tr_value, ChannelState chanState, double eventValue) {
		super();
		this.event_tr_id = eId;
		this.overall_tr_type = overall_tr_type;
		this.channelId = channelId; 
		this.channelLocation = channelLocation;
		this.severity = severity; 
		this.previous_severity = 0;
		this.decs = desc; 
		this.longDesc = longDecs;
		this.timeStamp = timeStamp;
		
		// TODO ---- WARNING, this will will break persistance of the event object.  The reason why this is commented out
		// is because this propagates the object to the ICNode...needs to be revisited!!!!
		this.chanState = chanState;
		this.event_tr_lower_bound = event_tr_lower_bound;
		this.event_tr_upper_bound = event_tr_upper_bound;		
		this.threshold_tr_value = threshold_tr_value;
		this.eventValue = eventValue;
	}
	
	/**
	 * Default constructor that shouldn't be used
	 */
	public Event() {
		super();
	}
	
	/**
	 * Default constructor that takes only channelId as a parameter.  User is to use setters/getters to populate object properties.
	 */
	public Event(int channelId) {
		this();
		this.channelId = channelId; 
	}
	
	// PRIVATE PROPERTIES
	private int 	eventId;
    private int     event_tr_id;
	private String overall_tr_type; // from to chanState.getProcessedData("Acceleration, G").getOveralls().getKeys()
	private double event_tr_lower_bound;  //event rcvd value
	private double event_tr_upper_bound;  //event rcvd value
	private double eventValue;
	private double threshold_tr_value;  //threshold value
	private int  	channelId;
	private String  channelLocation;
	private int  	severity; //0 = cleared!
	private int  	previous_severity; //used for cleared alarms 
	private String 	decs;  		
	private String 	longDesc;	
	private long 	timeStamp;
	private String type;
	private String resetby;
	private String notes;
	private String strTimeStamp;
	private boolean acked;
	
	private ChannelState chanState;
	private User ackuser;

	public long getTimeStamp() {
		return timeStamp;
	}

    public int getEventTrId() {
        return event_tr_id;
    }
	/**
	 * Get unique alarm identifier - historical data pulled from DB.  Future use.
	 */
	public int getEventId() {
		return eventId;
	}
	/**
	 * Set unique alarm identifier - historical data pulled from DB.  Future use.
	 */
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	/**
	 * Get unique identifier of a channel that generated the alarm.
	 */
	public int getChannelId() {
		return channelId;
	}
	/**
	 * Set unique identifier of a channel that generated the alarm.
	 */
	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}
	
	/**
	 * Gets the channel location.
	 * 
	 * @return the channel location
	 */
	public String getChannelLocation() {
		return channelLocation;
	}
	/**
	 * Sets the channel location.
	 * 
	 * @param channelLocation the new channel location
	 */
	public void setChannelLocation(String channelLocation) {
		this.channelLocation = channelLocation;
	}
	/**
	 * Get alarm severity level as defined in DAM/DPM protocol: 0-no alert, 1-level 1, 2-level 2, 3-level 4; 4+ - future use.
	 * GUI is to implement the coloring logic for visual representation of severity levels.
	 */
	public int getSeverity() {
		return severity;
	}
	/**
	 * Set alarm severity level as defined in DAM/DPM protocol: 0-no alert, 1-level 1, 2-level 2, 3-level 4; 4+ - future use.
	 * GUI is to implement the coloring logic for visual representation of severity levels.
	 */
	public void setSeverity(int severity) {
		this.severity = severity;
	}
	/**
	 * Get alert short description.
	 */
	public String getDecs() {
		return decs;
	}
	/**
	 * Set alert short description.
	 */
	public void setDecs(String decs) {
		this.decs = decs;
	}
	/**
	 * Get alert extended/long description.
	 */
	public String getLongDesc() {
		return longDesc;
	}
	/**
	 * Set alert extended/long description.
	 */
	public void setLongDesc(String longDesc) {
		this.longDesc = longDesc;
	}
	/**
	 * Get alert date/time stamp in seconds since 1970.
	 */
	public long getTimeSatmp() {
		return timeStamp;
	}
	/**
	 * Set alert date/time stamp in seconds since 1970.
	 */
	public void setTimeStamp(long timeStamp) {
		this.timeStamp = timeStamp;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getResetby() {
		return resetby;
	}

	public void setResetby(String resetby) {
		this.resetby = resetby;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
	
	
	@Override
	public String toString() {
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("eventId:").append(eventId).append("\n");
		sb.append("channel_id:").append(channelId).append("\n");
		sb.append("channel_location:").append(channelLocation).append("\n");
		sb.append("severity:").append(severity).append("\n");
		sb.append("description:").append(decs).append("\n");
		sb.append("longdescription:").append(longDesc).append("\n");
		sb.append("timeStamp:").append(timeStamp).append("\n");
		sb.append("type:").append(type).append("\n");
		sb.append("resetby:").append(resetby).append("\n");
		sb.append("notes:").append(notes).append("\n");
		sb.append("ackUser:").append(ackuser).append("\n");
		sb.append("eventValue:").append(eventValue).append("\n");
		return sb.toString();	
		
	}

	public String getStrTimeStamp() {
		//return strTimeStamp;
		return fmt.format(new Date(timeStamp));
	}

	public ChannelState getChanState() {
		return chanState;
	}

	public void setChanState(ChannelState chanState) {
		this.chanState = chanState;
	}

	public int getPrevious_severity() {
		return previous_severity;
	}

	public void setPrevious_severity(int previous_severity) {
		this.previous_severity = previous_severity;
	}

	public String getOverall_tr_type() {
		return overall_tr_type;
	}

	public void setOverall_tr_type(String overall_tr_type) {
		this.overall_tr_type = overall_tr_type;
	}

	public double getThreshold_tr_value() {
		return threshold_tr_value;
	}

	public void setThreshold_tr_value(double threshold_tr_value) {
		this.threshold_tr_value = threshold_tr_value;
	}

	public void setStrTimeStamp(String strTimeStamp) {
		this.strTimeStamp = strTimeStamp;
	}

	public double getEvent_tr_lower_bound() {
		return event_tr_lower_bound;
	}

	public void setEvent_tr_lower_bound(double event_tr_lower_bound) {
		this.event_tr_lower_bound = event_tr_lower_bound;
	}

	public double getEvent_tr_upper_bound() {
		return event_tr_upper_bound;
	}

	public void setEvent_tr_upper_bound(double event_tr_upper_bound) {
		this.event_tr_upper_bound = event_tr_upper_bound;
	}

	public boolean isAcked() {
		return acked;
	}

	public void setAcked(boolean acked) {
		this.acked = acked;
	}

	public double getEventValue() {
		return eventValue;
	}

	public void setEventValue(double eventValue) {
		this.eventValue = eventValue;
	}

	
	
		
}
