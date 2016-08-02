package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.notifications.EmailNotification;
import com.inchecktech.dpm.utils.Logger;

public class PersistNotifications {
	private static final Logger logger = new Logger(PersistNotifications.class);
	public static final String NOTIFY_TYPE_EMAIL = "e";

	public static Status updateNotifStatus(EmailNotification notification) {
		Status status = new Status();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_SET_NOTIFICATION_STATUS);
			stmt.setString(1, "d");
			stmt.setInt(2, notification.getNotifyId());
			int recnum = stmt.executeUpdate();

			if (recnum > 0) {
				status.setMessage("Event Status updated");
				status.setStatus(Status.STATUS_SUCCESS);
			} else {
				status
						.setMessage("Event Status was not updated, unable to locate event notification");
				status.setStatus(Status.STATUS_ERROR);
			}
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			String message = "SQL Exception, unable to updateNotifStatus, check the logs for exception ";
			logger.error(message, e);
			status.setMessage(message);
			status.setStatus(Status.STATUS_ERROR);
		}

		return status;

	}

	public static List<EmailNotification> getNotifications() {

		List<EmailNotification> notifications = new ArrayList<EmailNotification>();
		int notifCount = 0;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_AVAIL_NOTIFICATIONS);
			stmt.setString(1, "n");
			ResultSet rs = stmt.executeQuery();

			
			while (rs.next()) {
				if (rs.getString("notify_type").equals(NOTIFY_TYPE_EMAIL)) {
					EmailNotification en = new EmailNotification();
					en.setChannelId(rs.getInt("channel_id"));
					en.setDeliveryStatus(rs.getString("delivery_status"));
					en.setEventId(rs.getInt("event_id"));
					en.setFromName(rs.getString("from_name"));
					en.setLocation(rs.getString("location"));
					en.setMessageValue(rs.getString("message_value"));
					en.setNewSeverity(rs.getString("new_severity"));
					en.setNotifyTimestamp(rs.getTimestamp("notify_timestamp"));
					en.setNotifyType(rs.getString("notify_type").charAt(0));
					en.setOldSeverty(rs.getString("old_severity"));
					en.setToAddress(rs.getString("to_address"));
					en.setNotifyId(rs.getInt("notify_id"));

					notifications.add(en);
					logger.debug(en);
					notifCount++;
				}
			}

			if (notifCount > 0){
				logger.info("Found " + notifCount + " notifications ");
			}else{
				logger.debug("Found " + notifCount + " notifications ");
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger
					.error(
							"SQL Exception, unable to getNotifications, check the logs for exception",
							e);
		}
		
		return notifications;
	}
}
