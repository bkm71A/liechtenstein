package com.inchecktech.dpm.persistence;

import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.TreeNode;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PersistTreeNode {
	private static final Logger logger = new Logger(PersistTreeNode.class);

	public static List<TreeNode> getTreeNode() {

		List<TreeNode> nodeList = new ArrayList<TreeNode>();
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_GET_TREE);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				TreeNode node = new TreeNode();
				node.setTreenodeId(rs.getInt("TREENODE_ID"));
				node.setParentId(rs.getInt("PARENT_ID"));
				node.setChannelId(rs.getInt("CHANNEL_ID"));
				node.setStatus(rs.getInt("STATUS"));
				node.setMachineId(rs.getInt("MACHINE_ID"));
				node.setMachineId(rs.getInt("LOCATION_ID"));
				node.setPointId(rs.getInt("POINT_ID"));
				node.setName(rs.getString("NAME"));
				node.setDescription(rs.getString("DESCRIPTION"));
				node.setTreenodeType(rs.getString("TREENODE_TYPE"));
				node.setIncomingDataTimestamp(rs.getTimestamp("INCOMING_DATA_TIMESTAMP"));
				nodeList.add(node);

			}

			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger.error(
					"SQLException Occured while trying to get treenode list",
					se);
		}

		return nodeList;
	}

	public static void updateICNodeChannelTypeAndMeasureType(ICNode icnode) {

		if (null != icnode) {
			try {
				Connection conn = DAOFactory.getConnection();
				PreparedStatement stmt = conn
						.prepareStatement(SQLStatements.QUERY_GET_MISC_CHANNEL_INFO);
				stmt.setInt(1, icnode.getChannelid());
				ResultSet rs = stmt.executeQuery();

				while (rs.next()) {
					icnode.setChannelType(rs.getInt("CHANNEL_TYPE"));
					icnode.setMeasureType(rs.getString("MEASURE_TYPE"));
				}

				DAOFactory.closeConnection(conn);

			} catch (SQLException se) {
				logger.error("SQLException Occured while trying to get measure type and channel type", se);
			}
		}
	}

	public static void updateNodeIncomingDataTimestamp(int id, Date timestamp) {
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_TREE_NODE_INCOMING_DATA_TIMESTAMP);
			stmt.setObject(1, timestamp);
			stmt.setInt(2, id);

			stmt.executeUpdate();
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger
					.error(
							"SQLException Occured while trying to update treenode list with incoming data timestamp",
							se);
		}
	}

	public static void updateNode(int parentId, int locationId, int machineId, int channelId, int status,
								  String name, String description, String type, int id) {
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement stmt = conn
					.prepareStatement(SQLStatements.QUERY_UPDATE_TREE);
			stmt.setInt(1, parentId);
			stmt.setInt(2, locationId);
			stmt.setInt(3, machineId);
			stmt.setInt(4, channelId);
			stmt.setInt(5, status);
			stmt.setString(6, name);
			stmt.setString(7, description);
			stmt.setString(8, type);
			stmt.setInt(9, id);

			stmt.executeUpdate();
			DAOFactory.closeConnection(conn);

		} catch (SQLException se) {
			logger
					.error(
							"SQLException Occured while trying to update treenode list",
							se);
		}
	}

	public static int createNode(int parentId, int locationId, int machineId, int channelId, int status,
								 String name, String description, String type) {
		int nodeId = 0;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement create_stmt = conn
					.prepareStatement(SQLStatements.QUERY_INSERT_TREE);
			create_stmt.setInt(1, parentId);
			create_stmt.setInt(2, locationId);
			create_stmt.setInt(3, machineId);
			create_stmt.setInt(4, channelId);
			create_stmt.setInt(5, status);
			create_stmt.setString(6, name);
			create_stmt.setString(7, description);
			create_stmt.setString(8, type);

			create_stmt.executeUpdate();

			ResultSet rs = create_stmt.getGeneratedKeys();
			rs.next();
			nodeId = rs.getInt(1);

			DAOFactory.closeConnection(conn);
		} catch (SQLException se) {
			logger.error("SQLException Occured while trying to create treenode list", se);
		}
		return nodeId;
	}
}
