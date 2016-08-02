package com.inchecktech.dpm.network;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.HashMap;

import com.inchecktech.dpm.alarmEngine.AlarmEngine;
import com.inchecktech.dpm.beans.Channel;
import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.Device;
import com.inchecktech.dpm.beans.DeviceEvent;
import com.inchecktech.dpm.beans.DeviceOperation;
import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.config.ChannelConfigFactory;
import com.inchecktech.dpm.config.ChannelConfigItem;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.dsp.DSPFactory;
import com.inchecktech.dpm.engine.DPMEngine;
import com.inchecktech.dpm.persistence.PersistDeviceEvent;
import com.inchecktech.dpm.persistence.PersistTreeNode;
import com.inchecktech.dpm.utils.Logger;
import com.inchecktech.exception.DPMClientSocketException;

public class DPMClientSocketHandler extends Thread {

	
	private static final Logger logger = new Logger(DPMClientSocketHandler.class);
	public Socket socket = null;
	public static final String CRLF = "\r\n";
	private DataOutputStream dout = null;
	private static final byte CR = 13;
	private static final byte LF = 10;
	private DataInputStream din = null;
	private String damControllerMac=null;
	private String damControllerId=null;
	private Device thisDevice=null;
	private HashMap<Integer, Integer> deviceChannelMap=new HashMap<Integer, Integer>();
	
	public long lastTimeStamp =System.currentTimeMillis();
	
	
	
	private ArrayList<int[]> arrayofintarrays=null;
	
	/* Client socket manager */
	private static DPMClientSocketHandlerHelper helper;

	private static boolean newProtocol = false;
	
	public ArrayList<int[]> getArrayofintarrays() {
		return arrayofintarrays;
	}

	public void setArrayofintarrays(ArrayList<int[]> arrayofintarrays) {
		this.arrayofintarrays = arrayofintarrays;
	}

	public DPMClientSocketHandler(Socket s) {
		this.socket = s;
		helper = new DPMClientSocketHandlerHelperImpl();
	}

	public Device getThisDevice() {
		return thisDevice;
	}

