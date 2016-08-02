package com.inchecktech.dpm.persistence;

import com.inchecktech.dpm.beans.Location;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PersistLocations {
     private static final Logger logger = new Logger(PersistLocations.class);

        public static List<Location> getLocations() {
        List<Location> locations = new ArrayList<Location>();

        Location location = null;
        try {
            Connection conn = DAOFactory.getConnection();
            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_GET_LOCATIONS);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                location = new Location();
                location.setLocationId(rs.getInt("LOCATION_ID"));
                location.setDescription(rs.getString("DESCRIPTION"));

                locations.add(location);
            }

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to get locations ", se);
        }
        return locations;
    }

    public static int createLocation(String description) {
        int locationId = 0;
        try {
            Connection conn = DAOFactory.getConnection();

            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_SAVE_LOCATION);
            pstmt.setString(1, description);
            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
			rs.next();
			locationId = rs.getInt(1);

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to create location ", se);
        }
        return locationId;
    }

    public static int updateLocation(int locationId, String description) {
        int result = 0;
        try {
            Connection conn = DAOFactory.getConnection();
            PreparedStatement pstmt = conn
                    .prepareStatement(SQLStatements.QUERY_UPDATE_LOCATION);

            pstmt.setString(1, description);
            pstmt.setInt(2, locationId);

            result = pstmt.executeUpdate();

            DAOFactory.closeConnection(conn);

        } catch (SQLException se) {
            logger.error("An error occurred while trying to update location ", se);
        }
        return result;
    }
}
