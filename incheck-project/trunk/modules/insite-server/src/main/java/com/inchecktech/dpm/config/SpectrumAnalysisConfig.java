package com.inchecktech.dpm.config;
import java.io.Serializable;

public class SpectrumAnalysisConfig implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private int damSamplingRate;  
	private int analysisBandwidth;
	private int spectrumLines;
	private int damBlockSize;
	private int dspSamplingRate;
	private boolean current;
	private int channelId;

		
	public int getChannelId() {
		return channelId;
	}
	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}
	public int getDamSamplingRate() {
		return damSamplingRate;
	}
	public void setDamSamplingRate(int damSamplingRate) {
		this.damSamplingRate = damSamplingRate;
	}
	public int getAnalysisBandwidth() {
		return analysisBandwidth;
	}
	public void setAnalysisBandwidth(int analysisBandwidth) {
		this.analysisBandwidth = analysisBandwidth;
	}
	public int getSpectrumLines() {
		return spectrumLines;
	}
	public void setSpectrumLines(int spectrumLines) {
		this.spectrumLines = spectrumLines;
	}
	public int getDamBlockSize() {
		return damBlockSize;
	}
	public void setDamBlockSize(int daBlockSize) {
		this.damBlockSize = daBlockSize;
	}
	public int getDspSamplingRate() {
		return dspSamplingRate;
	}
	public void setDspSamplingRate(int dspSamplingRate) {
		this.dspSamplingRate = dspSamplingRate;
	}
	public boolean isCurrent() {
		return current;
	}
	public void setCurrent(boolean current) {
		this.current = current;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nSpectrumAnalysisConfig:");
		sb.append("\n\t").append("damSamplingRate=").append(damSamplingRate);
		sb.append("\n\t").append("analysisBandwidth=").append(analysisBandwidth);
		sb.append("\n\t").append("spectrumLines=").append(spectrumLines);
		sb.append("\n\t").append("damBlockSize=").append(damBlockSize);
		sb.append("\n\t").append("dspSamplingRate=").append(dspSamplingRate);
		sb.append("\n\t").append("current=").append(current);
		sb.append("\n\t").append("channelId=").append(channelId);
		
		return sb.toString();
	}
}
