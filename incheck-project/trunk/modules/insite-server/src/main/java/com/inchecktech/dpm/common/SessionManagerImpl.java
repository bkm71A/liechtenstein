package com.inchecktech.dpm.common;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.inchecktech.dpm.beans.Status;
import com.inchecktech.dpm.beans.UserSession;
import com.inchecktech.dpm.flex.FlexSessionHandler;
import com.inchecktech.dpm.utils.Logger;

//TODO create a thread that will clean up all inactive sessions every 30 minutes or so (remove them from the hashmap

public class SessionManagerImpl {

	private static SessionManagerImpl impl; 
	private static final Logger logger = new Logger(SessionManagerImpl.class);
	public static final int sessionTimeout = 30;
	private static Map<String, UserSession> sessions;
	
	private SessionManagerImpl(){
		sessions = new HashMap<String, UserSession>();
	}
	

	 public static synchronized SessionManagerImpl getInstance() {
	  if (impl==null) {
		  impl = new SessionManagerImpl();
	  }
	  return impl;
	 } 


	/**
	 * 
	 * @param userName
	 * @return status
	 */
	public Status createUserSession(String userName) {

		logger.info("creating sesion for user=" + userName);
		UserSession session = null;
		Status s = new Status();
		s.setStatus(Status.STATUS_ERROR);
		s.setMessage("An error occured");

		// check if the session already exist
		if (null != sessions.get(userName)) {
			logger.info("sesion for user=" + userName + " already exist: " + sessions.get(userName));
			updateSession(userName);
			s.setStatus(Status.STATUS_SUCCESS);
			s.setMessage("user session updated");
		} else {
			Date now = new Date();
			session = new UserSession(userName, FlexSessionHandler
					.getSessionId(), now);
			session.setModifiedDate(now);
			sessions.put(userName, session);
			
			s.setStatus(Status.STATUS_SUCCESS);
			s.setMessage("user session created");

		}
		
		logger.info("user session:" + session);
		return s;
	}

	/**
	 * 
	 * @param userName
	 * @return boolean
	 */
	public boolean isValidSession(String userName) {

		if (sessions.containsKey(userName)) {

			Date now = new Date();
			UserSession s = sessions.get(userName);
			Date modifyDate = s.getModifiedDate();

			if (null != modifyDate) {
				if (isLessThenTime(modifyDate, now, sessionTimeout)) {
					return false;
				}
			}
		}

		return true;
	}

	/**
	 * 
	 * @param userName
	 * @return boolean
	 */
	public void invalidate(String userName) {
		logger.info("Invalidating session for user" + userName);

		if (sessions.containsKey(userName)) {
			sessions.remove(userName);
			
		}
	}

	/**
	 * 
	 * @param userName
	 * @return boolean
	 */
	public boolean updateSession(String userName) {
		logger.info("updating user userName=" + userName);

		if (sessions.containsKey(userName)) {
			UserSession s = sessions.get(userName);
			s.setModifiedDate(new Date());
			s.setSessionId(FlexSessionHandler.getSessionId());
			sessions.put(userName, s);

			return true;
		}
		return false;
	}
	
	public String getUserNameForSession(){
		
		String userName = "";
		String sid = FlexSessionHandler.getSessionId();

		if (null != sessions){
			for (UserSession s: sessions.values()){
				if (s.getSessionId().equals(sid)){
					userName =  s.getUserName();
				}
			}
		}

		return userName;
	}

	private boolean isLessThenTime(Date date1, Date date2, int minutes) {

		if ((date1.getTime() - date2.getTime()) < (minutes * 1000)) {
			return true;
		}

		return false;
	}
}
