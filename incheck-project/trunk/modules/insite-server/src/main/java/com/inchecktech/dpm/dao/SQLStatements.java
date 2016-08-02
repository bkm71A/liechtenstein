package com.inchecktech.dpm.dao;

import com.inchecktech.dpm.beans.Device;
import com.inchecktech.dpm.beans.TimeUnit;

import java.text.MessageFormat;
import java.util.Date;
import java.util.List;

public class SQLStatements {

	/**
	 * Node Tree related
	 */
	public static final String QUERY_GET_TREE = "SELECT TREENODE_ID,PARENT_ID,CHANNEL_ID,STATUS,MACHINE_ID,LOCATION_ID,POINT_ID,NAME,DESCRIPTION,TREENODE_TYPE,INCOMING_DATA_TIMESTAMP FROM TREENODES";
	public static final String QUERY_GET_MISC_CHANNEL_INFO = "select channel_type, measure_type from channel c where channel_id=?";
	public static final String QUERY_UPDATE_TREE = "update treenodes set "
			+ "PARENT_ID= ? , LOCATION_ID=?, MACHINE_ID=?, CHANNEL_ID=? , STATUS= ?, NAME= ?, DESCRIPTION=?, TREENODE_TYPE= ? where TREENODE_ID= ?";

	public static final String QUERY_UPDATE_TREE_NODE_INCOMING_DATA_TIMESTAMP = "update treenodes set "
			+ "INCOMING_DATA_TIMESTAMP= ? where TREENODE_ID= ?";

	public static final String QUERY_DPMDEVENTLIST2 = "select * from DPMDEVICELIST where DPMID=?";
	public static final String QUERY_INSERT_TREE = "insert into treenodes (PARENT_ID,LOCATION_ID,MACHINE_ID,CHANNEL_ID,STATUS,NAME,DESCRIPTION,TREENODE_TYPE) values (?,?,?,?,?,?,?,?)";
	public static final String QUERY_DELETE_BY_ID = "delete from treenodes where Id=?";

	/**
	 * DSP configuration
	 */
	// TODO THIS NEEDS TO BE FIXED, it needs to determine SIM from the Device
	// not Sensor
	public static final String QUERY_GET_SIM_CHANNELS = "select distinct (c.CHANNEL_ID), c.CHANNEL_TYPE"
			+ " from CHANNEL c, SENSOR s"
			+ " WHERE c.SENSOR_ID=s.SENSOR_ID"
			+ " and s.SENSOR_TYPE = 'SIM'" + " and c.ENABLED=1";

	public static final String QUERY_GET_MTK_CHANNELS = "select distinct (c.CHANNEL_ID), c.CHANNEL_TYPE"
			+ " from CHANNEL c, SENSOR s"
			+ " WHERE c.SENSOR_ID=s.SENSOR_ID"
			+ " and s.SENSOR_TYPE = 'MTK'" + " and c.ENABLED=1";

	public static final String QUERY_GET_SPECTRUM_ANALYSIS_CONFIG_ALL = "SELECT sa.*"
			+ " FROM CONFIG_PROPERTIES cp, CONFIG_PROPERTIES_CHANNELS cc, channel c, CONFIG_SPECTR_ANALYSIS sa"
			+ " WHERE cp.PROPERTY_ID=cc.PROPERTY_ID"
			+ " AND c.CHANNEL_ID=CC.CHANNEL_ID"
			+ " AND c.CHANNEL_ID=?"
			+ " AND cp.PROPERTY_NAME='com.inchecktech.dpm.dam.SamplingRate'";
	//+ " AND sa.DAM_SAMPLING_RATE=cc.CONFIG_VALUE";

	public static final String QUERY_UPDATE_SPECTRUM_ANALYSIS_CONFIG = "update config_properties_channels c, config_properties cp,config_types t"
			+ " set c.CONFIG_VALUE=?"
			+ " where channel_id=?"
			+ " and c.PROPERTY_ID=cp.PROPERTY_id"
			+ " and cp.PROPERTY_NAME=?"
			+ " and cp.config_type_id=t.config_type_id;";

	public static final String QUERY_GET_CURRENT_SPECTRUM_ANALYSIS_CONFIG = "SELECT cp.PROPERTY_NAME, c.CONFIG_VALUE FROM config_properties_channels c, config_properties cp"
			+ " WHERE c.CHANNEL_ID=?"
			+ " AND c.PROPERTY_ID=cp.PROPERTY_ID"
			+ " AND cp.PROPERTY_NAME in ('com.inchecktech.dpm.dam.BlockSize', 'com.inchecktech.dpm.dam.SamplingRate', 'com.inchecktech.dpm.dam.AnalysisBandwidth', 'com.inchecktech.dpm.dam.NoOfLines')";

