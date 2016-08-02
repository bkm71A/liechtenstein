/**
 * Copyright 2008, Incheck, Inc.
 * All Rights Reserved
 *
 * This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended
 * publication of such source code. 
 * 
 */

package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

/**
 * This interface defines a signature for processed dynamic and static data.
 * Flex client should use this interface, not the classes that implement this interface. 
 * 
 * @author Taras Dobrovolsky
 *
 * Change History:
 * 11/07/2007	Taras Dobrovolsky	Initial release
 * 03/19/2008	Taras Dobrovolsky	Added min/max
 * 05/09/2008	Alex Forkosh		Added sampleId field
 * 07/11/2008   Taras Dobrovolsky   Added method declarations for looking up engineering units for X and Y dimensions
 */
public interface ProcessedData extends Serializable {
	
	
	// public static constants
	public final static String EU_VOLTS = "Volts";
	public final static String EU_ACCELERATION = "Acceleration";
	public final static String EU_VELOCITY = "Velocity";
	public final static String EU_DISPLACEMENT = "Displacement";
	
	public final static String EU_VOLTS_ABBR = "V";
	public final static String EU_ACCELERATION_ABBR = "A";
	public final static String EU_VELOCITY_ABBR = "V";
	public final static String EU_DISPLACEMENT_ABBR = "D";
	
	public final static String MEASUREMENT_UNIT_HZ = "Hz";
	public final static String MEASUREMENT_UNIT_MS = "ms";
	
	public final static String MEASUREMENT_TYPE_DELTA = "Delta";
	public final static String MEASUREMENT_TYPE_ABSOLUTE = "Absolute";
	
	public static final String KEY_TREND = "Recent Trend";
	
	public static final String KEY_TIMEWAVE_ACC = "Time Waveform - Acceleration";
	public static final String KEY_SPECTRUM_ACC_PEAK = "Spectrum - Acceleration (Peak)";
	public static final String KEY_SPECTRUM_ACC_RMS = "Spectrum - Acceleration (RMS)";
	
	public static final String KEY_TIMEWAVE_VEL = "Time Waveform - Velocity";	
	public static final String KEY_SPECTRUM_VEL_PEAK = "Spectrum - Velocity (Peak)";
	public static final String KEY_SPECTRUM_VEL_RMS = "Spectrum - Velocity (RMS)";
	
	public static final String KEY_TIMEWAVE_DISPL = "Time Waveform - Displacement";
	public static final String KEY_SPECTRUM_DISPL_PEAK = "Spectrum - Displacement (Peak)";
	public static final String KEY_SPECTRUM_DISPL_RMS = "Spectrum - Displacement (RMS)";
	
	public static final String KEY_OVRL_TREND_ACC_RMS = "Overalls Trend - Acceleration, RMS";
	public static final String KEY_OVRL_TREND_ACC_PEAK = "Overalls Trend - Acceleration, Peak";
	public static final String KEY_OVRL_TREND_ACC_DER_PEAK = "Overalls Trend - Acceleration, D-Peak";
	public static final String KEY_OVRL_TREND_ACC_DER_P2P = "Overalls Trend - Acceleration, D-P2P";
	public static final String KEY_OVRL_TREND_ACC_P2P = "Overalls Trend - Acceleration, P2P";
	
	public static final String KEY_OVRL_TREND_VEL_RMS = "Overalls Trend - Velocity, RMS";
	public static final String KEY_OVRL_TREND_VEL_PEAK = "Overalls Trend - Velocity, Peak";
	public static final String KEY_OVRL_TREND_VEL_DER_PEAK = "Overalls Trend - Velocity, D-Peak";
	public static final String KEY_OVRL_TREND_VEL_DER_P2P = "Overalls Trend - Velocity, D-P2P";
	public static final String KEY_OVRL_TREND_VEL_P2P = "Overalls Trend - Velocity, P2P";
	
	public static final String KEY_OVRL_TREND_DSPL_RMS = "Overalls Trend - Displacement, RMS";
	public static final String KEY_OVRL_TREND_DSPL_PEAK = "Overalls Trend - Displacement, Peak";
	public static final String KEY_OVRL_TREND_DSPL_DER_PEAK = "Overalls Trend - Displacement, D-Peak";
	public static final String KEY_OVRL_TREND_DSPL_DER_P2P = "Overalls Trend - Displacement, D-P2P";
	public static final String KEY_OVRL_TREND_DSPL_P2P = "Overalls Trend - Displacement, P2P";
	
	public static final String KEY_SPECTRUM_BRN_DEM_ACC_PEAK = "Spectrum - Brn Dem Acceleration (Peak)";
	public static final String KEY_SPECTRUM_BRN_DEM_ACC_RMS = "Spectrum - Brn Dem Acceleration (RMS)";
	
	public static final String KEY_OVRL_SUBTYPE_RMS = "RMS";
    public static final String KEY_OVRL_SUBTYPE_PEAK = "Peak";
    public static final String KEY_OVRL_SUBTYPE_DER_PEAK = "D-Peak";
    public static final String KEY_OVRL_SUBTYPE_DER_P2P = "D-P2P";
    public static final String KEY_OVRL_SUBTYPE_P2P = "P2P";
    
    
    
	/**
	 * 
	 * @return channel id
	 */
	public int getChannelId();
	
	/**
	 * 
	 * @return returns unique sampleid
	 */
	public String getSampleId();
	
	/**
	 * Channel type: 1 - dynamic, 2 - static
	 * @return
	 */
	public int getChannelType();
	
