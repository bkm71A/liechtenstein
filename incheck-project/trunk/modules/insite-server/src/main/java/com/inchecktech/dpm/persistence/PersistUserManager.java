package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.inchecktech.dpm.beans.User;
import com.inchecktech.dpm.beans.UserRole;
import com.inchecktech.dpm.common.UserManager;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistUserManager {
	private static Logger logger = new Logger(PersistUserManager.class);

	public static User getUser(String userName) {
		User user = null;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_USER);
			pstmt.setString(1, userName);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				user = new User(userName);
				user.setFirstName(rs.getString("FIRSTNAME"));
				user.setLastName(rs.getString("LASTNAME"));
				user.setTitle(rs.getString("TITLE"));
				user.setUserId(rs.getInt("USER_ID"));
				user.setEmail(rs.getString("EMAIL"));
				user.setEnabled(rs.getBoolean("ENABLED"));
				user.setMailist(rs.getBoolean("MAILLIST"));
				user.setContactlist(rs.getBoolean("CONTACTLIST"));
				user.setVerified(rs.getBoolean("VERIFIED"));
				user.setOrganization(rs.getString("ORGANIZATION"));
				user.setIndustry(rs.getString("INDUSTRY"));
				user.setHowdidyouhear(rs.getString("HOWDIDYOUHEAR"));

				String tz = rs.getString("TIMEZONE");
				if (tz.equals("")) {
					user.setTimezone("GMT");
				} else {
					user.setTimezone(rs.getString("TIMEZONE"));
				}
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception Occured", e);

		} 
		return user;
	}

	public static List<User> getUsers() {
		List<User> users = new ArrayList<User>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_USERS);
			ResultSet rs = pstmt.executeQuery();
			if (null != rs) {
				while (rs.next()) {
					User user = new User(rs.getString("USERNAME"));
					user.setFirstName(rs.getString("FIRSTNAME"));
					user.setLastName(rs.getString("LASTNAME"));
					user.setTitle(rs.getString("TITLE"));
					user.setUserId(rs.getInt("USER_ID"));
					user.setEmail(rs.getString("EMAIL"));
					user.setEnabled(rs.getBoolean("ENABLED"));
					user.setMailist(rs.getBoolean("MAILLIST"));
					user.setContactlist(rs.getBoolean("CONTACTLIST"));
					user.setVerified(rs.getBoolean("VERIFIED"));
					user.setOrganization(rs.getString("ORGANIZATION"));
					user.setIndustry(rs.getString("INDUSTRY"));
					user.setHowdidyouhear(rs.getString("HOWDIDYOUHEAR"));

					String tz = rs.getString("TIMEZONE");
					if (tz.equals("")) {
						user.setTimezone("GMT");
					} else {
						user.setTimezone(rs.getString("TIMEZONE"));
					}

					users.add(user);
					logger.debug("added user: " + user);
				}
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("SQL Exception Occured, ", se);

		} 
		return users;
	}

	public static User processUserLogon(String username, String passwordHash) {

		User user = null;
		List<UserRole> roles = new ArrayList<UserRole>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_AUTH_USER);
			pstmt.setString(1, username);
			pstmt.setString(2, passwordHash);
			pstmt.setBoolean(3, true);
			pstmt.setBoolean(4, true);

			ResultSet rs = pstmt.executeQuery();

			int recNum = 0;
			while (rs.next()) {
				recNum++;
				if (null == user) {
					user = new User(rs.getString("USERNAME"));
					user.setUserId(rs.getInt("USER_ID"));
					user.setFirstName(rs.getString("FIRSTNAME"));
					user.setLastName(rs.getString("LASTNAME"));
					user.setEmail(rs.getString("EMAIL"));
					user.setEnabled(rs.getBoolean("ENABLED"));
					user.setVerified(rs.getBoolean("VERIFIED"));
					user.setOrganization(rs.getString("ORGANIZATION"));
					user.setIndustry(rs.getString("INDUSTRY"));
					user.setMailist(rs.getBoolean("MAILLIST"));
					user.setContactlist(rs.getBoolean("CONTACTLIST"));
					user.setHowdidyouhear(rs.getString("HOWDIDYOUHEAR"));

					String tz = rs.getString("TIMEZONE");
					if (tz.equals("")) {
						user.setTimezone("GMT");
					} else {
						user.setTimezone(rs.getString("TIMEZONE"));
					}

					UserRole role = new UserRole(rs.getString("ROLENAME"));
					role.setRoleId(rs.getInt("ROLE_ID"));
					role.setRoleDescription(rs.getString("ROLEDESC"));
					roles.add(role);
				}
			}

			if (null != user && null != roles) {
				user.setUserroles(roles);
			}

			DAOFactory.closeConnection(conn);
			logger.debug("created user oobject: " + user);

		} catch (SQLException se) {
			logger.error("SQL Exception", se);
		} 
		return user;
	}

	public static boolean isUserInRole(String userName, String roleName) {
		boolean maybe = false;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_ROLES_FOR_USER);
			pstmt.setString(1, userName);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				if (rs.getString("ROLENAME").equalsIgnoreCase(roleName)) {
					maybe = true;
					break;
				}
			}

			DAOFactory.closeConnection(conn);
		} catch (SQLException se) {
			logger.error("SQL Exception occured", se);
		}
		return maybe;
	}

	public static boolean deleteUser(String userName) {
		boolean deleted = false;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_DELETE_USER);
			pstmt.setString(1, userName);
			int recnum = pstmt.executeUpdate();

			if (recnum > 0) {
				logger.info("deletedUser:" + userName);
				deleted = true;
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("SQL Exception occured", se);
		} 
		return deleted;
	}

	public static List<UserRole> getRolesForUser(String userName) {
		List<UserRole> roles = new ArrayList<UserRole>();

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_ROLES_FOR_USER);
			pstmt.setString(1, userName);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				UserRole role = new UserRole(rs.getString("ROLENAME"));
				role.setRoleId(rs.getInt("ROLE_ID"));
				role.setRoleDescription(rs.getString("ROLEDESC"));
				roles.add(role);
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception while getting roles for user", e);
		}

		return roles;
	}

	public static boolean addUserToRole(int userId, int roleId) {
		String message = "";
		boolean result = false;
		try {

			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_ADD_USER_TO_ROLE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, roleId);
			int r = pstmt.executeUpdate();

			if (r > 0) {
				result = true;
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {

			if (se.getErrorCode() == 2601) {
				message = " user already in role roleName";
				result = false;
				logger.info(message);
			}

			logger.error("SQL Exception occured", se);

		} 
		return result;
	}

	public static int getUserId(String userName) {

		int userid = 0;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_USER_ID);
			pstmt.setString(1, userName);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				userid = rs.getInt(1);
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception", e);
		} 
		return userid;
	}

	public static boolean removeUserFromRoles(int userId) {

		boolean result = false;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_REMOVE_USER_FROM_ROLES);
			pstmt.setInt(1, userId);
			int r = pstmt.executeUpdate();

			if (r > 0) {
				result = true;
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("SQL Exception occured", se);
		}

		return result;
	}

	public static boolean removeUserFromRole(int userId, int roleId) {

		boolean result = false;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_REMOVE_USER_FROM_ROLE);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, roleId);
			int r = pstmt.executeUpdate();
			if (r > 0) {
				result = true;
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error("SQL Exception occured", se);
		} 
		return result;
	}

	public static void updateUser(User user) {

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_USER);

			// update user
			pstmt.setString(1, user.getUserName());
			pstmt.setString(2, user.getFirstName());
			pstmt.setString(3, user.getLastName());
			pstmt.setString(4, user.getTitle());
			pstmt.setString(5, user.getEmail());
			pstmt.setBoolean(6, user.isEnabled());
			pstmt.setBoolean(7, user.isVerified());
			pstmt.setString(8, user.getTimezone());
			pstmt.setString(9, user.getUserName());
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			String message = "SQL Exception occured while updating user ";
			logger.error(message, e);

		} 
	}

