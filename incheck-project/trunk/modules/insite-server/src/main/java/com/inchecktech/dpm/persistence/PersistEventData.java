package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.DeliveryPath;
import com.inchecktech.dpm.beans.Event;
import com.inchecktech.dpm.beans.EventsThresholds;
import com.inchecktech.dpm.beans.OverallTypes;
import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.Unit;
import com.inchecktech.dpm.beans.User;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistEventData {
	
	private static final Logger logger = new Logger(PersistEventData.class);
	public static final String GENERIC_ERROR = "A System Error occured, please try again later or contact your system administrator";

	// TODO EVERY TIME Create/Update/Delete called, get all thresholds and put
	// them into data bucket or some other structure.
	final static DPMEventQueue queue = new DPMEventQueue();

	/**
	 * gets a list of EventsThresholds objects for channelID
	 * 
	 * @param channelID
	 * @return List<EventsThresholds>
	 */
	public static List<EventsThresholds> getEventsThresholds(int channelID) {
		logger.info("getEventsThresholds for channel " + channelID
				+ " was called");

		List<EventsThresholds> eventThresholdsList = new ArrayList<EventsThresholds>();

		try {
			Connection conn = DAOFactory.getConnection();

			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_EVENT_THRESHOLD);
			pstmt.setInt(1, channelID);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				EventsThresholds et = new EventsThresholds();
				et.setAction(rs.getString("ACTION"));
				et.setChannel_id(rs.getInt("CHANNEL_ID"));
				et.setChannel_location(rs.getString("location_name(CHANNEL_ID)"));
				et.setDelivery_id(rs.getInt("DELIVERY_ID"));
				et.setDescription(rs.getString("DESCRIPTION"));
				et.setEvent_tr_id(rs.getInt("EVENT_TR_ID"));
				et.setEvent_tr_lower_bound(rs.getDouble("LOWER_BOUND"));
                et.setBand_id(rs.getInt("BAND_ID"));

				logger
						.debug("created new ET for channel "
								+ et.getChannel_id());
				if (rs.wasNull()) {
					et.setEvent_tr_lower_bound(Double.MIN_VALUE);
				}
				et.setEvent_tr_upper_bound(rs.getDouble("UPPER_BOUND"));
				if (rs.wasNull()) {
					et.setEvent_tr_lower_bound(Double.MAX_VALUE);
				}
				et.setOverall_tr_type(OverallTypes.getOverallType(rs
						.getInt("OVERALL_TYPE_ID")));
				et.setSeverity(rs.getInt("SEVERITY_ID"));
				et.setUnit_id(rs.getInt("UNIT_ID"));
				eventThresholdsList.add(et);
			}

			DAOFactory.closeConnection(conn);
		} catch (SQLException se) {
			logger
					.error(
							"SQL Exception occured while trying to get events thresholds",
							se);
		} 
		
		// populate the list with delivery path
		for (EventsThresholds et : eventThresholdsList) {
			et.setDeliveryPathList(getDeliveryPath(et.getEvent_tr_id()));
		}

		return eventThresholdsList;
	}

	public static int updateEventsThresholdWithValues(int channelId, int severity,
			String overallType, double newLowerBound, double newUpperBound) {

		int result = 0;
		logger.info("updateEventsThreshold for channelId=" + channelId
				+ " and severity=" + severity + " and overallType="
				+ overallType + " and new newLowerBound=" + newLowerBound
				+ " and new newUpperBound=" + newUpperBound + " was called");
		try {
			Connection conn = DAOFactory.getConnection();

			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_EVENT_THRESHOLD_WITH_VALUES);
			pstmt.setDouble(1, newLowerBound);
			pstmt.setDouble(2, newUpperBound);
			pstmt.setInt(3, OverallTypes.getOverallType(overallType));
			pstmt.setInt(4, channelId);
			pstmt.setInt(5, severity);
			pstmt.setInt(6, Unit.UNIT_FPS);
			result = pstmt.executeUpdate();

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception, Unable to update threshhold ", e);
		} 

		return result;
	}

    public static int updateEventsThreshold(int channelId, int trId, String overallType,  int bandId, int severity,
        Double upperLimit, int unitId) {

		int result = 0;
		logger.info("updateEventsThreshold for channelId=" + channelId
				+ " and severity=" + severity + " and overallType="
				+ overallType + " and new newUpperBound=" + upperLimit + " was called");
		try {
			Connection conn = DAOFactory.getConnection();

			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_EVENT_THRESHOLD);
			pstmt.setInt(1, OverallTypes.getOverallType(overallType));
			pstmt.setDouble(2, upperLimit);
			pstmt.setInt(3, unitId);
			pstmt.setInt(4, severity);
            pstmt.setInt(5, bandId);
			pstmt.setInt(6, trId);
			result = pstmt.executeUpdate();

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception, Unable to update threshhold ", e);
		}

		return result;
	}

	public static int createEventsThreshold(int channelId, String overallType,  int bandId, int severity,
        Double upperLimit, int unitId) {

		int result = 0;
		logger.info("createEventsThreshold for channelId=" + channelId
				+ " and severity=" + severity + " and overallType="
				+ overallType + " and new newUpperBound=" + upperLimit + " was called");
		try {
			Connection conn = DAOFactory.getConnection();

			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_INSERT_EVENT_THRESHOLD);
			pstmt.setInt(1, channelId);
			pstmt.setInt(2, OverallTypes.getOverallType(overallType));
			pstmt.setDouble(3, 0);
			pstmt.setDouble(4, upperLimit);
			pstmt.setInt(5, unitId);
			pstmt.setInt(6, severity);
			pstmt.setString(7, null);
            pstmt.setInt(8, bandId);
			result = pstmt.executeUpdate();

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception, Unable to create threshhold ", e);
		} 

		return result;
	}

	/**
	 * inserts new event data object into db
	 * 
	 * @param event
	 */
	public static void persistEvent(Event event)  {

		if (null == event) {
			logger.error("unable to persist event, event is null");
		} else {
			if (event.getChanState() == null) {
				logger.error("unable to persist event, channel state is null");
			} else {
				ChannelState state = event.getChanState();
				logger.info("Putting event on the queue with channel state:"
						+ state);
				queue.accept(event);
			}
		}
	}
	
	public static List<Event> getAllEvents(){
		logger.info("getAllEvents() was called\n");

		List<Event> eventList = null;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_ALL_EVENTS_DATA);
			ResultSet rs = pstmt.executeQuery();
			eventList = getEventsFromRS(rs);
			DAOFactory.closeConnection(conn);

			if (null != eventList) {
				logger.debug("getAllEvents() returning " + eventList.size()
						+ " records in the list");
			}

		} catch (SQLException e) {
			logger.error("SQL Error Occured while trying to getAllEvents, ", e);
		}
		logger.debug("done getting all events");
		return eventList;
	}

	// THIS method is called
	public static List<Event> getEvent(int channel_id, int recNum) {

		logger.info("getEvent() was called for channel_id=" + channel_id
				+ " and at most " + recNum + " will be returned");

		List<Event> eventList = null;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_EVENT_DATA_BY_CH_ID);
			pstmt.setInt(1, channel_id);
			pstmt.setInt(2, recNum);
			ResultSet rs = pstmt.executeQuery();
			eventList = getEventsFromRS(rs);
			DAOFactory.closeConnection(conn);

			if (null != eventList) {
				logger.debug("getEvent() returning " + eventList.size()
						+ " records in the list for channel_id " + channel_id);
			}

		} catch (SQLException e) {
			logger.error("SQL Error Occured while trying to getEvent, ", e);
		}
		logger.debug("done getting events for channel " + channel_id);
		return eventList;
	}

	private static List<Event> getEventsFromRS(ResultSet rs){
		List<Event> eventList = new ArrayList<Event>();
		User user = null;

		try {
			while (rs.next()) {
				Event ad = new Event();
				ad.setEventId(rs.getInt("EVENT_ID"));
				ad.setChannelId(rs.getInt("CHANNEL_ID"));
                ad.setChannelLocation(rs.getString("location_name(channel.channel_id)"));
				ChannelState state = new ChannelState(ad.getChannelId(), rs
						.getInt("CHANNEL_TYPE"));

				ad.setChanState(state);
				ad.setDecs(rs.getString("DESCRIPTION"));
				ad.setEvent_tr_lower_bound(rs.getDouble("LOWER_BOUND"));
				if (rs.wasNull()) {
					ad.setEvent_tr_lower_bound(Double.MIN_VALUE);
				}
				ad.setEvent_tr_upper_bound(rs.getDouble("UPPER_BOUND"));
				if (rs.wasNull()) {
					ad.setEvent_tr_upper_bound(Double.MAX_VALUE);
				}
				ad.setLongDesc(rs.getString("LONGDESCRIPTION"));
				ad.setOverall_tr_type(rs.getString("OVERALL_TYPE"));
				ad.setResetby(rs.getString("ACK_BY"));
				ad.setSeverity(rs.getInt("SEVERITY_ID"));
				ad.setNotes(rs.getString("NOTES"));
				ad.setThreshold_tr_value(rs.getDouble("OVERALL_VALUE"));
				ad.setTimeStamp(rs.getTimestamp("SAMPLE_TS").getTime());
				ad.setStrTimeStamp(ad.getStrTimeStamp());

				if (rs.getInt("USER_ID") > 0) {
					user = new User();
					user.setUserId(rs.getInt("USER_ID"));
					user.setUserName(rs.getString("USERNAME"));
					ad.setAckuser(user);
					ad.setAcked(true);
                    logger.debug("event is acked");
				} else {
					ad.setAcked(false);
				}

				eventList.add(ad);
			}
		} catch (SQLException e) {
			logger.error("Unable to get events", e);
		}

		return eventList;
	}

	public static Status ackEvent(int userId, int eventId, String notes) {
		Status status = new Status();
		logger.info("EventID " + eventId + " acked by userid " + userId);

		status.setMessage("Event " + eventId + " has been acknowledged.");
		status.setStatus(Status.STATUS_SUCCESS);
		logger.info(status);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_ACK_EVENT);
			pstmt.setInt(1, userId);
			pstmt.setString(2, notes);
			pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
			pstmt.setInt(4, eventId);
			int rc = pstmt.executeUpdate();

			if (rc < 1) {
				status.setStatus(Status.STATUS_ERROR);
				status
						.setMessage("Unable to update event, no event found for id "
								+ eventId);
				logger.warn(status);
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			status.setMessage("Unknown userid, please try again");
			status.setStatus(Status.STATUS_ERROR);
			logger.error(status, se);
		} 
		
		if (Status.STATUS_ERROR != status.getStatus()) {
			PersistAuditLog.writeMessage(userId, PersistAuditLog.EVENT_ACK,
					new Date(), status.getMessage());
		}

		return status;

	}

	public static Status createDeliveryPath(DeliveryPath deliveryPath) {
		logger.debug("inserting/updating deliveryPath=" + deliveryPath);
		Status status = new Status();
		Integer devicePathId;

		status.setMessage("Delivery Path created");
		status.setStatus(Status.STATUS_SUCCESS);
		logger.info(status + deliveryPath.toString());

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(
					SQLStatements.QUERY_CREATE_DELIVERY_PATH,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, deliveryPath.getDeliveryGroupId());
			pstmt.setInt(2, deliveryPath.getRetryInterval());
			pstmt.setInt(3, deliveryPath.getRetryAttempts());
			pstmt.setInt(4, deliveryPath.getEscalationDeliveryId());
			pstmt.setString(5, deliveryPath.getDeliveryAddress());
			pstmt.setString(6, deliveryPath.getDeliveryName());
			pstmt.setString(7, deliveryPath.getDeliveryType());
			pstmt.setString(8, deliveryPath.getDeliveryNotes());

			int rc = pstmt.executeUpdate();

			if (rc < 1) {
				status.setStatus(Status.STATUS_ERROR);
				status.setMessage("Unable to create delivery path");
				logger.warn(status);
			}

			ResultSet rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				ResultSetMetaData rsmd = rs.getMetaData();
				int colCount = rsmd.getColumnCount();
				do {
					for (int i = 1; i <= colCount; i++) {
						devicePathId = Integer.valueOf(rs.getInt(i));
						status.setObject(devicePathId);
					}
				} while (rs.next());
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			status.setMessage("Unable to create delivery path");
			status.setStatus(Status.STATUS_ERROR);
			logger.error(status, se);
		} 

		return status;
	}

	public static Status mapEventThresholdToDeliveryPath(int eventThresholdId,
			int deliveryPathId) {
		logger.debug("mapping eventThresholdId=" + eventThresholdId
				+ " to deliveryPathId=" + deliveryPathId);
		Status status = new Status();

		status.setMessage("mapped eventThresholdId=" + eventThresholdId
				+ " to deliveryPathId=" + deliveryPathId);
		status.setStatus(Status.STATUS_SUCCESS);
		logger.info(status);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_MAP_EVENT_TR_TO_DELIVERY_PATH);
			pstmt.setInt(1, eventThresholdId);
			pstmt.setInt(2, deliveryPathId);
			int rc = pstmt.executeUpdate();

			if (rc < 1) {
				status.setStatus(Status.STATUS_ERROR);
				status.setMessage("Unable to map");
				logger.warn(status);
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			status.setMessage("Unable to map");
			status.setStatus(Status.STATUS_ERROR);
			logger.error(status, se);
		}
		
		return status;
	}

	public static Status deleteDeliveryPath(int deliveryPathId) {
		logger.debug("deleting deliveryPath=" + deliveryPathId);
		Status status = new Status();

		status.setMessage("Delivery Path deleted");
		status.setStatus(Status.STATUS_SUCCESS);
		logger.info(status + ":" + deliveryPathId);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_DELETE_DELIVERY_PATH);
			pstmt.setInt(1, deliveryPathId);
			int rc = pstmt.executeUpdate();

			if (rc < 1) {
				status.setStatus(Status.STATUS_ERROR);
				status.setMessage("Unable to find delivery path");
				logger.warn(status);
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			status.setMessage("Unable to delete delivery path");
			status.setStatus(Status.STATUS_ERROR);
			logger.error(status, se);
		} 

		return status;
	}

	public static void unmapDeliveryPath(int deliveryPathId, int eventTrId) {

		logger.debug("Unmapping deliveryPahtid=" + deliveryPathId
				+ " and eventTrId=" + eventTrId);
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UNMAP_EVENT_TR_TO_DELIVERY_PATH);
			pstmt.setInt(1, eventTrId);
			pstmt.setInt(2, deliveryPathId);
			pstmt.executeUpdate();

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("Unable to unmap delivery path", se);
		} 
	}

	public static List<DeliveryPath> getDeliveryPath(int eventThresholdId) {
		logger.debug("getting deliveryPaths for eventThresholdId="
				+ eventThresholdId);

		List<DeliveryPath> deliveryPathList = new ArrayList<DeliveryPath>();
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_DELIVERY_PATH_FOR_EVENTHRESHOLD);
			pstmt.setInt(1, eventThresholdId);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				DeliveryPath p = new DeliveryPath();
				p.setDeliveryAddress(rs.getString("delivery_address"));
				p.setDeliveryGroupId(rs.getInt("delivery_group_id"));
				p.setDeliveryId(rs.getInt("delivery_id"));
				p.setDeliveryName(rs.getString("delivery_name"));
				p.setDeliveryNotes(rs.getString("delivery_notes"));
				p.setDeliveryType(rs.getString("delivery_type"));
				p.setEscalationDeliveryId(rs.getInt("escalation_delivery_id"));
				p.setRetryAttempts(rs.getInt("retry_attempts"));
				p.setRetryInterval(rs.getInt("retry_attempts"));
				deliveryPathList.add(p);
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger
					.error(
							"SQL Error occured while trying to get deliveryPath information",
							se);
		} 
		
		return deliveryPathList;
	}

	public static Status deleteEventThreshold(int event_tr_id) {
		logger.info("deleting event threshold=" + event_tr_id);
		Status status = new Status();

		// first delete the mapping
		List<DeliveryPath> delPaths = getDeliveryPath(event_tr_id);

		for (DeliveryPath path : delPaths) {
			deleteDeliveryPath(path.getDeliveryId());
		}

		status.setMessage("Deleted event threshold ");
		status.setStatus(Status.STATUS_SUCCESS);
		logger.info(status + ":" + event_tr_id);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_DELETE_EVENT_THRESHOLD_BY_EVENT_TR_ID);
			pstmt.setInt(1, event_tr_id);
			int rc = pstmt.executeUpdate();

			if (rc < 1) {
				status.setStatus(Status.STATUS_ERROR);
				status.setMessage("Unable to find event threshold");
				logger.warn(status);
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			status.setMessage("Unable to delete event threshold");
			status.setStatus(Status.STATUS_ERROR);
			logger.error(status, se);
		} 
		
		return status;
	}

	public static Status modifyDeliveryPath(int deliveryId,
			String deliveryAddress, String notes) {
		logger.info("updating deliveryPathId=" + deliveryId + " address="
				+ deliveryAddress + " notes=" + notes);
		Status status = new Status();
		status.setStatus(Status.STATUS_SUCCESS);
		status.setMessage("Delivery path updated");

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_DELIVERY_PATH);
			pstmt.setString(1, deliveryAddress);
			pstmt.setString(2, notes);
			pstmt.setInt(3, deliveryId);

			int rc = pstmt.executeUpdate();

			if (rc < 1) {
				status.setStatus(Status.STATUS_ERROR);
				status.setMessage("Unable to find delivery path");
				logger.warn(status);
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			status.setMessage("Unable to update delivery path");
			status.setStatus(Status.STATUS_ERROR);
			logger.error(status, se);
		} 
		return status;
	}
}