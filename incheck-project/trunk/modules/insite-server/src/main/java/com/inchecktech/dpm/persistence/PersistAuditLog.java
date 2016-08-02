package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistAuditLog {
	private static final Logger logger = new Logger(PersistAuditLog.class);
	public static final String NEW_USER_REG="NEWUSERREG";
	public static final String NEW_USER_CREATED="NEWUSERCREATE";
	public static final String EMAIL_VERIFIED="EMAILVERIFIED";
	public static final String LOGIN_FAILED="USERLOGINFAILED";
	public static final String LOGIN_SUCCESS="USERLOGINSUCCESS";
	public static final String USER_PASS_CHANGE="USERPASSCHANGE";
	public static final String USER_ENABLED="USERENABLED";
	public static final String EVENT_ACK="EVENTACK";
	
	public static void writeMessage(int userid, String action, Date timestmp, String description){
		
		try {
			
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn
					.prepareStatement(SQLStatements.QUERY_INSERT_AUDIT_RECORD);
			pstmt.setInt(1, userid);
			pstmt.setString(2, action);
			
			if (null != timestmp) {
				Timestamp timestamp = new Timestamp(timestmp.getTime());
				pstmt.setTimestamp(3, timestamp);
			}else{
				Timestamp timestamp = new Timestamp(new Date().getTime());
				pstmt.setTimestamp(3, timestamp);
			}
			
			pstmt.setString(4, description);
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);
			
		}catch(SQLException e){
			logger.error("SQL Exception occured while inserting audit log record ", e);			
		}
	}
}
