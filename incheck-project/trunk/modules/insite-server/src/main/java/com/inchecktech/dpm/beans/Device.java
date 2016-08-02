package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.List;

public class Device implements Serializable{
	
	private static final long serialVersionUID = 1L;
	private int deviceId;
	private int deviceType;
	private String ipAddress;
	private int port;
	private String mac;
	private int nbrFastChannels;
	private int nbrSlowChannels;
	private int versionId;
	private String description;
	
	private String pwerSupplyId;
	private String externalIp;
	private String dpmIp;
	private int dpmPort;
	private String serialNumber;
	
	private List<Channel> channels;
	
	public int getDeviceId() {
		return deviceId;
	}
	public void setDeviceId(int deviceId) {
		this.deviceId = deviceId;
	}
	public int getDeviceType() {
		return deviceType;
	}
	public void setDeviceType(int deviceType) {
		this.deviceType = deviceType;
	}
	public String getIpAddress() {
		return ipAddress;
	}
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	public int getPort() {
		return port;
	}
	public void setPort(int port) {
		this.port = port;
	}
	public String getMac() {
		return mac;
	}
	public void setMac(String mac) {
		this.mac = mac;
	}
	public int getNbrFastChannels() {
		return nbrFastChannels;
	}
	public void setNbrFastChannels(int nbrFastChannels) {
		this.nbrFastChannels = nbrFastChannels;
	}
	public int getNbrSlowChannels() {
		return nbrSlowChannels;
	}
	public void setNbrSlowChannels(int nbrSlowChannels) {
		this.nbrSlowChannels = nbrSlowChannels;
	}
	public int getVersionId() {
		return versionId;
	}
	public void setVersionId(int versionId) {
		this.versionId = versionId;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getPwerSupplyId() {
		return pwerSupplyId;
	}
	public void setPwerSupplyId(String pwerSupplyId) {
		this.pwerSupplyId = pwerSupplyId;
	}
	public String getExternalIp() {
		return externalIp;
	}
	public void setExternalIp(String externalIp) {
		this.externalIp = externalIp;
	}
	public String getDpmIp() {
		return dpmIp;
	}
	public void setDpmIp(String dpmIp) {
		this.dpmIp = dpmIp;
	}
	public int getDpmPort() {
		return dpmPort;
	}
	public void setDpmPort(int dpmPort) {
		this.dpmPort = dpmPort;
	}
	public String getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}
	public List<Channel> getChannels() {
		return channels;
	}
	public void setChannels(List<Channel> channels) {
		this.channels = channels;
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder("\nDevice:");
		sb.append("\n\t").append("deviceId=").append(deviceId);
		sb.append("\n\t").append("deviceType=").append(deviceType);
		sb.append("\n\t").append("ipAddress=").append(ipAddress).append("\n");
		sb.append("\n\t").append("port=").append(port).append("\n");
		sb.append("\n\t").append("mac=").append(mac).append("\n");
		sb.append("\n\t").append("nbrFastChannels=").append(nbrFastChannels).append("\n");
		sb.append("\n\t").append("nbrSlowChannels=").append(nbrSlowChannels).append("\n");
		sb.append("\n\t").append("versionId=").append(versionId).append("\n");
		sb.append("\n\t").append("description=").append(description).append("\n");
		sb.append("\n\t").append("pwerSupplyId=").append(pwerSupplyId).append("\n");
		sb.append("\n\t").append("externalIp=").append(externalIp).append("\n");
		sb.append("\n\t").append("dpmIp=").append(dpmIp).append("\n");
		sb.append("\n\t").append("dpmPort=").append(dpmPort).append("\n");
		sb.append("\n\t").append("serialNumber=").append(serialNumber).append("\n");
		sb.append("\n\t").append("channels=").append(channels).append("\n");
		
		return sb.toString();
	}
	
}
