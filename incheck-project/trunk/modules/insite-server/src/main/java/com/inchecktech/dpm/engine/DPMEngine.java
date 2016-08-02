package com.inchecktech.dpm.engine;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Timer;

import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.ICNodeFactory;
import com.inchecktech.dpm.common.ChannelStateTimer;
import com.inchecktech.dpm.common.DPMController;
import com.inchecktech.dpm.config.ConfigItem;
import com.inchecktech.dpm.config.ConfigManagerImpl;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.network.DPMServerSocket;
import com.inchecktech.dpm.notifications.EventMailer;
import com.inchecktech.dpm.persistence.PersistDPMConfig;
import com.inchecktech.dpm.persistence.PersistenceTimer;
import com.inchecktech.dpm.utils.Logger;


/**
 * @author Leo B
 * This Class will instantiate the DPMContoroller and begin to run it.
 * The DPMController is the class responsible for:
 * 1. Starting the connection manager to the Micro-controller.
 * 2. Running the protocol to the GUI and the MC
 * 3. Storing signal data to the DB.
 */

public class DPMEngine {
	private static final int delay=1000;
	private static final Logger logger = new Logger(DPMEngine.class);

	/* " channe_state timer id"*/
	private static final String CHANNEL_STATE_TIMER_ID = "channel_state_timer";
	
	/**/
	private static final long CHANNEL_STATE_TIMER_INTERVAL = 300 * 1000;
	
	/**
	 * @param args
	 */
	//public static ICNodeFactory nodeFac;
	public static  ArrayList<ICNode>  tree;
	public static HashMap<Integer, ICNode> flatList4tree;
	
	/*
	public static String serverAddr="192.168.1.11";
	public static int serverPort=23452;
	*/
	
	public static String serverAddr;
	public static int serverPort;
	
	public static Long mailTimeInterval;
	
	public static void main(String[] args) throws IOException
	{
		new DataBucket();
		try{
			ConfigItem item = PersistDPMConfig.getConfigItem("SiteConfig", "SITE", "site.server.event.notification.mail.interval");
			String eventMailTimerValue = item.getPropertyValue();
			mailTimeInterval = new Long(eventMailTimerValue);
			
			serverAddr=ConfigManagerImpl.getConfigItem("SiteConfig", "SITE", "site.server.ip.address").getPropertyValue();
			serverPort=Integer.parseInt(ConfigManagerImpl.getConfigItem("SiteConfig", "SITE", "site.server.ip.port").getPropertyValue());
		}catch(Throwable e){
			logger.error("error parsing server host/port ");
			logger.error("using default 127.0.0.1 : 123452");
			
			serverAddr="127.0.0.1";
			serverPort=123452;
		}
		logger.info("USING SERVER HOST:PORT "+serverAddr+":"+serverPort);
		
/*		new Thread(new Runnable() {
		    public void run() {
		      
		    	try {
					WiVibSocket.main(null);
				} catch (Exception e) {
					e.printStackTrace();
				}
		    }
		  }).start();
		
		
		*/

		
		
		
		ICNodeFactory nodeFac=new ICNodeFactory();
		tree=nodeFac.getNodeList();
		flatList4tree=nodeFac.getFlatNodeMap();
		
		// saving to DB every X minutes
		logger.debug("Creating new Timer");
		Timer timer = new Timer("systematic_storing_channel_state");
		long seconds = PersistDPMConfig.getTimerValue();
		
		logger.debug("Running systematic_storing_channel_state every " + seconds + " seconds");
		timer.scheduleAtFixedRate(new PersistenceTimer(), delay, seconds/*seconds*/*1000);

		
		// Channel State timer
		Timer chStateTimer = new Timer(CHANNEL_STATE_TIMER_ID);
		chStateTimer.scheduleAtFixedRate(new ChannelStateTimer(), delay, CHANNEL_STATE_TIMER_INTERVAL);
		
		
		try{
			Timer eventMailerTimer = new Timer("event_mailer_timer");
			//ConfigItem item = PersistDPMConfig.getConfigItem("SiteConfig", "SITE", "site.server.event.notification.mail.interval");
			
			//String eventMailTimerValue = item.getPropertyValue();
			//long eventMailerInterval = new Long(eventMailTimerValue);
			
			logger.debug("Running event_mailer_timer every " + DPMEngine.mailTimeInterval + " seconds");
			eventMailerTimer.scheduleAtFixedRate(new EventMailer() , delay, /*eventMailerInterval*/ 60* 1000);
			
		}catch(Throwable e){
			logger.error("An exception occured while trying to run event_mailer_timer ", e);
		}
		 
	
		
/*		ProtoTestServerSocket pts=new ProtoTestServerSocket();
		pts.start();
		System.out.println("STARTED ProtoTestServerSocket");
		
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		DiscoverRequestHandler dt=new DiscoverRequestHandler();
		dt.start();
		System.out.println("STARTED DISC");*/
		
		
		//get controller instance
		DPMController dpmController = DPMController.getInstance();

		//start socket handling multi-threading (one per DPM-DAM connection)
		
		DPMServerSocket sock=new DPMServerSocket();
		sock.start();
		
		
//		DAMDiscoverListener ddl=new DAMDiscoverListener();
//		ddl.start();
		dpmController.runSocketThreads();
		
    // Start UDM Discover request listener
   // new DiscoverRequestHandler().start();
		
		
			
		
	}

}
