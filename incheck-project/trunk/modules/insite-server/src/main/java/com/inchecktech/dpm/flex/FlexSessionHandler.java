package com.inchecktech.dpm.flex;

import java.util.List;

import flex.messaging.FlexContext;
import flex.messaging.FlexSession;

public class FlexSessionHandler {

	public static String getSessionId(){
		
		return FlexContext.getFlexSession().getId();	
	}
	
	public static void invalidateFlexSession(){
		FlexContext.getFlexSession().invalidate();
	}
	
	public static String getFlexUserId(){
		String userName = (String)FlexContext.getFlexSession().getAttribute("userName");
		return userName;
	}
	
	
	@SuppressWarnings("unchecked")
	public static List<FlexSession> getAllActiveFlexSessions(){
		List<FlexSession> sessions = FlexContext.getFlexClient().getFlexSessions();
		return sessions;
	}
	
}
