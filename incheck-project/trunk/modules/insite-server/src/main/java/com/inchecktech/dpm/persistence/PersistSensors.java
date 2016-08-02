package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.inchecktech.dpm.beans.Sensor;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistSensors {
    private static final Logger logger = new Logger(PersistSensors.class);

    public static List<Sensor> getSensors() {
        List<Sensor> sensors = new ArrayList<Sensor>();

        Sensor s = null;
        try {
            Connection conn = DAOFactory.getConnection();
            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_GET_SENSORS);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                s = new Sensor();
                s.setSensorId(rs.getInt("SENSOR_ID"));
                s.setSerialNumber(rs.getString("VENDORSN"));
                s.setType(rs.getString("SENSOR_TYPE"));
                s.setVendorId(rs.getInt("VENDOR_ID"));
                s.setSensitivity(rs.getFloat("SENSITIVITY"));

                sensors.add(s);
            }

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occured while trying to get sensors ", se);
        }
        return sensors;
    }

    public static int createSensor(String serialNumber, int vendorId, String sensorType, float sensitivity, int channelId) {
        int sensorId = 0;
        try {
            Connection conn = DAOFactory.getConnection();

            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_SAVE_SENSOR);
            pstmt.setString(1, serialNumber);
            pstmt.setString(2, sensorType);
            pstmt.setFloat(3, sensitivity);
            pstmt.setInt(4, vendorId);
            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
			rs.next();
			sensorId = rs.getInt(1);

            PreparedStatement pstmt2 = conn
                .prepareStatement(SQLStatements.QUERY_SET_SENSOR_FOR_CHANNEL);
            pstmt2.setInt(1, sensorId);
            pstmt2.setInt(2, channelId);
            pstmt2.executeUpdate();

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to create sensor ", se);
        }
        return sensorId;
    }

    public static int updateSensor(int sensorId, String serialNumber, int vendorId, String sensorType, float sensitivity, int channelId) {
        int result = 0;
        try {
            Connection conn = DAOFactory.getConnection();
            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_UPDATE_SENSOR);

            pstmt.setString(1, serialNumber);
            pstmt.setString(2, sensorType);
            pstmt.setFloat(3, sensitivity);
            pstmt.setInt(4, sensorId);

            result = pstmt.executeUpdate();

            PreparedStatement pstmt2 = conn
                .prepareStatement(SQLStatements.QUERY_SET_SENSOR_FOR_CHANNEL);
            pstmt2.setInt(1, sensorId);
            pstmt2.setInt(2, channelId);
            pstmt2.executeUpdate();

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to update sensor ", se);
        }
        return result;
    }
}
