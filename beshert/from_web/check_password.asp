<%
'Dimension variables
Dim conn 		'Database Connection Variable
                 	'Holds the Database driver and the path and name of the database
Dim strEmail 		'Database Recordset Variable

Dim strSQL 		'Database query sring

Dim rsPassword



'Initalise the strUserName variable
strEmail = Request.Form("email")

response.write "" & strEmail & ""

%>

<%
'Check the database to see if user exsits and read in there password
'Initialise the strAccessDB variable with the name of the Access Database
'Create a connection odject
set conn = server.CreateObject("ADODB.Connection")
'conn.Open "DSN=students;"
conn.Open "DRIVER={SQL Server};SERVER=209.133.228.101;DATABASE=beshert;UID=beshert; PWD=bkm71"


'Create a recordset object
Set rsPassword = Server.CreateObject("ADODB.Recordset")

'Initalise the strSQL variable with an SQL statement to query the database
strSQL = "SELECT PASSWORD, EMAIL FROM PERSON WHERE EMAIL ='" & strEmail & "'"

'Query the database
rsPassword.Open strSQL, conn

'response.write " " & rsPassword("PASSWORD") & "<BR>"
'response.write "" & rsPassword("EMAIL") & ""

'If the recordset finds a record for the username entered then read in the password for the user
If NOT rsPassword.EOF Then
	
	'Read in the password for the user from the database
	If trim(strEmail) = trim(rsPassword("EMAIL")) Then
		
			'----------------Email Creation-----------------------------
		
		Dim strContactEmail
		Dim strPassword

		strPassword = rsPassword("PASSWORD")

		'getting values from form
		strContactEmail = "communication@beshert.com"
				
					
		strComment = "<FONT SIZE='2' FACE='Tahoma'>Here is your password:"
		
		strSendTo = strEmail

		Dim strBody
		'Setting up the body of the email
        datCurr = Now()	
		strBody = strComment & "<BR><BR>" _ 
		 
			& "<B>Sent: </b>" & datCurr & "<BR>" _ 
			& "<B>From: </b>" & strContactEmail & "<BR>" _
			& "<B>Password: </b>" & strPassword & "<BR>" 		

		strBody = strBody & "</font><BR><BR>"
		'---------------------------------------------------------

		'this routine sends email to the proper account
		'Setup the CDO object
		Dim objCDOMail 

		' Create an instance of the NewMail object.
		Set objCDOMail = Server.CreateObject("CDONTS.NewMail")

		objCDOMail.From = strContactEmail
		objCDOMail.To = strSendTo
		objCDOMail.Subject = "Your password"
		objCDOMail.Body = strBody

		objCDOMail.BodyFormat = 0 ' CdoBodyFormatHTML

		'Outlook gives you grief unless you also set:
		objCDOMail.MailFormat = 0 ' CdoMailFormatMime

		' Send the message!
		objCDOMail.Send

		'------------End of Mail-------------
		' Close the file and dispose of our objects
		Set objCDOMail = Nothing

		response.redirect "pwd_rqst_conf.htm"

		'Close Objects before redirecting
		'conn.Close
        'rsCheckUser.Close
		Set conn = Nothing
		Set rsPassword = Nothing

		
		else

		response.write "No such email. Please check it and try again. Click"
		%>

<A HREF="forget_password.htm">here </A>

		<%

		response.write "to return back"
		
		'Redirect to the authorised user page and send the users name
		'Response.Redirect"authorised_user.asp?fkt=QWERTYUIOP123ASDFG_GHJKL345_ZXCVBNM_qwert_asdasacbfg12345_zxcvbnm&unm=" & strUserName
	End If
End If
		
'Close Objects

'rsCheckUser.Close
Set conn = Nothing
Set rsPassword = Nothing
	
'If the script is still running then the user must not be authorised
'Session("blnIsUserGood") = False

'Redirect to the unautorised user page
Response.Redirect"forget_password.htm"

conn.Close
%>