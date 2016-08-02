package com.inchecktech.dpm.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import com.inchecktech.dpm.beans.Band;
import com.inchecktech.dpm.beans.DateDataPoint;
import com.inchecktech.dpm.beans.HistoryDataPoint;
import com.inchecktech.dpm.beans.TimeUnit;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistChartData {

	
	private static final Logger logger = new Logger(PersistChartData.class);

	
	public static final String OVERALL_TYPE_RMS_VEL = "VEL";
	public static final String OVERALL_TYPE_RMS_ACC = "ACC";
	
	public static final String FUNCTION_MAX = "MAX";
	public static final String FUNCTION_MIN = "MIN";
	public static final String FUNCTION_AVG = "AVG";
	public static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	

	/**
	 * 
	 * @param channelID
	 * @param startDateTime
	 * @param endDateTime
	 * @param overallType
	 * @param function
	 * @param timeUnit
	 * @return map of dates and floats
	 */
	public static Map<Date, Float> getChartData(int channelID,
			Date startDateTime, Date endDateTime, String overallType,
			String function, TimeUnit timeUnit){
		HashMap<Date, Float> map = new HashMap<Date, Float>();
		String SQL = "";

		if (!PersistChartData.FUNCTION_MAX.equals(function)
				&& !PersistChartData.FUNCTION_AVG.equals(function)
				&& !PersistChartData.FUNCTION_AVG.equals(function)) {
			logger.error(
					"Unknown function passed to Persist ChartData");
		}

		if (!PersistChartData.OVERALL_TYPE_RMS_ACC.equals(overallType)
				&& !PersistChartData.OVERALL_TYPE_RMS_VEL.equals(overallType)) {
			logger.error("Unknown RMS TYPE passed to Persist ChartData");
		}

		switch (timeUnit) {

		case minute:
			SQL = SQLStatements.queryGetOverallChartDataMinute(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		case hour:
			SQL = SQLStatements.queryGetOverallChartDataHour(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		case day:
			SQL = SQLStatements.queryGetOverallChartDataDay(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;
		case week:
			SQL = SQLStatements.queryGetOverallChartDataWeek(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		case month:
			SQL = SQLStatements.queryGetOverallChartDataMonth(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		case year:
			SQL = SQLStatements.queryGetOverallChartDataYear(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);

			break;

		}

		logger.debug("SQL Statement used " + SQL);

		Connection conn = DAOFactory.getConnection();

		try {
			PreparedStatement stmt = conn.prepareStatement(SQL);
			stmt.setInt(1, channelID);
			stmt.setTimestamp(2, new Timestamp(startDateTime.getTime()));
			stmt.setTimestamp(3, new Timestamp(endDateTime.getTime()));
			stmt.setString(4, overallType);

			ResultSet rs = stmt.executeQuery();

			if (logger.isDebugEnabled()) {
				int columns = rs.getMetaData().getColumnCount();
				for (int i = 1; i <= columns; i++) {
					logger.debug(rs.getMetaData().getColumnName(i));
				}
			}

			while (rs.next()) {

				Date mydate = rs.getTimestamp("MYTIME");
				Float val = rs.getFloat("RMS");
				map.put(mydate, val);
			}

		} catch (SQLException e) {
			logger.error("Error getting chart data", e);
		}

		return map;
	}
	
	/**
	 * 
	 * @param channelID
	 * @param startDateTime
	 * @param endDateTime
	 * @param overallType
	 * @param function
	 * @param timeUnit
	 * @return map of dates and floats
	 */
	public static Vector<DateDataPoint> getChartDataPoints(int channelID,
			Date startDateTime, Date endDateTime, String overallType,
			String function, TimeUnit timeUnit) {
		
		Vector<DateDataPoint> retVec=new Vector<DateDataPoint>();
		String SQL = "";

		if (!PersistChartData.FUNCTION_MAX.equals(function)
				&& !PersistChartData.FUNCTION_AVG.equals(function)
				&& !PersistChartData.FUNCTION_AVG.equals(function)) {
			logger.error("Unknown function passed to Persist ChartData");
		}

		if (!PersistChartData.OVERALL_TYPE_RMS_ACC.equals(overallType)
				&& !PersistChartData.OVERALL_TYPE_RMS_VEL.equals(overallType)) {
			logger.error("Unknown RMS TYPE passed to Persist ChartData");
		}

		switch (timeUnit) {

		case minute:
			SQL = SQLStatements.queryGetOverallChartDataMinute(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		case hour:
			SQL = SQLStatements.queryGetOverallChartDataHour(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		case day:
			SQL = SQLStatements.queryGetOverallChartDataDay(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;
		case week:
			SQL = SQLStatements.queryGetOverallChartDataWeek(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		case month:
			SQL = SQLStatements.queryGetOverallChartDataMonth(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		case year:
			SQL = SQLStatements.queryGetOverallChartDataYear(channelID, FUNCTION_MAX,
					startDateTime, endDateTime);
			break;

		}

		logger.debug("SQL Statement used " + SQL);
		logger.debug("START_TIME=" + startDateTime);
		logger.debug("END_TIME=" + endDateTime);

		Connection conn = DAOFactory.getConnection();

		try {
			PreparedStatement stmt = conn.prepareStatement(SQL);
			stmt.setInt(1, channelID);
			stmt.setTimestamp(2, new Timestamp(startDateTime.getTime()));
			stmt.setTimestamp(3, new Timestamp(endDateTime.getTime()));
			stmt.setString(4, overallType);
			
			ResultSet rs = stmt.executeQuery();

			if (logger.isDebugEnabled()) {
				int columns = rs.getMetaData().getColumnCount();
				for (int i = 1; i <= columns; i++) {
					logger.debug(rs.getMetaData().getColumnName(i));
				}
			}

			while (rs.next()) {

				Date mydate = new Date(rs.getTimestamp("MYTIME").getTime());
				logger.debug("MYTIME=:"+mydate+":");
				Float val = rs.getFloat("RMS");
				retVec.add(new DateDataPoint(mydate,val));
				logger.debug("DATE=" + mydate + " VAL=" + val);
			}
		} catch (SQLException e) {
			logger.error ("SQL Exception while pulling historical data:", e);
		}

		return retVec;
	}

	public static Vector<HistoryDataPoint> getHistoryChartPoints(int channelId, String overall, int bandId, Date startDate, Date endDate, TimeUnit unit) {
        Vector<HistoryDataPoint> retVec = new Vector<HistoryDataPoint>();
        Connection conn = DAOFactory.getConnection();

        try {
            String SQL = SQLStatements.queryGetHistoryData(channelId, overall, bandId, startDate, endDate, unit);
            PreparedStatement cs = conn.prepareStatement(SQL);
            cs.setInt(1, channelId);
            cs.setInt(2, bandId);
            cs.setTimestamp(3, new Timestamp(startDate.getTime()));
            cs.setTimestamp(4, new Timestamp(endDate.getTime()));
            if (overall != null) {
                cs.setString(5, overall);
            }
            ResultSet rs = cs.executeQuery();
            
            if (logger.isDebugEnabled()) {
                int columns = rs.getMetaData().getColumnCount();
                for (int i = 1; i <= columns; i++) {
                    logger.debug(rs.getMetaData().getColumnName(i));
                }
            }

            if (unit == TimeUnit.minute) {
                while (rs.next()) {
                  Date date = new Date(rs.getTimestamp(3).getTime());
                  Float y = rs.getFloat(1);
                  String overallType = rs.getString(2);
                  retVec.add(new HistoryDataPoint(date, y, y, y, overallType));
                }
            } else  {
                while (rs.next()) {
                    Date date = new Date(rs.getTimestamp(5).getTime());
                    Float ymin = rs.getFloat(1);
                    Float ymax = rs.getFloat(2);
                    Float yavg = rs.getFloat(3);
                    String overallType = rs.getString(4);
                    retVec.add(new HistoryDataPoint(date, ymin, ymax, yavg, overallType));
                  }  
            }
        } catch (SQLException e) {
            logger.error ("SQL Exception while pulling history data:", e);
        }

        return retVec;
    }
	
	/**
	 * Get data for Parameters menu for History tab
	 * @return
	 */
	public static Vector<String> getParamatersForHistoryMenu() {
        Vector<String> retVec = new Vector<String>();
        Connection conn = DAOFactory.getConnection();

        try {
            CallableStatement cs = conn.prepareCall("{call sp_get_overalls_dd}");
            ResultSet rs = cs.executeQuery();
            
            if (logger.isDebugEnabled()) {
                int columns = rs.getMetaData().getColumnCount();
                for (int i = 1; i <= columns; i++) {
                    logger.debug(rs.getMetaData().getColumnName(i));
                }
            }

            while (rs.next()) {
              retVec.add(rs.getString(1));
            }
        } catch (SQLException e) {
            logger.error ("SQL Exception while pulling parameters data:", e);
        }

        return retVec;
    }
	
	/**
	 * Get data for Band menu for History tab
	 * @return
	
	 */
	public static Vector<Band> getBandForHistoryMenu(int channel_id) {
	     Vector<Band> retVec = new Vector<Band>();
	        Connection conn = DAOFactory.getConnection();

	        try {
	            CallableStatement cs = conn.prepareCall("{call sp_get_bands_by_channel(" + channel_id + ")}");
	            ResultSet rs = cs.executeQuery();
	            
	            if (logger.isDebugEnabled()) {
	                int columns = rs.getMetaData().getColumnCount();
	                for (int i = 1; i <= columns; i++) {
	                    logger.debug(rs.getMetaData().getColumnName(i));
	                }
	            }
	            
	            Band band;
	            while (rs.next()) {
	                band = new Band();
	                band.setBandId(rs.getInt(1));
	                band.setBandName(rs.getString(2));
	                retVec.add(band);
	            }
	        } catch (SQLException e) {
	            logger.error ("SQL Exception while pulling band data:", e);
	        }

	        return retVec;
	 }
	}

