package com.inchecktech.dpm.common;

import java.io.IOException;
import java.util.HashMap;
import java.util.Properties;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.network.DPMClientSocketHandler;
import com.inchecktech.dpm.persistence.PersistDPMConfig;
import com.inchecktech.dpm.simulator.DynamicChannel;
import com.inchecktech.dpm.simulator.StaticChannel;
import com.inchecktech.dpm.utils.Logger;

//Singleton Class containing the intialization and control functionality for the
//Data Processing Module (DPM)
//This Class will control the connections to the GUI(by output messages to the JMS Queue,
//that the GUI will read asynchronously) and to the Micro-Controller. 
//As well as run the protocol manager to handle communications with those devices.
//As well as write signal data to the DB layer.
public class DPMController {
	private static final Logger logger = new Logger(DPMController.class);

	private static DPMController dpmController = null;

	// Micro-Controller side data channel connection tcp socket Port
	// private ArrayList mcIPAddress;

	// Micro-Controller side data channel connection tcp socket Port
	// private int mcDataTcpPort;

	// Private Constructor
	private DPMController() {
		// Initialize - Read prop files
		// init();
	}

	public static synchronized DPMController getInstance() {
		if (dpmController == null) {
			dpmController = new DPMController();
		}

		return dpmController;
	}

	/*
	 * //Load the properties file and get all ip port info. private void init() {
	 * try{ //READ properties file and load it at init time. File fis = new
	 * File("DPM_Controller.properties");
	 * DPMLogger.logger.info("DPM_Controller.properties path: " +
	 * fis.getAbsolutePath()); InputStream file = new FileInputStream(fis);
	 * Properties props = new Properties(); props.load(file);
	 * 
	 * //Get the TCP address/port for the Micro-Controller side connection
	 * ArrayList mcControllersIPAddress = new ArrayList(); String
	 * numOfControllers = props.getProperty("MC_Controllers"); Integer
	 * controllers = new Integer(numOfControllers); for (int i=0; i<
	 * controllers.intValue(); i++) { Integer num = new Integer(i+1); String
	 * controller = "MC_IP_Address_" + num.toString(); String mcIPAddress = new
	 * String(props.getProperty(controller));
	 * mcControllersIPAddress.add(mcIPAddress); DPMLogger.logger.info(controller + " : " +
	 * mcIPAddress); }
	 * 
	 * //store in memory all connection info.
	 * setMcIPAddress(mcControllersIPAddress);
	 * 
	 * String dataPort = props.getProperty("MC_Data_TCP_Port"); Integer
	 * dataPortVal = new Integer(dataPort);
	 * setMcDataTcpPort(dataPortVal.intValue());
	 * 
	 * DPMLogger.logger.info("Microcontroller TCP Data Port: " +
	 * getMcDataTcpPort());
	 * 
	 * TODO - fix with proper data loading + make/use DAO factorys //NOW open DB
	 * connections MCDataDAO mcDataDAO = MCDataDAO.getInstance();
	 * 
	 * //DAOFactory dataDAO = new DAOFactory(); Connection conn =
	 * mcDataDAO.getConnection(); Statement stmt = conn.createStatement(); //
	 * Create a result set object by executing the query. // May throw a
	 * SQLException. ResultSet rs = stmt.executeQuery("SELECT id, name FROM
	 * devices"); // Process the result set. while (rs.next()) { int id =
	 * rs.getInt(1); String name = rs.getString(2); //String Name =
	 * rs.getString(3); } rs.close(); stmt.close(); conn.close(); }
	 * 
	 * catch (IOException e){ DPMLogger.logger.log(Level.SEVERE,"Error reading
	 * properties file: " + e); System.err.println("Error reading properties
	 * file: " + e); return; } catch (Exception e){
	 * DPMLogger.logger.log(Level.SEVERE,"Error JDBConnects: " + e);
	 * System.err.println("Error JDBConnects: " + e); return; } }
	 */
	// The Main For loop that runs the microcontrollers communications protocol
	// by starting the Socket Handler threads
	public HashMap<Integer, DPMClientSocketHandler> sockets = new HashMap<Integer, DPMClientSocketHandler>();

