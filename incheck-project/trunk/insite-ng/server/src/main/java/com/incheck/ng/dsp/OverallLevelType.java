package com.incheck.ng.dsp;

public enum OverallLevelType {

    KEY_ACCEL_RMS("Accel_Rms"),
    KEY_ACCEL_PEAK("Accel Peak"),
    KEY_DERIVED_PEAK("Derived Peak"),
    KEY_DERIVED_PEAK_TO_PEAK("Derived Peak To Peak"),
    KEY_ACCEL_PEAK_TO_PEAK("Accel Peak To Peak"),
    KEY_VEL_RMS("Vel_Rms"), KEY_VEL_PEAK("Vel Peak"),
    KEY_VEL_PEAK_TO_PEAK("Vel Peak To Peak");

    private final String name;

    OverallLevelType(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}