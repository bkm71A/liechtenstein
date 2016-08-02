/**
 * 
 */
package com.inchecktech.dpm.common;

import java.util.Iterator;
import java.util.TimerTask;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.dao.DataBucket;

/**
 * @author
 * 
 */
public class ChannelStateTimer extends TimerTask {

	/**
	 * @see java.util.TimerTask#run()
	 */
	@Override
	public void run() {
		Iterator<ChannelState> iterator = DataBucket.getAllChannelState().iterator();
		while (iterator.hasNext()) {
			ChannelState state = iterator.next();
			if ((state != null) && (!state.isInUse())) {
				iterator.remove();
			}
		}
	}

}
