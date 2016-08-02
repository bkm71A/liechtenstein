package com.inchecktech.dpm.flex;

import com.inchecktech.dpm.beans.Device;
import com.inchecktech.dpm.beans.Location;
import com.inchecktech.dpm.beans.Sensor;
import com.inchecktech.dpm.beans.TreeNode;
import com.inchecktech.dpm.persistence.*;
import com.inchecktech.dpm.utils.Logger;

import java.util.List;

public class AdminFlexProxy {

	private static final Logger logger = new Logger(AdminFlexProxy.class);

	/*
		 *  Tree nodes
		 */
	public List<TreeNode> getTreeNodes() {
		try {
			List<TreeNode> result = PersistTreeNode.getTreeNode();
			return result;
		} catch (Exception e) {
			logger.error("ERROR IN getTreeNodes", e);
			e.printStackTrace();
			return null;
		}
	}

	public int saveTreeNode(int parentId, int locationId, int machineId, int channelId, int status,
							String name, String description, String type, int id) {
		int newNodeId = 0;
		try {
			if (id == 0) {
				newNodeId = PersistTreeNode.createNode(parentId, locationId, machineId, channelId, status, name, description, type);
			} else {
				PersistTreeNode.updateNode(parentId, locationId, machineId, channelId, status, name, description, type, id);
				newNodeId = id;
			}
		} catch (Exception e) {
			logger.error("ERROR IN saveTreeNode", e);
			e.printStackTrace();
		}
		return newNodeId;
	}

	/*
		 * Locations
		 */

	public List<Location> getLocations() {
		List<Location> locations = null;

		try {
			locations = PersistLocations.getLocations();
		} catch (Exception e) {
			logger.error("ERROR IN getLocations", e);
			e.printStackTrace();
		}

		return locations;
	}

	public int saveLocation(int locationId, String description) {
		int newLocationId = 0;
		try {
			if (locationId == 0) {
				newLocationId = PersistLocations.createLocation(description);
			} else {
				PersistLocations.updateLocation(locationId, description);
				newLocationId = locationId;
			}
		} catch (Exception e) {
			logger.error("ERROR IN saveLocation", e);
			e.printStackTrace();
		}
		return newLocationId;
	}

	/*
		 *  Devices
		 */

	public List<Device> getDevices() {
		List<Device> devices = null;

		try {
			devices = PersistDeviceConfig.getDevicesWithChannels();
		} catch (Exception e) {
			logger.error("ERROR IN getDevices", e);
			e.printStackTrace();
		}

		return devices;
	}

	public int saveDevice(int deviceId, String mac, String description, int maxChannels) {
		int newDeviceId = 0;
		try {
			if (deviceId == 0) {
				newDeviceId = PersistDeviceConfig.createDevice(mac, description, maxChannels);
			} else {
				PersistDeviceConfig.updateDevice(deviceId, mac, description, maxChannels);
				newDeviceId = deviceId;
			}
		} catch (Exception e) {
			logger.error("ERROR IN saveDevice", e);
			e.printStackTrace();
		}
		return newDeviceId;
	}

	/*
		 * Channels
		 */
	public int saveChannel(int channelId, int deviceId, String description, int channelType, String measureType, int deviceChannelId, float offset) {
		int newChannelId = 0;
		try {
			if (channelId == 0) {
				newChannelId = PersistChannelConfig.createChannel(deviceId, description, channelType, measureType, deviceChannelId, offset);
			} else {
				PersistChannelConfig.updateChannel(channelId, deviceId, description, channelType, measureType, deviceChannelId, offset);
				newChannelId = channelId;
			}
		} catch (Exception e) {
			logger.error("ERROR IN saveChannel", e);
			e.printStackTrace();
		}
		return newChannelId;
	}

	/*
		 * Sensors
		 */
	public List<Sensor> getSensors() {
		List<Sensor> sensors = null;

		try {
			sensors = PersistSensors.getSensors();
		} catch (Exception e) {
			logger.error("ERROR IN getDevices", e);
			e.printStackTrace();
		}

		return sensors;
	}

	public int saveSensor(int sensorId, String serialNumber, int vendorId, String sensorType, float sensitivity, int channelId) {
		int newSensorId = 0;
		try {
			if (sensorId == 0) {
				newSensorId = PersistSensors.createSensor(serialNumber, vendorId, sensorType, sensitivity, channelId);
			} else {
				PersistSensors.updateSensor(sensorId, serialNumber, vendorId, sensorType, sensitivity, channelId);
				newSensorId = sensorId;
			}
		} catch (Exception e) {
			logger.error("ERROR IN saveChannel", e);
			e.printStackTrace();
		}
		return newSensorId;
	}
}