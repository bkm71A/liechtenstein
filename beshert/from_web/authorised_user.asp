<%
'Dimension variables
Dim objConn 		'Database Connection Variable
                 	'Holds the Database driver and the path and name of the database
Dim rsUser 		'Database Recordset Variable

Dim strSQL 		'Database query sring

Dim strEmail 	'Holds the email

'Dim strPassword ' Holds password 

'Initalise the strUserName variable
strEmail = Request.querystring("unm")
'strPassword = Request.Form("password")

'Check the database to see if user exsits and read in there password
'Initialise the strAccessDB variable with the name of the Access Database
'Create a connection odject
set objConn = server.CreateObject("ADODB.Connection")
'conn.Open "DSN=students;"
objConn.Open "DRIVER={SQL Server};SERVER=209.133.228.101;DATABASE=beshert;UID=beshert; PWD=bkm71"


'Create a recordset object
Set rsUser = Server.CreateObject("ADODB.Recordset")

'Initalise the strSQL variable with an SQL statement to query the database
strSQL = "SELECT FIRST_NAME FROM PERSON WHERE EMAIL ='" & strEmail & "'"

'Query the database
rsUser.Open strSQL, objConn
%>

<html>
<head>
<title>BESHERT</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<link rel="stylesheet" href="beshert.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" background="images/background.jpg" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('images/navigation/search1-on.jpg','images/navigation/speed2-on.jpg','images/navigation/personal3-on.jpg','images/navigation/travel4-on.jpg')">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="8%" height="78"><img src="images/logo_top.jpg" width="111" height="95"></td>
    <td width="14%" height="78">&nbsp;</td>
    <td width="12%" height="78">&nbsp;</td>
    <td width="15%" height="78">&nbsp;</td>
    <td width="7%" height="78">&nbsp;</td>
    <td width="44%" height="78">&nbsp;</td>
  </tr>
  <tr> 
    <td width="8%" height="19"><img src="images/logo_buttom.jpg" width="111" height="33"></td>
    <td width="14%" height="19"><a href="yourprofile.htm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('nav1','','images/navigation/search1-on.jpg',1)"><img name="nav1" border="0" src="images/navigation/search1-off.jpg" width="189" height="33"></a></td>
    <td width="12%" height="19"><a href="speed.htm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('nav2','','images/navigation/speed2-on.jpg',1)"><img name="nav2" border="0" src="images/navigation/speed2-off.jpg" width="166" height="33"></a></td>
    <td width="15%" height="19"><a href="personal.htm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('nav3','','images/navigation/personal3-on.jpg',1)"><img name="nav3" border="0" src="images/navigation/personal3-off.jpg" width="198" height="33"></a></td>
    <td width="7%" height="19"><a href="events.htm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('nav4','','images/navigation/travel4-on.jpg',1)"><img name="nav4" border="0" src="images/navigation/travel4-off.jpg" width="132" height="33"></a></td>
    <td width="44%" background="images/image-backg-small1.jpg" height="19">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td background="images/image-backg.jpg" height="128"><img src="images/image-home.jpg" width="794" height="153"></td>
  </tr>
</table>
<span class="beshert"> : </span> <a href="index.htm" class="beshert">home</a><span class="beshert"> :</span> <a href="contact.htm" class="beshert">contact 
info</a><span class="beshert"> : </span><a href="privacyinfo.htm" class="beshert">privacy 
info</a><span class="beshert"> :</span> <a href="terms2.htm" class="beshert">terms 
&amp; conditions<span class="beshert"> </span></a><span class="beshert">: </span><a href="mediacoverage.htm" class="beshert">media 
&amp; press</a> <span class="beshert">: </span><br>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
<TR height=200>
	<TD><TABLE width="100%" border="0" cellspacing="0" cellpadding="0" >
<FORM METHOD=POST ACTION="">
<TR>
	<TD align=left  colspan=2>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD align=center  ><IMG SRC="images/new2beshert.jpg" WIDTH="185" HEIGHT="42" BORDER="0" ALT=""></TD>
</TR>
<TR>
	<TD class="copy" colspan=2 >Hello!
	
	<% 
	

	Response.write rsUser("FIRST_NAME")

	
	
Set objConn = Nothing
Set rsUser = Nothing





	%>

	 Welcome to your profile!
	</A></TD>
	
	
	<TD>&nbsp;</TD>
	<TD align=center class="copy">Please <A HREF="yourprofile.htm" class="copy">sign in</A></TD>
</TR>
<TR>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD align=left class="copy">Edit your profile:	
	</TD>
	<TD>&nbsp;</TD>
	<TD align=right class="copy">&nbsp;</TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD align=left class="copy">
	<A HREF="contactinfo.asp" class="copy"><FONT SIZE="1" COLOR="#FF9900">Contact Information</FONT></A></TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD align=left class="copy">
	<A HREF="personalchar.asp" class="copy"><FONT SIZE="1" COLOR="#FF9900">Personal Characteristics</FONT></A></TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD align=left class="copy">
	<A HREF="personalitytraits.asp" class="copy"><FONT SIZE="1" COLOR="#FF9900">Your Personality Traits</FONT></A></TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD align=left class="copy">
	<A HREF="personlookfor.asp" class="copy"><FONT SIZE="1" COLOR="#FF9900">Who You Looking for</FONT></A></TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD>&nbsp;</TD>
	<TD class="copy">&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
</TR>
</FORM>
</TABLE></TD>
</TR>
</TABLE>
<div align="center"><a href="http://www.iimaginestudio.com" target="_blank"><span class="beshert">&copy;2003 
  BESHERT. All Rights Reserved . Design by <b>i imagine studio.</b></span></a> 
</div>
<map name="Map"> 
  <area shape="rect" coords="1,6,320,28" href="personal.htm">
  <area shape="rect" coords="1,28,284,44" href="speed.htm">
  <area shape="rect" coords="3,45,284,66" href="events.htm">
</map>
</body>
</html>
<% 

'rsUser.Close
'objConn.Close
%>