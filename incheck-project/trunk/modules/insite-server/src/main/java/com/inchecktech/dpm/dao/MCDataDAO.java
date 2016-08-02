package com.inchecktech.dpm.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.inchecktech.dpm.utils.Logger;


// Each MC data thread will get this Singelton object to write data to the DB.
public class MCDataDAO  {
	
	private static final Logger logger = new Logger(MCDataDAO.class);

	//Singelton instance
	private static MCDataDAO mcDataDAO = null;
	
	// Each thread will have its own data HashMap w/ its own Hashmap per channel.
	@SuppressWarnings("unchecked")
	private Map<String,Map> threadData;

	private MCDataDAO()
	{
		//Start DB layer here
		init();
	}
	
	public static MCDataDAO getInstance()
	{
		if (mcDataDAO == null)
			mcDataDAO = new MCDataDAO();
		
		return mcDataDAO;
	}
	
	//Load datasource info + connection info
	@SuppressWarnings("unchecked")
	private void init()
	{
		logger.info("Enter MCDataDAO.init() ");
		
		
		//initalize the channel Data arrays
		threadData = new HashMap<String,Map>();
		
	}

	public static synchronized Connection getConnection(String dataSourceName) throws SQLException 
	{
		try{
			logger.info("DataSource: " + dataSourceName);
			//DataSource ds = (DataSource)MCDataDAO.getInstance();
			Connection con =  DAOFactory.getConnection();
			return con;
		}
		catch(Exception e)
		{
			logger.error("Unable to get Connection:" + e);
			throw new SQLException("Unable to get Connection." + e);
		}
		
	}
	
	public static synchronized Connection getConnection() throws SQLException 
	{
		try{
			logger.info("using JDBConnect");
			//DataSource ds = (DataSource)MCDataDAO.getInstance();
			Connection con =  DAOFactory.getConnection();
			return con;
		}
		catch(Exception e)
		{
			logger.error("Unable to get Connection:" + e);
			throw new SQLException("Unable to get Connection." + e);
		}
		
	}
	