	public static final String QUERY_GET_CHANNEL_CONFIG_BY_CHANNEL = "SELECT cp.PROPERTY_NAME as CHANNEL_KEY,"
			+ " cc.CONFIG_VALUE as CHANNEL_VALUE,"
			+ " cp.DATA_TYPE, cp.DESCRIPTION,"
			+ " cc.DEFAULT_VALUE,"
			+ " cp.PROPERTY_ID,"
			+ " cg.*,"
			+ " u.UNIT_ID,"
			+ " ct.CONFIG_TYPE_ID,"
			+ " ct.TYPE_NAME as CONFIG_TYPE_NAME,"
			+ " ct.DESCRIPTION as CONFIG_TYPE_DESCRIPTION"
			+ " FROM CONFIG_PROPERTIES cp, CONFIG_PROPERTIES_CHANNELS cc, CHANNEL c, CONFIG_GROUPS cg, CONFIG_TYPES ct, UNITS u"
			+ " WHERE cp.PROPERTY_ID=cc.PROPERTY_ID"
			+ " AND c.CHANNEL_ID=CC.CHANNEL_ID"
			+ " AND cp.group_id=cg.group_id"
			+ " AND ct.config_type_id=cp.config_type_id"
			+ " AND u.UNIT_ID=cp.UNIT_ID" + " AND c.CHANNEL_ID=?;";

	public static final String QUERY_GET_CHANNEL_CONFIG_BY_TYPE = "select u.UNITTYPE, u.UNIT, g.*, ct.CONFIG_TYPE_ID, ct.TYPE_NAME as CONFIG_TYPE_NAME, ct.DESCRIPTION as CONFIG_TYPE_DESCRIPTION"
			+ " FROM CONFIG_PROPERTIES c, config_types ct, units u, config_groups g, CONFIG_PROPERTIES_CHANNELS cpn"
			+ " WHERE c.config_type_id=ct.config_type_id"
			+ " AND ct.type_name=?"
			+ " AND c.unit_id=u.unit_id"
			+ " AND g.group_id=c.group_id"
			+ " AND c.property_id=cpn.PROPERTY_ID";

	public static final String QUERY_INSERT_OVERRIDE_CHANNEL_CONFIG_VALUE = "INSERT INTO CONFIG_PROPERTIES_CHANNELS (CHANNEL_ID, PROPERTY_ID, CONFIG_VALUE) values (?,?,?) ";
	public static final String QUERY_UPDATE_OVERRIDE_CHANNEL_CONFIG_VALUE = "UPDATE CONFIG_PROPERTIES_CHANNELS SET CONFIG_VALUE=? WHERE CHANNEL_ID=? AND PROPERTY_ID=?";
	public static final String QUERY_GET_AVAIL_CHANNELS = "SELECT DISTINCT (CHANNEL_ID) FROM CHANNEL";
	public static final String QUERY_GET_CONFIG_ITEM = "select * from CONFIG_PROPERTIES cp, config_groups cg, config_types ct "
			+ " where cp.GROUP_ID=cg.GROUP_ID"
			+ " and cp.CONFIG_TYPE_ID=ct.CONFIG_TYPE_ID"
			+ " and cg.GROUP_NAME=?"
			+ " and ct.TYPE_NAME=?"
			+ " and cp.PROPERTY_NAME=?";

	public static final String QUERY_UPDATE_RUN_DEFAULT_VALUE_OF_CONFIG_ITEM = "update config_properties CP set RUN_VALUE =?, DEFAULT_VALUE =? where CP.PROPERTY_NAME =?";
	
	/**
	 * DPM configuration
	 */
	public static final String QUERY_UPDATE_TIMER_CONFIG = "update DPM_CONFIG set CHANNEL_VALUE =? where channel_key='timer_freq'";

	@Deprecated
	public static final String QUERY_GET_PROCESSED_DATA_DATES = "select SAMPLE_TIME from SAMPLE_MASTER where CHANNEL_ID=? and SAMPLE_TIME >= ? and SAMPLE_TIME <= ? order by SAMPLE_TIME ASC";
	@Deprecated
	public static final String QUERY_GET_PROCESSED_DATA = "select SAMPLE_VALUE from SAMPLE_MASTER where CHANNEL_ID=? and SAMPLE_TIME=?";
	@Deprecated
	public static final String QUERY_GET_PROCESSED_DATA_LATEST_N = "SELECT TOP ? * from SAMPLE_MASTER WHERE CHANNEL_ID=? ORDER BY SAMPLE_TIME DESC";
	//@Deprecated	public static final String QUERY_INSERT_PROCESSED_DATA = "INSERT INTO SAMPLE_MASTER (CHANNEL_ID, SAMPLE_TIME, SAMPLE_RATE, SAMPLE_LENGTH, RPM,OVERALL_VALUE, UNIT_ID, ALARM_LOG_AVAILABLE, COMMENTS, SAMPLE_VALUE, DOMAIN_TYPE) values (?,?,?,?,?,?,?,?,?,?,?)";