//	public static boolean updateUserPass(String userName, String passwordHash) {
//		boolean result = false;
//		try {
//			Connection conn = DAOFactory.getConnection();
//			PreparedStatement pstmt = conn
//					.prepareStatement(SQLStatements.QUERY_UPDATE_USER_PASSWORD);
//			pstmt.setString(1, HashUtil.hashString(passwordHash));
//			pstmt.setString(2, userName);
//			int r = pstmt.executeUpdate();
//
//			if (r > 0) {
//				result = true;
//			}
//
//			DAOFactory.closeConnection(conn);
//		} catch (SQLException e) {
//			logger.error("SQL Exception occured", e);
//
//		} catch (DPMException de) {
//			logger.error("DPM Exception occured", de);
//		}
//
//		return result;
//	}

	public static boolean enableUser(String userName) {
		boolean retval = false;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_ENABLE_USER);
			pstmt.setBoolean(1, true);
			pstmt.setString(2, userName);
			int r = pstmt.executeUpdate();
			if (r > 0) {
				retval = true;
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception occured", e);
			retval = false;
		} catch (Exception de) {
			logger.error("Exception occured", de);
			retval = false;
		}

		return retval;
	}

	public static boolean verifyUser(String regtoken) {
		boolean result = false;
		String message = "";
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(
					SQLStatements.QUERY_VERIFY_USER_EMAIL,
					PreparedStatement.RETURN_GENERATED_KEYS);

			pstmt.setBoolean(1, true);
			pstmt.setString(2, regtoken);
			int recnum = pstmt.executeUpdate();

			if (recnum >= 1) {
				result = true;
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			message = "SQL Exception occured";
			logger.error(message, e);

		} catch (Exception de) {
			message = "Exception occured";
			logger.error(message, de);
		}

		return result;
	}

	public static boolean disableUser(String userName) {
		boolean retval = false;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_ENABLE_USER);
			pstmt.setBoolean(1, false);
			pstmt.setString(2, userName);
			int r = pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);

			if (r > 0) {
				retval = true;
			}

		} catch (SQLException e) {
			logger.error("SQL Exception occured", e);
			retval = false;
		} catch (Exception de) {
			logger.error("Exception occured", de);
			retval = false;
		}

		return retval;
	}

	public static int registerUser(String userName, String passwordHash,
			String firstName, String lastName, String email,
			String organization, String industry, String howdidyouhear,
			boolean addtomail, boolean contactbyrep, String serverurl,
			String timezone, String regtoken) {

		int userid = 0;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(
					SQLStatements.QUERY_REGISTER_USER,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, userName);
			pstmt.setString(2, passwordHash);
			pstmt.setString(3, firstName);
			pstmt.setString(4, lastName);
			pstmt.setString(5, email);
			pstmt.setString(6, organization);
			pstmt.setString(7, industry);
			pstmt.setString(8, howdidyouhear);
			pstmt.setBoolean(9, addtomail);
			pstmt.setBoolean(10, contactbyrep);
			pstmt.setString(11, regtoken);
			pstmt.setBoolean(12, true);
			pstmt.setString(13, timezone);

			pstmt.executeUpdate();
			ResultSet rs = pstmt.getGeneratedKeys();
			rs.next();

			userid = rs.getInt(1);
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			if (se.getErrorCode() == DAOFactory.DUPLICATE_RECORD_MYSQL
					|| se.getErrorCode() == DAOFactory.DUPLICATE_RECORD_SYBASE) {
				logger.error(UserManager.STATUS_USER_ALREADY_EXIST
						+ " for user " + userName);

			} else {
				logger.error("SQL Exception", se);
			}

		} catch (Exception de) {
			logger.error("Error occured while trying to regester user ", de);

		}
		return userid;
	}

	public static int createUser(String userName, String passwordHash,
			String firstName, String lastName, String email, String org,
			String ind, String howdidyou, boolean maillist,
			boolean contactlist, String regtoken, boolean enabled,
			boolean verified, String timezone) {

		int userId = 0;
		String message = "";

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(
					SQLStatements.QUERY_REGISTER_USER,
					PreparedStatement.RETURN_GENERATED_KEYS);

			pstmt.setString(1, userName);
			pstmt.setString(2, passwordHash);
			pstmt.setString(3, firstName);
			pstmt.setString(4, lastName);
			pstmt.setString(5, email);
			pstmt.setString(6, org);
			pstmt.setString(7, ind);
			pstmt.setString(8, howdidyou);
			pstmt.setBoolean(9, maillist);
			pstmt.setBoolean(10, contactlist);
			pstmt.setString(11, regtoken);
			pstmt.setBoolean(12, enabled);
			pstmt.setBoolean(13, verified);
			pstmt.setString(14, timezone);

			pstmt.executeUpdate();

			ResultSet rs = pstmt.getGeneratedKeys();
			rs.next();
			userId = rs.getInt(1);

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {

			if (se.getErrorCode() == DAOFactory.DUPLICATE_RECORD_MYSQL
					|| se.getErrorCode() == DAOFactory.DUPLICATE_RECORD_SYBASE) {
				logger.error(UserManager.STATUS_USER_ALREADY_EXIST
						+ " for user " + userName);
				message = UserManager.STATUS_USER_ALREADY_EXIST;
				logger.error(message);
			} else {
				logger.error("SQL Exception", se);
			}

		} catch (Exception e) {
			message = "Error occured while trying to create user ";
			logger.error("Exception occured ", e);
		}

		return userId;
	}
	
	public static boolean resetUserPassword(String username, String passwordHash){
		boolean retval = false;
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_USER_PASSWORD);
			pstmt.setString(2, username);
			pstmt.setString(1, passwordHash);
			
			int r = pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			if (r > 0){
				retval = true;
			}

		} catch (SQLException e) {
			retval = false;
			logger.error(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET, e);

		} catch (Exception de) {
			retval = false;
			logger.error(UserManager.STATUS_ERROR_DURING_PASSWORD_RESET, de);
		}
		
		return retval;
	}
}