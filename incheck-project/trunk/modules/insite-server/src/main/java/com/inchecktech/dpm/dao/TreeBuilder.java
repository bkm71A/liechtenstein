//package com.inchecktech.dpm.dao;
//
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.Map;
//
//import com.inchecktech.dpm.beans.ICNode;
//import com.inchecktech.dpm.utils.Logger;
//import com.inchecktech.exception.DPMException;
//
//public class TreeBuilder {
//	private static StringBuilder strbased = new StringBuilder();
//
//
//	private ArrayList<ICNode> nodeList = new ArrayList<ICNode>();
//	private HashMap<Integer,ICNode> nodeMapFLAT = new HashMap<Integer, ICNode>();
//	private static final Logger logger = new Logger(TreeBuilder.class);
//	//private static final String tableName="dba.treenodes";
//										   
//	
//
//	private void buildList() {
//		Map<Integer, ICNode> map = new HashMap<Integer, ICNode>();
//		String query = SQLStatements.QUERY_GET_TREE;
//		Connection conn = null;
//		PreparedStatement stmt = null;
//		ResultSet rs = null;
//		try {
//			
//			
//			try {
//				conn =DAOFactory.getConnection();
//			} catch (DPMException e) {
//				logger.error("SQL Exception while trying to get connection ",e );
//			}
//
//			stmt = conn.prepareStatement(query);
//			rs = stmt.executeQuery();
//
//			while (rs.next()) {
//
//				int id = rs.getInt("Id");
//				int parentid = rs.getInt("ParentID");
//				Integer level = new Integer(rs.getInt("Level"));
//
//				int channeld = rs.getInt("Channeld");
//				int status = rs.getInt("Status");
//
//				String name = rs.getString("Name");
//				String desc = rs.getString("Description");
//				String type = rs.getString("Type");
//				ICNode pNode = null;
//
//				if (0 != parentid) {
//					pNode = map.get(parentid);
//					if (null == pNode) {
//
//						pNode = new ICNode(parentid);
//						//pNode.setLevel(level);
//						pNode.setName(name);
//						pNode.setState(status);
//						pNode.setChannelid(channeld);
//						pNode.setType(type);
//						pNode.setDesc(desc);
//
//						map.put(parentid, pNode);
//
//					}
//				}
//
//
//				ICNode cNode = map.get(id);
//				if (null == cNode) {
//
//					cNode = new ICNode(id);
//				}
//				//cNode.setLevel(level);
//				cNode.setName(name);
//				cNode.setState(status);
//				cNode.setChannelid(channeld);
//				cNode.setType(type);
//				cNode.setDesc(desc);
//
//				map.put(id, cNode);
//				nodeMapFLAT.put(cNode.getId(),cNode);
//
//				if (0 != parentid) {
//					pNode.addChild(cNode);
//				} else {
//					nodeList.add(cNode);
//				}
//				cNode.setParent(pNode);
//
//			}
//
//			rs.close();
//			rs = null;
//			stmt.close();
//			stmt = null;
//			conn.close(); // Return to connection pool
//			conn = null; // Make sure we don't close it twice
//
//		} catch (SQLException e) {
//			logger.error("SQL Exception ",  e);
//		} finally {
//			// Always make sure result sets and statements are closed,
//			// and the connection is returned to the pool
//			if (rs != null) {
//				try {
//					rs.close();
//				} catch (SQLException e) {
//					;
//				}
//				rs = null;
//			}
//			if (stmt != null) {
//				try {
//					stmt.close();
//				} catch (SQLException e) {
//					;
//				}
//				stmt = null;
//			}
//			if (conn != null) {
//				try {
//					conn.close();
//				} catch (SQLException e) {
//					;
//				}
//				conn = null;
//			}
//		}
//
//		if (null != nodeList) {
//			for (ICNode node : nodeList) {
//				walk(node, 0);
//			}
//		}
//
//	}
//
//	public void updateNode(ICNode n){
//
//		Connection conn = null;
//		PreparedStatement stmt = null;
//		ResultSet rs = null;
//
//		try {
//			ICNode pnode=n.getParent();
//			int pid=0;
//			if(pnode!=null){
//
//				pid=pnode.getId();
//			}
//			
//			conn =DAOFactory.getConnection();
//			stmt = conn.prepareStatement(SQLStatements.QUERY_UPDATE_TREE);
//
//			/*			 int id = rs.getInt("Id");
//				int parentid = rs.getInt("ParentID");
//				Integer level = new Integer(rs.getInt("Level"));
//
//				int channeld = rs.getInt("Channeld");
//				int status = rs.getInt("Status");
//
//				String name = rs.getString("Name");
//				String desc = rs.getString("Description");
//				String type = rs.getString("Type");
//			 */
//			stmt.setInt(1, pid);
//			stmt.setInt(2, n.getChannelid());
//			stmt.setInt(3, n.getState());
//			stmt.setString(4, n.getName());
//			stmt.setString(5, n.getDesc());
//			stmt.setString(6, n.getType());
//			stmt.setInt(7, n.getId());
//			stmt.executeUpdate();
//			
//
//		} catch (Throwable e){
//			logger.error("Error", e);
//		} finally {
//			// Always make sure result sets and statements are closed,
//			// and the connection is returned to the pool
//			if (rs != null) {
//				try {
//					rs.close();
//				} catch (SQLException e) {
//					;
//				}
//				rs = null;
//			}
//			if (stmt != null) {
//				try {
//					stmt.close();
//				} catch (SQLException e) {
//					;
//				}
//				stmt = null;
//			}
//			if (conn != null) {
//				try {
//					conn.close();
//				} catch (SQLException e) {
//					;
//				}
//				conn = null;
//			}
//		}
//
//	}
//
//
//	public void createNode(ICNode n){
//
//		Connection conn = null;
//		PreparedStatement stmt = null;
//		ResultSet rs = null;
//
//
//		try {
//			ICNode pnode=n.getParent();
//			int pid=0;
//			if(pnode!=null){
//
//				pid=pnode.getId();
//			}
//			
//			conn =DAOFactory.getConnection();
//
//			/*			 int id = rs.getInt("Id");
//			int parentid = rs.getInt("ParentID");
//			Integer level = new Integer(rs.getInt("Level"));
//
//			int channeld = rs.getInt("Channeld");
//			int status = rs.getInt("Status");
//
//			String name = rs.getString("Name");
//			String desc = rs.getString("Description");
//			String type = rs.getString("Type");
//			 */
//			
//			stmt = conn.prepareStatement(SQLStatements.QUERY_INSERT_TREE);
//			stmt.setInt(1, n.getId());
//			stmt.setInt(2, pid);
//			stmt.setInt(3, n.getChannelid());
//			stmt.setInt(4, n.getState());
//			stmt.setString(5, n.getName());
//			stmt.setString(6, n.getDesc());
//			stmt.setString(7, n.getType());
//			stmt.executeUpdate();
//			
////			String q="insert into "+tableName+" (Id,ParentID,Level,Channeld,Status,Name,Description,Type) values ( " +
////			n.getId()+","+
////			pid+","+
////			//n.getLevel()+","+
////			n.getChannelid()+","+
////			n.getState()+","+
////			"'"+n.getName()+"',"+
////			"'"+n.getDesc()+"',"+
////			"'"+n.getType()+"')";
////
////			logger.debug(q);
////			conn.createStatement().executeUpdate(q);
//
//
//
//		} catch (Throwable e){
//			e.printStackTrace();
//		} finally {
//			// Always make sure result sets and statements are closed,
//			// and the connection is returned to the pool
//			if (rs != null) {
//				try {
//					rs.close();
//				} catch (SQLException e) {
//					;
//				}
//				rs = null;
//			}
//			if (stmt != null) {
//				try {
//					stmt.close();
//				} catch (SQLException e) {
//					;
//				}
//				stmt = null;
//			}
//			if (conn != null) {
//				try {
//					conn.close();
//				} catch (SQLException e) {
//					;
//				}
//				conn = null;
//			}
//		}
//
//	}
//
//	public void deleteNode(ICNode n){
//
//
//
//		String JNDI_NAME = "jdbc/incheckdb";
//		Connection conn = null;
//		PreparedStatement stmt = null;
//		ResultSet rs = null;
//
//
//		try {
//			ICNode pnode=n.getParent();
//			int pid=0;
//			if(pnode!=null){
//
//				pid=pnode.getId();
//			}
//			conn =DAOFactory.getConnection();
//
//			/*			 int id = rs.getInt("Id");
//			int parentid = rs.getInt("ParentID");
//			Integer level = new Integer(rs.getInt("Level"));
//
//			int channeld = rs.getInt("Channeld");
//			int status = rs.getInt("Status");
//
//			String name = rs.getString("Name");
//			String desc = rs.getString("Description");
//			String type = rs.getString("Type");
//			 */
//			
//			logger.debug("NOT DOING SHIT WITH DELETE YET");
//			//conn.createStatement().executeUpdate(q);
//
//
//
//		} catch (Throwable e){
//			e.printStackTrace();
//		} finally {
//			// Always make sure result sets and statements are closed,
//			// and the connection is returned to the pool
//			if (rs != null) {
//				try {
//					rs.close();
//				} catch (SQLException e) {
//					;
//				}
//				rs = null;
//			}
//			if (stmt != null) {
//				try {
//					stmt.close();
//				} catch (SQLException e) {
//					;
//				}
//				stmt = null;
//			}
//			if (conn != null) {
//				try {
//					conn.close();
//				} catch (SQLException e) {
//					;
//				}
//				conn = null;
//			}
//		}
//
//	}
//	public ArrayList<ICNode> getNodeList() {
//		buildList();		
//		return nodeList;
//	}
//
//
//	public HashMap<Integer,ICNode> getFlatNodeMap() {
//		buildList();		
//		return nodeMapFLAT;
//	}
//
//	public static void walk(ICNode node, int level) {
//
//		for (int i = 0; i < level; i++) {
//			System.out.print("  ");
//			strbased.append("  ");
//
//		}
//		logger.debug(node.getName());
//		strbased.append(node.getName());
//		if (node.children.size() > 0) {
//
//			for (ICNode b : node.children) {
//				level++;
//				walk(b, level);
//				level--;
//			}
//		}
//	}
//
//	public static String getStringBasedTree(){
//		return strbased.toString();
//	}
//
//}
