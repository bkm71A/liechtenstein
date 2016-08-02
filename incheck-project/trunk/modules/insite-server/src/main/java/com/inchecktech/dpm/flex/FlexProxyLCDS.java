package com.inchecktech.dpm.flex;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import com.inchecktech.dpm.beans.AxisBO;
import com.inchecktech.dpm.beans.DropDownBO;
import com.inchecktech.dpm.dao.DAOFactory;


public class FlexProxyLCDS {
	
	public static final String QUERY_GET_OVERALL_TYPE = "select overall_type_id,overall_type from overall_types";
	
	public static final String QUERY_GET_ANALYSIS_BANDS = "select band_id,band_name from analysis_bands";
	
	public static final String QUERY_GET_UNITS = "select unit_id,unittype,unit from units";
	
	public static final String QUERY_GET_OVERALL_DATA = "select sample_id,channel_id," +
			"sample_ts,sampling_rate,rpm,overall_type_id,band_id,overall_value,unit_id from sample_overall where overall_type_id = ? and band_id = ? and unit_id=?";
	
	public HashMap<String,ArrayList<DropDownBO>> getInitData() {
		HashMap<String,ArrayList<DropDownBO>> datas = new HashMap<String,ArrayList<DropDownBO>>();
		Connection conn;
		try {
			conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(QUERY_GET_OVERALL_TYPE);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				DropDownBO bo = new DropDownBO();
				bo.setData(rs.getInt(1));
				bo.setLabel(rs.getString(2));
				if (datas.containsKey("types")) {
					datas.get("types").add(bo);
				}else {
					ArrayList<DropDownBO> temp = new ArrayList<DropDownBO>();
					DropDownBO initData = new DropDownBO("Parameter",-1);
					temp.add(initData);
					temp.add(bo);
					datas.put("types", temp);
				}
			}
			pstmt = conn.prepareStatement(QUERY_GET_ANALYSIS_BANDS);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				DropDownBO bo = new DropDownBO();
				bo.setData(rs.getInt(1));
				bo.setLabel(rs.getString(2));
				if (datas.containsKey("bands")) {
					datas.get("bands").add(bo);
				}else {
					ArrayList<DropDownBO> temp = new ArrayList<DropDownBO>();
					DropDownBO initData = new DropDownBO("Band",-1);
					temp.add(initData);
					temp.add(bo);
					datas.put("bands", temp);
				}
			}
			
			pstmt = conn.prepareStatement(QUERY_GET_UNITS);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				DropDownBO bo = new DropDownBO();
				bo.setData(rs.getInt(1));
				bo.setLabel(rs.getString(2) + "," + rs.getString(3));
				if (datas.containsKey("units")) {
					datas.get("units").add(bo);
				}else {
					ArrayList<DropDownBO> temp = new ArrayList<DropDownBO>();
					DropDownBO initData = new DropDownBO("Units",-1);
					temp.add(initData);
					temp.add(bo);
					datas.put("units", temp);
				}
			}
			
			DAOFactory.closeConnection(conn);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return datas;
	}
	
	public ArrayList<AxisBO> query(String flag,long startDate, long endDate, int channel_id, int typeId, int bandId, int unitId) {
		ArrayList<AxisBO> data = new ArrayList<AxisBO>();
		Connection conn;
		SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date stDate = null;
		Date edDate = null;
		try {
			if ((startDate != 0) && (endDate != 0)) {
				stDate = new Date(startDate);
				edDate = new Date(endDate);
			}
			
			conn = DAOFactory.getConnection();
			StringBuffer queryStr = new StringBuffer("select a.sample_id, DATE_FORMAT(a.sample_ts,'%Y/%m/%d %H:%i:%s'), b.overall_value, DATE_FORMAT(a.sample_ts,'%Y %u') from sample_main a,sample_overall b where" +
					" a.sample_id=b.sample_id ");
			if ((startDate != 0) && (endDate != 0)) {
				queryStr.append("and a.sample_ts between '").append(sqlDateFormat.format(stDate))
				.append("' and '").append(sqlDateFormat.format(edDate));
				queryStr.append("' and a.channel_id=").append(channel_id);
			}else {
				queryStr.append(" and a.channel_id=").append(channel_id);
			}
			if (typeId != -1) {
				queryStr.append(" and b.overall_type =" + typeId);
			}
			if (bandId != -1){
				if (channel_id != -1 || typeId != -1) {
					queryStr.append(" and b.band_id = " + bandId);
				}else {
					queryStr.append(" b.band_id = " + bandId);
				}
			}
			
			if (unitId != -1){
				if (channel_id != -1 || typeId != -1 || bandId != -1) {
					queryStr.append(" and a.unit_id = " + unitId);
				}else {
					queryStr.append(" a.unit_id = " + unitId);
				}
			}
			queryStr.append(" order by sample_ts");
			PreparedStatement pstmt = conn.prepareStatement(queryStr.toString());
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				AxisBO bo = new AxisBO();
				bo.setId(rs.getInt(1));
				bo.setDate(rs.getString(2));
				bo.setValue(rs.getString(3));
				bo.setWeek(rs.getString(4));
				data.add(bo);
			}
			DAOFactory.closeConnection(conn);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return data;
	}
	
//	public void generateData(){
//		try {
//			ArrayList<String> al = new ArrayList<String>();
//			ArrayList<String> al2 = new ArrayList<String>();
//			Connection conn = DAOFactory.getConnection();
//			File file = new File("d:/projects/flex/xdata.txt");
//			FileReader fr = new FileReader(file);
//			BufferedReader bf = new BufferedReader(fr);
//			String temp = new String();
//			String sql = "insert into sample_main(sample_id,channel_id,unit_id,sample_ts) values(?,8,1,?)";
//			String sql2 = "insert into sample_overall(sample_id,overall_type,band_id,overall_value) values(?,1,1,?)";
//			while ((temp = bf.readLine()) != null) {
//				al.add(temp);
//			}
//			file = new File("d:/projects/flex/value.txt");
//			fr = new FileReader(file);
//			bf = new BufferedReader(fr);
//			while ((temp = bf.readLine()) != null) {
//				al2.add(temp);
//			}
//			for(int i=0;i<al.size();i++) {
//				long stamp = Long.parseLong((String)(al.get(i)));
//				double value = Double.parseDouble((String)(al2.get(i)));
//				Timestamp tm = new Timestamp(stamp);
//				PreparedStatement pstmt = conn.prepareStatement(sql);
//				pstmt.setInt(1, i+1);
//				pstmt.setString(2, tm.toString());
//				pstmt.execute();
//				PreparedStatement ps = conn.prepareStatement(sql2);
//				ps.setInt(1, i+1);
//				ps.setDouble(2, value*Math.exp((stamp - 1243044165)*0.0000004 ) + 0.1*(Math.random()-0.5));
//				ps.execute();
//			}
//			conn.commit();
//			DAOFactory.closeConnection(conn);
//		} catch (DPMException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (FileNotFoundException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		
//	}
	
}
