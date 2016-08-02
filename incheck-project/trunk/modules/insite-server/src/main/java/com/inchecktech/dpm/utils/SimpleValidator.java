package com.inchecktech.dpm.utils;

import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.ProcessedDynamicData;

public class SimpleValidator {
	
	/**
	 * Validate ProcessedDynamicData object
	 * @param data
	 * @throws IllegalArgumentException
	 */
	public static void vlidateProcessedDynamicData(ProcessedDynamicData data) throws IllegalArgumentException{
	
		if (null == data){
			throw new IllegalArgumentException("ProcessedDynamicData object can't be null");
		}
		
		validateChannelId(data.getChannelId());
		
		
	}
	
	public static void validateProcessedData(ProcessedData data) throws IllegalArgumentException{
		
		if (null == data){
			throw new IllegalArgumentException("ProcessedData object can't be null");
		}
		
		validateChannelId(data.getChannelId());
	}
	
	public static void validateChannelId(int channelId){
		if (0 == channelId){
			throw new IllegalArgumentException("channelid in ProcessedDynamicData can't be 0");
		}
	}
	
	

}
