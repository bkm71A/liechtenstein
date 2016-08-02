package com.inchecktech.dpm.beans;

import java.util.List;

public class UIProcessedData {

	
	
	private int channelId;
	private int samplingRate;
	private String eu;
	private OverallLevels overalls;
	private Double min;
	private Double max;
	private String measurementUnit;
	private String measurementType;
	private java.util.Date dateTimeStamp;
	private String sampleId;
	private EUnit xEUnit;
	private EUnit yEUnit;
	private String xSymbol;
	private String ySymbol;
	private String xPhysDomain;
	private String yPhysDomain;
	private List<ChartDataPoint> chartData;
	private int channelType;
	
	
	public UIProcessedData(ProcessedData pin) {
		channelId=pin.getChannelId();
		samplingRate=pin.getSamplingRate();
		eu=pin.getEU();
		overalls=pin.getOveralls();
		min=pin.getMin();
		max=pin.getMax();
		measurementUnit=pin.getMeasurementUnit();
		measurementType=pin.getMeasurementType();
		dateTimeStamp=pin.getDateTimeStamp();
		sampleId=pin.getSampleId();
		xEUnit=pin.getXEUnit();
		yEUnit=pin.getYEUnit();
		xSymbol=pin.getXSymbol();
		ySymbol=pin.getYSymbol();
		xPhysDomain=pin.getXPhysDomain();
		yPhysDomain=pin.getYPhysDomain();
		chartData=pin.getChartData();
		channelType=pin.getChannelType();
		
	}
	

	public int getChannelId() {
		return channelId;
	}

	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}

	public int getSamplingRate() {
		return samplingRate;
	}

	public void setSamplingRate(int samplingRate) {
		this.samplingRate = samplingRate;
	}

	public String getEu() {
		return eu;
	}

	public void setEu(String eu) {
		this.eu = eu;
	}

	public OverallLevels getOveralls() {
		return overalls;
	}

	public void setOveralls(OverallLevels overalls) {
		this.overalls = overalls;
	}

	public Double getMin() {
		return min;
	}

	public void setMin(Double min) {
		this.min = min;
	}

	public Double getMax() {
		return max;
	}

	public void setMax(Double max) {
		this.max = max;
	}

	public String getMeasurementUnit() {
		return measurementUnit;
	}

	public void setMeasurementUnit(String measurementUnit) {
		this.measurementUnit = measurementUnit;
	}

	public String getMeasurementType() {
		return measurementType;
	}

	public void setMeasurementType(String measurementType) {
		this.measurementType = measurementType;
	}

	public java.util.Date getDateTimeStamp() {
		return dateTimeStamp;
	}

	public void setDateTimeStamp(java.util.Date dateTimeStamp) {
		this.dateTimeStamp = dateTimeStamp;
	}

	public String getSampleId() {
		return sampleId;
	}

	public void setSampleId(String sampleId) {
		this.sampleId = sampleId;
	}

	public EUnit getXEUnit() {
		return xEUnit;
	}

	public void setXEUnit(EUnit unit) {
		xEUnit = unit;
	}

	public EUnit getYEUnit() {
		return yEUnit;
	}

	public void setYEUnit(EUnit unit) {
		yEUnit = unit;
	}

	public String getXSymbol() {
		return xSymbol;
	}

	public void setXSymbol(String symbol) {
		xSymbol = symbol;
	}

	public String getYSymbol() {
		return ySymbol;
	}

	public void setYSymbol(String symbol) {
		ySymbol = symbol;
	}

	public String getXPhysDomain() {
		return xPhysDomain;
	}

	public void setXPhysDomain(String physDomain) {
		xPhysDomain = physDomain;
	}

	public String getYPhysDomain() {
		return yPhysDomain;
	}

	public void setYPhysDomain(String physDomain) {
		yPhysDomain = physDomain;
	}

	public List<ChartDataPoint> getChartData() {
		return chartData;
	}

	public void setChartData(List<ChartDataPoint> chartData) {
		this.chartData = chartData;
	}

}