	public static final String QUERY_INSERT_SAMPLE_MAIN = "INSERT INTO SAMPLE_MAIN (CHANNEL_ID, SAMPLE_TS, SAMPLE_RATE, RPM, ALARM_LOG_AVAILABLE, UNIT_ID, COMMENTS) values (?,?,?,?,?,?,?)";
	public static final String QUERY_INSERT_SAMPLE_VIBRATION = "INSERT INTO SAMPLE_VIBRATION (SAMPLE_ID, SAMPLE_VALUE) values(?,?)";
	public static final String QUERY_INSERT_SAMPLE_OVERALL = "INSERT INTO SAMPLE_OVERALL (SAMPLE_ID, OVERALL_TYPE, BAND_ID, OVERALL_VALUE) values(?,?,?,?)";
	public static final String QUERY_GET_SAMPLE_VIBRATION = "select sv.SAMPLE_VALUE from SAMPLE_VIBRATION sv, SAMPLE_MAIN sm where sv.SAMPLE_ID = sm.SAMPLE_ID and sm.CHANNEL_ID=? and sm.SAMPLE_TS=?";

	public static final String QUERY_ACK_EVENT = "UPDATE EVENT_LOG SET ACK_BY=?, NOTES=?, ACK_TS=? WHERE EVENT_ID=?";

	public static final String QUERY_GET_EVENT_DATA_PATTERN = " SELECT"
			+ "   event_log.event_id, event_log.notes, channel.channel_id, location_name(channel.channel_id),"
			+ "   channel.channel_type, et.severity_id, es.description, et.lower_bound,"
			+ "   et.upper_bound, es.longdescription, sample_master.overall_type,"
			+ "   sample_master.overall_value, event_log.event_ts, event_log.ack_by, sample_main.sample_ts, users.*"
			+ " FROM" + "   event_log event_log"
			+ "   INNER JOIN sample_overall sample_master"
			+ "   ON event_log.sample_id = sample_master.sample_id"
			+ "   INNER JOIN sample_main"
			+ "   ON event_log.sample_id = sample_main.sample_id"
			+ "   INNER JOIN event_treshold et"
			+ "   ON event_log.event_tr_id = et.event_tr_id"
			+ "   INNER JOIN event_severity es"
			+ "   ON et.severity_id = es.severity_id"
			+ "   INNER JOIN channel channel"
			+ "   ON event_log.channel_id = channel.channel_id"
			+ "   INNER JOIN overall_types"
			+ "   ON et.overall_type_id = overall_types.overall_type_id"
			+ "   LEFT OUTER JOIN users" + "   ON ACK_BY= users.USER_ID"
			+ "   where sample_master.overall_type=\"Accel_Rms\""
			+ " {0} " + " ORDER BY"
			+ "   event_log.event_ts DESC {1}";

	public static final String QUERY_GET_ALL_EVENTS_DATA = MessageFormat.format(QUERY_GET_EVENT_DATA_PATTERN, "", "");

	public static final String QUERY_GET_EVENT_DATA_BY_CH_ID = MessageFormat.format(QUERY_GET_EVENT_DATA_PATTERN, " AND channel.channel_id = ?", " LIMIT ?");

	public static final String QUERY_INSERT_EVENT = "INSERT INTO EVENT_LOG(CHANNEL_ID, SAMPLE_ID, EVENT_TR_ID, EVENT_TS) VALUES(?, ?, ?, now())";

	// user-role stuff
	public static final String QUERY_GET_USERS = "select * from users";
	public static final String QUERY_GET_USER = "select * from users where username = ?";
	public static final String QUERY_GET_USER_ID = "select USER_ID from users where username=?";
	public static final String QUERY_GET_ROLES_FOR_USER = "SELECT r.* FROM roles r, users u, userrole ur WHERE r.ROLE_ID=ur.ROLE_ID AND u.USER_ID=ur.USER_ID AND u.username= ?";

	public static final String QUERY_AUTH_USER = "select u.*, r.*"
			+ " from USERS u, ROLES r, USERROLE ur" + " where u.USERNAME = ?"
			+ " and u.USERPASS = ?" + " and u.ENABLED=?" + " and u.VERIFIED=?"
			+ " and u.USER_ID=ur.USER_ID" + " and r.ROLE_ID=ur.ROLE_ID";

