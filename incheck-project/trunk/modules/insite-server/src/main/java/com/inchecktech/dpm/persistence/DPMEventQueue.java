package com.inchecktech.dpm.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.Event;
import com.inchecktech.dpm.dao.DAOFactory;
import com.inchecktech.dpm.dao.SQLStatements;
import com.inchecktech.dpm.utils.Logger;


public class DPMEventQueue extends Thread {
	private static final Logger logger = new Logger(DPMEventQueue.class);

	private BlockingQueue<Event> queue = new LinkedBlockingQueue<Event>();
	private Connection conn = null;
	
	public DPMEventQueue() {
		this.start();
	}

	public void accept(Event event) {
		try {
			queue.put(event);
		} catch (InterruptedException e) {
			logger.error("Queue is full, try again later");
			throw new RuntimeException("queue is full, try again later");
		}
	}

	public void run() {
		while (true) {
			try {
				// grab an event off the queue
				Event event = queue.take();
				
				try {
					conn = DAOFactory.getConnection();
					PreparedStatement pstmt = conn
							.prepareStatement(SQLStatements.QUERY_INSERT_EVENT);

					// First need to store the channel state
					ChannelState cState = event.getChanState();
					if (null == cState) {
						logger.info("Channel State can't be null in event");
					}else{
	
						int stateID = PersistChannelState.storeChannelState(cState,
								true, "severity-" + event.getSeverity());
	
						pstmt.setInt(1, event.getChannelId());
						pstmt.setInt(2, stateID);
						pstmt.setInt(3, event.getEventTrId());

						pstmt.executeUpdate();
						pstmt.close();
						conn.close();
					}
				} catch (SQLException se) {
					logger.error("SQL Exception occured, ", se);
					throw new InterruptedException();
					
				} catch (Exception e) {
					logger.error("Exception Occured, ", e);
					throw new InterruptedException();
				}

			} catch (InterruptedException e) {
			}
		}
	}
}