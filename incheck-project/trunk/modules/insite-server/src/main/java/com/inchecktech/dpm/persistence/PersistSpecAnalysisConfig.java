package com.inchecktech.dpm.persistence;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.config.SpectrumAnalysisConfig;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistSpecAnalysisConfig implements Serializable {

	private static final long serialVersionUID = 1L;
	private static final Logger logger = new Logger(
			PersistSpecAnalysisConfig.class);

	public static final String SAMPLING_RATE = "com.inchecktech.dpm.dam.SamplingRate";
	public static final String BLOCK_SIZE = "com.inchecktech.dpm.dam.BlockSize";
	public static final String ANALYSIS_BANDWIDTH = "com.inchecktech.dpm.dam.AnalysisBandwidth";
	public static final String NUMBER_OF_LINES = "com.inchecktech.dpm.dam.NoOfLines";

	public static ArrayList<SpectrumAnalysisConfig> getSpectrumAnalysisConfig(
			int channelId) {
		logger.debug("start getSpectrumAnalysisConfig");

		ArrayList<SpectrumAnalysisConfig> list = new ArrayList<SpectrumAnalysisConfig>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_GET_SPECTRUM_ANALYSIS_CONFIG_ALL);

			pstmt.setInt(1, channelId);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				SpectrumAnalysisConfig sac = new SpectrumAnalysisConfig();
				int analysisBandwidth = rs.getInt("ANALYSIS_BANDWIDTH");
				int dspSamplRate = (int) (analysisBandwidth * 2.56f);
				int damSamplRate = dspSamplRate;
				int spectrumLines = rs.getInt("SPECTRUM_LINES");
				int damBlockSize = (int)(spectrumLines * 2.56f);
				sac.setChannelId(channelId);
				sac.setDamSamplingRate(damSamplRate);
				sac.setAnalysisBandwidth(analysisBandwidth);
				sac.setSpectrumLines(spectrumLines);
				sac.setDamBlockSize(damBlockSize);
				sac.setDspSamplingRate(dspSamplRate);
				list.add(sac);
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("getSpectrumAnalysisConfig", se);
		} 
		setCurrentSpectrumConfig(list);
		logger.debug("end getSpectrumAnalysisConfig");
		return list;
	}

	public static Status updateSpecForChannel(SpectrumAnalysisConfig config) {
		Status status = new Status();
		status.setMessage("This method is not yet implemented");
		status.setStatus(Status.STATUS_WARNING);

		int channelId = config.getChannelId();
		//int sampleRate = config.getDamSamplingRate();
		//int blockSize = config.getDamBlockSize();
		//int analysisBandwith = config.getAnalysisBandwidth();
		//int numberOfLines = config.getSpectrumLines();

		Map<String, Integer> props = new HashMap<String, Integer>();
		props.put("com.inchecktech.dpm.dam.NoOfLines", config
				.getSpectrumLines());
		props.put("com.inchecktech.dpm.dam.AnalysisBandwidth", config
				.getAnalysisBandwidth());
		props.put("com.inchecktech.dpm.dam.SamplingRate", config
				.getDamSamplingRate());
		props
				.put("com.inchecktech.dpm.dam.BlockSize", config
						.getDamBlockSize());
		props.put("com.inchecktech.dpm.dsp.CalculationsSamplingRate", config
				.getDspSamplingRate());

		try {
			Connection conn = DAOFactory.getConnection();

			for (String propName : props.keySet()) {
				PreparedStatement pstmt = conn
						.prepareStatement(SQLStatements.QUERY_UPDATE_SPECTRUM_ANALYSIS_CONFIG);

				pstmt.setInt(1, props.get(propName));
				pstmt.setInt(2, channelId);
				pstmt.setString(3, propName);
				pstmt.executeUpdate();

				
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("updateSpecForChannel", e);
		} 
		return status;
	}

	private static void setCurrentSpectrumConfig(
			List<SpectrumAnalysisConfig> config) {
		int channelId = 0;

		int sampleRate = 5120;
		int blockSize = 4096;
		int analysisBandwith = 1000;
		int numberOfLines = 800;
		Properties props = new Properties();

		if (null == config) {
			logger.error("can't retrieve current config, the list is null");
		}else if(null == config.get(0)){
			
			logger
						.error("can't retrieve current config, the list is empty");
		}else{
				channelId = config.get(0).getChannelId();
		}

		if (channelId == 0) {
			logger.error("can't retrieve current config, channelId is 0");
		}

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_CURRENT_SPECTRUM_ANALYSIS_CONFIG);

			pstmt.setInt(1, channelId);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				props.put(rs.getString("PROPERTY_NAME"), rs
						.getString("CONFIG_VALUE"));
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("setCurrentSpectrumConfig", se);
		} 
		try {
			sampleRate = Integer.parseInt(((String) props.get(SAMPLING_RATE)));
			blockSize = Integer.parseInt((String) props.get(BLOCK_SIZE));
			analysisBandwith = Integer.parseInt((String) props.get(ANALYSIS_BANDWIDTH));
			numberOfLines = Integer.parseInt((String) props.get(NUMBER_OF_LINES));
		} catch (NumberFormatException e) {
			logger.error("Can't get the current setting", e);
		}

		boolean currentConfigFound = false;
		for (SpectrumAnalysisConfig conf : config) {
			if (conf.getDamSamplingRate() == sampleRate) {
				if (conf.getDamBlockSize() == blockSize) {
					if (conf.getAnalysisBandwidth() == analysisBandwith) {
						if (conf.getSpectrumLines() == numberOfLines) {
							conf.setCurrent(true);
							currentConfigFound = true;
							break;
						}

					}
				}
			}
		}
		// if current configuration has not been found - set first as default
		if (!currentConfigFound) {
			if ((config != null) && (config.size() > 0)) {
				config.get(0).setCurrent(true);
			}
		}
	}
}