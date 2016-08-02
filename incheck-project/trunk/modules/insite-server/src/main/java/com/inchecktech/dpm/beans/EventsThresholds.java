package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.List;

public class EventsThresholds implements Comparable<EventsThresholds>, Serializable{
	

	private static final long serialVersionUID = -7370783381574626183L;
	private int event_tr_id;
	private int channel_id;
	private String channel_location;
	private double event_tr_lower_bound;  //lower bound
	private double event_tr_upper_bound;  //upper bound
	private String overall_tr_type; 
	private int unit_id;
	private int severity;
    private int band_id;
	private int delivery_id;
	private String action;
	private String description;
	private String longdescription;
	private List<DeliveryPath> deliveryPathList;
	
	@Override
	public String toString() {

		StringBuilder sb = new StringBuilder("\tEventsThresholds:");
		sb.append("\n\t").append("event_tr_id=").append(event_tr_id);
		sb.append("\n\t").append("channel_id=").append(channel_id);
		sb.append("\n\t").append("event_tr_lower_bound=").append(event_tr_lower_bound);
		sb.append("\n\t").append("event_tr_upper_bound=").append(event_tr_upper_bound);
		sb.append("\n\t").append("overall_tr_type=").append(overall_tr_type);
		sb.append("\n\t").append("unit_id=").append(unit_id);
		sb.append("\n\t").append("severity=").append(severity);
		sb.append("\n\t").append("delivery_id=").append(delivery_id);
		sb.append("\n\t").append("action=").append(action);
		sb.append("\n\t").append("description=").append(description);
		sb.append("\n\t").append("longdescription=").append(longdescription);
		sb.append("\n\t").append("deliveryPathList=").append(deliveryPathList);
		
		return sb.toString();
	}
	
	public String getAction() {
		return action;
	}


	public void setAction(String action) {
		this.action = action;
	}


	public int getChannel_id() {
		return channel_id;
	}


	public void setChannel_id(int channel_id) {
		this.channel_id = channel_id;
	}

	public String getChannel_location() {
		return channel_location;
	}

	public void setChannel_location(String channel_location) {
		this.channel_location = channel_location;
	}

	public int getDelivery_id() {
		return delivery_id;
	}


	public void setDelivery_id(int delivery_id) {
		this.delivery_id = delivery_id;
	}


	public String getDescription() {
		return description;
	}


	public void setDescription(String description) {
		this.description = description;
	}


	public int getEvent_tr_id() {
		return event_tr_id;
	}


	public void setEvent_tr_id(int event_tr_id) {
		this.event_tr_id = event_tr_id;
	}

	public String getLongdescription() {
		return longdescription;
	}


	public void setLongdescription(String longdescription) {
		this.longdescription = longdescription;
	}


	public String getOverall_tr_type() {
		return overall_tr_type;
	}


	public void setOverall_tr_type(String overall_tr_type) {
		this.overall_tr_type = overall_tr_type;
	}


	public int getSeverity() {
		return severity;
	}


	public void setSeverity(int severity) {
		this.severity = severity;
	}

    public int getBand_id() {
        return band_id;
    }

    public void setBand_id(int band_id) {
        this.band_id = band_id;
    }

    public int getUnit_id() {
		return unit_id;
	}


	public void setUnit_id(int unit_id) {
		this.unit_id = unit_id;
	}
	
	public int compareTo(EventsThresholds evThresholds) {
	    int result = overall_tr_type.compareTo(evThresholds.getOverall_tr_type());
	    return result == 0 ? overall_tr_type.compareTo(((EventsThresholds) evThresholds).overall_tr_type) : result;
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

	public List<DeliveryPath> getDeliveryPathList() {
		return deliveryPathList;
	}

	public void setDeliveryPathList(List<DeliveryPath> deliveryPathList) {
		this.deliveryPathList = deliveryPathList;
	}

}
