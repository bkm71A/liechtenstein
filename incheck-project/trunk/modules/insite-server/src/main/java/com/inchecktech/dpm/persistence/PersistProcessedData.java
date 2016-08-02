package com.inchecktech.dpm.persistence;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;
import com.inchecktech.dpm.utils.SimpleConverter;
import com.inchecktech.dpm.utils.SimpleValidator;

public class PersistProcessedData {
	private static final Logger logger = new Logger(PersistProcessedData.class);

	/**
	 * 
	 * @param channelID
	 * @param startDate
	 * @param endDate
	 * @return List<ProcessedData>
	 * @throws DPMException
	 */
	public static List<Date> retrieveAvailDates(int channelID, Date startDate,
			Date endDate) {

		logger.info("start retrieveAvailDates for channelID=" + channelID
				+ " startDate=" + startDate + " endDate=" + endDate);
		List<Date> dateRange = new ArrayList<Date>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_PROCESSED_DATA_DATES);
			pstmt.setInt(1, channelID);
			pstmt.setTimestamp(2, new Timestamp(startDate.getTime()));
			pstmt.setTimestamp(3, new Timestamp(endDate.getTime()));
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				dateRange.add(rs.getTimestamp("SAMPLE_TIME"));
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("retrieveAvailDates", se);
		} 

		logger.info("end retrieveAvailDates returning " + dateRange.size()
				+ " dates");
		return dateRange;
	}

	/**
	 * 
	 * @param channelID
	 * @param date
	 * @return ProcessedData
	 */
	public static ProcessedData retrieveProcessedData(int channelID, Date date) {

		logger.info("retrieveProcessedData for channelID=" + channelID
				+ " and date " + date);
		ProcessedData data = null;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_SAMPLE_VIBRATION);
			pstmt.setInt(1, channelID);
			pstmt.setTimestamp(2, new Timestamp(date.getTime()));

			ResultSet rs = pstmt.executeQuery();

			if (!rs.next()) {
				logger
						.info("Not able to find any data for specified date/channelID, will return an empty vector");
				DAOFactory.closeConnection(conn);
				return data;
			}

			// should only return one object back
			data = (ProcessedData) SimpleConverter.getObject(rs.getBytes(1));
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("retrieveProcessedData", se);
		} catch (IOException e) {
			logger.error("retrieveProcessedData", e);
		} catch (ClassNotFoundException e) {
			logger.error("ClassNotFoundException in retrieveProcessedData", e);
		} 

		logger.info("retrieveProcessedData returning " + data.getData().size()
				+ " items");
		return data;

	}

	/**
	 * 
	 * @param channelID
	 * @param numberOfSamples
	 * @return List<ProcessedData>
	 */
	public static List<ProcessedData> retrieveProcessedData(int channelID,
			int numberOfSamples) {

		logger.info("retrieveProcessedData for channelId=" + channelID
				+ " and number of samples=" + numberOfSamples);

		List<ProcessedData> retval = new ArrayList<ProcessedData>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_PROCESSED_DATA_LATEST_N);
			pstmt.setInt(1, numberOfSamples);
			pstmt.setInt(2, channelID);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				ProcessedData data = (ProcessedData) SimpleConverter
						.getObject(rs.getBytes("SAMPLE_VALUE"));
				retval.add(data);
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("retrieveProcessedData", se);
		} catch (IOException e) {
			logger.error("retrieveProcessedData", e);
		} catch (ClassNotFoundException e) {
			logger.error("retrieveProcessedData", e);
		}

		logger.info("retrieveProcessedData returning " + retval.size()
				+ " samples");

		return retval;

	}

	/**
	 * 
	 * @param channelID
	 * @param dates
	 * @return List<ProcessedData>
	 */
	public static List<ProcessedData> retrieveProcessedDataList(int channelID,
			List<Date> dates) {

		logger.info("retrieveProcessedDataList for channelId=" + channelID
				+ " and dates=" + dates);

		List<ProcessedData> list = new ArrayList<ProcessedData>();
		SimpleValidator.validateChannelId(channelID);
		if (null != dates && !dates.isEmpty()) {
			for (Date date : dates) {
				list.add(retrieveProcessedData(channelID, date));
			}
		}

		logger.info("retrieveProcessedDataList returning " + list.size()
				+ " dates");

		return list;
	}

	public static void storeSampleOverall(int sampleId, String overallType,
			int bandId, double overallValue) {

		logger.debug("storeSampleOverall for sample=" + sampleId
				+ " and overalLTypeId=" + overallType);

		Connection conn = DAOFactory.getConnection();
		
		try {

			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_INSERT_SAMPLE_OVERALL);

			pstmt.setInt(1, sampleId);
			pstmt.setString(2, overallType);
			pstmt.setInt(3, bandId);
			pstmt.setDouble(4, overallValue);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			logger.error("sql error:", e);
		}
		DAOFactory.closeConnection(conn);
		logger.debug("storeProcessedData inserted " + sampleId + " sample");

	}

	public static int storeSampleMain(int channelId, Date sampleTime,
			int sampleRate, double rpm, boolean isAlarm, int unitId,
			String comments) {
		int sampleId = 0;

		Connection 	conn = DAOFactory.getConnection();

		PreparedStatement pstmt;
		try {
			pstmt = conn.prepareStatement(
					SQLStatements.QUERY_INSERT_SAMPLE_MAIN,
					PreparedStatement.RETURN_GENERATED_KEYS);

			pstmt.setInt(1, channelId);

			if (null != sampleTime) {
				Timestamp timestamp = new Timestamp(sampleTime.getTime());
				pstmt.setTimestamp(2, timestamp);
			} else {
				Timestamp timestamp = new Timestamp(System.currentTimeMillis());
				pstmt.setTimestamp(2, timestamp);
			}
			pstmt.setInt(3, sampleRate);
			pstmt.setDouble(4, rpm);
			pstmt.setBoolean(5, isAlarm);
			pstmt.setInt(6, unitId);
			pstmt.setString(7, comments);

			pstmt.executeUpdate();

			ResultSet rs = pstmt.getGeneratedKeys();

			if (rs.next()) {
				ResultSetMetaData rsmd = rs.getMetaData();
				int colCount = rsmd.getColumnCount();
				do {
					for (int i = 1; i <= colCount; i++) {
						sampleId = rs.getInt(i);
					}
				} while (rs.next());
			}

		} catch (SQLException e) {
			logger.error("sql error", e);
		}

		return sampleId;

	}

	/**
	 * 
	 * @param sampleId
	 * @param data
	 * @throws DPMException
	 * @throws SQLException
	 */
	public static void storeSampleVibration(int sampleId, byte[] data) {

		logger.debug("storeSampleVibration storing data for sample=" + sampleId);

		Connection 	conn = DAOFactory.getConnection();
		
		try {
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_INSERT_SAMPLE_VIBRATION);
			pstmt.setInt(1, sampleId);
			pstmt.setBytes(2, data);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			logger.error("an error occured", e);		
		}

		DAOFactory.closeConnection(conn);
		logger.debug("storeProcessedData inserted " + sampleId + " sample");

	}

