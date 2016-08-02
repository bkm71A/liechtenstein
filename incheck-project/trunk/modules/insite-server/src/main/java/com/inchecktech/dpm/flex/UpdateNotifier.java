package com.inchecktech.dpm.flex;

import java.util.ArrayList;
import java.util.concurrent.LinkedBlockingQueue;

import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.utils.Logger;

public class UpdateNotifier extends Thread {
	private static final Logger logger = new Logger(UpdateNotifier.class);
	

	private ArrayList<UpdateListener> clients=new ArrayList<UpdateListener>();
	private LinkedBlockingQueue<ICNode> updateQueue=new LinkedBlockingQueue<ICNode>(5000);
	
	public void registerListener(UpdateListener l){
		logger.debug("ADDED NEW LISTENER "+l.getClass().getName());
		clients.add(l);
	}

	public void notifyUpdate(ICNode o){
		
		updateQueue.add(o);
		
	}
	
	@Override
	public void run() {
		 while(true){
			 try {
				ICNode o=updateQueue.take();
				for(UpdateListener eachList:clients){
					eachList.updatedNode(o);
				}
				logger.debug("UPDATED "+o +" "+o.getName());
			} catch (InterruptedException e) {
				logger.error("Exception in UpdateNotifier", e);
			}
		 }
	}
}
