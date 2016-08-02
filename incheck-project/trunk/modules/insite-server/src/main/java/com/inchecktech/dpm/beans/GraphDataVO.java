package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.List;

/**
 * The Class GraphDataVO.
 */
public class GraphDataVO implements Serializable {

	/* Serial UID */
	private static final long serialVersionUID = 1L;

	/** The chart data. */
	private List<ChartDataPoint> chartData;

	/** The eu. */
	private String eu;

	/** The max. */
	private Double max;

	/** The min. */
	private Double min;

	/** The measurement type. */
	private String measurementType; // "Absolute, Delta";

	/** The measurement unit. */
	private String measurementUnit; // "ms, Hz";

	/** The overalls. */
	private OverallLevels overalls;

	/** The sampling rate. */
	private int samplingRate;

	/** The X symbol. */
	private String XSymbol; // "s, Hz"

	/** The Y symbol. */
	private String YSymbol; // "g";

	/** The X phys domain. */
	private String XPhysDomain; // "Time, Frequency"

	/** The Y phys domain. */
	private String YPhysDomain; // "Velocity, Acceleration";

	/** The XE unit. */
	private String XEUnit; // "TimeSec, FreqHz"

	/** The YE unit. */
	private String YEUnit; // "VelInSec, AccG";

	/**
	 * Instantiates a new graph data vo.
	 */
	public GraphDataVO() {
		super();
	}

	/**
	 * Instantiates a new graph data vo.
	 * 
	 * @param data
	 *            the data
	 */
	public GraphDataVO(UIProcessedData data) {
		super();
		if (data != null) {
			chartData = data.getChartData();
			eu = data.getEu();
			max = data.getMax();
			measurementType = data.getMeasurementType();
			measurementUnit = data.getMeasurementUnit();
			min = data.getMin();
			overalls = data.getOveralls();
			samplingRate = data.getSamplingRate();
			XPhysDomain = data.getXPhysDomain();
			XSymbol = data.getXSymbol();
			YPhysDomain = data.getYPhysDomain();
			YSymbol = data.getYSymbol();
			XEUnit = data.getXEUnit().name();
			YEUnit = data.getYEUnit().name();
		}
	}

	/**
	 * Gets the chart data.
	 * 
	 * @return the chart data
	 */
	public List<ChartDataPoint> getChartData() {
		return chartData;
	}

	/**
	 * Sets the chart data.
	 * 
	 * @param chartData
	 *            the new chart data
	 */
	public void setChartData(List<ChartDataPoint> chartData) {
		this.chartData = chartData;
	}

	/**
	 * Gets the eu.
	 * 
	 * @return the eu
	 */
	public String getEu() {
		return eu;
	}

	/**
	 * Sets the eu.
	 * 
	 * @param eu
	 *            the new eu
	 */
	public void setEu(String eu) {
		this.eu = eu;
	}

	/**
	 * Gets the max.
	 * 
	 * @return the max
	 */
	public Double getMax() {
		return max;
	}

	/**
	 * Sets the max.
	 * 
	 * @param max
	 *            the new max
	 */
	public void setMax(Double max) {
		this.max = max;
	}

	/**
	 * Gets the min.
	 * 
	 * @return the min
	 */
	public Double getMin() {
		return min;
	}

	/**
	 * Sets the min.
	 * 
	 * @param min
	 *            the new min
	 */
	public void setMin(Double min) {
		this.min = min;
	}

	/**
	 * Gets the measurement type.
	 * 
	 * @return the measurement type
	 */
	public String getMeasurementType() {
		return measurementType;
	}

	/**
	 * Sets the measurement type.
	 * 
	 * @param measurementType
	 *            the new measurement type
	 */
	public void setMeasurementType(String measurementType) {
		this.measurementType = measurementType;
	}

	/**
	 * Gets the measurement unit.
	 * 
	 * @return the measurement unit
	 */
	public String getMeasurementUnit() {
		return measurementUnit;
	}

	/**
	 * Sets the measurement unit.
	 * 
	 * @param measurementUnit
	 *            the new measurement unit
	 */
	public void setMeasurementUnit(String measurementUnit) {
		this.measurementUnit = measurementUnit;
	}

	/**
	 * Gets the overalls.
	 * 
	 * @return the overalls
	 */
	public OverallLevels getOveralls() {
		return overalls;
	}

	/**
	 * Sets the overalls.
	 * 
	 * @param overalls
	 *            the new overalls
	 */
	public void setOveralls(OverallLevels overalls) {
		this.overalls = overalls;
	}

	/**
	 * Gets the sampling rate.
	 * 
	 * @return the sampling rate
	 */
	public int getSamplingRate() {
		return samplingRate;
	}

	/**
	 * Sets the sampling rate.
	 * 
	 * @param samplingRate
	 *            the new sampling rate
	 */
	public void setSamplingRate(int samplingRate) {
		this.samplingRate = samplingRate;
	}

	/**
	 * Gets the x symbol.
	 * 
	 * @return the x symbol
	 */
	public String getXSymbol() {
		return XSymbol;
	}

	/**
	 * Sets the x symbol.
	 * 
	 * @param xSymbol
	 *            the new x symbol
	 */
	public void setXSymbol(String xSymbol) {
		XSymbol = xSymbol;
	}

	/**
	 * Gets the y symbol.
	 * 
	 * @return the y symbol
	 */
	public String getYSymbol() {
		return YSymbol;
	}

	/**
	 * Sets the y symbol.
	 * 
	 * @param ySymbol
	 *            the new y symbol
	 */
	public void setYSymbol(String ySymbol) {
		YSymbol = ySymbol;
	}

	/**
	 * Gets the x phys domain.
	 * 
	 * @return the x phys domain
	 */
	public String getXPhysDomain() {
		return XPhysDomain;
	}

	/**
	 * Sets the x phys domain.
	 * 
	 * @param xPhysDomain
	 *            the new x phys domain
	 */
	public void setXPhysDomain(String xPhysDomain) {
		XPhysDomain = xPhysDomain;
	}

	/**
	 * Gets the y phys domain.
	 * 
	 * @return the y phys domain
	 */
	public String getYPhysDomain() {
		return YPhysDomain;
	}

	/**
	 * Sets the y phys domain.
	 * 
	 * @param yPhysDomain
	 *            the new y phys domain
	 */
	public void setYPhysDomain(String yPhysDomain) {
		YPhysDomain = yPhysDomain;
	}

	/**
	 * Gets the xE unit.
	 *
	 * @return the xE unit
	 */
	public String getXEUnit() {
		return XEUnit;
	}

	/**
	 * Sets the xE unit.
	 *
	 * @param xEUnit the new xE unit
	 */
	public void setXEUnit(String xEUnit) {
		XEUnit = xEUnit;
	}

	/**
	 * Gets the yE unit.
	 *
	 * @return the yE unit
	 */
	public String getYEUnit() {
		return YEUnit;
	}

	/**
	 * Sets the yE unit.
	 *
	 * @param yEUnit the new yE unit
	 */
	public void setYEUnit(String yEUnit) {
		YEUnit = yEUnit;
	}

}
