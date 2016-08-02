package com.inchecktech.dpm.tests;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.ICNodeFactory;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;


public class TestConnectionPool {
	public static void main(String[] args) throws Exception {
		Connection conn = DAOFactory.getConnection();
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(SQLStatements.QUERY_GET_TREE);
		
		System.out.println("returned " + rs.getMetaData().getColumnCount() + " columns");
		
		while(rs.next()){
		 int id = rs.getInt ("Id");
         int parentid = rs.getInt("ParentID");


         int channeld = rs.getInt("Channeld");
         int status = rs.getInt("Status");

         String name = rs.getString("Name");
         String desc = rs.getString("Description");
         String type = rs.getString("Type");
		}
         
		DAOFactory.closeConnection(conn);
		
		ICNodeFactory fac = new ICNodeFactory();
		List<ICNode> list = fac.getNodeList();
		ICNode n=null;
		for (ICNode node : list){
			n = node; 
			System.out.println(node.getName());
		}
		
		// test update
		System.out.println("Current status=" + n.getState());
		
		fac.updateNode(n);
		
		// test insert
		System.out.println("Inserting node with name Vlad");
		n.setName("Vlad");
		n.setId(99);
		fac.createNode(n);
		
		// test ugly delete
		conn = DAOFactory.getConnection();
		PreparedStatement delete_stmt = conn.prepareStatement(SQLStatements.QUERY_DELETE_BY_ID);
		delete_stmt.setInt(1, 99);
		int rows = delete_stmt.executeUpdate();
		
		System.out.println(rows  + " number of rows deleted");
		
		
		
		
	}
}
