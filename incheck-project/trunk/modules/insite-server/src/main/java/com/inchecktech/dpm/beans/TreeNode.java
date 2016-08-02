package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class TreeNode implements Serializable {

	private static final long serialVersionUID = 1L;
	private int treenodeId;
	private int parentId;
	private String name;
	private String description;
	private int locationId;
	private int machineId;
	private int channelId;
	private int pointId;
	private String treenodeType;
	private int status;
	private Date incomingDataTimestamp;
    private List<TreeNode> children = null;

    public int getTreenodeId() {
		return treenodeId;
	}

	public void setTreenodeId(int treenodeId) {
		this.treenodeId = treenodeId;
	}

	public int getParentId() {
		return parentId;
	}

	public void setParentId(int parentId) {
		this.parentId = parentId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getLocationId() {
		return locationId;
	}

	public void setLocationId(int locationId) {
		this.locationId = locationId;
	}

	public int getMachineId() {
		return machineId;
	}

	public void setMachineId(int machineId) {
		this.machineId = machineId;
	}

	public int getChannelId() {
		return channelId;
	}

	public void setChannelId(int channelId) {
		this.channelId = channelId;
	}

	public int getPointId() {
		return pointId;
	}

	public void setPointId(int pointId) {
		this.pointId = pointId;
	}

	public String getTreenodeType() {
		return treenodeType;
	}

	public void setTreenodeType(String treenodeType) {
		this.treenodeType = treenodeType;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public Date getIncomingDataTimestamp() {
		return incomingDataTimestamp;
	}

	public void setIncomingDataTimestamp(Date incomingDataTimestamp) {
		this.incomingDataTimestamp = incomingDataTimestamp;
	}

    public List<TreeNode> getChildren() {
        return children;
    }

    public void addChild(TreeNode treeNode) {
        if (children == null) {
            children = new ArrayList<TreeNode>();
        }
        children.add(treeNode);
    }
}