	/**
	 * overall levels calculated for specific data set in specific engineering units (A, V, D)
	 * NOTES:
	 *  - Some dynamic data (in Frequency domain) will have no overall levels, the method will return null
	 *  - For static data this will be the only single value available
	 * @return overall levels
	 */
	public OverallLevels getOveralls();
	
	/**
	 * 
	 * @return
	 */
	public List<Double> getData();
	
	/**
	 * engineering units (A, V, D)
	 * @return engineering units (A, V, D)
	 */
	public String getEU();
	
	/**
	 * data sampling rate
	 * @return data sampling rate
	 */
	public int getSamplingRate();
	
	/**
	 * @return the dateTimeStamp
	 */
	public java.util.Date getDateTimeStamp();
	
	/**
	 * @return the dateTimeStamp in milliseconds since 1970
	 */
	public long getDateTimeStampMillis();
	
	/**
	 * 
	 * @return
	 */
	public List<Double> getDataLabels();
	
	/**
	 * 
	 * @return
	 */
	public void setDataLabels(List<Double> dataLabels);
	
	
	public void setChartData(List<ChartDataPoint> d);
	
	public List<ChartDataPoint>  getChartData();
	
	/**
	 * Get maximum element from the processed data set
	 * @return maximum element from the processed data set
	 */
	public Double getMax();
	
	/**
	 * Get minimum element from the processed data set
	 * @return minimum element from the processed data set
	 */
	public Double getMin();
	
	/**
	 * Find new min/max values for data set
	 */
	public void updateMinMax();
	
	/**
	 * @return The measurement type (delta, absolute).  Use static variables ProcessedData.MEASUREMENT_TYPE_* for comparisons (avoid hard-coding)
	 */
	public String getMeasurementType();
	
	/**
	 * @return The measurement unit (Hz, ms).  Use static variables ProcessedData.MEASUREMENT_UNIT_* for comparisons (avoid hard-coding)
	 */
	public String getMeasurementUnit();
	
	/**
     * Creates and new deep copy of the ProcessedDynamicData object
     * 
     * @return Deep copy of the object
     */
    public ProcessedData deepCopy();
    
    /**
     * Get engineering unit the data set is in for X dimension/axis
     * @return engineering unit the data set is in for X dimension/axis
     */
    public EUnit getXEUnit();
    
    /**
     * Set engineering unit of the current data set for X domain (labels)
     * @param eUnit Engineering unit of the current data set for X domain (labels)
     */
    public void setXEUnit(EUnit eUnit);
    
    /**
     * Get engineering unit the data set is in for Y dimension/axis
     * @return engineering unit the data set is in for Y dimension/axis
     */
    public EUnit getYEUnit();
	
    /**
     * Set engineering unit of the current data set for Y domain (data)
     * @param eUnit Engineering unit of the current data set for Y domain (data)
     */
    public void setYEUnit(EUnit eUnit);
    
    /**
     * Get the physical domain (time, frequency etc.) for data set labels (X axis)
     * @return Get the physical domain (time, frequency etc.) for data set labels (X axis)
     */
    public PhysicalDomain getXPhysicalDomin();
    
    /**
     * Get the physical domain (acceleration, velocity, displacement etc.) for data set (Y axis)
     * @return physical domain (acceleration, velocity, displacement etc.) for data set (Y axis)
     */
    public PhysicalDomain getYPhysicalDomain();
    
    /**
     * Convert the labels (X axis) to the target engineering units
     * @param targetUnits target engineering units
     */
    public void convertToEUnitsX(EUnit targetUnits);
    
    /**
     * COnvert data points (Y axis) to the target engineering units
     * @param targetUnits target engineering units
     */
    public void convertToEUnitsY(EUnit targetUnits);
    
    /**
     * Get engineering unit symbol the data set is in for Y dimension/axis
     * @return engineering unit the data set is in for Y dimension/axis
     */
    public String getYSymbol();
    public void setYSymbol( String s);
    
    /**
     * Get engineering unit symbol the data set is in for X dimension/axis
     * @return engineering unit the data set is in for X dimension/axis
     */
    public String getXSymbol();
    
    /**
     * Get the physical domain description (acceleration, velocity, displacement etc.) for data set (Y axis)
     * @return physical domain (acceleration, velocity, displacement etc.) for data set (Y axis)
     */
    public String getYPhysDomain();
    
    /**
     * Get the physical domain description (time, frequency etc.) for data set labels (X axis)
     * @return Get the physical domain description (time, frequency etc.) for data set labels (X axis)
     */
    public String getXPhysDomain();
    
    /**
     * Set the number of zeros appended during re-sampling to make the data radix 2
     * @param noOfZeros number of zeros appended during re-sampling to make the data radix 2 
     */
    public void setNoOfAppendedZeros(int noOfZeros);
    
    /**
     * Get the number of zeros appended during re-sampling to make the data radix 2
     * @return The number of zeros appended during re-sampling to make the data radix 2
     */
    public int getNoOfAppendedZeros();
    
    
    /**
     * 
     * @return HashMap of bandId and OverallValue
     */
	public HashMap<Integer, Double> getAccBandOveralls();

	/**
	 * 
	 * @param bandOveralls (A HashMap of bandId and OverallValue)
	 */
	public void setAccBandOveralls(HashMap<Integer, Double> bandOveralls);

    /**
     * 
     * @return HashMap of bandId and OverallValue (RMS) for velocity
     */
    public HashMap<Integer, Double> getVelBandOveralls();

    /**
     * 
     * @param bandOveralls (A HashMap of bandId and OverallValue) for velocity
     */
    public void setVelBandOveralls(HashMap<Integer, Double> bandOveralls);
	/**
	 * Set data
	 * @param data
	 */
	void setData( List<Double> data );
}
