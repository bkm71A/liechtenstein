package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.inchecktech.dpm.beans.OverallLevels;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.utils.SimpleConverter;

public class TestCreateStaticProcessedData {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		Connection conn = DAOFactory.getConnection();
		Statement stmt =conn.createStatement();
		String query = "select top 1 SAMPLE_VALUE from DBA.SAMPLE_MASTER where channel_id=4 order by sample_time desc";
		ResultSet rs = stmt.executeQuery(query);
		ProcessedData data=null;
		
		while(rs.next()){
			data = (ProcessedData) SimpleConverter.getObject(rs.getBytes(1));
		}
		System.out.println(data);
		OverallLevels levels = data.getOveralls();
		System.out.println("keys=" + levels.getKeys());
		Double blah = levels.getOverall("T");
		System.out.println(blah);

	}

}
