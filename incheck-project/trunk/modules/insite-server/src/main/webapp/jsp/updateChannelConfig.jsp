<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!-- %@ taglib uri="http://java.sun.com/jstl/core" prefix="c"% -->
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ page import="com.inchecktech.dpm.flex.DPMFlexProxy" %>
<%@page import="com.inchecktech.dpm.config.ChannelConfigFactory"%>
<%@page import="com.inchecktech.dpm.config.ChannelConfigItem"%>
<%@page import="com.inchecktech.dpm.config.ChannelConfig"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<html>
<body>

<%
	int channelid = new Integer(request.getParameter("channel_id"));
	String[] keys = request.getParameterValues("keys");
	String[] vals = request.getParameterValues("myval");
	String[] ids = request.getParameterValues("myid");
	
	ChannelConfig cconfig = new ChannelConfig();
	ArrayList<ChannelConfigItem> lItems = new ArrayList<ChannelConfigItem>();

	if (null != keys && null != vals && null != ids){
		for (int i = 0; i < ids.length; i ++){
			//out.println("adding item " + keys[i]);
			ChannelConfigItem item = new ChannelConfigItem();
			item.setChannel_id(channelid);
			item.setProperty_id(new Integer (keys[i]));
			item.setPropertyValue(vals[i]);
			lItems.add(item);
		}
		
		cconfig.setChannelConfigItems(lItems);
	}
	
	try{
		int	intid = new Integer(channelid).intValue();
		
		//update with new values
		ChannelConfigFactory.updateConfigItems(cconfig);
		
		// refresh channel config
		DPMFlexProxy proxy = new DPMFlexProxy();
		proxy.reloadChannelConfig(intid);
		
		//redirect back to display
		response.sendRedirect("displayChannelConfig.jsp?channel_id=" + channelid);
		
		
	}catch (NumberFormatException e){
		e.printStackTrace();
	}


%>

</body>
</html>