<%
'Dimension variables
Dim conn 		'Database Connection Variable
                 	'Holds the Database driver and the path and name of the database
Dim rsCheckUser 		'Database Recordset Variable

Dim strSQL 		'Database query sring

Dim strUserName 	'Holds the user name

Dim strPassword ' Holds password 

'Initalise the strUserName variable
strUserName = Request.Form("txtusername")
strPassword = Request.Form("txtpassword")
%>

<%
'Check the database to see if user exsits and read in there password
'Initialise the strAccessDB variable with the name of the Access Database
'Create a connection odject
set conn = server.CreateObject("ADODB.Connection")
'conn.Open "DSN=students;"
conn.Open "DRIVER={SQL Server};SERVER=209.133.228.101;DATABASE=beshert;UID=beshert; PWD=bkm71"


'Create a recordset object
Set rsCheckUser = Server.CreateObject("ADODB.Recordset")

'Initalise the strSQL variable with an SQL statement to query the database
strSQL = "SELECT PASSWORD FROM PERSON WHERE EMAIL ='" & strUserName & "'"

'Query the database
rsCheckUser.Open strSQL, conn

'If the recordset finds a record for the username entered then read in the password for the user
If NOT rsCheckUser.EOF Then
	
	'Read in the password for the user from the database
	If (Request.Form("txtpassword")) = rsCheckUser("PASSWORD") Then
		
		'If the password is correct then set the session variable to True
		Session("blnIsUserGood") = True
		

		'Close Objects before redirecting
		'conn.Close
        'rsCheckUser.Close
		Set conn = Nothing
		Set rsCheckUser = Nothing

		
		
		

		
		
		'Redirect to the authorised user page and send the users name
		Response.Redirect"authorised_user.asp?fkt=QWERTYUIOP123ASDFG_GHJKL345_ZXCVBNM_qwert_asdasacbfg12345_zxcvbnm&unm=" & strUserName
	End If
End If
		
'Close Objects

'rsCheckUser.Close
Set conn = Nothing
Set rsCheckUser = Nothing
	
'If the script is still running then the user must not be authorised
Session("blnIsUserGood") = False

'Redirect to the unautorised user page
Response.Redirect"unauthorised_user.htm"

conn.Close
%>