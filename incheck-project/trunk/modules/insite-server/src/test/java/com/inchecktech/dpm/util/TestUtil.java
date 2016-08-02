package com.inchecktech.dpm.util;

import java.util.Date;
import java.util.Vector;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.Event;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.ProcessedDynamicData;

public class TestUtil {
	
	public static Event getTestEvent(int chId){
		Event e = new Event();
		
		ChannelState state = getTestChannelState(chId);
		e.setEventId(1);
		e.setChannelId(state.getChannelId());
		e.setChanState(state);
		
		return e;
	}
	
	
	public static OverallLevels getOverallLevels(int ChID){
		OverallLevels levels = new OverallLevels(ChID);
		levels.setOverall("RMS", new Double(5));
		
		return levels;
	}
	
	public static ProcessedData getProcessedData(int ChID){
		ProcessedData data = getProcessedDynamicData(ChID);
		
		return data;
		
	}
	
	public static ProcessedDynamicData getProcessedDynamicData(int ChID){
		
		Vector<Double> vecData = new Vector<Double>();
		vecData.add(new Double(1));
		vecData.add(new Double(2));
		
		ProcessedDynamicData data = new ProcessedDynamicData(ChID);
		data.setChannelId(ChID);
		data.setData(vecData);
		data.setOveralls(getOverallLevels(ChID));
		data.setSamplingRate(5);
		data.setDateTimeStamp(new Date());
		
		return data;
		
	}

	public static ChannelState getTestChannelState(int Chid) {
		
		Double rpm = new Double(0.03498493101646087);
		
		ChannelState state = new ChannelState(Chid, 1);
		
		state.setRpm(rpm);
		state.addProcessedData("Acceleration, G", getProcessedDynamicData(Chid));
		state.addProcessedData("Time Waveform - Acceleration", getProcessedDynamicData(Chid));
				
		return state;
	}
	
	public static ICNode getNode(int id){
		ICNode node = new ICNode(id);
		node.setDesc("Node Description");
		node.setDeviceId(id);
		node.setLabel("Pump");
		node.setName("Pump");
		node.setType("Channel");
	
		return node;
		
		
	}

}
