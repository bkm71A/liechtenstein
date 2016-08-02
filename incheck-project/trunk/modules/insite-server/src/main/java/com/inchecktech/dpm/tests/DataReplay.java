package com.inchecktech.dpm.tests;

import java.net.ServerSocket;
import java.net.Socket;

public class DataReplay {

	
	public static void main(String[] args) throws Throwable {
		
		
		if(args== null || args.length<4){
			
			System.out.println("USAGE:  Listport bytesPerMsg sleepBtwSends fileToReadFrom");
			return;
		}
		
		int bytesAtOneTime=Integer.parseInt(args[1]);
		
		long sleepBtwSends=Long.parseLong(args[2]);
		String sourceFile=args[3];
		ServerSocket ss= new ServerSocket(Integer.parseInt(args[0]));
		Socket clientSock=null;
		
		while((clientSock=ss.accept())!=null){
			DataReplaySocketHandler blah=new DataReplaySocketHandler(clientSock,sourceFile,bytesAtOneTime,sleepBtwSends);
			blah.start();
			
		}
		
		
	}
}
