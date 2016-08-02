package com.inchecktech.dpm.dao;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;

import com.inchecktech.dpm.alarmEngine.AlarmEngine;
import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.DSPCoreDump;
import com.inchecktech.dpm.beans.Device;
import com.inchecktech.dpm.beans.Event;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.OverallTypes;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.engine.DPMEngine;
import com.inchecktech.dpm.flex.FlexUpdateListenerImpl;
import com.inchecktech.dpm.flex.UpdateNotifier;
import com.inchecktech.dpm.network.DPMClientSocketHandler;
import com.inchecktech.dpm.utils.Logger;
import com.inchecktech.dpm.simulator.*;


public class DataBucket {

	private static final Logger logger = new Logger(DataBucket.class);
	
	private static Hashtable<Integer,DSPCalculator> DSPProcById=new Hashtable<Integer, DSPCalculator>();
	private static Hashtable<Integer,AlarmEngine> AlarmEngineById=new Hashtable<Integer, AlarmEngine>();
	private static Hashtable<Integer,ChannelState> ChannelStateById=new Hashtable<Integer, ChannelState>();
	private static Hashtable<Integer,DSPCoreDump> DSPCoreDumpById=new Hashtable<Integer, DSPCoreDump>();
	private static Hashtable<Integer,List<Event>> eventsByChId=new Hashtable<Integer,List<Event>> ();
	private static Hashtable<String,DPMClientSocketHandler> socketHandlersByControllerId=new Hashtable<String,DPMClientSocketHandler> ();
	private static Hashtable<String,Device> deviceListByMac=new Hashtable<String,Device> ();
	private static Hashtable<String,Device> deviceListById=new Hashtable<String,Device> ();
	public static ArrayList<DPMClientSocketHandler> handlers=new ArrayList<DPMClientSocketHandler>();
	public static UpdateNotifier updateNotifier=null;
	public static List<String> overallTypes = new LinkedList<String>();
	private static Hashtable<Integer, DynamicChannel> dynamicSimChannels = new Hashtable<Integer, DynamicChannel>();
	private static Hashtable<Integer, StaticChannel> staticSimChannels = new Hashtable<Integer, StaticChannel>(); 
	
	public static List<String> getOverallTypes(){
		
		if (overallTypes.size() < 1 ){
			overallTypes.add(OverallTypes.getOverallType(1));
			overallTypes.add(OverallTypes.getOverallType(2));
			overallTypes.add(OverallTypes.getOverallType(3));
			overallTypes.add(OverallTypes.getOverallType(4));
			overallTypes.add(OverallTypes.getOverallType(5));
			overallTypes.add(OverallTypes.getOverallType(6));
			overallTypes.add(OverallTypes.getOverallType(7));
			overallTypes.add(OverallTypes.getOverallType(8));			
		}
		
		return overallTypes;
	}
	public DataBucket() {
		updateNotifier=new UpdateNotifier();
		
		FlexUpdateListenerImpl list=new FlexUpdateListenerImpl();
		
		updateNotifier.registerListener(list);
		updateNotifier.start();
		
		
	}
	
	public static void addSocketHandler(String id,DPMClientSocketHandler h){
		// @TODO need to add log here to deal with existing handlers
		logger.debug("added new handler to the bucket " + id);
		socketHandlersByControllerId.put(id, h);
	}

	public static DPMClientSocketHandler getSocketHandler(String id){
		return socketHandlersByControllerId.get(id);
	}
	
	
	public static ICNode getICNode(int chId){
		if (null == DPMEngine.flatList4tree){
			return null;
			
		}
		return DPMEngine.flatList4tree.get(chId);
	}
	
	public static DSPCalculator getDSPCalculator(int chId){
		return DSPProcById.get(chId);
	}
	
	public static void addOrReplaceDSPCalculator(int chId,DSPCalculator dsp){
		
		DSPProcById.put(chId,dsp);

		
	}
	
	public static AlarmEngine getAlarmEngine(int chId){
		return AlarmEngineById.get(chId);
	}
	
	public static void addOrReplaceAlarmEngine(int chId,AlarmEngine alarmEngine){
		
		
		AlarmEngineById.put(chId,alarmEngine);
		
		
	}
	
	public static void addOrReplaceDevice(String deviceId,Device dev,String mac){
		
		
		deviceListById.put(deviceId, dev);
		deviceListByMac.put(mac, dev);
		
		
	}
	
	
	public static Device getDeviceById(String id){
		return deviceListById.get(id);
	}
	
	public static Device getDeviceByMac(String mac){
		return deviceListByMac.get(mac);
	}
	
	public static ChannelState getChannelState(int chId){
		return ChannelStateById.get(chId);
	}
	
	public static void putChannelState(int chId, ChannelState chstate) {
		if ((ChannelStateById.containsKey(chId)) && (ChannelStateById.get(chId) != null)
				&& (ChannelStateById.get(chId).getPrimaryProcessedData() != null)
				&& (ChannelStateById.get(chId).getPrimaryProcessedData().getOveralls() != null)) {
			OverallLevels levels = ChannelStateById.get(chId).getPrimaryProcessedData().getOveralls();

			if ((chstate.getPrimaryProcessedData() != null)
					&& (chstate.getPrimaryProcessedData().getOveralls() != null)) {
				OverallLevels newlevels = chstate.getPrimaryProcessedData().getOveralls();
				for (String key : newlevels.getKeys()) {
					levels.addOverall(key, newlevels.getOverall(key));
				}
			}
		} else {
			ChannelStateById.put(chId, chstate);
		}
	}
	
	public static List<Event> getEvents(int chId){
		return eventsByChId.get(chId);
	}
	
	public static void putEvents(int chId,List<Event> events){
		
		eventsByChId.put(chId,events);
		
	}
	
	
	/*
	public static void addOrReplaceICNode(int chId,ICNode bean){
		logger.debug("ADDING NODE chId "+chId);
	
		synchronized (byChanelId) {
			byChanelId.put(bean.getChannelid(),bean);
		}
		
	}
	*/
	public static List<ICNode> getICNodes() {
		//return new ArrayList<ICNode>(someTestBucket.values());
		//return new ArrayList<ICNode>(DPMEngine.nodeFac.getNodeList());
		return new ArrayList<ICNode>(DPMEngine.tree);
	}
	
	public static Collection<ChannelState> getAllChannelState(){
		
		return new ArrayList<ChannelState>(ChannelStateById.values());
		
		
	}

	public static DSPCoreDump getDSPCoreDump(int chId){
		return DSPCoreDumpById.get(chId);
	}
	
	public static void putDSPCoreDump(int chId, DSPCoreDump dump){
		
		DSPCoreDumpById.put(chId, dump);
		
	}
	
	public static Hashtable<Integer, DynamicChannel> getDynamicSimChannels() {
		return dynamicSimChannels;
	}
	
	public static DynamicChannel getDynamicSimChannel(int chid) {
		return dynamicSimChannels.get(chid);
	}
	
	public static void putDynamicSimChannel(int chid, DynamicChannel channel){
		dynamicSimChannels.put(chid, channel);
	}
	
	public static Hashtable<Integer, StaticChannel> getStaticSimChannels() {
		return staticSimChannels;
	}
	
	public static StaticChannel getStaticSimChannel(int chid) {
		return staticSimChannels.get(chid);
	}
	
	public static void putStaticSimChannel(int chid, StaticChannel channel){
		staticSimChannels.put(chid, channel);
	}
	
	
}
