package com.inchecktech.dpm.network.parser;

public interface JsonFieldNameConstants {

	public enum DAM_MESSAGE_TYPE {
		REGISTER, DATA, ASK, CONFIG
	}

	public static final String PROTOCOL_VERSION = "PROTOCOL_VERSION";
	public static final String MESSAGE_TYPE = "MESSAGE_TYPE";
	public static final String DEVICE_ID = "DEVICE_ID";
	public static final String TIMESTAMP = "TIMESTAMP";
    public static final String DEVICE_CHANNEL_ID = "DEVICE_CHANNEL_ID";
    public static final String SAMPLING_RATE = "SAMPLING_RATE";
    public static final String RPM = "RPM";
    public static final String SAMPLE_SIZE = "SAMPLE_SIZE";
    public static final String DATA = "DATA";
    public static final String UNIT = "UNIT";

    public static final String CHANNEL_ID = "chID";
    public static final String SENSOR_ID = "sensID";
    public static final String NAME = "text";
    public static final String CONTENT = "content";
    public static final String ITEMS = "items";
    public static final String LEAF = "leaf";
}
