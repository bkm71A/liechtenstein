package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.UserPreference;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistUserPreferences {

	private static Logger logger = new Logger(PersistUserPreferences.class);

	public static UserPreference getUserPreference(int userId, String key) {

		logger.info("getting user preferences for userid=" + userId
				+ " and key=" + key);
		UserPreference preference = new UserPreference();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_PREFERENCE_FOR_USER_AND_KEY);
			pstmt.setInt(1, userId);
			pstmt.setString(2, key);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				preference.setId(rs.getInt("PREFERENCE_ID"));
				preference.setKey(key);
				preference.setLevel(rs.getInt("PREFERENCE_LEVEL"));
				preference.setType(rs.getString("PREFERENCE_TYPE"));
				preference.setValue(rs.getString("PREFERENCE_VALUE"));
				preference.setDescription(rs
						.getString("PREFERENCE_DESCRIPTION"));
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);

		} catch (Throwable t) {
			logger.error("Error occured", t);
		}

		logger.info("got preference object:" + preference);
		return preference;
	}

	public static List<UserPreference> getUserPreferences(int userId) {

		logger.info("getting user preferences for userid=" + userId);
		List<UserPreference> preferences = new ArrayList<UserPreference>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_PREFERENCES_FOR_USER);
			pstmt.setInt(1, userId);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				UserPreference preference = new UserPreference();
				preference.setId(rs.getInt("PREFERENCE_ID"));
				preference.setKey(rs.getString("PREFERENCE_KEY"));
				preference.setLevel(rs.getInt("PREFERENCE_LEVEL"));
				preference.setType(rs.getString("PREFERENCE_TYPE"));
				preference.setValue(rs.getString("PREFERENCE_VALUE"));
				preference.setDescription(rs.getString("PREFERENCE_DESCRIPTION"));
			
				preferences.add(preference);
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);

		} catch (Throwable t) {
			logger.error("Error occured", t);
		}

		logger.info("got " + preferences.size() + " preference objects for userid="+ userId);
		
		return preferences;

	}

	public static Status setUserPreference(int userId, int preferenceId) {
		
		logger.info("setting user preference=" + preferenceId + " for userid=" + userId);
		Status status = new Status();
		status.setStatus(Status.STATUS_SUCCESS);
		status.setMessage("User preference set");
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_SET_PREFERENCE_FOR_USER);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, preferenceId);
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			logger.info("preference set");

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to set user preference");

		} catch (Throwable t) {
			logger.error("Error occured", t);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to set user preference");

		}
		return status;
	}
	
public static Status unsetUserPreference(int userId, int preferenceId) {
		
		logger.info("unsetting user preference=" + preferenceId + " for userid=" + userId);
		Status status = new Status();
		status.setStatus(Status.STATUS_SUCCESS);
		status.setMessage("User preference unset");
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UNSET_PREFERENCE_FOR_USER);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, preferenceId);
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			logger.info("preference unset");

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to unset user preference");

		} catch (Throwable t) {
			logger.error("Error occured", t);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to unset user preference");

		}
		return status;
	}

	public static List<UserPreference> getAvailableUserPreference(){
		
		logger.info("getting available user preferences for userid=");
		List<UserPreference> preferences = new ArrayList<UserPreference>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_AVAIL_PREFERENCES);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				UserPreference preference = new UserPreference();
				preference.setId(rs.getInt("PREFERENCE_ID"));
				preference.setKey(rs.getString("PREFERENCE_KEY"));
				preference.setLevel(rs.getInt("PREFERENCE_LEVEL"));
				preference.setType(rs.getString("PREFERENCE_TYPE"));
				preference.setValue(rs.getString("PREFERENCE_VALUE"));
				preference.setDescription(rs.getString("PREFERENCE_DESCRIPTION"));

				preferences.add(preference);
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);

		} catch (Throwable t) {
			logger.error("Error occured", t);
		}

		logger.info("got " + preferences.size() + " preference objects");
		
		return preferences;
	}
	
	public static Status createUserPreference(UserPreference preference) {
		
		logger.info("creating user preference=" + preference);
		Status status = new Status();
		status.setStatus(Status.STATUS_SUCCESS);
		status.setMessage("User preference created");
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_CREATE_PREFERENCE);
			pstmt.setString(1, preference.getKey());
			pstmt.setString(2, preference.getValue());
			pstmt.setInt(3, preference.getLevel());
			pstmt.setString(4, preference.getType());
			pstmt.setString(5, preference.getDescription());
			
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			logger.info("preference created");

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to create preference");

		} catch (Throwable t) {
			logger.error("Error occured", t);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to create preference");

		}
		return status;
	}
	public static Status updateUserPreference(UserPreference preference) {
	
		logger.info("updating user preference=" + preference);
		Status status = new Status();
		status.setStatus(Status.STATUS_SUCCESS);
		status.setMessage("User preference updated");
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_PREFERENCE);
			pstmt.setString(1, preference.getKey());
			pstmt.setString(2, preference.getValue());
			pstmt.setInt(3, preference.getLevel());
			pstmt.setString(4, preference.getType());
			pstmt.setString(5, preference.getDescription());
			pstmt.setInt(6, preference.getId());
			
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			logger.info("preference updated");

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to update preference");

		} catch (Throwable t) {
			logger.error("Error occured", t);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to update preference");

		}
		return status;
	}
	
	public static Status deleteUserPreference(int preferenceId) {
		
		logger.info("deleting user preference=" + preferenceId);
		Status status = new Status();
		status.setStatus(Status.STATUS_SUCCESS);
		status.setMessage("User preference deleted");
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_DELETE_PREFERENCE);
			pstmt.setInt(1, preferenceId);
			
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			logger.info("preference deleted");

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to deletedpreference");

		} catch (Throwable t) {
			logger.error("Error occured", t);
			status.setStatus(Status.STATUS_ERROR);
			status.setMessage("An error occured while trying to deleted preference");

		}
		return status;
	}
	
	public static List<UserPreference> getUserPreferences(String preferenceKey) {
		
		logger.info("getting preferences for preferenceId=");
		List<UserPreference> preferences = new ArrayList<UserPreference>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_PREFERENCES_FOR_KEY);
			pstmt.setString(1, preferenceKey);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				UserPreference preference = new UserPreference();
				preference.setId(rs.getInt("PREFERENCE_ID"));
				preference.setKey(rs.getString("PREFERENCE_KEY"));
				preference.setLevel(rs.getInt("PREFERENCE_LEVEL"));
				preference.setType(rs.getString("PREFERENCE_TYPE"));
				preference.setValue(rs.getString("PREFERENCE_VALUE"));
				preference.setDescription(rs.getString("PREFERENCE_DESCRIPTION"));

				preferences.add(preference);
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);

		} catch (Throwable t) {
			logger.error("Error occured", t);
		}

		logger.info("got " + preferences.size() + " preference objects");
		
		return preferences;
	}
	
	public static Integer getMinDisplayedPrecision() {
		logger.info("getting min displayed precision");
		Integer result = null;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_MIN_DISPLAYED_PRECISION);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				String resultString = rs.getString("MIN(preference_value)");
				try {
					result = Integer.valueOf(resultString);
				} catch (RuntimeException e) {
				}
			}
			DAOFactory.closeConnection(conn);
		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);

		} catch (Throwable t) {
			logger.error("Error occured", t);
		}
		return result;
	}

}