	public static final String QUERY_REGISTER_USER = "insert into users (username, userpass, firstname, lastname, email, organization, industry, howdidyouhear, maillist, contactlist, regtoken, enabled, verified, timezone) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	public static final String QUERY_UPDATE_USER = "update users set username=?, firstname=?, lastname=?, title=?, email=?, enabled=?, verified=?, timezone=? where username=?";
	public static final String QUERY_ENABLE_USER = "update users set enabled=? where username=?";
	public static final String QUERY_VERIFY_USER_EMAIL = "update users set verified=? where regtoken=?";

	public static final String QUERY_UPDATE_USER_PASSWORD = "update users set userpass=? where username=?";
	public static final String QUERY_DELETE_USER = "delete from users where username=?";
	public static final String QUERY_ADD_USER_TO_ROLE = "insert into userrole (USER_ID, ROLE_ID) values (?, ?)";
	public static final String QUERY_REMOVE_USER_FROM_ROLE = "delete from userrole where USER_ID=? and ROLE_ID=?";
	public static final String QUERY_REMOVE_USER_FROM_ROLES = "delete from userrole where USER_ID=?";

	public static final String QUERY_CREATE_ROLE = "insert into ROLES (ROLENAME, ROLEDESC) values (?,?)";
	public static final String QUERY_UPDATE_ROLE = "update ROLES set ROLENAME=?, ROLEDESC=? where ROLENAME=?";
	public static final String QUERY_GET_ROLE_ID = "select ROLE_ID from ROLES where ROLENAME=?";
	public static final String QUERY_GET_ROLE = "select * from roles where ROLENAME=?";
	public static final String QUERY_GET_ROLES = "select * from ROLES";

	// user session
	//public static final String QUERY_CREATE_USER_SESSION = "insert into usersession (sessionid, createDate, modifyDate, USER_ID) values (?,?,?,?)";
	//public static final String QUERY_DELETE_USER_SESSION = "delete from usersession where sessionid=?";
	//public static final String QUERY_GET_USER_SESSION = "select s.* from usersession s, users u where u.username=? AND u.USER_ID=s.USER_ID";
	//public static final String QUERY_UPDATE_USER_SESSION = "UPDATE usersession SET modifyDate = ? WHERE SESSION_ID=?";
	//public static final String QUERY_IS_VALID_SESSION = "select count(*) from usersession where SESSION_ID=?";

	// user preferences
	public static final String QUERY_GET_PREFERENCE_FOR_USER_AND_KEY = "select p.* from user_preference up, preference p, users u where up.user_id=? and p.preference_key=? and up.user_id=u.user_id and p.preference_id=up.preference_id order by preference_key";
	public static final String QUERY_GET_PREFERENCES_FOR_USER = "select p.* from user_preference up, preference p, users u where up.user_id=? and up.user_id=u.user_id and p.preference_id=up.preference_id order by preference_key ";
	public static final String QUERY_SET_PREFERENCE_FOR_USER = "insert into user_preference (user_id, preference_id) values (?,?)";
	public static final String QUERY_UNSET_PREFERENCE_FOR_USER = "delete from user_preference where user_id=? and preference_id=?";

	public static final String QUERY_CREATE_PREFERENCE = "insert into preference (preference_key, preference_value, preference_level, preference_type, preference_description) values (?,?,?,?,?)";
	public static final String QUERY_UPDATE_PREFERENCE = "update preference set preference_key=?, preference_value=?, preference_level=?, preference_type=?, preference_description=? where preference_id=? ";
	public static final String QUERY_DELETE_PREFERENCE = "delete from preference where preference_id=?";
	public static final String QUERY_GET_AVAIL_PREFERENCES = "select * from preference";
	public static final String QUERY_GET_PREFERENCES_FOR_KEY = "select * from preference where preference_key=?";
	public static final String QUERY_GET_MIN_DISPLAYED_PRECISION = "SELECT MIN(preference_value) FROM preference WHERE preference_type = 'DisplayedPrecision'";

	// bands
	public static final String QUERY_CREATE_BAND = "INSERT INTO ANALYSIS_BANDS (band_coefficient, start_freq, end_freq, band_name, active_flag) values (?,?,?,?,?)";
	public static final String QUERY_UPDATE_BAND = "UPDATE ANALYSIS_BANDS set band_coefficient=?, start_freq=?, end_freq=?, band_name=?, active_flag=? where band_id=?";
	public static final String QUERY_DELETE_BAND = "DELETE FROM ANALYSIS_BANDS where band_id=?";
	public static final String QUERY_MAP_BAND_TO_CHANNEL = "INSERT INTO CHANNEL_BAND (band_id, channel_id) values (?,?)";
	public static final String QUERY_UNMAP_BAND_TO_CHANNEL = "DELETE FROM CHANNEL_BAND where band_id=? and channel_id=?";
	public static final String QUERY_GET_BAND_FOR_CHANNEL = "SELECT ab.*, cb.channel_id FROM ANALYSIS_BANDS ab, CHANNEL_BAND cb, CHANNEL c where c.channel_id=? and ab.band_id=cb.band_id and cb.channel_id=c.channel_id";
	public static final String QUERY_GET_ALL_BANDS = "SELECT ab.* FROM ANALYSIS_BANDS ab";
	public static final String QUERY_DISABLE_BAND = "UPDATE ANALYSIS_BANDS set ACTIVE_FLAG='false' where band_id=?";


