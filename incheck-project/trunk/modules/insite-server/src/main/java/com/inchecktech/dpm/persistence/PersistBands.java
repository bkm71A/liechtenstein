package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.inchecktech.dpm.beans.Band;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

public class PersistBands {
	
	private static final Logger logger = new Logger(PersistBands.class);
	
	public static void mapBandToChannel (int channelId, int bandId) {
	
		logger.info("mapBandToChannel bandId=" + bandId + " channelId=" + channelId);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_MAP_BAND_TO_CHANNEL);
			pstmt.setInt(1, bandId);
			pstmt.setInt(2, channelId);
			
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception:", e);
		}
	}
	
	public static void unmapBandToChannel (int channelId, int bandId) {
		
		logger.info("unmapBandToChannel bandId=" + bandId + " channelId=" + channelId);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_UNMAP_BAND_TO_CHANNEL);
			pstmt.setInt(1, bandId);
			pstmt.setInt(2, channelId);
			
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception:", e);
		} 
	}
	
	public static List<Band> getBandsForChannel(int channelId) {
		
		logger.debug("getBandsForChannel:" + channelId);
		List<Band> bands = new ArrayList<Band>();
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_GET_BAND_FOR_CHANNEL);
			pstmt.setInt(1, channelId);
			
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()){
				Band band = new Band();
				band.setBandId(rs.getInt("BAND_ID"));
				band.setBandName(rs.getString("BAND_NAME"));
				band.setBandCoefficient(rs.getDouble("BAND_COEFFICIENT"));
				band.setStartFreq(rs.getDouble("START_FREQ"));
				band.setEndFreq(rs.getDouble("END_FREQ"));
				band.setActive(rs.getBoolean("ACTIVE_FLAG"));
				bands.add(band);
			}
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception:", e);
		} 
		
		logger.debug("got " + bands.size() + " BandsForChannel:" + channelId);
		return bands;
	}
	
	public static Map<Integer, Band> getAllBands() {
		
		logger.info("Getting all bands");
		Map<Integer, Band> bands = new HashMap<Integer, Band>();
		
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_GET_ALL_BANDS);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()){
				Band band = new Band();
				band.setBandId(rs.getInt("BAND_ID"));
				band.setBandName(rs.getString("BAND_NAME"));
				band.setBandCoefficient(rs.getDouble("BAND_COEFFICIENT"));
				band.setStartFreq(rs.getDouble("START_FREQ"));
				band.setEndFreq(rs.getDouble("END_FREQ"));
				band.setActive(rs.getBoolean("ACTIVE_FLAG"));
				
				int channelId = rs.getInt("CHANNEL_ID");
				bands.put(channelId, band);
			}
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception:", e);
		} 
		
		return bands;
	}
	
	
	public static void disableBand(int bandId){
		logger.info("disableBand:" + bandId);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_DISABLE_BAND);
			pstmt.setInt(1, bandId);
			pstmt.executeUpdate();
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception:", e);
		}
	}
	
	public static int createBand (Band band) {
		logger.info("Creating Band:" + band);
		
		int bandId=0;
		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_CREATE_BAND, PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setDouble(1, band.getBandCoefficient());
			pstmt.setDouble(2, band.getStartFreq());
			pstmt.setDouble(3, band.getEndFreq());
			pstmt.setString(4, band.getBandName());
			pstmt.setBoolean(5, band.isActive());
			pstmt.executeUpdate();
	
			ResultSet rs = pstmt.getGeneratedKeys();
			rs.next();
			bandId = rs.getInt(1);
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception:", e);
		} 
		return bandId;
	}
	
	public static void updateBand (Band band) {
		
		logger.info("updating Band:" + band);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_UPDATE_BAND);
			pstmt.setDouble(1, band.getBandCoefficient());
			pstmt.setDouble(2, band.getStartFreq());
			pstmt.setDouble(3, band.getEndFreq());
			pstmt.setString(4, band.getBandName());
			pstmt.setBoolean(5, band.isActive());
			pstmt.setInt(6, band.getBandId());
			pstmt.executeUpdate();
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception:", e);
		} 
	}
	
	public static void deleteBand (int bandId) {
		
		logger.info("deleting Band:" + bandId);

		try {
			Connection conn = DAOFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQLStatements.QUERY_DELETE_BAND);

			pstmt.setInt(1, bandId);
			pstmt.executeUpdate();
			
			DAOFactory.closeConnection(conn);

		} catch (SQLException e) {
			logger.error("SQL Exception:", e);
		} 
	}
}
