package com.inchecktech.dpm.dao;

import java.util.ArrayList;
import java.util.List;

public class DataPacketVO  {

	private int protocol_version;
	private int device_number;
	private int channel_id;
	private int message_number;
	private int alarm_status;
	private int timestamp;
	private int num_of_samples_in_message;
	private int num_of_samples_total;
	private int sample_rate;
	private int trigger_mode;
	private int machine_speed; 
	private int machine_status;  
	private int internal_program_ID;
	
	//The Dynamic DATA
	private List<Double> data;
	private List<Double> external_ticks;
	
    public DataPacketVO()
    { 
    	this.data = new ArrayList<Double>();
    	this.external_ticks = new ArrayList<Double>();
    }

	public int getAlarm_status() {
		return alarm_status;
	}

	public void setAlarm_status(int alarm_status) {
		this.alarm_status = alarm_status;
	}

	public int getChannel_id() {
		return channel_id;
	}

	public void setChannel_id(int channel_id) {
		this.channel_id = channel_id;
	}

	public List<Double> getData() {
		return data;
	}

	public void setData(List<Double> data) {
		this.data = data;
	}
	
	public List<Double> getExternal_ticks() {
		return external_ticks;
	}

	public void setExternal_ticks(List<Double> external_ticks) {
		this.external_ticks = external_ticks;
	}
	
	public int getDevice_number() {
		return device_number;
	}

	public void setDevice_number(int device_number) {
		this.device_number = device_number;
	}

	public int getInternal_program_ID() {
		return internal_program_ID;
	}

	public void setInternal_program_ID(int internal_program_ID) {
		this.internal_program_ID = internal_program_ID;
	}

	public int getMachine_speed() {
		return machine_speed;
	}

	public void setMachine_speed(int machine_speed) {
		this.machine_speed = machine_speed;
	}

	public int getMachine_status() {
		return machine_status;
	}

	public void setMachine_status(int machine_status) {
		this.machine_status = machine_status;
	}

	public int getMessage_number() {
		return message_number;
	}

	public void setMessage_number(int message_number) {
		this.message_number = message_number;
	}

	public int getNum_of_samples_in_message() {
		return num_of_samples_in_message;
	}

	public void setNum_of_samples_in_message(int num_of_samples_in_message) {
		this.num_of_samples_in_message = num_of_samples_in_message;
	}

	public int getNum_of_samples_total() {
		return num_of_samples_total;
	}

	public void setNum_of_samples_total(int num_of_samples_total) {
		this.num_of_samples_total = num_of_samples_total;
	}

	public int getProtocol_version() {
		return protocol_version;
	}

	public void setProtocol_version(int protocol_version) {
		this.protocol_version = protocol_version;
	}

	public int getSample_rate() {
		return sample_rate;
	}

	public void setSample_rate(int sample_rate) {
		this.sample_rate = sample_rate;
	}

	public int getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(int timestamp) {
		this.timestamp = timestamp;
	}

	public int getTrigger_mode() {
		return trigger_mode;
	}

	public void setTrigger_mode(int trigger_mode) {
		this.trigger_mode = trigger_mode;
	}
}
