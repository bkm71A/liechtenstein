package com.inchecktech.dpm.network;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.SocketTimeoutException;

import com.inchecktech.dpm.beans.Device;
import com.inchecktech.dpm.config.ChannelConfigFactory;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.engine.DPMEngine;
import com.inchecktech.dpm.utils.Logger;

public class DAMDiscoverListener extends Thread {
	public static final String CRLF = "\r\n";
	private static final Logger logger = new Logger(DAMDiscoverListener.class);
	protected DatagramSocket socket = null;
	public static final int DISCOVER_PORT = 15210;
	// TODO todo XXX this to be taken from some configuration server
	//public static final int TCP_IP_PORT = 4441;

	private static final int SOCKET_TIMEOUT = 1000;
	private boolean run;

	public DAMDiscoverListener()  throws SocketException{
		super("DAMDiscoverListener");
		socket = new DatagramSocket(DISCOVER_PORT);
		//socket.setSoTimeout(SOCKET_TIMEOUT);
		
		run = true;

	}

	@Override
	public void run() {

		logger.error("started");
		logger.error("DiscoverRequestHandler started.");
		while (run) {

			try {
				byte[] buf = new byte[512];
				DatagramPacket packet = new DatagramPacket(buf, buf.length);
				boolean packetReceived = false;
				
				while (!packetReceived) {
					try {
						logger.error("DOING RCV UDP");
						
						socket.receive(packet);
						packetReceived = true;
					} catch (SocketTimeoutException tme) {
						if (!run) {
							socket.close();
							return;
						}
						Thread.sleep(500);
					}
				}
				logger.error("packetReceived? "+packetReceived);
				String msgdatanew=new String(packet.getData());
				String msgLines[]=msgdatanew.split("\n");
				logger.error(msgdatanew);
				String mac=msgLines[0].trim().split(" ")[1];
				Device device = null;
				try{
					device=ChannelConfigFactory.getDevice(mac);
				} catch(Throwable e){
					logger.error("error while loading device "+mac,e);
				}
				
				if(device==null){
					
					logger.error(" NO DEVICE WITH MAC  doing nothing"+mac);
				}else{
					logger.error(" DEVICE WITH MAC "+mac+ " FOUND");
					DataBucket.addOrReplaceDevice(device.getDeviceId()+"", device, mac);
					
					String response = "DDP/1.0 200 OK"+CRLF+
					"To:"+DPMEngine.serverAddr+":"+DPMEngine.serverPort+CRLF+
					"From:192.168.1.61:30165"+CRLF+
					"Message-ID:1 DISCOVER"+CRLF+
					"Content-Length:0"+CRLF+CRLF;
				
				logger.error("SENDING RESPONSE BACK :\n"+response);
				buf = response.getBytes();
				InetAddress address = packet.getAddress();
				int port = packet.getPort();
				// send the response to the client at "address" and "port"
				logger.error("sent response back :\n" + new String(buf) + ":	");
				packet = new DatagramPacket(buf, buf.length, address, port);
				;
				socket.send(packet);
					
				}
				

				Thread.sleep(5000);
				//run=false;
			} catch (Exception ex) {
				logger.error("DiscoverRequestHandler failure.", ex);
				run = false;
			}
		}
		socket.close();
	}

}
