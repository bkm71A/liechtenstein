package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class Location implements Serializable {

    private static final long serialVersionUID = 1L;
	private int locationId;
	private String description;

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
