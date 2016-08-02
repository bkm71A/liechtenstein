package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.Date;

/**
 * The Class DeviceEvent.
 */
public class DeviceEvent implements Serializable {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -7576042755104687139L;

	/** The device id. */
	private int deviceId;

	/** The device mac. */
	private String deviceMac;

	/** The operation. */
	private DeviceOperation operation;

	/** The timestamp. */
	private Date timestamp;

	/**
	 * Instantiates a new device event.
	 */
	public DeviceEvent() {
		super();
	}

	/**
	 * Instantiates a new device event.
	 * 
	 * @param deviceId
	 *            the device id
	 * @param operation
	 *            the operation
	 */
	public DeviceEvent(int deviceId, DeviceOperation operation) {
		this(deviceId, operation, new Date());
	}

	/**
	 * Instantiates a new device event.
	 * 
	 * @param deviceId
	 *            the device id
	 * @param operation
	 *            the operation
	 * @param timestamp
	 *            the timestamp
	 */
	public DeviceEvent(int deviceId, DeviceOperation operation, Date timestamp) {
		super();
		this.deviceId = deviceId;
		this.operation = operation;
		this.timestamp = timestamp;
	}

	/**
	 * Gets the device id.
	 * 
	 * @return the device id
	 */
	public int getDeviceId() {
		return deviceId;
	}

	/**
	 * Sets the device id.
	 * 
	 * @param deviceId
	 *            the new device id
	 */
	public void setDeviceId(int deviceId) {
		this.deviceId = deviceId;
	}

	/**
	 * Gets the device mac.
	 *
	 * @return the device mac
	 */
	public String getDeviceMac() {
		return deviceMac;
	}

	/**
	 * Sets the device mac.
	 *
	 * @param deviceMac the new device mac
	 */
	public void setDeviceMac(String deviceMac) {
		this.deviceMac = deviceMac;
	}

	/**
	 * Gets the operation.
	 * 
	 * @return the operation
	 */
	public DeviceOperation getOperation() {
		return operation;
	}

	/**
	 * Sets the operation.
	 * 
	 * @param operation
	 *            the new operation
	 */
	public void setOperation(DeviceOperation operation) {
		this.operation = operation;
	}

	/**
	 * Gets the timestamp.
	 * 
	 * @return the timestamp
	 */
	public Date getTimestamp() {
		return timestamp;
	}

	/**
	 * Sets the timestamp.
	 * 
	 * @param timestamp
	 *            the new timestamp
	 */
	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}

}
