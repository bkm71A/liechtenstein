package com.inchecktech.dpm.tests;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.net.Socket;

public class DataCapture {

	
	public static void main(String[] args)  throws Throwable{
		
		
		if(args== null || args.length<4){
			
			System.out.println("USAGE:  host port numOfMsgsToCap KBytesToRead");
		}
		
		int KBytesToRead=Integer.parseInt(args[2]);
		String fileToStore=args[3];
		Socket s = new Socket(args[0],Integer.parseInt(args[1]));
		int readSoFar=0;
		DataInputStream di = new DataInputStream(s.getInputStream());
		FileOutputStream fos =new FileOutputStream(new File(fileToStore));
		int readAtOnce=300;
		while(true){
			byte b[]=new byte[readAtOnce];
			di.readFully(b);
			readSoFar+=readAtOnce;
			fos.write(b);
			fos.flush();
			System.out.println(readSoFar/1024 +" KB ");
			if(readSoFar>=(KBytesToRead*1024)){
				break;
			}
		}
		di.close();
		
		
		
		fos.close();
		
		
		
	}
}
