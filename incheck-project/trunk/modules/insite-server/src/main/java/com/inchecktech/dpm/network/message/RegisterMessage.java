/**
 * 
 */
package com.inchecktech.dpm.network.message;

/**
 * Describes Register message of DDP protocol
 * 
 * @author
 * 
 */
public class RegisterMessage implements DPMMessage {

	/* Serial version UID */
	private static final long serialVersionUID = -6679715884071834858L;
	
	private String header;
	
	private String controllerId;
	
	private String timeStampStr;
	
	private String toIp;
	
	private String fromIp;
	
	private String messageId;
	
	private String contentLength;
	
}
