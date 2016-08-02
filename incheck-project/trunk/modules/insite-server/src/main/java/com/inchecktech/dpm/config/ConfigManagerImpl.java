package com.inchecktech.dpm.config;

import java.util.List;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.persistence.PersistDPMConfig;
import com.inchecktech.dpm.persistence.PersistSpecAnalysisConfig;

public class ConfigManagerImpl {

	/**
	 * 
	 * @param channelId
	 * @return list of allowable spectrum configs for that channel
	 */
	public static List<SpectrumAnalysisConfig> getSpectrumAnalysisConfig(int channelId){
		List<SpectrumAnalysisConfig> confList = PersistSpecAnalysisConfig.getSpectrumAnalysisConfig(channelId);
		return confList;
	}
	
	/**
	 * 
	 * @param channelTypes
	 * @return returns channelCOnfig for different channel types (DYNAMIC, STATIC)
	 */
	public static ChannelConfig getChannelConfig(List<String> channelTypes){
		return ChannelConfigFactory.getChannelConfig(channelTypes);
	}
	
	/**
	 * 
	 * @param channelConfigItem
	 * @return status when updating the config_value;
	 */
	public static Status updateConfigItem(ChannelConfigItem channelConfigItem){
		return ChannelConfigFactory.updateConfigItem(channelConfigItem);
	}
	

	/**
	 * 
	 * @param groupName
	 * @param typeName
	 * @param propertyName
	 * @return ConfigItem
	 */
	public static ConfigItem getConfigItem(String groupName, String typeName, String propertyName){
		return PersistDPMConfig.getConfigItem(groupName, typeName, propertyName);
	}
	
	
}
