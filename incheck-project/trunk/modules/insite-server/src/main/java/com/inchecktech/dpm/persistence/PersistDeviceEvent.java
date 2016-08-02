package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.inchecktech.dpm.beans.DeviceEvent;
import com.inchecktech.dpm.beans.DeviceOperation;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistDeviceEvent {
	
	private static final Logger logger = new Logger(PersistDeviceEvent.class);
	
	public static void save(DeviceEvent event){
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_SAVE_DEVICE_EVENT);
			int param = 1;
			stmt.setInt(param++, event.getDeviceId());
			stmt.setString(param++, (event.getOperation()!=null ? event.getOperation().toString() : null));
			stmt.setObject(param++, event.getTimestamp());

			stmt.executeUpdate();
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger
					.error(
							"SQLException Occured while trying to save device event",
							se);
		} 
	}
	
	/**
	 * 
	 * @return array of int of available channels
	 */
	public static List<DeviceEvent> getLastDeviceEvents() {
		logger.debug("getting last device events");

		List<DeviceEvent> result = new ArrayList<DeviceEvent>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_LAST_DEVICE_EVENTS);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				DeviceEvent node = new DeviceEvent();
				node.setDeviceId(rs.getInt("DEVICE_ID"));
				node.setDeviceMac(rs.getString("MAC"));
				node.setOperation(DeviceOperation.valueOf(rs.getString("OPERATION")));
				node.setTimestamp(rs.getTimestamp("OPERATION_TS"));
				result.add(node);

			}

			DAOFactory.closeConnection(conn);
		} catch (SQLException e) {
			logger
					.error(
							"SQL Exception, unable to get last device events, check the logs for exception",
							e);
		} 
		
		logger.debug("found " + result.size() + " last device events : " + result);
		return result;
	}

}
