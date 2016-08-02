<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server" language="c#">
  System.String connectionString = "server=localhost;uid=beshert;pwd=bkm71;database=beshert";
  /* Called on page load */
  protected void Page_Load(Object sender, EventArgs e) {
    if ( ! IsPostBack ) {
     if ( Session["user"] == null ){
        Session["requestor"] = "Register3.aspx"; 
        Response.Redirect("Login.aspx");       
      } else {
   /* if () {   
        Response.Redirect("Register2.aspx");
      } */      

      }
      all_DataBind();
      briefTxt.Attributes["onKeyUp"]="javascript:countCharacters();";
      Session.Timeout = 60;
    }
  }

  /* Bind data to controls */
  void all_DataBind() {
    SqlConnection connection = new SqlConnection(connectionString);
    connection.Open();
    fillListControl("CHECKBOX_LIST",cblPersonality,connection,"WHERE SECTION = 'PERSONALITY'",false);
    fillListControl("CHECKBOX_LIST",cblOther,connection,"WHERE SECTION = 'OTHER'",false);
    fillListControl("CHECKBOX_LIST",cblSport,connection,"WHERE SECTION = 'SPORT'",false);
    fillListControl("CHECKBOX_LIST",cblMusic,connection,"WHERE SECTION = 'MUSIC'",false);
    fillListControl("CHECKBOX_LIST",cblDancing,connection,"WHERE SECTION = 'DANCING'",false);
    fillListControl("PHYSICAL_ACTIVITY",cmbPhysicalActivity,connection,"",true);
    connection.Close();
 }

  /* Format string for SQL - if not empty, encloses in '', otherwise return string "NULL" */
  String formatStrSql(String src) {
    if (src==null || src.Length<1) {
      return "NULL";
    }
    String result = src.Replace("'","`").Replace("\"","``");
    return "'" + result + "'";
  }

  void fillListControl(String tableName,ListControl control,SqlConnection sqlConn,String filter,bool orderByCode) {
    SqlCommand dataSelect = new SqlCommand("SELECT CODE,DESCRIPTION FROM "+tableName+" "+filter+
    (orderByCode? " ORDER BY CODE":" ORDER BY DESCRIPTION"),sqlConn);
    SqlDataReader reader = dataSelect.ExecuteReader();
    control.DataSource = reader;
    control.DataTextField = "DESCRIPTION";
    control.DataValueField = "CODE";
    control.DataBind();
    reader.Close();
  }

  void SubmitImage(Object sender,EventArgs e) {
    HttpPostedFile upFile = UP_FILE.PostedFile;
    String userId = (String)Session["user"];
    if ( upFile == null || upFile.ContentLength == 0 ) {
      message.Text = "<b>* You must pick a file to upload</b>";
    } else {
      Stream streamObject;
      int fileLength = upFile.ContentLength;
      Byte[] fileByteArray = new Byte[fileLength];
      streamObject = upFile.InputStream;
      streamObject.Read(fileByteArray,0,fileLength);
      SqlConnection sqlConn = new SqlConnection(connectionString);
      SqlCommand insertPhoto = new SqlCommand("INSERT INTO PHOTO (ID,PHOTO) VALUES ("+formatStrSql(userId)+",@image)",sqlConn);
      SqlParameter param = insertPhoto.Parameters.Add(new SqlParameter("@image",SqlDbType.Image));
      param.Value = fileByteArray;
      sqlConn.Open();
      insertPhoto.ExecuteNonQuery();
      sqlConn.Close();
	    message.Text= "<b>* Your image has been uploaded</b>";
      photoSubmit.Enabled=false;
    }
  }

  /* Save data and continue */
  void Save_More_Continue(Object sender, EventArgs e) {
    if ( Page.IsPostBack && Page.IsValid ) {
      Save_Data(sender,e);
      Response.Redirect("Register4.aspx");
    }
  }
  
  /* Save data and exit */
  void Save_More_Exit(Object sender, EventArgs e) {
    if ( Page.IsPostBack && Page.IsValid ) {
      Save_Data(sender,e);
      Response.Redirect("Done.aspx");
    } 
  }

  /* Save feature */
  void saveFeature(ListControl control,SqlParameter parameter,SqlCommand comm){
    for ( int k = 0; k< control.Items.Count; k++ ) {
      if ( control.Items[k].Selected ) {
        parameter.Value = control.Items[k].Value;
        comm.ExecuteNonQuery();
      }
    }
  }

  /* Save form data in database */
  void Save_Data(Object sender, EventArgs e) {
    String userId = (String)Session["user"];
    StringBuilder sqlCommand = new StringBuilder();
    sqlCommand.Append("UPDATE PERSON_EXTRA SET ACTIVITY = ");
    sqlCommand.Append(formatStrSql(cmbPhysicalActivity.SelectedItem.Value));
    sqlCommand.Append(" ,FAVORITE_SPORT=");
    sqlCommand.Append(formatStrSql(favorite_sport.Text));
    sqlCommand.Append(" ,FAVORITE_HOBBY=");
    sqlCommand.Append(formatStrSql(favorite_hobby.Text));
    sqlCommand.Append(", FAVORITE_VACATION=");
    sqlCommand.Append(formatStrSql(favorite_vacation.Text));
    sqlCommand.Append(", STATEMENT = ");
    sqlCommand.Append(formatStrSql(briefTxt.Text));
    sqlCommand.Append(" WHERE ID = ");
    sqlCommand.Append(formatStrSql(userId)); 
    SqlConnection sqlConn = new SqlConnection(connectionString);
    sqlConn.Open();
    SqlCommand insertPersonMore = new SqlCommand(sqlCommand.ToString(),sqlConn);
    insertPersonMore.ExecuteNonQuery();
    SqlCommand deleteFeatures = new SqlCommand("DELETE FROM PERSON_FEATURE WHERE ID='" + userId + "'",sqlConn);
    deleteFeatures.ExecuteNonQuery();
    String sFeature="";
    SqlCommand insertFeatures = new SqlCommand("INSERT INTO PERSON_FEATURE(ID,FEATURE) VALUES('"+userId+"',@sFeature)",sqlConn);
    SqlParameter param = new SqlParameter("@sFeature",SqlDbType.Char,4);
    insertFeatures.Parameters.Add(param);
    saveFeature(cblPersonality,param,insertFeatures);
    saveFeature(cblSport,param,insertFeatures);
    saveFeature(cblMusic,param,insertFeatures);
    saveFeature(cblDancing,param,insertFeatures);
    saveFeature(cblOther,param,insertFeatures);
    sqlConn.Close();
    // TODO ? catch ?? System.Data.SqlClient.SqlException
  }
  </script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>BESHERT</TITLE>