	@Override
	public void run() {

		if(newProtocol){
			try {
				din = new DataInputStream(socket.getInputStream());
				dout = new DataOutputStream(socket.getOutputStream());
			} catch (Throwable e) {
				e.printStackTrace();
				return;
			}
			ByteArrayOutputStream myMsgBytes = null;
			ArrayList<int[]> intHolder = null;
			lastTimeStamp = System.currentTimeMillis();
			while (true) {
				try {
					ByteArrayOutputStream bos = new ByteArrayOutputStream();
					boolean stillLookingForHeader = true;
					int cntr = -1;
					while (stillLookingForHeader) {
						cntr++;
						if (cntr > 300) {
							logger.info("Couldnt find header after reading 200 bytes.. exiting.. " + this.getName());
							return;
						}
						bos.write(din.readByte());
						lastTimeStamp = System.currentTimeMillis();
						if (cntr > 3) {
							byte headerArray[] = bos.toByteArray();
							if (headerArray[cntr - 3] == CR && headerArray[cntr - 2] == LF
									&& headerArray[cntr - 1] == CR && headerArray[cntr] == LF) {
								logger.info("HERE IS MY HEADER :" + new String(headerArray) + ":" + this.getName());
								stillLookingForHeader = false;
								DAMMessageType type = getDAMMessageType(new String(headerArray));
								if (type == null) {
									logger.error("Unknown Message type " + new String(headerArray) + "\t"
											+ this.getName());
								} else if (type.equals(DAMMessageType.REGISTER)) {
									System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
									try {
										thisDevice = helper.getDevice(headerArray, socket);
										helper.processRegisterMessage(deviceChannelMap, dout, thisDevice, socket);
									} catch (DPMClientSocketException exc) {
										socket.close();
										logger.error("DPMClientSocketException.", exc);
									} catch (IOException exc) {
										logger.error("Register message process exception...", exc);
									}
									try {
										Thread.sleep(3000);
									} catch (InterruptedException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
									
									
								} else if (type.equals(DAMMessageType.DATA)) {/*
									try {
										helper.processDataMessage(headerArray, din, deviceChannelMap);
									}catch (DPMClientSocketException exc) {
										logger.error(" no mapping to  device " + "for device "+thisDevice.getDeviceId()+ " with mac "+thisDevice.getMac());										
									}*/
//////
									lastTimeStamp=System.currentTimeMillis();
									if (myMsgBytes == null) {
										myMsgBytes = new ByteArrayOutputStream();
									}
									if (intHolder == null) {
										intHolder = new ArrayList<int[]>();;
									}
									logger.error("MSG IS DATA \n\n"+"\t"+this.getName());
									DAMDataMessage msg = new DAMDataMessage(
											new String(headerArray));
									byte toReadNow[] = new byte[msg.getBytesToRead()];
									din.readFully(toReadNow);
									intHolder.add(getIntArr(toReadNow));
									myMsgBytes.write(toReadNow);
									if (msg.isLastMessage()) {
										msg.setArrayofintarrays(intHolder);
										processDataMessage(msg);
										myMsgBytes = null;
										intHolder=null;
									}
//////									
								} else {
									logger.error("INELSE MSG IS " + type);
								}
							}
						}
					}
				} catch (Throwable e) {
					e.printStackTrace();
					try {
						socket.close();
					} catch (Throwable e2) {
						logger.error(e2);
					}
					return;
				}
			}
		} else {
		try {
			din = new DataInputStream(socket.getInputStream());
			dout = new DataOutputStream(socket.getOutputStream());
		} catch (Throwable e) {
			e.printStackTrace();
			return;
		}

		ByteArrayOutputStream myMsgBytes = null;
		ArrayList<int[]> intHolder = null;
		lastTimeStamp=System.currentTimeMillis();
		while (true) {
			try {
				ByteArrayOutputStream bos = new ByteArrayOutputStream();
				boolean stillLookingForHeader = true;
				int cntr = -1;
				while (stillLookingForHeader) {
					cntr++;
					if(cntr>300){
						logger.error("Couldnt find header after reading 200 bytes.. exiting.. "+this.getName());
						return;
					}
					bos.write(din.readByte());
					lastTimeStamp=System.currentTimeMillis();
					if (cntr > 3) {
						byte headerArray[] = bos.toByteArray();
						if (headerArray[cntr - 3] == CR
								&& headerArray[cntr - 2] == LF
								&& headerArray[cntr - 1] == CR
								&& headerArray[cntr] == LF) {
							logger.error("HERE IS MY HEADER :"
									+ new String(headerArray) + ":"+this.getName());
							;
							stillLookingForHeader = false;

							DAMMessageType type = getDAMMessageType(new String(
									headerArray));
							if (type == null) {
								logger.error("Unknown Message type "
										+ new String(headerArray)+"\t"+this.getName());
								System.err.println("Unknown Message type "
										+ new String(headerArray));

							} else if (type.equals(DAMMessageType.REGISTER)) {
								
								String mac=new String(headerArray).split("\n")[0].trim().split(" ")[1].trim();
								
								Device deviceTEMP = null;
								try{
									deviceTEMP=ChannelConfigFactory.getDevice(mac);
								} catch(Throwable e){
									logger.error("error while loading device "+mac+"\t"+this.getName(),e);
								}
								
								
								DataBucket.addOrReplaceDevice(deviceTEMP.getDeviceId()+"", deviceTEMP, mac);
								
								
								Device device = DataBucket.getDeviceByMac(mac);
								if(device==null){
									logger.error(" CANT REGISTER DEVICE WITH MAC -"+mac+"-"+"\t"+this.getName());
									socket.close();
									return;
								}
								this.thisDevice=device;
								
								String cont = "[CHANNEL-01]" + CRLF
								+ "SamplingRate=5120" + CRLF
								+ "SamplingInterval=10" + CRLF
								+ "Samples=4096" + CRLF
								+ "[CHANNEL-02]" + CRLF
								+ "SamplingRate=5120" + CRLF
								+ "SamplingInterval=10" + CRLF
								+ "Samples=4096" + CRLF
								+ "[CHANNEL-03]" + CRLF
								+ "SamplingRate=5120" + CRLF
								+ "SamplingInterval=10" + CRLF
								+ "Samples=4096" + CRLF
								+ "[CHANNEL-04]" + CRLF
								+ "SamplingRate=256" + CRLF
								+ "SamplingInterval=10" + CRLF
								+ "Samples=64" + CRLF;
								
								cont="";
								
								for(Channel c:device.getChannels()){
									deviceChannelMap.put( c.getDeviceChannelId(),c.getChannelId());
									
									logger.error("adding mapping for deviceId "+device.getDeviceId() +"  DEVC="+c.getDeviceChannelId()+" DPMC="+c.getChannelId()+"\t"+this.getName());
									String samplerate=null;
									String numOfsample=null;
									String chidstr=null;
									for(ChannelConfigItem item:c.getChannelConfig().getChannelConfigItems()){
											if(item.getPropertyName().equals("com.inchecktech.dpm.dam.SamplingRate")){
												samplerate=item.getPropertyValue();
											}else if(item.getPropertyName().equals("com.inchecktech.dpm.dam.BlockSize")){
												numOfsample=item.getPropertyValue();
											}
												
											logger.error("CHANN CONF="+item.getPropertyName()+":"+item.getProperty_id()+":="+item.getPropertyValue()+"\t"+this.getName());
									}
									
									chidstr=String.valueOf(c.getDeviceChannelId());
									if(chidstr.length()==1){
										chidstr="0"+chidstr;
									}
									if( samplerate != null  && numOfsample != null && chidstr !=null && !chidstr.equals("")){
										cont=cont+
										"[CHANNEL-"+chidstr+"]" + CRLF
										+ "SamplingRate="+samplerate + CRLF
										+ "SamplingInterval=10" + CRLF
										+ "Samples="+numOfsample + CRLF;
									}
								}
								{
									if (thisDevice != null) {
										PersistDeviceEvent.save(new DeviceEvent(thisDevice.getDeviceId(),
												DeviceOperation.CON));
									}
									String response = "DDP/1.0 200 OK"
											+ CRLF
											+ "Controller-ID:"+device.getDeviceId()
											+ CRLF
											+ "Time-Stamp:1209866566"
											+ CRLF
											+ "To:"
											+ DPMEngine.serverAddr
											+ ":"
											+ DPMEngine.serverPort
											+ CRLF
											+ "From:"
											+ socket.getRemoteSocketAddress()
													.toString().replaceFirst(
															"/", "") + CRLF
											+ "Message-ID:1 REGISTER" + CRLF
											+ "Content-Length:0" + CRLF + CRLF;

									logger.error("SENDING : \n"
											+ response
											+ "\n-------------------"+"\t"+this.getName());

									try {
										Thread.sleep(3000);
									} catch (InterruptedException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
									
									
										
									synchronized (dout) {
										
										dout.write(response.getBytes());
										try {
											Thread.sleep(3000);
										} catch (InterruptedException e) {
											// TODO Auto-generated catch block
											e.printStackTrace();
										}
										
									}

								

									response = "UPDATE "+device.getDeviceId()+" DDP/1.0"
											+ CRLF + "Content-Type:config"
											+ CRLF + "Message-ID:2 UPDATE"
											+ CRLF + "Content-Length:"
											+ cont.getBytes().length + CRLF
											+ CRLF + cont + CRLF;
									logger.error("UPDATING CONFIG WITH "+cont+"\t"+this.getName());
									synchronized (dout) {
										dout.write(response.getBytes());
									}

								}

							} else if (type.equals(DAMMessageType.DATA)) {
								lastTimeStamp=System.currentTimeMillis();

								if (myMsgBytes == null) {
									myMsgBytes = new ByteArrayOutputStream();
								}
								
								if (intHolder == null) {
									intHolder = new ArrayList<int[]>();;
								}

								logger.error("MSG IS DATA \n\n"+"\t"+this.getName());

								DAMDataMessage msg = new DAMDataMessage(
										new String(headerArray));
								ByteBuffer bb = ByteBuffer
										.allocate(msg.getBytesToRead());

								byte toReadNow[] = new byte[msg.getBytesToRead()];
								
								
								din.readFully(toReadNow);
								intHolder.add(getIntArr(toReadNow));
						/*		if(msg.getDamChannelId()==1){
									FileOutputStream fos= new FileOutputStream("each-msg-"+msg.getMessageId()+"_"+msg.getSamplingRate()+"_"+msg.getNumOfSamples()+"_"+msg.getDamChannelId()+"_"+System.currentTimeMillis()+".bin");
									fos.write(toReadNow);
									fos.flush();
									fos.close();
									
								}*/
								
								
								myMsgBytes.write(toReadNow);
								if (msg.isLastMessage()) {
									// last message/ submit buffer(s) for
									// processesing;
									/*if(msg.getDamChannelId()==1){
										FileOutputStream fos= new FileOutputStream("last-msg-"+msg.getMessageId()+"_"+msg.getSamplingRate()+"_"+msg.getNumOfSamples()+"_"+msg.getDamChannelId()+".bin");
										fos.write(myMsgBytes.toByteArray());
										fos.flush();
										fos.close();
										
									}*/
									
									msg.setArrayofintarrays(intHolder);
									processDataMessage(msg);
									myMsgBytes = null;
									intHolder=null;
								/*	
									ByteBuffer finalBuffer = ByteBuffer
											.wrap(myMsgBytes.toByteArray());
									finalBuffer.order(ByteOrder.LITTLE_ENDIAN);
									
									msg.setData(finalBuffer);
									*/
									//int[] data=processDataMessage(msg);
									
									/*if(msg.getDamChannelId()==1){
										FileWriter fos= new FileWriter("intArray-msg-"+msg.getMessageId()+"_"+msg.getSamplingRate()+"_"+msg.getNumOfSamples()+"_"+msg.getDamChannelId()+".txt");
										for(int i=0;i<data.length;i++){
											fos.write(data[i]+"\n");
										}
										
										fos.flush();
										fos.close();
										
									}*/
								}

							}else{
								logger.error("INELSE MSG IS "+type);
								
							}

							// System.exit(0);

						}
					}
				}

			} catch (Throwable e) {
				e.printStackTrace();
				try {
					socket.close();
				} catch (Throwable e2) {
					logger.error(e2);
				}
				;
				return;
				// this.reconnect();
			}
		}
		}
	}

	private int[] getIntArr(byte[] bin){
		
		ByteBuffer finalBuffer = ByteBuffer
		.wrap(bin);
		finalBuffer.order(ByteOrder.LITTLE_ENDIAN);
		finalBuffer.rewind();
		int[] dataArray = new int[bin.length/2];
		
		
		for (int i = 0; i < dataArray.length; i++) {
			// read data int
			int data =finalBuffer.getChar() & 0xffff;
			dataArray[i] = data;
		}
		
		return dataArray;
		
		
	}
	private void processDataMessage(DAMDataMessage dm) {

		ArrayList<Integer> finarr=new ArrayList<Integer>();
		
		ArrayList<int[]> sourceArray=dm.getArrayofintarrays();
		for(int arin[]:sourceArray){
			for(int i=0;i<arin.length;i++){
				finarr.add(arin[i]);
			}
		}
		
		int[] dataArray = new int[finarr.size()];;
		for (int i = 0; i < dataArray.length; i++) {
			dataArray[i]=finarr.get(i);;
		}
		/*
		dm.setNumOfSamples(dataArray.length);
		dm.getData().rewind();
		for (int i = 0; i < dataArray.length; i++) {
			// read data int
			int data = dm.getData().getChar() & 0xffff;
			dataArray[i] = data;
		}*/

		Integer DeviceChannelId=dm.getDamChannelId();
		Integer DPMChannelId=deviceChannelMap.get(DeviceChannelId);
		
		if(DPMChannelId==null){
			logger.error(" no mapping to  device channel id "+DeviceChannelId +" for device "+thisDevice.getDeviceId()+ " with mac "+thisDevice.getMac() +"\t"+this.getName());
			return ;
		}
		String name = DPMChannelId + "";

		
		ICNode node = DataBucket.getICNode(DPMChannelId);
		if (node == null) {
			logger.error("CHANNEL ID " + DPMChannelId
					+ " is not defined....  skipping"+"\t"+this.getName());
			return ;
			
		}

		node.setSamplingRate(dm.getSamplingRate());
		try {
			long tstart = System.currentTimeMillis();
			// logger.error(("STARTING........ "+tstart+"\n\n\n");

			DSPCalculator calc = DataBucket.getDSPCalculator(DPMChannelId);

			if (calc == null) {
				/*
				 * if(msgType==1 && ChID!=4){ logger.error(("\n\nChID="+ChID+"
				 * using DYNAMIC\n\nC"); calc=new DSPDynamicCalculator(ChID);
				 * }else{ logger.error(("\n\nCChID="+ChID+" using STATIC\n\nC");
				 * calc=new DSPStaticCalculator(ChID); }
				 */
				calc = DSPFactory.newDSPCalculator(DPMChannelId);
				DataBucket
						.addOrReplaceDSPCalculator(DPMChannelId, calc);
			}
			long timeTook = System.currentTimeMillis() - tstart;

			logger.error("DDD:  SampRate=" + dm.getSamplingRate() + " for "
					+ DPMChannelId);
			RawData raw = new RawData(DPMChannelId);
			raw.setChannelId(DPMChannelId);
			raw.setSamplingRate(dm.getSamplingRate());
			raw
					.setDateTimeStamp(new java.util.Date(System
							.currentTimeMillis()));
			PersistTreeNode.updateNodeIncomingDataTimestamp(node.getId(), raw.getDateTimeStamp());
			// raw.setDataTicks(tickData);
			raw.setData(dataArray);

			ChannelState st = calc.processData(raw, null);

			if (calc.isDebugMode()) { // TD: DEBUG MODE - STORE DSP CORE DUMP
										// FOR THE CHANNEL
				DataBucket.putDSPCoreDump(calc.getDspCoreDump().getChannelId(),
						calc.getDspCoreDump());
			}

			// logger.error(("IN HERE!!!!!!!!!!!!\n\n\n");
			// node.setChannelState(st);
			DataBucket.putChannelState(node.getChannelid(), st);
			node.setProcessedDataKeysString(st.getProcessedData().keySet());

			// node.setlatestRawData(raw);
			// node.setTickData1(tickData1);
			// node.setTickData2(tickData2);

			// TLD: Alarm Engine integration - Start - 1/2/2008
			// Comment out this section if it is causing problems
			try {
				AlarmEngine alarmEngine = DataBucket.getAlarmEngine(DPMChannelId);

				if (alarmEngine == null) {
					alarmEngine = new AlarmEngine();
					alarmEngine.initAlarmEngine(node);

					DataBucket.addOrReplaceAlarmEngine(DPMChannelId, alarmEngine);
				}

				alarmEngine.evaluateThresholds(st);
				// node.setEvents(alarmEngine.getEvents());

			} catch (Exception ex) {
				logger.error(":Exception in Alarm Engine: "
						+ ex.getLocalizedMessage());
				ex.printStackTrace();
				ex.printStackTrace(System.out);
				
			}
			// TLD: Alarm Engine integration - End - 1/2/2008

			DataBucket.updateNotifier.notifyUpdate(node);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		;
		

	}
	
	public void updateControllerConfig(){
		String cont="";
		
	
	
		thisDevice=ChannelConfigFactory.getDevice(thisDevice.getMac());
     

		for(Channel c:thisDevice.getChannels()){
			deviceChannelMap.put( c.getDeviceChannelId(),c.getChannelId());
			
			logger.error("adding mapping for deviceId "+thisDevice.getDeviceId() +"  DEVC="+c.getDeviceChannelId()+" DPMC="+c.getChannelId()+"\t"+this.getName());
			String samplerate=null;
			String numOfsample=null;
			String chidstr=null;
			for(ChannelConfigItem item:c.getChannelConfig().getChannelConfigItems()){
					if(item.getPropertyName().equals("com.inchecktech.dpm.dam.SamplingRate")){
						samplerate=item.getPropertyValue();
					}else if(item.getPropertyName().equals("com.inchecktech.dpm.dam.BlockSize")){
						numOfsample=item.getPropertyValue();
					}
						
					logger.error("CHANN CONF="+item.getPropertyName()+":"+item.getProperty_id()+":="+item.getPropertyValue());
			}
			
			chidstr=String.valueOf(c.getDeviceChannelId());
			if(chidstr.length()==1){
				chidstr="0"+chidstr;
			}
			if( samplerate != null  && numOfsample != null && chidstr !=null && !chidstr.equals("")){
				cont=cont+
				"[CHANNEL-"+chidstr+"]" + CRLF
				+ "SamplingRate="+samplerate + CRLF
				+ "SamplingInterval=10" + CRLF
				+ "Samples="+numOfsample + CRLF;
				
			}
				
			
			
			
		}
		
		String response = "UPDATE "+thisDevice.getDeviceId()+" DDP/1.0"
		+ CRLF + "Content-Type:config"
		+ CRLF + "Message-ID:40 UPDATE"
		+ CRLF + "Content-Length:"
		+ cont.getBytes().length + CRLF
		+ CRLF + cont + CRLF;
		logger.error("UPDATING CONFIG WITH "+cont);
		try{
			synchronized (dout) {
				dout.write(response.getBytes());
				dout.flush();
			}
		}catch(Throwable e){
			e.printStackTrace();
			logger.error(e);
		}
	}

	private DAMMessageType getDAMMessageType(String header) {

		String headerLines[] = header.split("\n");
		for (DAMMessageType eachType : DAMMessageType.values()) {
			if (headerLines[0].startsWith(eachType.toString())) {
				return eachType;
			}
		}

		return null;

	}
	
	
	public boolean sendTimeSyncMsg(){
		
		boolean retVal=true;
		try{
			String response="RESET "+thisDevice.getDeviceId()+" DDP/1.0"
				+ CRLF
				+"To:"+socket.getRemoteSocketAddress().toString().replaceFirst("/", "")
				+ CRLF
				+"From:"+DPMEngine.serverAddr+":"+ DPMEngine.serverPort
				+ CRLF
				+"Time-Stamp:"+((long)(System.currentTimeMillis()/1000))
				+ CRLF
				+"Message-ID:40 RESET"
				+ CRLF
				+"Content-Length:0"+ CRLF + CRLF;
			logger.error("sent \n"+response);
				
			synchronized (dout) {
				dout.write(response.getBytes());
			}
		}catch(Throwable e){
			logger.error(e);
			logger.error("error in sendTimeSyncMsg "+e.getMessage() +" "+this.getName());
			retVal=false;
		}

		
		return retVal;
		
	}
	public void closeSocket(){
		
		try{
			dout.close();
		}catch(Throwable e){}
		
		try{
			din.close();
		}catch(Throwable e){}
		
		
		try{
			this.socket.close();
		}catch(Throwable e){}
		
	}

	/**
	 * @return the manager
	 */
	public static DPMClientSocketHandlerHelper getHelper() {
		return helper;
	}

	/**
	 * @param manager the manager to set
	 */
	public static void setManager(DPMClientSocketHandlerHelper helper) {
		DPMClientSocketHandler.helper = helper;
	}

	public static enum DAMMessageType {
		REGISTER("REGISTER"), DISCOVER("DISCOVER"), DATA("DATA");
		private DAMMessageType(String name) {
			this.name = name;
		}

		private final String name;

		public String toString() {
			return name;
		}
	}
}
