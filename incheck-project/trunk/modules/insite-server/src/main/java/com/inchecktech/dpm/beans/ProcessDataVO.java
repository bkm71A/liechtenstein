package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.Date;
/**
 * The Class ProcessDataVO.
 */
public class ProcessDataVO implements Serializable {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -3844101232229001273L;

	/** The sample id. */
	private String sampleId;
	
	/** The channel id. */
	private int channelId;
	
	/** The date time stamp. */
	private Date dateTimeStamp;
	
	/** The acceleration data. */
	private FunctionDataVO accelerationData;
	
	/** The velocity data. */
	private FunctionDataVO velocityData;	
	
    /* Exponential Averages data for the acceleration */
    private FunctionDataVO accelerationDataAveragesExp;

    /* Exponential Averages data for the velocity */
    private FunctionDataVO velocityDataAveragesExp;

    /* Linear Averages data for the acceleration */
    private FunctionDataVO accelerationDataAveragesLinear;

    /* Linear Averages data for the velocity */
    private FunctionDataVO velocityDataAveragesLinear;

    /* PeakHold Averages data for the acceleration */
    private FunctionDataVO accelerationDataAveragesPeakHold;

    /* PeakHold Averages data for the velocity */
    private FunctionDataVO velocityDataAveragesPeakHold;
	
	/**
	 * Gets the sample id.
	 *
	 * @return the sample id
	 */
	public String getSampleId() {
		return sampleId;
	}
	
	/**
	 * Sets the sample id.
	 *
	 * @param sampleId the new sample id
	 */
	public void setSampleId(String sampleId) {
		this.sampleId = sampleId;
	}
	
	/**
	 * Gets the channel id.
	 *
	 * @return the channel id
	 */
	public int getChannelId() {
		return channelId;
	}
	
	/**
	 * Sets the channel id.
	 *
	 * @param channelId the new channel id
	 */
	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}
	
	/**
	 * Gets the date time stamp.
	 *
	 * @return the date time stamp
	 */
	public Date getDateTimeStamp() {
		return dateTimeStamp;
	}
	
	/**
	 * Sets the date time stamp.
	 *
	 * @param dateTimeStamp the new date time stamp
	 */
	public void setDateTimeStamp(Date dateTimeStamp) {
		this.dateTimeStamp = dateTimeStamp;
	}
	
    /**
     * Create empty <code>FunctionDataVO</code> instance.
     * 
     * @return
     */
    private FunctionDataVO createEmptyFunctionDataVO() {
	FunctionDataVO result = new FunctionDataVO();
	result.setSpectrumData(new GraphDataVO());
	result.setWaveformData(new GraphDataVO());
	return result;
    }

    /**
     * @return the accelerationDataAveragesExp
     */
    public FunctionDataVO getAccelerationDataAveragesExp() {
	if (this.accelerationDataAveragesExp == null) {
	    this.accelerationDataAveragesExp = createEmptyFunctionDataVO();
	}
	return this.accelerationDataAveragesExp;
    }

    /**
     * @param accelerationDataAveragesExp
     *            the accelerationDataAveragesExp to set
     */
    public void setAccelerationDataAveragesExp(FunctionDataVO accelerationDataAveragesExp) {
	this.accelerationDataAveragesExp = accelerationDataAveragesExp;
    }

    /**
     * @return the velocityDataAverages
     */
    public FunctionDataVO getVelocityDataAveragesExp() {
	if (this.velocityDataAveragesExp == null) {
	    this.velocityDataAveragesExp = createEmptyFunctionDataVO();
	}
	return this.velocityDataAveragesExp;
    }

    /**
     * @param velocityDataAverages
     *            the velocityDataAverages to set
     */
    public void setVelocityDataAveragesExp(FunctionDataVO velocityDataAveragesExp) {
	this.velocityDataAveragesExp = velocityDataAveragesExp;
    }

    /**
     * @return the accelerationDataAveragesLinear
     */
    public FunctionDataVO getAccelerationDataAveragesLinear() {
	if (this.accelerationDataAveragesLinear == null) {
	    this.accelerationDataAveragesLinear = createEmptyFunctionDataVO();
	}
	return this.accelerationDataAveragesLinear;
    }

    /**
     * @param accelerationDataAveragesLinear
     *            the accelerationDataAveragesLinear to set
     */
    public void setAccelerationDataAveragesLinear(FunctionDataVO accelerationDataAveragesLinear) {
	this.accelerationDataAveragesLinear = accelerationDataAveragesLinear;
    }

    /**
     * @return the velocityDataAveragesLinear
     */
    public FunctionDataVO getVelocityDataAveragesLinear() {
	if (this.velocityDataAveragesLinear == null) {
	    this.velocityDataAveragesLinear = createEmptyFunctionDataVO();
	}
	return this.velocityDataAveragesLinear;
    }

    /**
     * @param velocityDataAveragesLinear
     *            the velocityDataAveragesLinear to set
     */
    public void setVelocityDataAveragesLinear(FunctionDataVO velocityDataAveragesLinear) {
	this.velocityDataAveragesLinear = velocityDataAveragesLinear;
    }

    /**
     * @return the accelerationDataAveragesPeakHold
     */
    public FunctionDataVO getAccelerationDataAveragesPeakHold() {
	if (this.accelerationDataAveragesPeakHold == null) {
	    this.accelerationDataAveragesPeakHold = createEmptyFunctionDataVO();
	}
	return this.accelerationDataAveragesPeakHold;
    }

    /**
     * @param accelerationDataAveragesPeakHold
     *            the accelerationDataAveragesPeakHold to set
     */
    public void setAccelerationDataAveragesPeakHold(FunctionDataVO accelerationDataAveragesPeakHold) {
	this.accelerationDataAveragesPeakHold = accelerationDataAveragesPeakHold;
    }

    /**
     * @return the velocityDataAveragesPeakHold
     */
    public FunctionDataVO getVelocityDataAveragesPeakHold() {
	if (this.velocityDataAveragesPeakHold == null) {
	    this.velocityDataAveragesPeakHold = createEmptyFunctionDataVO();
	}
	return this.velocityDataAveragesPeakHold;
    }

    /**
     * @param velocityDataAveragesPeakHold
     *            the velocityDataAveragesPeakHold to set
     */
    public void setVelocityDataAveragesPeakHold(FunctionDataVO velocityDataAveragesPeakHold) {
	this.velocityDataAveragesPeakHold = velocityDataAveragesPeakHold;
    }

    /**
     * @return the accelerationData
     */
    public FunctionDataVO getAccelerationData() {
        return accelerationData;
    }

    /**
     * @param accelerationData the accelerationData to set
     */
    public void setAccelerationData(FunctionDataVO accelerationData) {
        this.accelerationData = accelerationData;
    }

    /**
     * @return the velocityData
     */
    public FunctionDataVO getVelocityData() {
        return velocityData;
    }

    /**
     * @param velocityData the velocityData to set
     */
    public void setVelocityData(FunctionDataVO velocityData) {
        this.velocityData = velocityData;
    }
}