	public static String queryGetOverallChartDataMinute(int channelId,
														String function, Date startDateTime, Date endDateTime) {

		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append(function).append("(OVERALL_VALUE) AS RMS, ").append(
				" YEAR (SAMPLE_TIME) AS YEAR,").append(
				" MONTH (SAMPLE_TIME) AS MONTH,").append(
				" DAY (SAMPLE_TIME) AS DAY,").append(
				" HOUR (SAMPLE_TIME) AS HOUR,").append(
				" MINUTE (SAMPLE_TIME) AS MINUTE,").append(
				" SAMPLE_TIME AS MYTIME").append(" FROM SAMPLE_MASTER ")
				.append(" WHERE CHANNEL_ID=? ").append(
				" AND NOT (OVERALL_VALUE = 0) ").append(
				" AND SAMPLE_TIME BETWEEN ? AND ?").append(
				" AND DOMAIN_TYPE = ?").append(
				" GROUP BY YEAR, MONTH, DAY, HOUR, MINUTE;");

		return SQL.toString();
	}

	public static String queryGetOverallChartDataHour(int channelId,
													  String function, Date startDateTime, Date endDateTime) {

		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append(function).append("(OVERALL_VALUE) AS RMS, ").append(
				" YEAR(SAMPLE_TIME) AS YEAR,").append(
				" MONTH (SAMPLE_TIME) AS MONTH,").append(
				" DAY (SAMPLE_TIME) AS DAY,").append(
				" HOUR (SAMPLE_TIME) AS HOUR, SAMPLE_TIME AS MYTIME")
				.append(" FROM SAMPLE_MASTER ").append(" WHERE (CHANNEL_ID=? ")
				.append(" AND NOT (OVERALL_VALUE = 0) ").append(
				" AND SAMPLE_TIME BETWEEN ? AND ?)").append(
				" AND DOMAIN_TYPE = ?").append(
				" GROUP BY YEAR, MONTH, DAY, HOUR;");

		return SQL.toString();
	}

	public static String queryGetOverallChartDataDay(int channelId,
													 String function, Date startDateTime, Date endDateTime) {

		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append(function).append("(OVERALL_VALUE) AS RMS, ").append(
				" YEAR(SAMPLE_TIME) AS YEAR,").append(
				" MONTH (SAMPLE_TIME) AS MONTH,").append(
				" DAY (SAMPLE_TIME) AS DAY, SAMPLE_TIME AS MYTIME")
				.append(" FROM SAMPLE_MASTER ").append(" WHERE (CHANNEL_ID=? ")
				.append(" AND NOT (OVERALL_VALUE = 0) ").append(
				" AND SAMPLE_TIME BETWEEN ? AND ?)").append(
				" AND DOMAIN_TYPE = ?").append(
				" GROUP BY YEAR, MONTH, DAY;");

		return SQL.toString();
	}

	public static String queryGetOverallChartDataWeek(int channelId,
													  String function, Date startDateTime, Date endDateTime) {

		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append(function).append("(OVERALL_VALUE) AS RMS,  ").append(
				" YEAR(SAMPLE_TIME) AS YEAR,").append(
				" MONTH (SAMPLE_TIME) AS MONTH,").append(
				" WEEK (SAMPLE_TIME) AS WEEK,").append(
				" SAMPLE_TIME AS MYTIME").append(" FROM SAMPLE_MASTER ")
				.append(" WHERE (CHANNEL_ID=? ").append(
				" AND NOT (OVERALL_VALUE = 0) ").append(
				" AND SAMPLE_TIME BETWEEN ? AND ?)").append(
				" AND DOMAIN_TYPE = ?").append(
				" GROUP BY YEAR, MONTH, WEEK;");

		return SQL.toString();
	}

