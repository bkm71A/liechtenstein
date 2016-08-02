/**
 * 
 */
package com.inchecktech.dpm.network;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.Map;

import com.inchecktech.dpm.beans.Channel;
import com.inchecktech.dpm.beans.Device;
import com.inchecktech.dpm.config.ChannelConfigFactory;
import com.inchecktech.dpm.config.ChannelConfigItem;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.engine.DPMEngine;
import com.inchecktech.dpm.utils.Logger;
import com.inchecktech.exception.DPMClientSocketException;

/**
 * Manager to control of network messaging module
 * 
 * @author
 * 
 */
public class DPMClientSocketHandlerHelperImpl implements DPMClientSocketHandlerHelper {

	/* logger */
	private static final Logger LOGGER = new Logger(DPMClientSocketHandlerHelperImpl.class);

	public void processRegisterMessage(Map<Integer, Integer> deviceChannelMap,
			DataOutputStream dout, Device device, Socket socket) throws DPMClientSocketException, IOException {
		/*
		String mac = new String(headerArray).split("\n")[0].trim().split(" ")[1].trim();
		Device deviceTEMP = null;
		try {
			deviceTEMP = ChannelConfigFactory.getDevice(mac);
		} catch (Throwable e) {
			LOGGER.error("Error while loading device " + mac + "\t", e);
		}
		DataBucket.addOrReplaceDevice(deviceTEMP.getDeviceId() + "", deviceTEMP, mac);
		Device device = DataBucket.getDeviceByMac(mac);
		if (device == null) {
			throw new DPMClientSocketException("Can not register device with mac: " + mac);
		}
		thisDevice = device;

		String cont = "";

		for (Channel c : device.getChannels()) {
			deviceChannelMap.put(c.getDeviceChannelId(), c.getChannelId());
			LOGGER.error("adding mapping for deviceId " + device.getDeviceId() + "  DEVC=" + c.getDeviceChannelId()
					+ " DPMC=" + c.getChannelId());
			String samplerate = null;
			String numOfsample = null;
			String chidstr = null;
			for (ChannelConfigItem item : c.getChannelConfig().getChannelConfigItems()) {
				if (item.getPropertyName().equals("com.inchecktech.dpm.dam.SamplingRate")) {
					samplerate = item.getPropertyValue();
				} else if (item.getPropertyName().equals("com.inchecktech.dpm.dam.BlockSize")) {
					numOfsample = item.getPropertyValue();
				}

				LOGGER.error("CHANN CONF=" + item.getPropertyName() + ":" + item.getProperty_id() + ":="
						+ item.getPropertyValue());
			}
			chidstr = String.valueOf(c.getDeviceChannelId());
			if (chidstr.length() == 1) {
				chidstr = "0" + chidstr;
			}
			if (samplerate != null && numOfsample != null && chidstr != null && !chidstr.equals("")) {
				cont = cont + "[CHANNEL-" + chidstr + "]" + DPMNetworkConstants.CRLF + "SamplingRate=" + samplerate
						+ DPMNetworkConstants.CRLF + "SamplingInterval=10" + DPMNetworkConstants.CRLF + "Samples="
						+ numOfsample + DPMNetworkConstants.CRLF;
			}
		}
		{
			String response = "DDP/1.0 200 OK" + DPMNetworkConstants.CRLF + "Controller-ID:" + device.getDeviceId()
					+ DPMNetworkConstants.CRLF + "Time-Stamp:1209866566" + DPMNetworkConstants.CRLF + "To:"
					+ DPMEngine.serverAddr + ":" + DPMEngine.serverPort + DPMNetworkConstants.CRLF + "From:"
					+ socketAddress.toString().replaceFirst("/", "") + DPMNetworkConstants.CRLF
					+ "Message-ID:1 REGISTER" + DPMNetworkConstants.CRLF + "Content-Length:0"
					+ DPMNetworkConstants.CRLF + DPMNetworkConstants.CRLF;

			LOGGER.error("SENDING : \n" + response + "\n-------------------");
			synchronized (dout) {
				dout.write(response.getBytes());
			}
			response = "UPDATE " + device.getDeviceId() + " DDP/1.0" + DPMNetworkConstants.CRLF + "Content-Type:config"
					+ DPMNetworkConstants.CRLF + "Message-ID:2 UPDATE" + DPMNetworkConstants.CRLF + "Content-Length:"
					+ cont.getBytes().length + DPMNetworkConstants.CRLF + DPMNetworkConstants.CRLF + cont
					+ DPMNetworkConstants.CRLF;
			LOGGER.error("UPDATING CONFIG WITH " + cont);
			synchronized (dout) {
				dout.write(response.getBytes());
			}
		}
	*/
		
	
	
		/* get device
		String mac=new String(headerArray).split("\n")[0].trim().split(" ")[1].trim();
		
		Device deviceTEMP = null;
		try{
			deviceTEMP=ChannelConfigFactory.getDevice(mac);
		} catch(Throwable e){
			LOGGER.error("error while loading device "+mac+"\t",e);
		}
		
		
		DataBucket.addOrReplaceDevice(deviceTEMP.getDeviceId()+"", deviceTEMP, mac);
		
		
		Device device = DataBucket.getDeviceByMac(mac);
		if(device==null){
			LOGGER.error(" CANT REGISTER DEVICE WITH MAC -"+mac+"-");
			socket.close();
			return;
		}
		thisDevice=device;
		*/
		/*
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
		*/
		String cont="";
		
		for(Channel c:device.getChannels()){
			deviceChannelMap.put( c.getDeviceChannelId(),c.getChannelId());
			
			LOGGER.error("adding mapping for deviceId "+device.getDeviceId() +"  DEVC="+c.getDeviceChannelId()+" DPMC="+c.getChannelId());
			String samplerate=null;
			String numOfsample=null;
			String chidstr=null;
			for(ChannelConfigItem item:c.getChannelConfig().getChannelConfigItems()){
					if(item.getPropertyName().equals("com.inchecktech.dpm.dam.SamplingRate")){
						samplerate=item.getPropertyValue();
					}else if(item.getPropertyName().equals("com.inchecktech.dpm.dam.BlockSize")){
						numOfsample=item.getPropertyValue();
					}
						
					LOGGER.error("CHANN CONF="+item.getPropertyName()+":"+item.getProperty_id()+":="+item.getPropertyValue());
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
			try {
				Thread.sleep(25000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			


			LOGGER.error("SENDING : \n"
					+ response
					+ "\n-------------------"+"\t");
			
				
			synchronized (dout) {
				dout.write(response.getBytes());
			}

			try {
				Thread.sleep(25000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
 
			response = "UPDATE "+device.getDeviceId()+" DDP/1.0"
					+ CRLF + "Content-Type:config"
					+ CRLF + "Message-ID:2 UPDATE"
					+ CRLF + "Content-Length:"
					+ cont.getBytes().length + CRLF
					+ CRLF + cont + CRLF;
			LOGGER.error("UPDATING CONFIG WITH "+cont);
			synchronized (dout) {
				dout.write(response.getBytes());
			}

		}
}
	
	public Device getDevice(byte headerArray[], Socket socket) throws IOException {
		String mac=new String(headerArray).split("\n")[0].trim().split(" ")[1].trim();
		
		Device deviceTEMP = null;
		try{
			deviceTEMP=ChannelConfigFactory.getDevice(mac);
		} catch(Throwable e){
			LOGGER.error("error while loading device "+mac+"\t",e);
		}
		
		
		DataBucket.addOrReplaceDevice(deviceTEMP.getDeviceId()+"", deviceTEMP, mac);
		
		
		Device device = DataBucket.getDeviceByMac(mac);
		if(device==null){
			LOGGER.error(" CANT REGISTER DEVICE WITH MAC -"+mac+"-");
			socket.close();
			return null;
		}
		return device;
	}
	
	public static final String CRLF = "\r\n";
	
	/**
	 * @see com.inchecktech.dpm.network.DPMClientSocketHandlerHelper#processDataMessage(byte[], java.io.DataInputStream, java.util.Map)
	 */
	public void processDataMessage(byte[] headerArray, DataInputStream din, Map<Integer, Integer> deviceChannelMap)
			throws IOException, DPMClientSocketException  {/*
		ByteArrayOutputStream myMsgBytes = null;
		ArrayList<int[]> intHolder = null;

		// ? lastTimeStamp = System.currentTimeMillis();
		if (myMsgBytes == null) {
			myMsgBytes = new ByteArrayOutputStream();
		}
		if (intHolder == null) {
			intHolder = new ArrayList<int[]>();
		}
		LOGGER.error("MSG IS DATA \n\n");
		DAMDataMessage msg = new DAMDataMessage(new String(headerArray));
		// ? ByteBuffer bb = ByteBuffer.allocate(msg.getBytesToRead());
		byte toReadNow[] = new byte[msg.getBytesToRead()];
		din.readFully(toReadNow);
		intHolder.add(getIntArr(toReadNow));
		myMsgBytes.write(toReadNow);
		if (msg.isLastMessage()) {
			msg.setArrayofintarrays(intHolder);
			processDataMessage(msg, deviceChannelMap);
			myMsgBytes = null;
			intHolder = null;
		}
	*/}

	/*
	private int[] getIntArr(byte[] bin) {
		ByteBuffer finalBuffer = ByteBuffer.wrap(bin);
		finalBuffer.order(ByteOrder.LITTLE_ENDIAN);
		finalBuffer.rewind();
		int[] dataArray = new int[bin.length / 2];
		for (int i = 0; i < dataArray.length; i++) {
			// read data int
			int data = finalBuffer.getChar() & 0xffff;
			dataArray[i] = data;
		}
		return dataArray;
	}*/

	private void processDataMessage(DAMDataMessage dm, Map<Integer, Integer> deviceChannelMap)
			throws DPMClientSocketException {/*
		ArrayList<Integer> finarr = new ArrayList<Integer>();
		ArrayList<int[]> sourceArray = dm.getArrayofintarrays();
		for (int arin[] : sourceArray) {
			for (int i = 0; i < arin.length; i++) {
				finarr.add(arin[i]);
			}
		}
		int[] dataArray = new int[finarr.size()];
		for (int i = 0; i < dataArray.length; i++) {
			dataArray[i] = finarr.get(i);
		}

		Integer DeviceChannelId = dm.getDamChannelId();
		Integer DPMChannelId = deviceChannelMap.get(DeviceChannelId);

		if (DPMChannelId == null) {
			throw new DPMClientSocketException();
		}
		ICNode node = DataBucket.getICNode(DPMChannelId);
		if (node == null) {
			LOGGER.error("CHANNEL ID " + DPMChannelId + " is not defined....  skipping");
			return;
		}

		node.setSamplingRate(dm.getSamplingRate());
		try {
			//? long tstart = System.currentTimeMillis();
			DSPCalculator calc = DataBucket.getDSPCalculator(DPMChannelId);

			if (calc == null) {
				calc = DSPFactory.newDSPCalculator(DPMChannelId);
				DataBucket.addOrReplaceDSPCalculator(DPMChannelId, calc);
			}
			// ? long timeTook = System.currentTimeMillis() - tstart;

			LOGGER.error("DDD:  SampRate=" + dm.getSamplingRate() + " for " + DPMChannelId);
			RawData raw = new RawData(DPMChannelId);
			raw.setChannelId(DPMChannelId);
			raw.setSamplingRate(dm.getSamplingRate());
			raw.setDateTimeStamp(new java.util.Date(System.currentTimeMillis()));
			raw.setData(dataArray);

			ChannelState st = calc.processData(raw, null);

			if (calc.isDebugMode()) {
				DataBucket.putDSPCoreDump(calc.getDspCoreDump().getChannelId(), calc.getDspCoreDump());
			}
			DataBucket.putChannelState(node.getChannelid(), st);
			node.setProcessedDataKeysString(st.getProcessedData().keySet());
			try {
				AlarmEngine alarmEngine = DataBucket.getAlarmEngine(DPMChannelId);

				if (alarmEngine == null) {
					alarmEngine = new AlarmEngine();
					alarmEngine.initAlarmEngine(node);
					DataBucket.addOrReplaceAlarmEngine(DPMChannelId, alarmEngine);
				}
				alarmEngine.evaluateThresholds(st);
			} catch (Exception ex) {
				LOGGER.error(":Exception in Alarm Engine: " + ex.getLocalizedMessage());
				ex.printStackTrace();
				ex.printStackTrace(System.out);
			}
			DataBucket.updateNotifier.notifyUpdate(node);
		} catch (Throwable e) {
			e.printStackTrace();
		}
	*/}
}
