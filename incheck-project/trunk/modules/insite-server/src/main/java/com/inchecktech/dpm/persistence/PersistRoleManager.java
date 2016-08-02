package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.inchecktech.dpm.beans.UserRole;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistRoleManager {

	private static Logger logger = new Logger(PersistRoleManager.class);
	public static boolean createRole(String roleName, String roleDescription) {
		
		boolean retval = false;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_CREATE_ROLE);
			pstmt.setString(1, roleName);
			pstmt.setString(2, roleDescription);
			int result = pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			if (result >= 1) {
				retval = true;
			}

			
		} catch (SQLException se) {

			StringBuilder message = new StringBuilder();
			if (se.getErrorCode() == 548) {
				message.append(" role already exist with rolename '").append(roleName).append("'");
				logger.error(message, se);
				retval = false;
			}
			retval = false;
			logger.error(message.toString(), se);

		} catch (Exception de){
			logger.error("Unable to create role", de);
			retval = false;
		}
		return retval;
	}
	
	public static boolean deleteRole(String roleName){
		boolean retval = false;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_CREATE_ROLE);
			pstmt.setString(1, roleName);
			int result = pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			if (result > 0) {
				retval = true;
			}
			
		} catch (SQLException e) {
			logger.error("SQL Exception occured while deleting role", e);
			retval = false;
		}catch (Exception e) {
			logger.error("DPM Exception occured while deleting role", e);
			retval = false;
		}
		return retval;
	}
	
	public static UserRole getRole(String roleName) {

		UserRole role = null;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_ROLE);
			pstmt.setString(1, roleName);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				role = new UserRole(roleName);
				role.setRoleId(rs.getInt("ROLE_ID"));
				role.setRoleDescription(rs.getString("ROLEDESC"));
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception occured while getting role", e);
		} catch (Exception de) {
			logger.error("DPM Exception occured while getting role", de);
		}

		return role;
	}
	

	public static boolean updateRole(String roleName, String roleDescription) {
		boolean retval = false;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_ROLE);
			pstmt.setString(1, roleName);
			pstmt.setString(2, roleDescription);
			int result = pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
			if (result < 1) {
				logger.error("Unable to update role, probably role does not exist");
				retval = false;
			}else{
				retval = true;
			}

		} catch (SQLException e) {
			logger.error("SQL Exception occured while updating role", e);
			retval = false;
		}catch (Exception de){
			logger.error("DPM Exception occured while updating role", de);
			retval = false;
			
		}
		return retval;
	}
	
	public static List<UserRole> getRoles() {

		List<UserRole> roles = new ArrayList<UserRole>();
		UserRole role;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_ROLES);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				role = new UserRole(rs.getString("ROLENAME"));
				role.setRoleId(rs.getInt("ROLE_ID"));
				role.setRoleDescription(rs.getString("ROLEDESC"));
				roles.add(role);
			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception occured while getting role", e);
		} 
		return roles;
	}

	public static int getRoleId(String roleName) {
		int roleid = 0;

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_ROLE_ID);
			pstmt.setString(1, roleName);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				roleid = rs.getInt("ROLE_ID");
			}
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("A SQL error occured in getRoleId", e);
		} 
		return roleid;
	}
}