	//Store Data into the HEAP.
	@SuppressWarnings("unchecked")
	public synchronized void  setThreadHeapData(String threadName, DataPacketVO vo)
	{
		Map<String,Object> chnData; //Contains many data Maps - one per MC channel
		Map<String,Object> dataAndTicks;
		
		//	Running counter of total samples rcvd so far. Or msg_number field
		int samplesRcvdCounter = 0;
		
		//indicates how number of messages across which the samples are spread
		// Saved value from previously rcvd Msg of: num_of_samples_total
		int lastSamplesTotalRcvdCounter = 0;
		
		Integer chanNum = new Integer(vo.getChannel_id());
		
		//check if this is an active thread (MC) if so enter data.  
		//if not, then create an entry.		
		if(threadData.containsKey(threadName) == true)
		{
			//GET the chanData Map for the Channel that rcvd data.			
			//Check if channel allready has entries (then get its allready
			//stored data) and add the new packet to the array list.
			//if not then add this channel to the channelData map
			//and then add the new data to the new channel
			chnData  = threadData.get(threadName);
			
			//Find the Channel Map
			if(chnData.containsKey(chanNum.toString()) == true)
			{

				//Now check if one DataPoint is complete and we can write out to GUI/DB.
				if(vo.getMessage_number() == 1 )
				{
					//find the channel data
					//Get and compare the counters for this channel
					Map tmpDataTicks = (Map)chnData.get(chanNum.toString());
					samplesRcvdCounter = (Integer)tmpDataTicks.get("samplesRcvdCounter");
					lastSamplesTotalRcvdCounter = (Integer)tmpDataTicks.get("lastSamplesTotalRcvdCounter");
					
					if( samplesRcvdCounter == lastSamplesTotalRcvdCounter)
					{
						//Send Whats in HEAP stored so far to GUI/DB
						//Pass in the data HashMap picked for this channel from above
						writeDataToGUI(tmpDataTicks);
						//DPMLogger.logger.info("XXX Write to GUI/DB: message r " + vo.getMessage_number());
						
						// JMSQueueSender jmsQueueSend = new JMSQueueSender();
						// jmsQueueSend.sendJMSMessage();

					}
					else
					{
						logger.info("XXX Total Data Samples rcvd mismatch - Expected: " + samplesRcvdCounter + "Recvd: " + lastSamplesTotalRcvdCounter);
					}
					
					//FLUSH Heap
					//get the chnData for the channel data was rcvd for.
					chnData.remove(chanNum.toString());
									
					//Store new packet in heap
					dataAndTicks = new HashMap<String,Object>();
					
					//reset the counters to start with Msg number 1
					//samplesRcvdCounter = 0;
					dataAndTicks.put("samplesRcvdCounter", vo.getMessage_number());
					dataAndTicks.put("lastSamplesTotalRcvdCounter", vo.getNum_of_samples_total());
					
					dataAndTicks.put("Data", vo.getData());
					dataAndTicks.put("Ticks", vo.getExternal_ticks());
		
					chnData.put(chanNum.toString(), dataAndTicks);
					
				}
				//Else Add more samples to Heap
				else
				{
					//Get channel's Data/Ticks
					Map tmpDataTicks = (HashMap)chnData.get(chanNum.toString());
					
					List<Double> data = (List<Double>)tmpDataTicks.get("Data");
					data.addAll(vo.getData());
					
					List ticks = (List)tmpDataTicks.get("Ticks");
					ticks.addAll(vo.getExternal_ticks());

					//Copy the counter value before losing it in the remove()
					lastSamplesTotalRcvdCounter = (Integer)tmpDataTicks.get("lastSamplesTotalRcvdCounter");
					
					chnData.remove(chanNum.toString());
					
					dataAndTicks = new HashMap<String,Object>();

					//increment the msg number counter
					dataAndTicks.put("samplesRcvdCounter", vo.getMessage_number());
					dataAndTicks.put("lastSamplesTotalRcvdCounter", lastSamplesTotalRcvdCounter); 
					
					dataAndTicks.put("Data", data);
					dataAndTicks.put("Ticks", ticks);

					chnData.put(chanNum.toString(), dataAndTicks);
				}
			}
			//Else a NEW Channel is being read for first time for an Existing MC/Thread
			else
			{
				dataAndTicks = new HashMap<String,Object>();
				dataAndTicks.put("samplesRcvdCounter", vo.getMessage_number());
				dataAndTicks.put("lastSamplesTotalRcvdCounter", vo.getNum_of_samples_total());
				
				dataAndTicks.put("Data", vo.getData());
				dataAndTicks.put("Ticks", vo.getExternal_ticks());
		
				chnData.put(chanNum.toString(), dataAndTicks);
				
			}
			
			threadData.put(threadName, chnData);
		}
		//First Time thread HEAP is initialized and used/set fro this Thread(MC)
		else
		{
			chnData = new HashMap<String,Object>();
			dataAndTicks = new HashMap<String,Object>();
			dataAndTicks.put("samplesRcvdCounter", vo.getMessage_number());
			dataAndTicks.put("lastSamplesTotalRcvdCounter", vo.getNum_of_samples_total());
			dataAndTicks.put("Data", vo.getData());
			dataAndTicks.put("Ticks", vo.getExternal_ticks());

			chnData.put(chanNum.toString(), dataAndTicks);
			
			threadData.put(threadName, chnData);			
		}
		
	}
	
	// TODO - will be used by the DB layer to read data samples and write to DB.
	/*
	public DataPacketVO getThreadData(String threadName)
	{
		return (DataPacketVO) this.threadData.get(threadName);
	}
	*/
	
	@SuppressWarnings("unchecked")
	public synchronized void writeDataToGUI(Map dataTicks)
	{	
		List<Double> dataArray = (List<Double>)dataTicks.get("Data");
		ArrayList tickArray = (ArrayList)dataTicks.get("Ticks");
		
		double data[] = new double[dataArray.size()];
		int ticks[] = new int[tickArray.size()];
		
		StringBuffer guiMsg = new StringBuffer((dataArray.size()+tickArray.size())*3);
		guiMsg.append("XXX Data[size]: " + "[" + dataArray.size() + "]" + " ");
		for (int i=0; i< dataArray.size(); i++)
		{
			data[i] = (Double)dataArray.get(i);
			//data[i] = val.doubleValue();
			
			guiMsg.append(data[i] + ",");
		}
		guiMsg.append("\n");
		guiMsg.append(" XXX Ticks[size]: " + "[" + tickArray.size() + "]" + " ");
		
		for (int i=0; i< tickArray.size(); i++)
		{
			guiMsg.append(ticks[i] + ",");
		}
		logger.info("XXX writeDataToGUI: " + guiMsg.toString());
		guiMsg=null;
	}
}
