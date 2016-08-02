/**
 * 
 */
package com.inchecktech.exception;

/**
 * Describe client socket exception
 * 
 * @author
 * 
 */
public class DPMClientSocketException extends Exception {

	/* Serial version UID */
	private static final long serialVersionUID = -3917364799276462491L;

	/**
	 * Default constructor
	 */
	public DPMClientSocketException() {
		super();
	}

	/**
	 * Constructor
	 * 
	 * @param errorMessage
	 *            - error message
	 */
	public DPMClientSocketException(String errorMessage) {
		super(errorMessage);
	}
}
