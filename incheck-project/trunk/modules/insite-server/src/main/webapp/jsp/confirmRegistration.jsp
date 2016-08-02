<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!-- %@ taglib uri="http://java.sun.com/jstl/core" prefix="c"% -->
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ page
	import="java.util.Map,java.util.List,com.inchecktech.dpm.persistence.*"%>

<%@page import="com.inchecktech.dpm.common.UserManager"%>
<%@page import="com.inchecktech.dpm.common.UserManagerImpl"%>


<%@page import="com.inchecktech.dpm.beans.Status"%><html>
<body>

<%
	String regcode = "";
	Status status;

	if (request.getParameter("id") != null) {
		regcode = request.getParameter("id");

		UserManager mgr = new UserManagerImpl();
		status = mgr.verifyUser(regcode);
		pageContext.setAttribute("status", status);
		
		
	} else {
		pageContext.setAttribute("status", "There was an error validating your registration information, please contect help@inchecktech.net ");
	}
	
%>
<c:out value="${status.message}"></c:out>

</body>
</html>