<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri='http://java.sun.com/jstl/core' prefix='c'%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<c:choose>
	<c:when test='${statusbean.status ==0}'>
		<c:out value="${statusbean.message}"></c:out>
	</c:when>
	<c:otherwise>
		<c:out value="An error occured"></c:out>
	</c:otherwise>
	
</c:choose>

</body>
</html>