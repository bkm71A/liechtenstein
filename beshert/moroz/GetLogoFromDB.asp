<%
Server.ScriptTimeout = 10000
Response.Expires=0
Response.Buffer = TRUE
Response.Clear


'Const conChunkSize = 100
Const conChunkSize = 900000
Dim filename
filename = "someone.bmp"
Dim lngOffset, lngLogoSize
Dim varChunk, varLogo
Dim UploadRequest
Set UploadRequest = CreateObject("Scripting.Dictionary")
Session("server") = Request.QueryString("server")

'contentType = UploadRequest.Item("blob").Item("ContentType")
'filepathname = UploadRequest.Item("blob").Item("FileName")
'filename = Right(filepathname,Len(filepathname)-InstrRev(filepathname,"\"))
'value = UploadRequest.Item("blob").Item("Value")

Set conn = Server.CreateObject("ADODB.Connection")

conn.open "Provider=SQLOLEDB;Data Source=" & Session("server") & ";Initial Catalog=test1;User ID=sa;Password=;"

sql = "SELECT ImageFile FROM tblImageFile"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, conn, 3, 3

lngLogoSize = rs("ImageFile").ActualSize
'Response.Write "lngLogoSize=" & lngLogoSize
'Response.End
'Do While lngOffset < lngLogoSize
    varChunk = rs("ImageFile").GetChunk(lngLogoSize)
	
    'varLogo = varLogo & varChunk
    lngOffset = lngOffset + conChunkSize
'Loop
   
'picturechunk =  value & chrB(0)

'rs.Fields("ImageFile").appendChunk picturechunk

'rs.Update



'Create FileSytemObject Component
 Set ScriptObject = Server.CreateObject("Scripting.FileSystemObject")

'Create and Write to a File
 pathEnd = Len(Server.mappath(Request.ServerVariables("PATH_INFO")))-17

 Set MyFile = ScriptObject.CreateTextFile(Left(Server.mappath(Request.ServerVariables("PATH_INFO")),pathEnd)& "Temp/" & filename)
 For i = 1 to LenB(varChunk)
	 MyFile.Write chr(AscB(MidB(varChunk,i,1)))
 Next
 
 MyFile.Close
%>
<html>
<head>
	<title>Image Retrieved From SQL Server Database</title>
</head>
<body bgcolor="#ffffff" alink="#000000" vlink="#000000" link="#000000">
<b>Downloaded Logo(<%=Session("server")%>): </b><%=filename%><br>
<%'Response.ContentType = "image/GIF"
'Response.BinaryWrite(rs("ImageFile"))
%>

<img src="Temp/<%=filename%>">
<br>
<%conn.close%>
</body>
</html>