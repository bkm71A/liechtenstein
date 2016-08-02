package com.inchecktech.dpm.config;

import java.io.Serializable;
import java.util.ArrayList;

public class ChannelConfig  implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	public static final String CHANNEL_TYPE_DYNAMIC="DYNAMIC";
	public static final String CHANNEL_TYPE_STATIC="STATIC";
	public static final String CHANNEL_TYPE_SIMULATOR="SIMULATOR";
	
	private ConfigGroup configGroup;
	private ConfigType configType;
	private int userControl;
	
	private ArrayList<ChannelConfigItem> channelConfigItems;
	
	public ArrayList<ChannelConfigItem> getChannelConfigItems() {
		return channelConfigItems;
	}
	public void setChannelConfigItems(
			ArrayList<ChannelConfigItem> channelConfigItems) {
		this.channelConfigItems = channelConfigItems;
	}
	public ConfigGroup getConfigGroup() {
		return configGroup;
	}
	public void setConfigGroup(ConfigGroup configGroup) {
		this.configGroup = configGroup;
	}
	public ConfigType getConfigType() {
		return configType;
	}
	public void setConfigType(ConfigType configType) {
		this.configType = configType;
	}
	public int getUserControl() {
		return userControl;
	}
	public void setUserControl(int userControl) {
		this.userControl = userControl;
	}
	

}
