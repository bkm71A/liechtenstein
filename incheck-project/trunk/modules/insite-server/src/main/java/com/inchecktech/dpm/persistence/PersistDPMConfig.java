package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import com.inchecktech.dpm.beans.Unit;
import com.inchecktech.dpm.config.ConfigItem;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistDPMConfig {

	private static final Logger logger = new Logger(PersistDPMConfig.class);

	public static final String CONFIGURATION_AVERAGES_PARAM = "com.incheckteck.dpm.average.value";
	
	public static void setTimerValue(int seconds) {
		logger.info("setting the systematic persistance interval to " + seconds
				+ " seconds");

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_TIMER_CONFIG);
			pstmt.setInt(1, seconds);
			pstmt.executeUpdate();
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error(
					"SQL Exception while setting the value of timer_freq to "
							+ seconds + " seconds", e);

		}
	}

	/**
	 * 
	 * @return interval of how often the processed data will be saved to DB.
	 *         default is 30 seconds.
	 */
	public static int getTimerValue() {
		// Setting default to 30 seconds
		int value = 30;
		value = Integer.parseInt(getConfigItem("DPMCONFIG", "DPM", "timer_freq").getPropertyValue());

		return value;

	}

	public static Properties getSimChannels() {
		Properties  result = new Properties();
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_SIM_CHANNELS);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				result.put( rs.getInt("CHANNEL_ID"), rs.getInt("CHANNEL_TYPE"));
			}
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception while getting sim channel ids", e);

		} 
		return result;
	}
	/* machine talker code commented
	public static Properties getMTalkerChannels() {
        Properties  result = new Properties();
        try {
            Connection conn = DAOFactory.getConnection();
            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_GET_MTK_CHANNELS);
            ResultSet rs = pstmt.executeQuery();
            
            

            while (rs.next()) {
                result.put( rs.getInt("CHANNEL_ID"), rs.getInt("CHANNEL_TYPE"));
            }
            
            DAOFactory.closeConnection(conn);

        } catch (SQLException e) {
            logger.error("SQL Exception while getting MachineTalker channel ids", e);

        } 
        
        return result;
    }
	machine talker code commented */
	public static ConfigItem getConfigItem(String groupName, String typeName, String propertyName){
		
		ConfigItem item=null; 
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_CONFIG_ITEM);
			pstmt.setString(1, groupName);
			pstmt.setString(2, typeName);
			pstmt.setString(3, propertyName);
			
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
			
				item = new ConfigItem();
				item.setDataType(rs.getString("DATA_TYPE"));
				item.setDefaultValue(rs.getString("DEFAULT_VALUE"));
				item.setDescription(rs.getString("DESCRIPTION"));
				item.setProperty_id(rs.getInt("PROPERTY_ID"));
				item.setPropertyName(rs.getString("PROPERTY_NAME"));
				item.setPropertyValue(rs.getString("DEFAULT_VALUE"));
				item.setUnit(new Unit(rs.getInt("UNIT_ID")));
				
			}
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception while getting sim channel ids", e);

		} 

		return item;		
	}
	
	/**
	 * Update 'run_value' and 'default_value' columns.
	 * @param propertyName
	 * @param runValue
	 */
    public static void updateRunValueOfConfigItem(final String propertyName, final String runValue, final String defaultValue) {
	try {
	    Connection conn = DAOFactory.getConnection();
	    PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_UPDATE_RUN_DEFAULT_VALUE_OF_CONFIG_ITEM);
	    pstmt.setString(1, runValue);
	    pstmt.setString(2, defaultValue);	    
	    pstmt.setString(3, propertyName);
	    pstmt.executeUpdate();
	} catch (SQLException e) {
	    logger.error("SQL Exception while updating configuration parameters", e);
	}
    }

}
