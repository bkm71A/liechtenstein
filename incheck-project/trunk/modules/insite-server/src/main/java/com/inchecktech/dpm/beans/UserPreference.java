package com.inchecktech.dpm.beans;

import java.io.Serializable;

public class UserPreference implements Serializable {
	
	/** The Constant DISPLAYED_PRECISION_TYPE. */
	public static final String DISPLAYED_PRECISION_TYPE = "DisplayedPrecision";
	
	/** The Constant ACCELERATION_REF_LEVEL_TYPE. */
	public static final String ACCELERATION_REF_LEVEL_TYPE = "AccelerationRefLevel";
	
	/** The Constant VELOCITY_REF_LEVEL_TYPE. */
	public static final String VELOCITY_REF_LEVEL_TYPE = "VelocityRefLevel";
	
	/** Acceleration average type preference */
	public static final String ACCELERATION_AVERAGE_TYPE = "AccelerationAvarage"; 
	
	/** Acceleration average type prefix */
	public static final String ACCELERATION_AVERAGE_KEY_PREFIX = "_acc_average";
	
	/** The Constant SCIENTIFIC_NOTATION_THRESHOLD_TYPE. */
	public static final String SCIENTIFIC_NOTATION_THRESHOLD_TYPE = "ScientificNotationThreshold";
	
	/** The Constant DEFAULT_DISPLAYED_PRECISION. */
	public static final String DEFAULT_DISPLAYED_PRECISION = "4";
	
	public static final String DEFAULT_ACC_REF_LEVEL = "1";
	
	/** The Constant DEFAULT_VEL_REF_LEVEL. */
	public static final String DEFAULT_VEL_REF_LEVEL = "1";
	
	/** The Constant DEFAULT_SCIENTIFIC_NOTATION_THRESHOLD. */
	public static final String DEFAULT_SCIENTIFIC_NOTATION_THRESHOLD = "3";
	
	/** The Constant DISPLAYED_PRECISION_KEY_PREFIX. */
	public static final String DISPLAYED_PRECISION_KEY_PREFIX = "_precision";
	
	/** The Constant SCIENTIFIC_NOTATION_THRESHOLD_KEY_PREFIX. */
	public static final String SCIENTIFIC_NOTATION_THRESHOLD_KEY_PREFIX= "_threshold";
	
	/** The Constant ACC_REF_LEVEL_KEY_PREFIX. */
	public static final String ACC_REF_LEVEL_KEY_PREFIX= "_acc_ref_level";
	
	/** The Constant VEL_REF_LEVEL_KEY_PREFIX. */
	public static final String VEL_REF_LEVEL_KEY_PREFIX= "_vel_ref_level";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int id;
	private String key;
	private String value;
	private String type;
	private int level;
	private String description;
	private String delim = ";";
	
	public UserPreference(){};
	
	public UserPreference(String key) {
		this.key = key;
	}

	public UserPreference(String key, String value) {
		this.key = key;
		this.value = value;
	}

	/**
	 * Instantiates a new user preference.
	 * 
	 * @param key the key
	 * @param value the value
	 * @param type the type
	 */
	public UserPreference(String key, String value, String type) {
		super();
		this.key = key;
		this.value = value;
		this.type = type;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	@Override
	public String toString() {
		StringBuilder str = new StringBuilder("UserPreference:");
		str.append("id=")
		.append(id)
		.append(delim)
		
		.append("key=")
		.append(key)
		.append(delim)
		
		.append("value=")
		.append(value)
		.append(delim)
		
		.append("type=")
		.append(type)
		.append(delim)
		
		.append("level=")
		.append(level)
		.append(delim)

		.append("description=")
		.append(description)
		.append(delim)
		;
		
		return str.toString();
		
	}	
}