	public static String queryGetOverallChartDataMonth(int channelId,
													   String function, Date startDateTime, Date endDateTime) {

		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append(function).append("(OVERALL_VALUE) AS RMS, ").append(
				" YEAR(SAMPLE_TIME) AS YEAR,").append(
				" MONTH (SAMPLE_TIME) AS MONTH, SAMPLE_TIME AS MYTIME")
				.append(" FROM SAMPLE_MASTER ").append(" WHERE (CHANNEL_ID=? ")
				.append(" AND NOT (OVERALL_VALUE = 0) ").append(
				" AND SAMPLE_TIME BETWEEN ? AND ?)").append(
				" AND DOMAIN_TYPE = ?")
				.append(" GROUP BY YEAR, MONTH;");

		return SQL.toString();
	}

	public static String queryGetOverallChartDataYear(int channelId,
													  String function, Date startDateTime, Date endDateTime) {

		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append(function).append("(OVERALL_VALUE) AS RMS, ").append(
				" YEAR(SAMPLE_TIME) AS YEAR, SAMPLE_TIME AS MYTIME")
				.append(" FROM SAMPLE_MASTER ").append(" WHERE (CHANNEL_ID=? ")
				.append(" AND NOT (OVERALL_VALUE = 0) ").append(
				" AND SAMPLE_TIME BETWEEN ? AND ?)").append(
				" AND DOMAIN_TYPE = ?").append(" GROUP BY YEAR;");

		return SQL.toString();
	}

	public static String queryGetHistoryData(int channelId, String overall, int bandId, Date startDate, Date endDate, TimeUnit unit) {
		StringBuilder SQL = new StringBuilder("SELECT ");
		if (unit == TimeUnit.minute) {
			SQL.append("OVERALL_VALUE, SO.OVERALL_TYPE, SAMPLE_TS ");
		} else {
			SQL.append("MIN(OVERALL_VALUE) , MAX(OVERALL_VALUE), AVG(OVERALL_VALUE), SO.OVERALL_TYPE, ");
			if (unit == TimeUnit.hour) {
				SQL.append("SAMPLE_TS, DATE(SAMPLE_TS), HOUR(SAMPLE_TS) ");
			} else if (unit == TimeUnit.week) {
				SQL.append("SAMPLE_TS, WEEK(SAMPLE_TS) ");
			} else {
				SQL.append("DATE(SAMPLE_TS) ");
			}
		}
		SQL.append("FROM SAMPLE_MAIN SM ")
				.append("JOIN SAMPLE_OVERALL SO ON SM.SAMPLE_ID=SO.SAMPLE_ID ")
				.append("WHERE ")
				.append("SM.CHANNEL_ID = ? ")
				.append("AND SO.BAND_ID = ? ")
				.append("AND SAMPLE_TS BETWEEN ? AND ? ");
		if (overall != null) {
			SQL.append("AND SO.OVERALL_TYPE = ? ");
		}
		if (unit == TimeUnit.minute) {
			SQL.append("ORDER BY SAMPLE_TS;");
		} else if (unit == TimeUnit.hour) {
			SQL.append("GROUP BY DATE(SAMPLE_TS), HOUR(SAMPLE_TS) ")
					.append("ORDER BY DATE(SAMPLE_TS), HOUR(SAMPLE_TS);");
		} else if (unit == TimeUnit.week) {
			SQL.append("GROUP BY WEEK(SAMPLE_TS) ")
					.append("ORDER BY WEEK(SAMPLE_TS);");
		} else {
			SQL.append("GROUP BY DATE(SAMPLE_TS) ")
					.append("ORDER BY DATE(SAMPLE_TS);");
		}
		return SQL.toString();
	}

	public static String queryGetHistoryDataHour(int channelId, String overall, int bandId, Date startDate, Date endDate) {
		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append("MIN(OVERALL_VALUE) , MAX(OVERALL_VALUE), AVG(OVERALL_VALUE), SAMPLE_TS, DATE(SAMPLE_TS), HOUR(SAMPLE_TS) ")
				.append("FROM SAMPLE_MAIN SM ")
				.append("JOIN SAMPLE_OVERALL SO ON SM.SAMPLE_ID=SO.SAMPLE_ID ")
				.append("WHERE ")
				.append("SM.CHANNEL_ID = ? ")
				.append("AND SAMPLE_TS BETWEEN ? AND ? ")
				.append("AND SO.BAND_ID = ? ")
				.append("AND SO.OVERALL_TYPE = ? ")
				.append("GROUP BY DATE(SAMPLE_TS), HOUR(SAMPLE_TS) ")
				.append("ORDER BY DATE(SAMPLE_TS), HOUR(SAMPLE_TS);");

		return SQL.toString();
	}

