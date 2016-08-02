package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class Sensor implements Serializable {

	private static final long serialVersionUID = 1L;
    private int sensorId;
    private String type;
    private int vendorId;
    private String serialNumber;
    private float sensitivity;

    public int getSensorId() {
        return sensorId;
    }
    public void setSensorId(int sensorId) {
        this.sensorId = sensorId;
    }
    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
    public int getVendorId() {
        return vendorId;
    }
    public void setVendorId(int vendorId) {
        this.vendorId = vendorId;
    }
    public String getSerialNumber() {
        return serialNumber;
    }
    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }
    public float getSensitivity() {
        return sensitivity;
    }
    public void setSensitivity(float sensitivity) {
        this.sensitivity = sensitivity;
    }
}
