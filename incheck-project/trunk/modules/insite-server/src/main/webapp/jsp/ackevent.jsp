<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri='http://java.sun.com/jstl/core_rt' prefix='c_rt'%>
<%@ taglib uri='http://java.sun.com/jstl/core' prefix='c'%>
<%@page import="com.inchecktech.dpm.flex.DPMFlexProxy"%>
<%@page import="com.inchecktech.dpm.beans.Status"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Ack Event</title>
<jsp:useBean id='statusbean' class='com.inchecktech.dpm.beans.Status' scope="session"/>
<jsp:setProperty name="statusbean" property="status" value="1" />

</head>
<body>
<%
DPMFlexProxy proxy = new DPMFlexProxy();
%>

<c:if test='${not empty param.eventid}'>
	Acking event: <c:out value="${param.eventid}" />
	<form method="POST"><font color='red'> Please enter	your user name: </font> 
	<input type="text" name="username" /> 
	<input type='submit' name='submit' value='submit' <c:if test='${statusbean.status == 0}'> disabled='disabled' </c:if> />
		<c:if test='${not empty param.username}'>
				<%
					try{
					String userName = (String) request.getParameter("username");
					int eventId = (new Integer(request.getParameter("eventid"))
							.intValue());
					
					Status status = proxy.ackEvent(userName, eventId, "acked");
					statusbean.setMessage(status.getMessage());
					statusbean.setStatus(status.getStatus());
					}catch (NumberFormatException e){
						statusbean.setStatus(Status.STATUS_ERROR);
						statusbean.setMessage("Invalid event specified");
					}catch (Exception e1){
						statusbean.setStatus(Status.STATUS_ERROR);
						statusbean.setMessage("An error occured");
					}
					
					
				%>
				<c:out value="statusbean=${statusbean.message}"></c:out>
				<jsp:forward page="status.jsp"></jsp:forward>
		</c:if>
	</form>
</c:if>

</body>
</html>