	public static String queryGetHistoryDataDate(int channelId, String overall, int bandId, Date startDate, Date endDate) {
		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append("MIN(OVERALL_VALUE) , MAX(OVERALL_VALUE), AVG(OVERALL_VALUE), DATE(SAMPLE_TS) ")
				.append("FROM SAMPLE_MAIN SM ")
				.append("JOIN SAMPLE_OVERALL SO ON SM.SAMPLE_ID=SO.SAMPLE_ID ")
				.append("WHERE ")
				.append("SM.CHANNEL_ID = ? ")
				.append("AND SAMPLE_TS BETWEEN ? AND ? ")
				.append("AND SO.BAND_ID = ? ")
				.append("AND SO.OVERALL_TYPE = ? ")
				.append("GROUP BY DATE(SAMPLE_TS) ")
				.append("ORDER BY DATE(SAMPLE_TS);");

		return SQL.toString();
	}

	public static String queryGetHistoryDataWeek(int channelId, String overall, int bandId, Date startDate, Date endDate) {
		StringBuilder SQL = new StringBuilder("SELECT ");
		SQL.append("MIN(OVERALL_VALUE) , MAX(OVERALL_VALUE), AVG(OVERALL_VALUE), SAMPLE_TS, WEEK(SAMPLE_TS) ")
				.append("FROM SAMPLE_MAIN SM ")
				.append("JOIN SAMPLE_OVERALL SO ON SM.SAMPLE_ID=SO.SAMPLE_ID ")
				.append("WHERE ")
				.append("SM.CHANNEL_ID = ? ")
				.append("AND SAMPLE_TS BETWEEN ? AND ? ")
				.append("AND SO.BAND_ID = ? ")
				.append("AND SO.OVERALL_TYPE = ? ")
				.append("GROUP BY WEEK(SAMPLE_TS) ")
				.append("ORDER BY WEEK(SAMPLE_TS);");

		return SQL.toString();
	}

	/**
	 * Audit Log
	 */
	public static final String QUERY_INSERT_AUDIT_RECORD = "INSERT INTO AUDITLOG (USER_ID, ACTION, TIMESTMP, DESCRIPTION) values (?,?,?,?)";
	public static final String QUERY_GET_DEVICE_CONFIG_BY_MAC = "SELECT d.*, c.*"
			+ " FROM DEVICE d, CHANNEL c"
			+ " WHERE c.DEVICE_ID=d.DEVICE_ID"
			+ " AND d.MAC=?";

	public static final String QUERY_GET_AVAIL_NOTIFICATIONS = "SELECT * FROM NOTIFY_DELIVERY n WHERE DELIVERY_STATUS = ?;";
	public static final String QUERY_SET_NOTIFICATION_STATUS = "UPDATE NOTIFY_DELIVERY SET DELIVERY_STATUS = ? WHERE NOTIFY_ID=?;";

	public static final String QUERY_CREATE_DELIVERY_PATH = "INSERT INTO DELIVERY_PATH (DELIVERY_GROUP_ID, RETRY_INTERVAL, RETRY_ATTEMPTS, ESCALATION_DELIVERY_ID, DELIVERY_ADDRESS, DELIVERY_NAME, DELIVERY_TYPE, DELIVERY_NOTES) VALUES(?,?,?,?,?,?,?,?) ";
	public static final String QUERY_DELETE_DELIVERY_PATH = "DELETE FROM DELIVERY_PATH WHERE DELIVERY_ID=?";
	public static final String QUERY_UPDATE_DELIVERY_PATH = "UPDATE DELIVERY_PATH SET DELIVERY_ADDRESS=?, DELIVERY_NOTES=? WHERE DELIVERY_ID=?";

	public static final String QUERY_GET_EVENT_THRESHOLD = "select EVENT_TR_ID,CHANNEL_ID,location_name(CHANNEL_ID),OVERALL_TYPE_ID,LOWER_BOUND,UPPER_BOUND,UNIT_ID,BAND_ID,et.SEVERITY_ID,DELIVERY_ID,ACTION,es.DESCRIPTION,es.LONGDESCRIPTION from EVENT_TRESHOLD et INNER JOIN event_severity es ON et.SEVERITY_ID = es.SEVERITY_ID where CHANNEL_ID=? ORDER BY et.SEVERITY_ID desc";
	public static final String QUERY_INSERT_EVENT_THRESHOLD = "INSERT INTO EVENT_TRESHOLD (CHANNEL_ID,OVERALL_TYPE_ID,LOWER_BOUND,UPPER_BOUND,UNIT_ID,SEVERITY_ID,ACTION,BAND_ID) VALUES (?,?,?,?,?,?,?,?)";
	public static final String QUERY_UPDATE_EVENT_THRESHOLD = "UPDATE EVENT_TRESHOLD SET OVERALL_TYPE_ID=? , UPPER_BOUND=?, UNIT_ID=?, SEVERITY_ID=?, BAND_ID=? WHERE EVENT_TR_ID=?";
	public static final String QUERY_UPDATE_EVENT_THRESHOLD_WITH_VALUES = "UPDATE EVENT_TRESHOLD SET LOWER_BOUND=? , UPPER_BOUND=? WHERE OVERALL_TYPE_ID=? AND CHANNEL_ID=? AND SEVERITY_ID=? AND UNIT_ID=?";
	public static final String QUERY_DELETE_EVENT_THRESHOLD_BY_EVENT_TR_ID = "delete from EVENT_TRESHOLD where event_tr_id=?";
	public static final String QUERY_DELETE_EVENT_THRESHOLD_BY_CHANNEL_ID = "delete from EVENT_TRESHOLD where CHANNEL_ID=?";
	public static final String QUERY_UNMAP_EVENT_TR_TO_DELIVERY_PATH = "DELETE FROM EVENT_DELIVERY WHERE EVENT_TR_ID=? AND DELIVERY_ID=?";

