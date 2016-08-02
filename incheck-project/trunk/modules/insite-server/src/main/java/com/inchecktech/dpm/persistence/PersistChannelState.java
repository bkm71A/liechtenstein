package com.inchecktech.dpm.persistence;

import java.io.IOException;
import java.util.HashMap;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.ProcessedDynamicData;
import com.inchecktech.dpm.utils.Logger;
import com.inchecktech.dpm.utils.SimpleConverter;

public class PersistChannelState {

	private static final Logger logger = new Logger(PersistChannelState.class);

	// @Deprecated public static int storeChannelState(ChannelState state,
	// boolean isAlarm,
	// String comments) throws DPMException {
	//
	// logger.info("storeChannelState called with state=" + state
	// + " isAlarm=" + isAlarm + " comments=" + comments);
	//
	// ProcessedData primaryData = state.getPrimaryProcessedData();
	// int channelType = state.getChannelType();
	//
	// if (channelType == ChannelState.CHANNEL_TYPE_DYNAMIC) {
	// }else if (channelType == ChannelState.CHANNEL_TYPE_STATIC){
	//			
	// logger.debug("WHATS NOT NULL: PROCESSDDATA:" +
	// state.getPrimaryProcessedData());
	// logger.debug("WHATS NOT NULL: OVERALL:" +
	// state.getPrimaryProcessedData().getOveralls());
	// logger.debug("THIS FUNCTION IS NOT WRITTEN YET OR NOT WORKING PROPERLY");
	// }
	//
	// Double rpm = state.getRpm();
	// Date overwriteTime = state.getDateTimeStamp();
	// String overallKey = state.getOverallKey();
	//
	// return PersistProcessedData.storeProcessedData(primaryData, rpm,
	// isAlarm, overwriteTime, channelType, overallKey, comments);
	//		
	// }
	
    public static int calculateSampleId(ChannelState state, ProcessedData primaryData, double rpm, boolean isAlarm,
            int unitId, String comments) {
        return PersistProcessedData.storeSampleMain(state.getChannelId(), state.getDateTimeStamp(), primaryData
                .getSamplingRate(), rpm, isAlarm, unitId, comments);
    }

	public static int storeChannelState(ChannelState state, boolean isAlarm,
			String comments) {

		logger.info("START storeChannelState called with state=" + state
				+ " isAlarm=" + isAlarm + " comments=" + comments);

		ProcessedData primaryData = state.getPrimaryProcessedData();
		if(primaryData == null){
			return 0;
		}
		int channelType = state.getChannelType();
		double rpm = 0;

		// only dynamic channels have RPM, for static channels RPM is 0
		if (channelType == ChannelState.CHANNEL_TYPE_DYNAMIC) {
			if (null != state.getRpm()) {
				rpm = state.getRpm();
			}
		}

		// TODO need to have unitID populated inside ProcessedData object
		int unitId = 1;

		/* Ticket #20. The code moved to the 'store all overalls' loop*/
		// store data description
		int sampleId = PersistProcessedData.storeSampleMain(state
				.getChannelId(), state.getDateTimeStamp(), primaryData
				.getSamplingRate(), rpm, isAlarm, unitId, comments);
/**/
		// store raw data
		try {
			PersistProcessedData.storeSampleVibration(sampleId, SimpleConverter
					.getBytes(primaryData));
		} catch (IOException e) {
			logger
					.error(
							"an error occured trying to convert ProcessedData into an array of bytes",
							e);
		}

		// store all overalls
        for (ProcessedData processedData : state.getProcessedData().values()) {
            OverallLevels overalls = processedData.getOveralls();
            if (overalls != null) {
                for (String key : overalls.getKeys()) {
                    Double data = overalls.getOverall(key);
                    if (processedData.getAccBandOveralls() != null) {
                        for (Integer bandId : processedData.getAccBandOveralls().keySet()) {
                            PersistProcessedData.storeSampleOverall(sampleId, key, bandId, data);
                        }
                    } else if (processedData.getVelBandOveralls() != null) {
                        for (Integer bandId : processedData.getVelBandOveralls().keySet()) {
                            PersistProcessedData.storeSampleOverall(sampleId, key, bandId, data);
                        }
                    
                    }else {
                        // hot fix
                        PersistProcessedData.storeSampleOverall(sampleId, key, 1, data);
                    }
                }
                overalls.clear();
            }
        }

		// store bands
        if (channelType == ChannelState.CHANNEL_TYPE_DYNAMIC) {
            if (null != primaryData.getAccBandOveralls()){
                HashMap<Integer, Double> map = primaryData.getAccBandOveralls();
                for (Integer key : map.keySet()){
                    Double overallValue = map.get(key);
                    if(!overallValue.isNaN()){
                        PersistProcessedData.storeSampleOverall(sampleId, "accBand", key, map.get(key));
                    }
                }
            }
            if (null != primaryData.getVelBandOveralls()){
                HashMap<Integer, Double> map = primaryData.getVelBandOveralls();
                for (Integer key : map.keySet()){
                    Double overallValue = map.get(key);
                    if(!overallValue.isNaN()){
                        PersistProcessedData.storeSampleOverall(sampleId, "velBand", key, map.get(key));
                    }
                }
            }
        }

		logger.info("END storeChannelState for state=" + state + " isAlarm="
				+ isAlarm + " comments=" + comments);

		return sampleId;
	}
}