package com.inchecktech.dpm.tests;

import java.net.ServerSocket;
import java.net.Socket;
import com.inchecktech.dpm.utils.Logger;

public class WiVibSocket {
	private static final Logger logger = new Logger(WiVibSocket.class);
	
	
	public static void main(String[] args) throws Exception{
		
		
		ServerSocket s= new ServerSocket(9988);
		
		Socket cs=null;
		logger.info("WiVib READY TO ACCEPT on 9988");
		while((cs=s.accept())!=null){
			
			WiVibSocketHand h=new WiVibSocketHand(cs);
			h.start();
			
		}
	}
}