	public static final String QUERY_MAP_EVENT_TR_TO_DELIVERY_PATH = "INSERT INTO EVENT_DELIVERY (EVENT_TR_ID, DELIVERY_ID) VALUES (?,?)";
	public static final String QUERY_GET_DELIVERY_PATH_FOR_EVENTHRESHOLD = "SELECT d.* from DELIVERY_PATH d, EVENT_DELIVERY ed"
			+ " WHERE d.DELIVERY_ID=ed.DELIVERY_ID" + " AND ed.EVENT_TR_ID=?";

	public static final String QUERY_SAVE_DEVICE_EVENT = "INSERT INTO DEVICE_EVENT (DEVICE_ID,OPERATION,OPERATION_TS) VALUES (?,?,?)";
	public static final String QUERY_GET_LAST_DEVICE_EVENTS = "SELECT e.*, d.MAC FROM DEVICE_EVENT e, DEVICE d WHERE (d.DEVICE_ID = e.DEVICE_ID)";

	/*
		*  Admin tool
		*/

	public static final String QUERY_GET_DEVICES = "SELECT * FROM DEVICE d";

	public static String getChannelsForDevices(List<Device> deviceList) {
		StringBuffer result = new StringBuffer("SELECT * FROM CHANNEL c WHERE c.DEVICE_ID IN (");
		StringBuffer deviceIds = new StringBuffer("");
		for (Device device : deviceList) {
			if (deviceIds.length() != 0) {
				deviceIds.append(", ");
			}
			deviceIds.append(device.getDeviceId());
		}
		result.append(deviceIds);
		result.append(")");
		return result.toString();
	}

	public static final String QUERY_SAVE_DEVICE = "INSERT INTO DEVICE (MAC, NBRFASTCHANNELS, NBRSLOWCHANNELS, DESCRIPTION, DEVICE_TYPE,VERSION_ID) VALUES (?,?,?,?,?,?)";
	public static final String QUERY_UPDATE_DEVICE = "UPDATE DEVICE SET MAC=?, NBRFASTCHANNELS=?, DESCRIPTION=? WHERE DEVICE_ID=?";

	public static final String QUERY_SAVE_CHANNEL = "INSERT INTO CHANNEL (DEVICE_ID, DESCRIPTION, CHANNEL_TYPE, MEASURE_TYPE, DEVICE_CHANNEL_ID, SC_OFFSET, ENABLED) VALUES (?,?,?,?,?,?,?)";
	public static final String QUERY_UPDATE_CHANNEL = "UPDATE CHANNEL SET DEVICE_ID=?, DESCRIPTION=?, CHANNEL_TYPE=?, MEASURE_TYPE=?, DEVICE_CHANNEL_ID=?, SC_OFFSET=?, ENABLED=? WHERE CHANNEL_ID=?";

	public static final String QUERY_GET_SENSORS = "SELECT * FROM SENSOR";
	public static final String QUERY_SAVE_SENSOR = "INSERT INTO SENSOR (VENDORSN, SENSOR_TYPE, SENSITIVITY, VENDOR_ID) VALUES (?,?,?,?)";
	public static final String QUERY_UPDATE_SENSOR = "UPDATE SENSOR SET VENDORSN=?, SENSOR_TYPE=?, SENSITIVITY=? WHERE SENSOR_ID=?";

	public static final String QUERY_GET_LOCATIONS = "SELECT * FROM LOCATION";
	public static final String QUERY_SAVE_LOCATION = "INSERT INTO LOCATION (DESCRIPTION) VALUES (?)";
	public static final String QUERY_UPDATE_LOCATION = "UPDATE LOCATION SET DESCRIPTION=? WHERE LOCATION_ID=?";

	public static final String QUERY_SET_SENSOR_FOR_CHANNEL = "UPDATE CHANNEL SET SENSOR_ID=? WHERE CHANNEL_ID=?";
}