<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">
<meta name="Author" content="Slava Kovalenko, Slava_K, BKM71">
<script src="javascript/beshert.js"></script>
<SCRIPT language=JavaScript>
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
</SCRIPT>
<LINK href="css/beshert.css" type=text/css rel=stylesheet>
</HEAD>
<BODY text=#000000 bgColor=#ffffff leftMargin=0 
background=img/background.jpe topMargin=0 
onload="MM_preloadImages('img/navigation/search1-on.jpg','img/navigation/speed2-on.jpg','img/navigation/personal3-on.jpg','img/navigation/travel4-on.jpg')" 
marginheight="0" marginwidth="0">
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD width="11%" height=83><A 
      href="http://www.iimaginestudio.com/beshert/index.htm"><IMG height=95 
      src="img/logo_top.jpe" width=111 border=0></A></TD>
    <TD vAlign=bottom width="19%" height=83>
      <TABLE height=30 cellSpacing=0 cellPadding=0 width="101%" border=0>
        <TBODY>
        <TR>
          <TD width="28%">&nbsp;</TD>
          <TD class=subnavig2 width="72%">&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD width="16%" height=83>&nbsp;</TD>
    <TD width="19%" height=83>&nbsp;</TD>
    <TD width="11%" height=83>&nbsp;</TD>
    <TD width="24%" height=83>&nbsp;</TD></TR>
  <TR>
    <TD width="11%" height=23><A 
      href="http://www.iimaginestudio.com/beshert/index.htm"><IMG height=33 
      src="img/logo_buttom.jpe" width=111 border=0></A></TD>
    <TD width="19%" height=23><A 
      onmouseover="MM_swapImage('nav1','','img/navigation/search1-on.jpg',1)" 
      onmouseout=MM_swapImgRestore() 
      href="http://www.iimaginestudio.com/beshert/yourprofile.htm"><IMG 
      height=33 src="img/search1-on.jpe" width=189 border=0 
      name=nav1></A></TD>
    <TD width="16%" height=23><A 
      onmouseover="MM_swapImage('nav2','','img/navigation/speed2-on.jpg',1)" 
      onmouseout=MM_swapImgRestore() 
      href="http://www.iimaginestudio.com/beshert/speed.htm"><IMG 
      class=newspaper height=33 src="img/speed2-off.jpe" width=166 
      border=0 name=nav2></A></TD>
    <TD width="19%" height=23><A 
      onmouseover="MM_swapImage('nav3','','img/navigation/personal3-on.jpg',1)" 
      onmouseout=MM_swapImgRestore() 
      href="http://www.iimaginestudio.com/beshert/personal.htm"><IMG height=33 
      src="img/personal3-off.jpe" width=198 border=0 
