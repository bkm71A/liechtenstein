<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!-- %@ taglib uri="http://java.sun.com/jstl/core" prefix="c"% -->
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ page import="java.util.Map,java.util.List,com.inchecktech.dpm.persistence.*" %>
<%@page import="com.inchecktech.dpm.config.ChannelConfigItem"%>
<%@page import="com.inchecktech.dpm.config.ChannelConfigFactory"%>
<%@page import="com.inchecktech.dpm.config.ChannelConfig"%>
<html>
<head>


</head>
<body>

<%
			List<Integer> channels = PersistChannelConfig.getAvailableChannels();
			pageContext.setAttribute("channels", channels);
			
			int currentChannel=0;
			int timerFreq = 600;
			ChannelConfig channelConfig=new ChannelConfig();

			if(request.getParameter("channel_id") !=null){
				try{
					currentChannel=new Integer(request.getParameter("channel_id")).intValue();
				}catch(NumberFormatException e){
					currentChannel=0;
				}
				
				
				channelConfig = ChannelConfigFactory.getChannelConfig(currentChannel);
			}else{
				channelConfig = ChannelConfigFactory.getChannelConfig(channels.size());
			}
			pageContext.setAttribute("config", channelConfig);
			
			if(request.getParameter("timerFreq") !=null){
				try{
					timerFreq=new Integer(request.getParameter("timerFreq")).intValue();
				}catch(NumberFormatException e){
					timerFreq=600;
				}
				PersistDPMConfig.setTimerValue(timerFreq);
			}else{
				timerFreq = PersistDPMConfig.getTimerValue();
			}
			
			pageContext.setAttribute("timerFreq", timerFreq);

%>

<script type="text/javascript">
function submitChannelSelect(){
	document.channelSelect.submit();
}
</script>

<script type="text/javascript">
function submitDPMConfig(){
	document.timerFreqForm.submit();
}
</script>

<hr>

<form method="get" name="channelSelect">
	Select Channel: 
<select name="channel_id" onchange="submitChannelSelect();">
	<c:forEach items='${channels}' var="item">
		<c:choose>
			<c:when test="${param.channel_id != null && param.channel_id == item}" >
				<option id="channel_id" value='<c:out value='${item}'/>' selected="selected"><c:out value='${item}'/></option>
			</c:when>
			<c:otherwise>
				<option id="channel_id" value='<c:out value='${item}'/>'><c:out value='${item}'/></option>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</select>
</form>

<c:if test="${param.channel_id != null}" >
<form method="post" name="channelConfig" action="updateChannelConfig.jsp?channel_id=<c:out value='${param.channel_id}'/>">
Values for channel <c:out value='${param.channel_id}'/>
<table>
	<tr>
		<td>Id</td>
		<td>Name</td>
		<td>Conf V</td>
		<td>Def V</td>
		<td>Description</td>
	</tr>
	<c:forEach items='${config.channelConfigItems}' var='item'>
	<tr>
	  <td><input type="text" size="10" disabled="disabled" id="ids" name="ids" value=<c:out value='${item.property_id}'/>></td>
	  <td><input type="text" size="80" id="mykey" name="mykey" disabled="disabled" value='<c:out value="${item.propertyName}"/>'></td>
	  <td><input type="text" size="80" id="myval" name="myval" value='<c:out value="${item.propertyValue}"/>'></td>
	  <td><input type="text" disabled="disabled" size="80" id="dval" name="dval" value='<c:out value="${item.defaultValue}"/>'></td>
	  <td><input type="text" disabled="disabled" size="80" id="desc" name="desc" value='<c:out value="${item.description}"/>'></td>
  </tr>
	  <input type="hidden" id="keys" name="keys" value=<c:out value='${item.property_id}'/>>
	  <input type="hidden" id="channelid" name="channelid" value=<c:out value='${currentChannel}'/>>
	  <input type="hidden" id="myid" name="myid" value=<c:out value='${item.property_id}'/>>
  </c:forEach>
 </table>
  <input type="submit" value="update">
  </form>
  
 </c:if>
 
 <hr>
 Timer Settings:
 <form method="get" name="timerFreqForm">
 <table>
 	<tr>
 		<td><input type="text" alt="interval to save processed data to database in seconds" value="DPM Timer Interval" disabled="disabled"/></td>
 		<td><input type="text" name="timerFreq" value="<c:out value='${timerFreq}'/>"></td>
 	</tr>
 	<tr>
 		<td><input type="submit" value="update"/>
 	</tr>
 </table>
 </form>

 
</body>
</html>