<!-- INCLUDE FILE = "adovbs.inc" -->

<%
Response.Expires=0
Response.Buffer = TRUE
Response.Clear
If Request.QueryString("server") <> "" Then
	Session("server") = Request.QueryString("server")
Else
	Session("server") = "SERVER1"
End If
%>
<html>
<head>
	<title>Load Image To SQL Server Database</title>	
</head>
<body bgcolor="#ffffff">
<FORM METHOD="Post" ENCTYPE="multipart/form-data" 
ACTION="OutputLogoToDB.asp">
<table align="left" border="0">
	<tr><td colspan="2" align="center"><b>Upload Logo:</b><p></tr>	
	<tr>
		<td align="right" valign="top">Select an image file:</td>
		<td align="left"><INPUT TYPE="file" 
NAME="blob">&nbsp;&nbsp;&nbsp;<INPUT TYPE="submit" NAME="Enter" VALUE="Upload File"><p></td>
	</tr>
</table>
</FORM>
</body>
</html>