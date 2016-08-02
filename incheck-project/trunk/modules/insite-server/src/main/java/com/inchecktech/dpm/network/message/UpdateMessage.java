/**
 * 
 */
package com.inchecktech.dpm.network.message;

import java.util.List;

/**
 * REGISTER response to update configuration from DPM to DAM
 * 
 * @author
 * 
 */
public class UpdateMessage implements DPMMessage {

	/* Serial version UID */
	private static final long	serialVersionUID = 4125724967643522413L;

	/* List of messages for the channels to update */
	private List<ChannelMessage> channelMessages;

	/**
	 * @return the channelMessages
	 */
	public List<ChannelMessage> getChannelMessages() {
		return channelMessages;
	}

	/**
	 * @param channelMessages
	 *            the channelMessages to set
	 */
	public void setChannelMessages(List<ChannelMessage> channelMessages) {
		this.channelMessages = channelMessages;
	}
}
