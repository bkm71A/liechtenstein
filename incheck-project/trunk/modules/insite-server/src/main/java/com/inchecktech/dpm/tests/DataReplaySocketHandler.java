package com.inchecktech.dpm.tests;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.Socket;

public class DataReplaySocketHandler  extends Thread{

	
	Socket s=null;
	String fileToRead=null;
	int BytesPerMSG=0;
	long sleepBtwSends;
	public DataReplaySocketHandler(Socket s,String fileToRead,int BytesPerMSG,long sleepBtwSends){
		this.s=s;
		this.fileToRead=fileToRead;
		this.BytesPerMSG=BytesPerMSG;
		this.sleepBtwSends=sleepBtwSends;
		
	}
	
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		super.run();
		try{
			
			FileInputStream fis=new FileInputStream(new File(fileToRead));
			byte atOne[]=new byte[BytesPerMSG];
			DataOutputStream dos=new DataOutputStream(s.getOutputStream());
			
			
			while(fis.read(atOne)!=-1){
				dos.write(atOne);
				dos.flush();
				Thread.sleep(sleepBtwSends);
			}
			dos.flush();
			dos.close();
			fis.close();
			
		}catch(Throwable e){
			e.printStackTrace();
		};
		
	}
}
