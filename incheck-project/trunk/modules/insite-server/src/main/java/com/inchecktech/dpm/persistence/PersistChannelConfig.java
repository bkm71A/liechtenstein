package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.Unit;
import com.inchecktech.dpm.config.ChannelConfig;
import com.inchecktech.dpm.config.ChannelConfigItem;
import com.inchecktech.dpm.config.ConfigGroup;
import com.inchecktech.dpm.config.ConfigType;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistChannelConfig {

	private static final Logger logger = new Logger(PersistChannelConfig.class);

	/**
	 * 
	 * @return array of int of available channels
	 */
	public static List<Integer> getAvailableChannels() {
		logger.debug("getting available channels");

		List<Integer> result = new ArrayList<Integer>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_AVAIL_CHANNELS);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				result.add(rs.getInt("CHANNEL_ID"));
			}

			DAOFactory.closeConnection(conn);
		} catch (SQLException e) {
			logger
					.error(
							"SQL Exception, unable to get available channels, check the logs for exception",
							e);
		} 
		
		logger.debug("found " + result.size() + " channels configured : " + result);
		return result;
	}

	/**
	 * 
	 * @param channelId
	 * @return channel config map of key,value pairs.
	 */
	public static Map<String, String> readChannelConfig(int channelId) {

		Map<String, String> properties = new HashMap<String, String>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_CHANNEL_CONFIG_BY_CHANNEL);
			stmt.setInt(1, channelId);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				properties.put(rs.getString("CHANNEL_KEY"), rs
						.getString("CHANNEL_VALUE"));
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("An error occured trying to read channel config", e);
		}

		return properties;
	}

	public static ChannelConfig getChannelConfig(List<String> channelType) {

		logger.debug("getting ChannelConfig for " + channelType);

		ChannelConfig config = new ChannelConfig();
		ArrayList<ChannelConfigItem> channelConfigItems = null;
		ConfigGroup group = null;
		ConfigType configType = null;
		ChannelConfigItem item=null;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_CHANNEL_CONFIG_BY_TYPE);

			
			for (int i = 0; i < channelType.size(); i++) {
				logger.debug("setting channelType to "
						+ channelType.get(i).toUpperCase());
				stmt.setString(1, channelType.get(i).toUpperCase());
				ResultSet rs = stmt.executeQuery();
				while (rs.next()) {

					if (null == channelConfigItems) {
						logger.debug("creating new config items");
						channelConfigItems = new ArrayList<ChannelConfigItem>();
					}

					if (null == group) {
						group = new ConfigGroup();
						group.setConfigGroupId(rs.getInt("GROUP_ID"));
						group.setConfigGroupName(rs.getString("GROUP_NAME"));
						group.setConfigGroupDescription(rs
								.getString("GROUP_DESCRIPTION"));
						config.setConfigGroup(group);
					}

					if (null == configType) {
						configType = new ConfigType();
						configType.setConfigTypeId(rs.getInt("CONFIG_TYPE_ID"));
						configType.setConfigTypeName(rs
								.getString("CONFIG_TYPE_NAME"));
						configType.setConfigTypeDescription(rs
								.getString("CONFIG_TYPE_DESCRIPTION"));
						config.setConfigType(configType);
					}

					item = new ChannelConfigItem();
					item.setDataType(rs.getString("DATA_TYPE"));
					item.setDefaultValue(rs.getString("DEFAULT_VALUE"));
					item.setDescription(rs.getString("DESCRIPTION"));
					item.setPropertyName(rs.getString("PROPERTY_NAME"));
					item.setProperty_id(rs.getInt("PROPERTY_ID"));
					item.setPropertyValue(rs.getString("CONFIG_VALUE"));
					item.setUnit(new Unit(rs.getInt("UNIT_ID")));

					//logger.debug("adding item " + item);
					channelConfigItems.add(item);
				}
	
			
			}
			

			
			DAOFactory.closeConnection(conn);

			config.setChannelConfigItems(channelConfigItems);

		} catch (SQLException e) {
			logger.error("An error occured trying to read channel config", e);
		} 

		return config;

	}
	
	
	public static ChannelConfig getChannelConfig(int channelId) {

		logger.debug("getting ChannelConfig for " + channelId);

		ChannelConfig config = new ChannelConfig();
		ArrayList<ChannelConfigItem> channelConfigItems = null;
		ConfigGroup group = null;
		ConfigType configType = null;
		ChannelConfigItem item=null;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_CHANNEL_CONFIG_BY_CHANNEL);
			pstmt.setInt(1, channelId);

			ResultSet rs = pstmt.executeQuery();
				while (rs.next()) {

					if (null == channelConfigItems) {
						logger.debug("creating new config items");
						channelConfigItems = new ArrayList<ChannelConfigItem>();
					}

					if (null == group) {
						group = new ConfigGroup();
						group.setConfigGroupId(rs.getInt("GROUP_ID"));
						group.setConfigGroupName(rs.getString("GROUP_NAME"));
						group.setConfigGroupDescription(rs
								.getString("GROUP_DESCRIPTION"));
						config.setConfigGroup(group);
					}

					if (null == configType) {
						configType = new ConfigType();
						configType.setConfigTypeId(rs.getInt("CONFIG_TYPE_ID"));
						configType.setConfigTypeName(rs
								.getString("CONFIG_TYPE_NAME"));
						configType.setConfigTypeDescription(rs
								.getString("CONFIG_TYPE_DESCRIPTION"));
						config.setConfigType(configType);
					}

					item = new ChannelConfigItem();
					item.setDataType(rs.getString("DATA_TYPE"));
					item.setDefaultValue(rs.getString("DEFAULT_VALUE"));
					item.setDescription(rs.getString("DESCRIPTION"));
					item.setPropertyName(rs.getString("CHANNEL_KEY"));
					item.setProperty_id(rs.getInt("PROPERTY_ID"));
					item.setPropertyValue(rs.getString("CHANNEL_VALUE"));
					item.setUnit(new Unit(rs.getInt("UNIT_ID")));

					//logger.debug("adding item " + item);
					channelConfigItems.add(item);
				}
	
			DAOFactory.closeConnection(conn);

			config.setChannelConfigItems(channelConfigItems);

		} catch (SQLException e) {
			logger.error("An error occured trying to read channel config", e);
		} 

		return config;

	}

	public static Status overrideConfigItem(int channel_id, int property_id,
			String overrideValue)  {
		
		Status status = new Status();
		try{
		
			insertOverrideConfigItem(channel_id, property_id, overrideValue);
			status.setStatus(Status.STATUS_SUCCESS);
			status.setMessage("inserted configItem with value " + overrideValue);
		} catch (SQLException e) {
			
			if (e.getErrorCode() == 2601) {
					updateOverrideConfigItem(channel_id, property_id, overrideValue);
					status.setStatus(Status.STATUS_SUCCESS);
					status.setMessage("updated configItem with value " + overrideValue);
				
			} else {
				String msg = "SQL Exception, unable to override config item";
				logger.error(msg, e);
				
				status.setStatus(Status.STATUS_ERROR);
				status.setMessage(msg);
			}

		} 

		return status;

	}

	public static void insertOverrideConfigItem(int channel_id, int property_id,
			String overrideValue)throws SQLException{
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_INSERT_OVERRIDE_CHANNEL_CONFIG_VALUE);
			
			stmt.setInt(1, channel_id);
			stmt.setInt(2, property_id);
			stmt.setString(3, overrideValue);

			stmt.executeUpdate();
			DAOFactory.closeConnection(conn);
	}
	
	public static Status updateOverrideConfigItem(int channel_id, int property_id,
			String overrideValue){
		
		Status status = new Status();
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_OVERRIDE_CHANNEL_CONFIG_VALUE);
			
			stmt.setString(1, overrideValue);
			stmt.setInt(2, channel_id);
			stmt.setInt(3, property_id);
			stmt.executeUpdate();
			
			status.setStatus(Status.STATUS_SUCCESS);
			status.setMessage("Config updated");
			DAOFactory.closeConnection(conn);
			
		}catch (SQLException se){
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("an error occured");
			logger.error("SQL Exception occured while trying to update config item", se);
		}
		
		return status;
			
	}

    public static int createChannel(int deviceId, String description, int channelType, String measureType, int deviceChannelId, float offset) {
        int channelId = 0;
        try {
            Connection conn = DAOFactory.getConnection();

            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_SAVE_CHANNEL);
            pstmt.setInt(1, deviceId);
            pstmt.setString(2, description);
            pstmt.setInt(3, channelType);
            pstmt.setString(4, measureType);
            pstmt.setInt(5, deviceChannelId);
            pstmt.setFloat(6, offset);
            pstmt.setInt(7, 1);
            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
			rs.next();
			channelId = rs.getInt(1);

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to create channel ", se);
        }
        return channelId;
    }

    public static int updateChannel(int channelId, int deviceId, String description, int channelType, String measureType, int deviceChannelId, float offset) {
        int result = 0;
        try {
            Connection conn = DAOFactory.getConnection();

            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_UPDATE_CHANNEL);
            pstmt.setInt(1, deviceId);
            pstmt.setString(2, description);
            pstmt.setInt(3, channelType);
            pstmt.setString(4, measureType);
            pstmt.setInt(5, deviceChannelId);
            pstmt.setFloat(6, offset);
            pstmt.setInt(7, 1);
            pstmt.setInt(8, channelId);
            result = pstmt.executeUpdate();

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to update channel ", se);
        }
        return result;
    }
}