	public void runSocketThreads() throws IOException {
		logger.info("Enter DPMController.runSocketThreads()");

		try {
			logger.info("looking for sim channels");
			Properties channelids = PersistDPMConfig.getSimChannels();
			
			logger.info("Found the following sim channels:" + channelids);
			
			for (Object chid : channelids.keySet()){
				
				if (channelids.get(chid).equals(ChannelState.CHANNEL_TYPE_DYNAMIC)){
				
					DynamicChannel dn = new DynamicChannel((Integer)chid);
					DataBucket.putDynamicSimChannel((Integer)chid, dn);
					
					logger.info("created dynamic sim channel " + dn.getName());

				}else if  (channelids.get(chid).equals(ChannelState.CHANNEL_TYPE_STATIC)){
					
					StaticChannel st = new StaticChannel((Integer)chid);
					DataBucket.putStaticSimChannel((Integer)chid, st);
					logger.info("created static sim channelid " + st.getName());
					
				}
			}

		} catch (Throwable t) {
			logger.error("An exception occured while looking for sim channels" , t);
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// TD: MachineTalker Channels (file based integration)
		/* machine talker code commented
		try {
		    
            logger.info("Looking for MachineTalker channels...");
            Properties channelids = PersistDPMConfig.getMTalkerChannels();
            
            logger.info("Found the following MachineTalker channels: " + channelids);
            
            for (Object chid : channelids.keySet()){
                
                if (channelids.get(chid).equals(ChannelState.CHANNEL_TYPE_DYNAMIC)){
                
                    MTalkerChannel dn = new MTalkerChannel((Integer)chid);
                    logger.info("Created dynamic MachineTalker channel " + dn.getName());

                }else if  (channelids.get(chid).equals(ChannelState.CHANNEL_TYPE_STATIC)){
                    
                    logger.info("Static MachineTalker channels are not supported... ");
                    
                }
            }

        } catch (Throwable t) {
            logger.error("An exception occured while looking for sim channels" , t);
        }
        */
		// TD: End of MachineTalker Channels initializations
		///////////////////////////////////////////////////////////////////////////////////////////

/*		try {
			Connection con;
			try {
				con = DAOFactory.getConnection();
			} catch (DPMException e1) {
				e1.printStackTrace();
				logger.error("unable to get connection from DAOFactory", e1);
				return;
			}
			
			String DPMID = System.getProperty("DPMID");
			if (DPMID == null || DPMID.trim().equals("")) {
				DPMID = "noname";
			}
			
			logger.info("DPMID=" + DPMID);
			PreparedStatement pstmt = con.prepareStatement(SQLStatements.QUERY_DPMDEVENTLIST2);
			pstmt.setString(1, DPMID);
//			String q = "select * from DPMDEviceList2 where DPMID='" + DPMID
//					+ "'";

//			logger.debug("USING QUERY " + q);
//			ResultSet rs = con.createStatement().executeQuery(q);
			ResultSet rs = pstmt.executeQuery();

			// for(int i=0; i< mcIPAddress.size(); i++)

			while (rs.next()) {
				String threadName = null;
				try {
					Integer deviceId = rs.getInt("DeviceId");
					String ipAddr = rs.getString("DeviceIp");
					int port = rs.getInt("DevicePort");

					logger.debug("working on deviceId" + deviceId
							+ " and ipAddress=" + ipAddr + " and port=" + port);

					SocketHandler sh = new SocketHandler(ipAddr, port);

					if (sockets.containsKey(deviceId)) {
						System.err
								.println("Duplicate device id while creating new socket Handlers "
										+ deviceId);
						int randStuff = (int) Math.round(Math.random() * 1000);
						System.err
								.println(deviceId
										+ " will be assigned random id of "
										+ randStuff);
						sockets.put(randStuff, sh);
					} else {
						sockets.put(deviceId, sh);
					}

				} catch (Exception e) {
					logger.error("Error Could connect to : " + threadName
							+ " -- " + e);
					logger.error("Could not listen on port: " , e);
					
					continue;
				}
			}
			con.close();
		} catch (SQLException e) {
			logger.error("Database error: " + e);
			return;
		}*/

	}

	public Object clone() throws CloneNotSupportedException {
		throw new CloneNotSupportedException();
	}

}