name=nav3></A></TD>
    <TD width="11%" background=img/image-backg-small1.jpe 
      height=23><A 
      onmouseover="MM_swapImage('nav4','','img/navigation/travel4-on.jpg',1)" 
      onmouseout=MM_swapImgRestore() 
      href="http://www.iimaginestudio.com/beshert/events.htm"><IMG height=33 
      src="img/travel4-off.jpe" width=132 border=0 name=nav4></A></TD>
    <TD width="24%" background=img/image-backg-small1.jpe 
    height=23>&nbsp;</TD></TR></TBODY></TABLE><A class=beshert 
href="http://www.iimaginestudio.com/beshert/index.htm">: home</A><SPAN 
class=beshert> : </SPAN><FONT class=beshert color=#333333><A class=beshert 
href="http://www.iimaginestudio.com/beshert/contact.htm">contact 
info</A></FONT><SPAN class=beshert> :<FONT color=#666666> </FONT></SPAN><FONT 
color=#666666><FONT color=#999999><A class=beshert 
href="http://www.iimaginestudio.com/beshert/privacyinfo.htm">privacy 
info</A></FONT></FONT><SPAN class=beshert> :</SPAN><FONT class=beshert 
color=#666666> <A class=beshert 
href="http://www.iimaginestudio.com/beshert/terms2.htm">terms &amp; conditions 
</A></FONT><SPAN class=beshert>:</SPAN><FONT color=#666666><SPAN class=beshert> 
</SPAN><A class=beshert 
href="http://www.iimaginestudio.com/beshert/mediacoverage.htm">media 
coverage</A></FONT><SPAN class=beshert> : <BR></SPAN>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD>&nbsp;</TD>
    <TD>&nbsp;</TD></TR></TBODY></TABLE><BR>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD width=0% height=26>&nbsp;</TD>
    <TD width="7%" height=26>&nbsp;</TD>
    <TD class=TITLES2 vAlign=top width="90%" height=26><FONT 
      size=2>QUESTIONARY <SPAN class=TITLES>:: Submit your 
    Profile</SPAN></FONT></TD>
    <TD width="3%" height=26>&nbsp;</TD></TR>
  <TR>
    <TD class=beshertCopy vAlign=top width=0% height=819><FONT 
      color=#ffffff></FONT></TD>
    <TD class=beshertCopy vAlign=top align=left width="7%" 
