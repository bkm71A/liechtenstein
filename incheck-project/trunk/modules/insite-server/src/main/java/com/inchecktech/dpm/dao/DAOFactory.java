package com.inchecktech.dpm.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.logicalcobwebs.proxool.configuration.PropertyConfigurator;

import com.inchecktech.dpm.utils.Logger;
import com.inchecktech.dpm.utils.PropLoader;

/**
 * 
 * This class will return a connection from tomcat, if not available, it will
 * get a pooled connection via driver
 * 
 */
public abstract class DAOFactory {

	private static final Logger logger = new Logger(DAOFactory.class);
	private static boolean initialized;
	public static final int DUPLICATE_RECORD_SYBASE=548;
	public static final int DUPLICATE_RECORD_MYSQL=1062;

	public static Connection getConnection() {

		Connection conn = null;

		try {
			conn = getJDBCConnection();

		} catch (NamingException ne) {
			logger.debug("Naming exception, now trying pooled connection");
			try {
				conn = getPooledConnection();
				logger.debug("Got pooled DB connection");

			} catch (Exception se) {
				se.printStackTrace();
				logger.error("Unable to get database connection", se);
			}

		} catch (SQLException e) {
			logger.error("SQL exception, now trying pooled connection", e);
			e.printStackTrace();
			try {
				conn = getPooledConnection();
			} catch (Exception se) {
				e.printStackTrace();
				logger.error("Unable to get database connection", se);
			}

		}

		return conn;
	}

	/**
	 * 
	 * @return
	 * @throws SQLException
	 */
	private static Connection getPooledConnection() {
		Connection conn = null;

		try {

			if (! initialized){
				logger.debug("Start Loading DB Driver ");
				Class.forName(PropLoader.getProperty("DB_POOL_CLASS_NAME"));
				PropertyConfigurator.configure(PropLoader.loadDbProps());
				initialized = true;
			}
			conn = DriverManager.getConnection("proxool.incheck");
			logger.debug("Done Loading DB Driver ");
		} catch (Exception e) {
			logger.error(e.getMessage() + "Unable to get pooled connection", e);
		}
		return conn;
	}

	public static void printMetaData() {

		Connection conn = getConnection();
		try {
			logger.info("conn.getMetaData().getDatabaseMajorVersion()"
					+ conn.getMetaData().getDatabaseMajorVersion());
			logger.info("conn.getMetaData().getDatabaseMinorVersion()"
					+ conn.getMetaData().getDatabaseMinorVersion());
			logger.info("conn.getMetaData().getDatabaseProductName()"
					+ conn.getMetaData().getDatabaseProductName());
			logger.info("conn.getMetaData().getDatabaseProductVersion()"
					+ conn.getMetaData().getDatabaseProductVersion());
			logger.info("conn.getMetaData().getDriverMajorVersion()"
					+ conn.getMetaData().getDriverMajorVersion());
			logger.info("conn.getMetaData().getDriverMinorVersion()"
					+ conn.getMetaData().getDriverMinorVersion());
			logger.info("conn.getMetaData().getDriverName()"
					+ conn.getMetaData().getDriverName());
			logger.info("conn.getMetaData().getDriverVersion()"
					+ conn.getMetaData().getDriverVersion());
		} catch (SQLException se) {
			logger.error("SQL Exception occured", se);
			se.printStackTrace();
		}

	}

	/**
	 * 
	 * @return
	 * @throws NamingException
	 * @throws SQLException
	 */
	private static Connection getJDBCConnection() throws NamingException,
			SQLException {
		//logger.debug("Start getJDBCConnection");
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds;
		Connection conn=null;
		
		try {
			ds = (DataSource) envCtx.lookup(PropLoader
					.getProperty("DB_JNDI_NAME"));
			
			conn = ds.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Exception:", e);
		}
		return conn;
	}

	/**
	 * 
	 * @param e
	 * @param description
	 */
	private static void handleSQLException(SQLException e, String description) {
		String delim = "\n";
		logger
				.info("----------------------------------------------------------------");
		logger.info("SQL EXCEPTION:");
		logger.info("description=" + description + delim);
		logger.info("message=" + e.getMessage() + delim);
		logger.info("cause=" + e.getCause() + delim);
		logger.info("next exception=" + e.getNextException() + delim);
		logger.info("errorCode=" + e.getErrorCode() + delim);
		logger.info("stackTrace:" + e.getStackTrace() + delim);
		logger
				.info("----------------------------------------------------------------");
	}

	/**
	 * 
	 * @param conn
	 */
	public static void closeConnection(Connection conn) {
		try {

			conn.close(); // Return to connection pool
			conn = null; // Make sure we don't close it twice

		} catch (SQLException e) {
			handleSQLException(e, "3");
		} finally {

			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					;
				}
				conn = null;
			}
		}
	}
}