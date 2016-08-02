package com.inchecktech.dpm.network;

import java.net.ServerSocket;
import java.net.Socket;

import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.engine.DPMEngine;
import com.inchecktech.dpm.utils.Logger;



public class DPMServerSocket extends Thread{
	
	
	private static final Logger logger = new Logger(DPMServerSocket.class);
	@Override
	public void run() {

		// TODO Auto-generated method stub
		super.run();
		
		DAMClientSocketMonitor HBThread=new DAMClientSocketMonitor();
		HBThread.start();
		try{
		
			ServerSocket s = new ServerSocket(DPMEngine.serverPort);
			Socket clientSok=null;
			while((clientSok=s.accept())!=null){
				clientSok.setKeepAlive(true);
				
				logger.error("STARTING NEW DPMClientSocketHandler ");
				DPMClientSocketHandler dsh=new DPMClientSocketHandler(clientSok);
				dsh.start();
				DataBucket.handlers.add(dsh);
				logger.error("STARTED NEW DPMClientSocketHandler "+"\t"+dsh.getName());
			
			}
			
		}catch(Throwable e){
			e.printStackTrace();
		}
		
	}
	

}
