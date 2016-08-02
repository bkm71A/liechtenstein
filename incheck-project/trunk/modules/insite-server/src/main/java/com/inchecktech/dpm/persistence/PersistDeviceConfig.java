package com.inchecktech.dpm.persistence;

import com.inchecktech.dpm.beans.Channel;
import com.inchecktech.dpm.beans.Device;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PersistDeviceConfig {
    private static final Logger logger = new Logger(PersistDeviceConfig.class);

    public static Device getDevice(String macAddress) {
        Device d = null;
        Channel c = null;
        List<Channel> clist = new ArrayList<Channel>();
        try {
            Connection conn = DAOFactory.getConnection();
            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_GET_DEVICE_CONFIG_BY_MAC);
            pstmt.setString(1, macAddress);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {

                if (null == d) {
                    d = new Device();
                    d.setDescription(rs.getString("DESCRIPTION"));
                    d.setDeviceId(rs.getInt("DEVICE_ID"));
                    d.setDeviceType(rs.getInt("DEVICE_TYPE"));
                    d.setDpmIp(rs.getString("DPM_IP"));
                    d.setDpmPort(rs.getInt("DPM_PORT"));
                    d.setExternalIp(rs.getString("EXTERNAL_IP"));
                    d.setIpAddress(rs.getString("IP_ADDR"));
                    d.setMac(rs.getString("MAC"));
                    d.setNbrFastChannels(rs.getInt("NBRFASTCHANNELS"));
                    d.setNbrSlowChannels(rs.getInt("NBRSLOWCHANNELS"));
                    d.setPort(rs.getInt("IP_PORT"));
                    d.setPwerSupplyId(rs.getString("POWERSUPPLYID"));
                    d.setSerialNumber(rs.getString("SER_NBR"));
                    d.setVersionId(rs.getInt("VERSION_ID"));

                }

                c = new Channel();
                c.setChannelId(rs.getInt("CHANNEL_ID"));
                c.setChannelType(rs.getInt("CHANNEL_TYPE"));
                c.setMeasureType(rs.getString("MEASURE_TYPE"));
                c.setComments(rs.getString("COMMENTS"));
                c.setDeviceChannelId(rs.getInt("DEVICE_CHANNEL_ID"));
                c.setDeviceId(rs.getInt("DEVICE_ID"));
                c.setEnabled(rs.getBoolean("ENABLED"));
                c.setScGain(rs.getDouble("SC_GAIN"));
                c.setScOffset(rs.getDouble("SC_OFFSET"));
                c.setSensorChannelId(rs.getInt("SENSOR_CHANNEL_ID"));
                c.setSensorId(rs.getInt("SENSOR_ID"));

                clist.add(c);
            }

            DAOFactory.closeConnection(conn);

            if (null != d) {
                d.setChannels(clist);
            }

        } catch (SQLException se) {
            logger.error("An error occurred while trying to get device config ",
                    se);
        }
        return d;
    }

    public static List<Device> getDevicesWithChannels() {
        List<Device> devices = new ArrayList<Device>();
        Device d = null;
        Channel c = null;
        try {
            Connection conn = DAOFactory.getConnection();
            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_GET_DEVICES);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                d = new Device();
                d.setDescription(rs.getString("DESCRIPTION"));
                d.setDeviceId(rs.getInt("DEVICE_ID"));
                d.setDeviceType(rs.getInt("DEVICE_TYPE"));
                d.setDpmIp(rs.getString("DPM_IP"));
                d.setDpmPort(rs.getInt("DPM_PORT"));
                d.setExternalIp(rs.getString("EXTERNAL_IP"));
                d.setIpAddress(rs.getString("IP_ADDR"));
                d.setMac(rs.getString("MAC"));
                d.setNbrFastChannels(rs.getInt("NBRFASTCHANNELS"));
                d.setNbrSlowChannels(rs.getInt("NBRSLOWCHANNELS"));
                d.setPort(rs.getInt("IP_PORT"));
                d.setPwerSupplyId(rs.getString("POWERSUPPLYID"));
                d.setSerialNumber(rs.getString("SER_NBR"));
                d.setVersionId(rs.getInt("VERSION_ID"));

                devices.add(d);
            }

            PreparedStatement pstmtChannel = conn
                    .prepareStatement(SQLStatements.getChannelsForDevices(devices));
            ResultSet rsChannel = pstmtChannel.executeQuery();

            while (rsChannel.next()) {
                c = new Channel();
                c.setChannelId(rsChannel.getInt("CHANNEL_ID"));
                c.setChannelType(rsChannel.getInt("CHANNEL_TYPE"));
                c.setMeasureType(rsChannel.getString("MEASURE_TYPE"));
                c.setComments(rsChannel.getString("COMMENTS"));
                c.setDescription(rsChannel.getString("DESCRIPTION"));
                c.setDeviceChannelId(rsChannel.getInt("DEVICE_CHANNEL_ID"));
                c.setDeviceId(rsChannel.getInt("DEVICE_ID"));
                c.setEnabled(rsChannel.getBoolean("ENABLED"));
                c.setScGain(rsChannel.getDouble("SC_GAIN"));
                c.setScOffset(rsChannel.getDouble("SC_OFFSET"));
                c.setSensorChannelId(rsChannel.getInt("SENSOR_CHANNEL_ID"));
                c.setSensorId(rsChannel.getInt("SENSOR_ID"));
                setChannelToDevice(devices, c);
            }

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occured while trying to get devices with channels ", se);
        }

        return devices;
    }

    private static void setChannelToDevice(List<Device> devices, Channel channel) {
        if (channel == null) return;
        for (Device device : devices) {
            if (channel.getDeviceId() == device.getDeviceId()) {
                if (device.getChannels() == null) {
                    device.setChannels(new ArrayList<Channel>());
                }
                device.getChannels().add(channel);
                return;
            }
        }
    }

    public static int createDevice(String mac, String description, int maxChannels) {
        int deviceId = 0;
        try {
            Connection conn = DAOFactory.getConnection();

            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_SAVE_DEVICE);
            pstmt.setString(1, mac);
            pstmt.setInt(2, maxChannels);
            pstmt.setInt(3, 0);
            pstmt.setString(4, description);
            pstmt.setInt(5, 1);
            pstmt.setInt(6, 1);
            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
			rs.next();
			deviceId = rs.getInt(1);

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to create devices ", se);
        }
        return deviceId;
    }

    public static void updateDevice(int deviceId, String mac, String description, int maxChannels) {
        try {
            Connection conn = DAOFactory.getConnection();
            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_UPDATE_DEVICE);
            pstmt.setString(1, mac);
            pstmt.setInt(2, maxChannels);
            pstmt.setString(3, description);
            pstmt.setInt(4, deviceId);
            pstmt.executeUpdate();
            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to update devices ", se);
        }
    }

}


