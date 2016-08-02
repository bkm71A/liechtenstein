package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.utils.Logger;

public class ICNode implements Serializable {

	private static final Logger logger = new Logger(ICNode.class);
	private static final long serialVersionUID = -3481454536902701017L;

	private String name = "";
	private int id;
	private int channelid;
	private String desc;
	private String type;
	private String label = "";
	private int state = 0;
	private ICNode parent = null;
	private int deviceId;
	private long latestTimeStamp;
	private long samplingRate;
	private long numberOfSamples;
	private String dataUnits;
	private int channelType =0;
	private String measureType ="N/A";
	public Collection<ICNode> children = new ArrayList<ICNode>();
	public Collection<String> processedDataKeysString = new ArrayList<String>();
	public Collection<Double> latestData = new ArrayList<Double>();
	Boolean[] latestTicks;
	private Date incomingDataTimestamp;

	@Override
	public int hashCode() {
		return id;
	}

	public ICNode() {
		super();
	}

	public ICNode(String name, int state) {
		this.name = name;
		this.state = state;
	}

	public ICNode(int id) {
		this.id = id;
	}

	@SuppressWarnings("unchecked")
	public Collection getChildren() {
		return children;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getState() {
		return state;
	}

	public void setState(int state) {
		if (this.state != state){
			logger.info("STATE CHANGED TO ANOTHER :" + state);
		}else{
			logger.debug("STATE CHANGE " + label);
		}
		this.state = state;
	}

	public void addChild(ICNode o) {
		if (children == null) {
			children = new ArrayList<ICNode>();
		}
		children.add(o);
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public boolean isManaged() {
		return true;
	}

	public ICNode getParent() {
		return parent;
	}

	public void setParent(ICNode parent) {
		this.parent = parent;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getChannelid() {
		return channelid;
	}

	public void setChannelid(int channelid) {
		this.channelid = channelid;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	// TODO: Add more meta data so the client will have enough info to plot
	// different types of graph with proper labels and scales.
	// Leave it simple for the prototype.

	/**
	 * Get sampling rate read from controller and used in calculations
	 * 
	 * @return the samplingRate
	 */
	public long getSamplingRate() {
		return samplingRate;
	}

	/**
	 * Set sampling rate read from controller and used in calculations
	 * 
	 * @param samplingRate
	 *            the samplingRate to set
	 */
	public void setSamplingRate(long samplingRate) {
		this.samplingRate = samplingRate;
	}

	/**
	 * Get measurements units for the data set
	 * 
	 * @return the dataUnits
	 */
	public String getDataUnits() {
		return dataUnits;
	}

	/**
	 * Set measurement units for the data set
	 * 
	 * @param dataUnits
	 *            the dataUnits to set
	 */
	public void setDataUnits(String dataUnits) {
		this.dataUnits = dataUnits;
	}

	/**
	 * Get the processed data points for plotting graphs. Assume that they are
	 * equally spaced. TODO: confirm the assumption with Yuri.
	 * 
	 * @return the data
	 */
	@SuppressWarnings("unchecked")
	public Collection getLatestData() {
		return latestData;
	}

	/**
	 * Set the processed data points for plotting graphs. Assume that they are
	 * equally spaced.
	 * 
	 * @param data
	 *            the data to set
	 */
	public void addData(double[] data, long dataTimeStamp) {
		ArrayList<Double> newD = new ArrayList<Double>();
		for (int i = 0; i < data.length; i++) {
			newD.add(data[i]);
		}
		this.latestData = newD;
		this.latestTimeStamp = dataTimeStamp;
		logger.debug("ADDED LatestData " + data.length + " with TS of "
				+ dataTimeStamp);
	}

	/**
	 * @return the dataTicks
	 */
	protected Boolean[] getLatestDataTicks() {
		return latestTicks;
	}

	/**
	 * @param dataTicks
	 *            the dataTicks to set
	 */
	public void addDataTicks(Boolean[] dataTicks, long tickTimeStamp) {
		logger.debug("ADDED dataTicks " + dataTicks.length);
		this.latestTicks = dataTicks;
	}

	public void addDataAndTicks(double[] data, Boolean[] dataTicks,
			long tickTimeStamp) {
		this.addData(data, tickTimeStamp);
		this.addDataTicks(dataTicks, tickTimeStamp);
	}

	public int getDeviceId() {
		return deviceId;
	}

	public void setDeviceId(int deviceId) {
		this.deviceId = deviceId;
	}

	public long getLatestTimeStamp() {
		return latestTimeStamp;
	}

	public void setLatestTimeStamp(long latestTimeStamp) {
		this.latestTimeStamp = latestTimeStamp;
	}

	public Double getOverall(String key) {
		ChannelState chState=DataBucket.getChannelState(this.channelid);
	
		if ( chState!= null) {
			return chState.getPrimaryProcessedData().getOveralls().getOverall(key);
		} else {
			return 0.0;
		}
	}

	public List<String> getProcessedDataKeys() {
		ChannelState chState=DataBucket.getChannelState(this.channelid);
		if (chState != null) {
			return new ArrayList<String>(chState.getProcessedData().keySet());
		} else {
			return null;
		}
	}
	
	public String getOverallPrimaryKey() {
		ChannelState chState=DataBucket.getChannelState(this.channelid);
		if (chState != null) {
			return chState.getOverallTrendKey();
		} else {
			return null;
		}
	}
	
        public ProcessedData getOverallTrendData(String type) {
		ChannelState chState=DataBucket.getChannelState(this.channelid);
		if (chState != null) {
			return chState.getOverallTrendData(type);
		} else {
			return null;
		}
	}

	public List<Double> getProcessedData(String type) {
		ChannelState chState=DataBucket.getChannelState(this.channelid);
		if (chState != null) {
			return chState.getProcessedData().get(type).getData();
		} else {
			return null;
		}
	}

	public ProcessedData getProcessedDataObj(String type) {
		ChannelState chState=DataBucket.getChannelState(this.channelid);
		if (chState != null) {
			return chState.getProcessedData().get(type);
		} else {
			return null;
		}
	}
	
	public ChannelState getChannelState() {
		return DataBucket.getChannelState(this.channelid);
	}

	public void setEvents(	List<Event> events) {
		DataBucket.putEvents(this.channelid, events);
		if (events == null || events.size() == 0) {
			logger.debug("EVENTS empty for :" + channelid + "  evob: "
					+ events);
			setState(0);
		} else {
			int tmpState = 0;
			logger.debug("EVENTS for :" + channelid + "  evob: "
					+ events.size());
			for (Event eachEvent : events) {
				int mysev = eachEvent.getSeverity();
				logger.debug("EVENTS for :" + channelid + "  mysev: "
						+ mysev);
				if (mysev > tmpState) {
					tmpState = mysev;
				}
			}
			setState(tmpState);
		}
		logger.debug("EVENTS for :" + channelid + "  STATE SET TO  "
				+ this.state);
		if(parent!=null){
			parent.propagateState();
		}
	}
	
	public void propagateState(){
		int tmpState=0;
		if(children!=null){
			for(ICNode ec:children){
				if(ec.getState()>tmpState){
					tmpState=ec.getState();
				}
			}
		}
		setState(tmpState);
		if(parent!=null){
			parent.propagateState();
		}
		
		DataBucket.updateNotifier.notifyUpdate(this);
		
	}

	public Collection<String> getProcessedDataKeysString() {
		return processedDataKeysString;
	}
	
	public void setProcessedDataKeysString(Collection<String> c){
		logger.debug("in  setProcessedDataKeysString");
		this.processedDataKeysString=c;
		for(Object o:this.processedDataKeysString){
			logger.debug(o);
		}
	}

	public long getNumberOfSamples() {
		return numberOfSamples;
	}

	public void setNumberOfSamples(long numberOfSamples) {
		this.numberOfSamples = numberOfSamples;
	}

	public int getChannelType() {
		return channelType;
	}

	public void setChannelType(int channelType) {
		this.channelType = channelType;
	}

	public String getMeasureType() {
		return measureType;
	}

	public void setMeasureType(String measureType) {
		this.measureType = measureType;
	}

	public Date getIncomingDataTimestamp() {
		return incomingDataTimestamp;
	}

	public void setIncomingDataTimestamp(Date incomingDataTimestamp) {
		this.incomingDataTimestamp = incomingDataTimestamp;
	}
}
