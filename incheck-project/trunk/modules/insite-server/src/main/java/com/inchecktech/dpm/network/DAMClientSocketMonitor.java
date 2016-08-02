package com.inchecktech.dpm.network;

import com.inchecktech.dpm.beans.DeviceEvent;
import com.inchecktech.dpm.beans.DeviceOperation;
import com.inchecktech.dpm.dao.DataBucket;
import com.inchecktech.dpm.persistence.PersistDeviceEvent;
import com.inchecktech.dpm.utils.Logger;



public class DAMClientSocketMonitor extends Thread{
	
	private static final Logger logger = new Logger(DAMClientSocketMonitor.class);
	@Override
	public void run() {

		while(true){
			try {
				Thread.sleep(400*1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			logger.error("Heartbeat execute");
			
			synchronized (DataBucket.handlers) {
				
				
				for(int i=0;i<DataBucket.handlers.size();i++){
					DPMClientSocketHandler each=DataBucket.handlers.get(i);
					logger.error("Checking Heartbeat for "+each.getName());
					try{
						
						if(System.currentTimeMillis()-each.lastTimeStamp > 30*1000){
							logger.error("DAM DISCONNECTED 0 (timeout)	 , KILLING SOCKET "+each.getName());
							each.closeSocket();
							if (each.getThisDevice() != null) {
								PersistDeviceEvent.save(new DeviceEvent(each.getThisDevice().getDeviceId(),
										DeviceOperation.DISCON));
							}
							DataBucket.handlers.remove(each);
							break;
						}
						boolean isConnected=each.socket.isConnected();
						boolean isClosed=each.socket.isClosed();
						boolean sendTimeSyncMsg=each.sendTimeSyncMsg();
						logger.error("testvals = "+isConnected+"\t"+isClosed+"\t"+sendTimeSyncMsg);
						if(isConnected && !isClosed){
							if(!sendTimeSyncMsg){
								logger.error("DAM DISCONNECTED 1 , KILLING SOCKET "+each.getName());
								each.closeSocket();
								DataBucket.handlers.remove(each);
								break;
								
							}
						}else{
							logger.error("DAM DISCONNECTED 2 , KILLING SOCKET "+each.getName());
							each.closeSocket();
							DataBucket.handlers.remove(each);
							break;
							
						}
					}catch(Throwable e){
						logger.error(e);
						logger.error("DAM DISCONNECTED 3, KILLING SOCKET "+each.getName());
						each.closeSocket();
						DataBucket.handlers.remove(each);
						break;
						
					};
					
				}
			}
			
		}
	}
	
	
	

}
