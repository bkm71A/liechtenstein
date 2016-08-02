package com.inchecktech.dpm.persistence;

import java.util.Collection;
import java.util.TimerTask;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.utils.Logger;

public class PersistenceTimer extends TimerTask{

	private static final Logger logger = new Logger(PersistenceTimer.class);
	
	@Override
	public void run() {
		
		// To ensure the same time is set on all...
		long date = System.currentTimeMillis();
		Collection<ChannelState> channelStateList = DataBucket.getAllChannelState();
		logger.info("got "  + channelStateList.size() + " channnelStates in the list");
	
		for (ChannelState state : channelStateList ){
			if (null != state){
				try {
					state.setDateTimeStampMillis(date);
					logger.debug("Trying to save chl state to DB now for channelid=" + state.getChannelId());
					PersistChannelState.storeChannelState(state, false, "systematic");
				} catch (Exception e) {
					logger.error("Unable to store channel state", e);
					e.printStackTrace();
				}
			}
		}
	}
}