height=819>&nbsp;</TD>
    <TD class=subnavig2Copy vAlign=center width="90%" height=819>
      
 <form  runat="server" enctype="multipart/form-data" id="person_more" name="person_more" action="Register3.aspx" method="post">     
      <P><FONT class=subnavigCopy face="Verdana, Arial, Helvetica, sans-serif" 
      color=#666666 size=1>Your Personality Traits</FONT></P>
          <asp:CheckBoxList runat="server" id="cblPersonality" CellPadding="4" CellSpacing="0" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="4" RepeatDirection="Vertical" Width="100%"/>

      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><B class=subnavigCopy>T<SPAN class=subnavigCopy>hings you enjoy the 
      most</SPAN></B><BR></FONT></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="16%" height=27><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Favorite sport</FONT></TD>
          <TD width="84%" height=27><FONT color=#666666>
          <asp:TextBox runat="server" maxLength="30" Columns="30" id="favorite_sport" name="favorite_sport" /> </FONT></TD></TR>
        <TR>
          <TD width="16%" height=18><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><BR><SPAN class=subgraybold>Favorite hobby</SPAN></FONT></TD>
          <TD width="84%" height=18><FONT color=#666666>
          <asp:TextBox runat="server" maxLength="30" Columns="30" id="favorite_hobby" name="favorite_hobby" /> </FONT></TD></TR>
        <TR>
          <TD width="16%" height=35><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Favorite vacation</FONT></TD>
          <TD width="84%" height=35><FONT color=#666666>
          <asp:TextBox runat="server" maxLength="30" Columns="30" id="favorite_vacation" name="favorite_vacation" /></FONT></TD></TR></TBODY></TABLE>
      <P>&nbsp;</P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><BR><SPAN class=subnavigCopy>Physical Activities</SPAN> 
      <asp:DropDownList runat="server" id="cmbPhysicalActivity"/> <BR><BR></FONT></P>
          <asp:CheckBoxList runat="server" id="cblSport" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="2" RepeatDirection="Vertical" Width="100%"/>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><BR><SPAN class=subnavigCopy>Music</SPAN></FONT></P>
          <asp:CheckBoxList runat="server" id="cblMusic" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="2" RepeatDirection="Vertical" Width="100%"/>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><BR><SPAN class=subnavigCopy>Dancing</SPAN></FONT></P>
          <asp:CheckBoxList runat="server" id="cblDancing" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="2" RepeatDirection="Vertical" Width="100%"/>

      <P class=subnavigCopy><FONT class=subnavigCopy 
      face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1>Other 
      interests and activities</FONT></P>
      <asp:CheckBoxList runat="server" id="cblOther"  CssClass="textSK"
      RepeatLayout="table" RepeatColumns="3" RepeatDirection="Vertical" Width="100%"/>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1>Please write a brief statement (up to 1000 characters) about 
      yourself<BR><BR>
      <asp:TextBox runat="server" columns=100 rows=10 textmode="multiline" id="briefTxt" name="briefTxt" Wrap="true"/>
      <BR><BR></FONT></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="40%" valign="TOP"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1><input type="text" name="charCountOut" id="charCountOut"  disabled size=25> Counter - "how 
            many characters" </FONT></TD>
          <TD width="60%"><TABLE><TBODY><TR><TD>
          <FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Upload Photo (optional):</FONT> <input type="file" id="UP_FILE" runat="server" Size="34" accept="image/*" /> 
</TD></TR><TR><TD>
            <asp:Button runat="server" id="photoSubmit" width="239" OnClick="SubmitImage" text="Upload your photo" />
</TD></TR><TR><TD colspan=2><asp:Label runat="server" id="message" forecolor="red" maintainstate="false" /></TD></TR>             
            </TBODY></TABLE>
            </TD>
            </TR>
            </TBODY></TABLE>
      <P>&nbsp;</P>
<center><P class=beshertCopy><FONT color=#666666 size=1>
				<asp:Button id="SubmitExit3" runat="server" Text="Save & Exit" alt="Save &amp; Exit" border="0" 
        name="RegisterExit" OnClick="Save_More_Exit" />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<asp:Button id="SubmitContinue3" runat="server" Text="Save & Continue" alt="Save &amp; Continue" 
        border="0" name="RegisterContinue" OnClick="Save_More_Continue" /></FONT></P></center>
</FORM>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD>
            <DIV align=center><A href="http://www.iimaginestudio.com/" 
            target=_blank><SPAN class=beshert>©2003 BESHERT. All Rights Reserved 
            . Design by <B>i imagine studio.</B></SPAN></A> 
      </DIV></TD></TR></TBODY></TABLE>
      <P> </P></TD>
    <TD width="3%" height=819></TD></TR></TBODY></TABLE></BODY></HTML>
