package com.inchecktech.dpm.beans;

import java.io.Serializable;

/**
 * The Class FunctionDataVO.
 */
public class FunctionDataVO implements Serializable {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -573641973920215841L;

	/** The waveform data. */
	public GraphDataVO waveformData;

	/** The spectrum data. */
	public GraphDataVO spectrumData;

	/**
	 * Gets the waveform data.
	 *
	 * @return the waveform data
	 */
	public GraphDataVO getWaveformData() {
		return waveformData;
	}

	/**
	 * Sets the waveform data.
	 *
	 * @param waveformData the new waveform data
	 */
	public void setWaveformData(GraphDataVO waveformData) {
		this.waveformData = waveformData;
	}

	/**
	 * Gets the spectrum data.
	 *
	 * @return the spectrum data
	 */
	public GraphDataVO getSpectrumData() {
		return spectrumData;
	}

	/**
	 * Sets the spectrum data.
	 *
	 * @param spectrumData the new spectrum data
	 */
	public void setSpectrumData(GraphDataVO spectrumData) {
		this.spectrumData = spectrumData;
	}

}
