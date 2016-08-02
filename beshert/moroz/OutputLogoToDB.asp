<!--#include file="upload_util.asp"-->
<%
Response.Expires=0
Response.Buffer = TRUE
Response.Clear

Response.BinaryWrite(Request.BinaryRead(Request.TotalBytes))
Response.End
byteCount = Request.TotalBytes
'Response.BinaryWrite(Request.BinaryRead(varByteCount))

RequestBin = Request.BinaryRead(byteCount)

Dim UploadRequest
Set UploadRequest = CreateObject("Scripting.Dictionary")

BuildUploadRequest  RequestBin

'email = UploadRequest.Item("email").Item("Value")

contentType = UploadRequest.Item("blob").Item("ContentType")
filepathname = UploadRequest.Item("blob").Item("FileName")
filename = Right(filepathname,Len(filepathname)-InstrRev(filepathname,"\"))
value = UploadRequest.Item("blob").Item("Value")

Set conn = Server.CreateObject("ADODB.Connection")

conn.open "Provider=SQLOLEDB;Data Source=" & Session("server") & ";Initial Catalog=test1;User ID=sa;Password=;"

sql = "SELECT ImageFile FROM tblImageFile"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, conn, 3, 3

picturechunk =  value & chrB(0)

rs.Fields("ImageFile").appendChunk picturechunk

rs.Update

conn.close

'Create FileSytemObject Component
 Set ScriptObject = Server.CreateObject("Scripting.FileSystemObject")

'Create and Write to a File
 pathEnd = Len(Server.mappath(Request.ServerVariables("PATH_INFO")))-18

 Set MyFile = ScriptObject.CreateTextFile(Left(Server.mappath(Request.ServerVariables("PATH_INFO")),pathEnd)& "Temp/" & filename)
 For i = 1 to LenB(value)
	 MyFile.Write chr(AscB(MidB(value,i,1)))
 Next
 
 MyFile.Close
%>
<html>
<head>
	<title>Upload Image To SQL Server Database</title>
</head>
<body bgcolor="#ffffff" alink="#000000" vlink="#000000" link="#000000">
<b>Uploaded Logo(<%=Session("server")%>): </b><%=filename%><br>
<img src="Temp/<%=filename%>">
<br>
<%=Session("server") = "cicascan"%>
<a href="GetLogoFromDB.asp?server=<%=Session("server")%>">Retrieve Uploaded Image</a>
</body>
</html>