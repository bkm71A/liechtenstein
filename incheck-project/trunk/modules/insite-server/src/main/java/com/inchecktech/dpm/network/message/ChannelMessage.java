/**
 * 
 */
package com.inchecktech.dpm.network.message;

/**
 * @author 
 *
 */
public class ChannelMessage implements DPMMessage {

	/* Serial version UID */
	private static final long serialVersionUID = 1525420962323540176L;

	private String channel;
	
	private String samplingRate;
	
	private String samplingInterval; 
	
	private String samples;

	/**
	 * @return the channel
	 */
	public String getChannel() {
		return channel;
	}

	/**
	 * @param channel the channel to set
	 */
	public void setChannel(String channel) {
		this.channel = channel;
	}

	/**
	 * @return the samplingRate
	 */
	public String getSamplingRate() {
		return samplingRate;
	}

	/**
	 * @param samplingRate the samplingRate to set
	 */
	public void setSamplingRate(String samplingRate) {
		this.samplingRate = samplingRate;
	}

	/**
	 * @return the samplingInterval
	 */
	public String getSamplingInterval() {
		return samplingInterval;
	}

	/**
	 * @param samplingInterval the samplingInterval to set
	 */
	public void setSamplingInterval(String samplingInterval) {
		this.samplingInterval = samplingInterval;
	}

	/**
	 * @return the samples
	 */
	public String getSamples() {
		return samples;
	}

	/**
	 * @param samples the samples to set
	 */
	public void setSamples(String samples) {
		this.samples = samples;
	}
	
	
}