//	@Deprecated
//	public static int storeProcessedData(ProcessedData data, Double rpm,
//			boolean isAlarm, Date overwriteTime, int channelType,
//			String overallKey, String comments) throws DPMException {
//
//		logger.debug("storeProcessedData storing " + data);
//		Connection conn = DAOFactory.getConnection();
//		OverallLevels overalls = data.getOveralls();
//		int sampleId = 0;
//
//		try {
//			PreparedStatement pstmt = conn.prepareStatement(
//					SQLStatements.QUERY_INSERT_PROCESSED_DATA,
//					PreparedStatement.RETURN_GENERATED_KEYS);
//			pstmt.setInt(1, data.getChannelId());
//
//			if (null != overwriteTime) {
//				Timestamp timestamp = new Timestamp(overwriteTime.getTime());
//				pstmt.setTimestamp(2, timestamp);
//			} else {
//				Timestamp timestamp = new Timestamp(data
//						.getDateTimeStampMillis());
//				pstmt.setTimestamp(2, timestamp);
//			}
//
//			pstmt.setInt(3, data.getSamplingRate());
//			pstmt.setInt(4, data.getData().size());
//
//			if (null == rpm) {
//				rpm = new Double(0);
//			}
//			pstmt.setDouble(5, rpm);
//
//			if (null == overalls.getOverall(overallKey)) {
//				Double overVal = new Double(0);
//				pstmt.setDouble(6, overVal);
//			} else {
//				pstmt.setDouble(6, overalls
//						.getOverall(ProcessedData.KEY_OVRL_SUBTYPE_RMS));
//			}
//
//			pstmt.setInt(7, Unit.UNIT_FPS);
//			pstmt.setBoolean(8, isAlarm);
//			pstmt.setString(9, comments);
//			pstmt.setBytes(10, SimpleConverter.getBytes(data));
//			pstmt.setString(11, DomainType.DOMAIN_ACC);
//			pstmt.executeUpdate();
//
//			ResultSet rs = pstmt.getGeneratedKeys();
//
//			if (rs.next()) {
//				ResultSetMetaData rsmd = rs.getMetaData();
//				int colCount = rsmd.getColumnCount();
//				do {
//					for (int i = 1; i <= colCount; i++) {
//						sampleId = rs.getInt(i);
//					}
//				} while (rs.next());
//			}
//
//			logger.debug("storeProcessedData inserted " + sampleId + " sample");
//
//		} catch (SQLException se) {
//			logger.error("storeProcessedData", se);
//			DAOFactory.closeConnection(conn);
//		} catch (IOException e) {
//			throw new DPMException("IO Exception occured", e);
//		}
//		logger.debug("storeProcessedData successfully stored " + data);
//		DAOFactory.closeConnection(conn);
//		return sampleId;
//	}

	// public static List<OverallLevels> getOveralls(int channelId, int type,
	// Date startDate, Date endDate) {
	// return null;
	// }

}