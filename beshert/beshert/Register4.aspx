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
        Session["requestor"] = "Register4.aspx"; 
        Response.Redirect("Login.aspx");       
      }
      all_DataBind();
    }
  }

  /* Save feature*/
  void saveFeature(bool bAny,ListControl control,String tableName,SqlConnection sqlConn,String userId,String fieldName){
    SqlCommand deleteFeatures = new SqlCommand("DELETE FROM "+tableName+" WHERE USERID='" + userId + "'",sqlConn);
    deleteFeatures.ExecuteNonQuery();
    if ( !bAny ) {
      StringBuilder sqlCommand = new StringBuilder();
      sqlCommand.Append("INSERT INTO ").Append(tableName).Append(" (USERID,").Append(fieldName).Append(") VALUES ('");
      sqlCommand.Append(userId).Append("',@sFeature)");
      SqlCommand insertFeatures = new SqlCommand(sqlCommand.ToString(),sqlConn);
      SqlParameter param = new SqlParameter("@sFeature",SqlDbType.Char,3);
      insertFeatures.Parameters.Add(param);
      for ( int k = 0; k< control.Items.Count; k++ ) {
        if ( control.Items[k].Selected ) {
          param.Value = control.Items[k].Value;
          insertFeatures.ExecuteNonQuery();
        }
      }
    }
  }

  /* Bind data to controls */
  void all_DataBind() {
    SqlConnection connection = new SqlConnection(connectionString);
    connection.Open();
    fillListControl("COUNTRY",cmbTrgResidenceCountry,connection,"WHERE FOR_TARGET=1",false);
    fillListControl("MARITAL",cblTrgMarital,connection,"",false);
    fillListControl("BODY_TYPE",cblTrgBodyType,connection,"",false);
    fillListControl("RELIGION",cblTrgReligion,connection,"",false);
    fillListControl("DRINK",cblTrgDrink,connection,"",true);
    fillListControl("SMOKE",cblTrgSmoke,connection,"",false);
    fillListControl("TARGET_CHILDREN",cmbTrgChildren,connection,"",true);
    fillListControl("STATE",ddlTrgState,connection,"",false);
    fillListControl("KOSHER",cmbTrgKosher,connection,"",false);
    fillListControl("DEGREE",cmbTrgDegree,connection,"",false);
    fillListControl("INCOME",cmbTrgIncome,connection,"",true);
    cmbTrgDegree.Items.Insert(0,new ListItem("Doesn't matter",""));
    cblTrgMarital.Items.Insert(0,new ListItem("Doesn't matter",""));
    cmbTrgResidenceCountry.Items.Insert(0,new ListItem("Doesn't matter",""));
    cmbTrgResidenceCountry.SelectedIndex = 14;
    ddlTrgState.Items.Insert(0,new ListItem("Doesn't matter",""));
    cblTrgReligion.Items.Insert(0,new ListItem("Doesn't matter",""));
    cmbTrgIncome.Items.Insert(0,new ListItem("Doesn't matter",""));
    cmbTrgIncome.Items.RemoveAt(7);
    ddlTrgState.SelectedIndex = 12;
    connection.Close();
    for (int i=18; i<=70; i++) {
      cmbTrgFromYear.Items.Add(new ListItem(i.ToString(),i.ToString()));
      cmbTrgToYear.Items.Add(new ListItem(i.ToString(),i.ToString()));
    }
    cmbTrgFromYear.SelectedIndex = 0;
    cmbTrgToYear.SelectedIndex = 52;
    int j = 0;
    for (j=3; j<=8; j++) {
      cmbFromFeetHight.Items.Add(new ListItem(j.ToString(),j.ToString()));
      cmbToFeetHight.Items.Add(new ListItem(j.ToString(),j.ToString()));
    }
    for (j=0; j<=11; j++) {
      cmbFromInchesHight.Items.Add(new ListItem(j.ToString(),j.ToString()));
      cmbToInchesHight.Items.Add(new ListItem(j.ToString(),j.ToString()));
    }
  }

  /* sealed */
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

  /* Save data and exit */
  void Save_Target(Object sender, EventArgs e) {
    if ( Page.IsPostBack && Page.IsValid ) {
      Save_Data(sender,e);
      Response.Redirect("Done.aspx");
    } 
  }

  /* Format number for SQL */
	public String formatIntSql(String number) {
    try {
      number = number.Trim();
			if ( number == null || number.Length<1 ) {
				return "NULL";
			} else  {
				int ahha = Int32.Parse(number);
				return ahha.ToString();
			}
		} catch (System.FormatException sfe) {
			return "0";
		}
	}

  /* Returns height in inches */
	public String getHeight(String feet,String inches) {
      feet = feet.Trim();
      inches = inches.Trim();
      try {
        if ( feet.Length >0 || inches.Length >0 ) {
          int heightInInches = (feet.Length >0 ? Int32.Parse(feet) : 0)*12 + (inches.Length >0 ? Int32.Parse(inches) : 0);
          return heightInInches.ToString();
        } else {
          return "NULL";
        }
		  } catch (System.FormatException sfe) {
			  return "NULL";
		  }
	}

  /* Save form data in database */
  void Save_Data(Object sender, EventArgs e) {
    String userId = (String)Session["user"];
    bool bAnyStatus = cblTrgMarital.Items[0].Selected;
    bool bAnyCountry = cmbTrgResidenceCountry.Items[0].Selected;
    bool bAnyReligion = cblTrgReligion.Items[0].Selected;
    bool bAnyKosher = cmbTrgKosher.Items[4].Selected;
    bool bAnyDegree = cmbTrgDegree.Items[0].Selected;
    bool bAnyIncome = cmbTrgIncome.Items[0].Selected;
    SqlConnection sqlConn = new SqlConnection(connectionString);
    sqlConn.Open();
    SqlCommand cleanTarget = new SqlCommand("DELETE FROM TARGET WHERE USER_ID='" + userId + "'",sqlConn);      
    cleanTarget.ExecuteNonQuery();
    StringBuilder sqlCommand = new StringBuilder();
    sqlCommand.Append("INSERT INTO TARGET (USER_ID,AGE_FROM,AGE_TO,US_STATE,CITY,CHILDREN,HEIGHT_FROM,HEIGHT_TO,");
    sqlCommand.Append("STATEMENT,ANY_COUNTRY,ANY_STATUS,ANY_RELIGION,ANY_KOSHER,ANY_DEGREE,ANY_INCOME) VALUES (");
    sqlCommand.Append(formatStrSql(userId)).Append(",");
    sqlCommand.Append(formatIntSql(cmbTrgFromYear.SelectedItem.Value)).Append(",");
    sqlCommand.Append(formatIntSql(cmbTrgToYear.SelectedItem.Value)).Append(",");
    sqlCommand.Append(formatStrSql(ddlTrgState.SelectedItem.Value)).Append(",");
    sqlCommand.Append(formatStrSql(txtCity.Text)).Append(",");
    sqlCommand.Append(formatStrSql(cmbTrgChildren.SelectedItem.Value)).Append(",");
    sqlCommand.Append(getHeight(cmbFromFeetHight.SelectedItem.Value,cmbFromInchesHight.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(getHeight(cmbToFeetHight.SelectedItem.Value,cmbToInchesHight.SelectedItem.Value)).Append(",");
    sqlCommand.Append(formatStrSql(Request.Form.Get("briefTxt"))).Append(",");    
    sqlCommand.Append(bAnyCountry ?"1":"0").Append(",");    
    sqlCommand.Append(bAnyStatus ?"1":"0").Append(",");    
    sqlCommand.Append(bAnyReligion ?"1":"0").Append(",");    
    sqlCommand.Append(bAnyKosher ?"1":"0").Append(",");    
    sqlCommand.Append(bAnyDegree ?"1":"0").Append(",");    
    sqlCommand.Append(bAnyIncome ?"1":"0").Append(")");
    SqlCommand insertTarget = new SqlCommand(sqlCommand.ToString(),sqlConn);
    insertTarget.ExecuteNonQuery();
    saveFeature(bAnyCountry,cmbTrgResidenceCountry,"TARGET_COUNTRY",sqlConn,userId,"COUNTRY");
    saveFeature(false,cblTrgBodyType,"TARGET_BODY_TYPE",sqlConn,userId,"BODY_TYPE");
    saveFeature(bAnyDegree,cmbTrgDegree,"TARGET_DEGREE",sqlConn,userId,"DEGREE");
    saveFeature(bAnyIncome,cmbTrgIncome,"TARGET_INCOME",sqlConn,userId,"INCOME");
    saveFeature(bAnyKosher,cmbTrgKosher,"TARGET_KOSHER",sqlConn,userId,"KOSHER");
    saveFeature(bAnyReligion,cblTrgReligion,"TARGET_RELIGION",sqlConn,userId,"RELIGION");
    saveFeature(bAnyStatus,cblTrgMarital,"TARGET_STATUS",sqlConn,userId,"MARITAL");
    saveFeature(false,cblTrgDrink,"TARGET_DRINKING",sqlConn,userId,"DRINKING");
    saveFeature(false,cblTrgSmoke,"TARGET_SMOKING",sqlConn,userId,"SMOKING");
/*  TODO - check if logged and redirect
    // TODO ? catch ?? System.Data.SqlClient.SqlException
*/
    sqlConn.Close();
  }

  /* Format string for SQL - if not empty, encloses in '', otherwise return string "NULL" */
  String formatStrSql(String src) {
    if (src==null || src.Length<1) {
      return "NULL";
    }
    String result = src.Replace("'","`").Replace("\"","``");
    return "'" + result + "'";
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
      <P></P>
      <form  runat="server" id="target" name="target" action="Register4.aspx" method="post">
      <P class=subnavig2Copy><SPAN class=subnavig2Copy>The Person you are 
      looking for:</SPAN></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="11%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Age Range from: </FONT></TD>
          <TD width="89%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1><asp:DropDownList runat="server" id="cmbTrgFromYear" name="cmbTrgFromYear" />
             to <asp:DropDownList runat="server" id="cmbTrgToYear" name="cmbTrgToYear"/> </FONT></TD></TR></TBODY></TABLE>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavigCopy>Place of residence: 
      </SPAN><BR>Country/choose all that apply</FONT></P>

      <TABLE height=78 cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="1%" height=37>&nbsp;</TD>
          <TD width="1%" height=37>&nbsp;</TD>
          <TD width="17%" height=37><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><INPUT type=checkbox value=checkbox name=checkbox1082> State 
            (U.S. only) </FONT></TD>
          <TD width="37%" height=37><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>City/Town <asp:TextBox runat="server" maxLength="20" Columns="20" id="txtCity" name="txtCity" /> </FONT></TD>
          <TD width="45%" height=37><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1><asp:DropDownList runat="server" id="ddlTrgState"/> 
      </FONT></TD></TR></TBODY></TABLE>
          <asp:CheckBoxList runat="server" id="cmbTrgResidenceCountry" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="2" RepeatDirection="Vertical" Width="100%"/>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavigCopy>Marital Status</SPAN> /choose all that 
      apply<BR>          
      <asp:CheckBoxList runat="server" id="cblTrgMarital"  CssClass="textSK"
          RepeatLayout="table" RepeatColumns="5" RepeatDirection="Vertical" Width="100%"/></FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavigCopy>Children from Previous 
      Marriage</SPAN>/choose one)<BR><asp:DropDownList runat="server" id="cmbTrgChildren"/>
      </FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavigCopy>Religion</SPAN>/check all that 
      apply</FONT></P>
          <asp:CheckBoxList runat="server" id="cblTrgReligion" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="2" RepeatDirection="Vertical" Width="100%"/>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavigCopy>Keeping kosher</SPAN>/check all that 
      apply<BR>
      <asp:CheckBoxList runat="server" id="cmbTrgKosher" CssClass="textSK"
      RepeatLayout="table" RepeatColumns="4" RepeatDirection="Vertical" Width="100%"/>
      </FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><BR><SPAN class=subnavigCopy>Education</SPAN>/check all that 
      apply<BR>
<asp:CheckBoxList runat="server" id="cmbTrgDegree" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="4" RepeatDirection="Vertical" Width="100%"/>      
      </FONT></P>
      <P><SPAN class=subnavigCopy>Income</SPAN> 
      <asp:CheckBoxList runat="server" id="cmbTrgIncome" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="5" RepeatDirection="Vertical" Width="100%"/> </P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><B class=subnavigCopy>Physical Characteristics</B></FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subgraybold>Height from</SPAN><SPAN class=subnavigCopy> 
      </SPAN><asp:DropDownList runat="server" id="cmbFromFeetHight" name="cmbFromFeetHight"/>
          feet  
          <asp:DropDownList runat="server" id="cmbFromInchesHight" name="cmbFromFeetHight"/>inches&nbsp;&nbsp;&nbsp;&nbsp;  
          to <asp:DropDownList runat="server" id="cmbToFeetHight" name="cmbToFeetHight"/>
          feet  
          <asp:DropDownList runat="server" id="cmbToInchesHight" name="cmbToInchesHight"/>          
          inches  
      </FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1>Body type/choose all that apply</FONT></P>
      <asp:CheckBoxList runat="server" id="cblTrgBodyType" CssClass="textSK"
      RepeatLayout="table" RepeatColumns="2" RepeatDirection="Vertical" Width="100%"/>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="12%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Drinking Habits</FONT></TD>
          <TD width="61%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>          
            <asp:CheckBoxList runat="server" id="cblTrgDrink" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="5" RepeatDirection="Vertical" Width="100%"/>
            </FONT></TD>
          <TD width="27%">&nbsp;</TD></TR>
        <TR>
          <TD width="12%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Smoking Habits</FONT></TD>
          <TD width="61%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>
          <asp:CheckBoxList runat="server" id="cblTrgSmoke" CssClass="textSK"
          RepeatLayout="table" RepeatColumns="5" RepeatDirection="Vertical" Width="100%"/>              
              </FONT></TD>
          <TD width="27%">&nbsp;</TD></TR></TBODY></TABLE>
      <P></P>
      <P>&nbsp;</P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1>Please write a brief statement (up to 1000 characters) about the 
      person you would like to meet:</FONT></P>
      <P class=subnavigCopy><FONT face="Verdana, Arial, Helvetica, sans-serif" 
      color=#666666 size=1><textarea cols="100" rows="10" name="briefTxt" id="briefTxt" value="" onKeyUp='countCharacters()'>
          </textarea> 
      <BR><BR><BR></FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><input type="text" name="charCountOut" id="charCountOut"  disabled size=99> </FONT><FONT color=#666666 
      size=1>word counter''</FONT></P>
      <P></P>
      <P class=beshertCopy><FONT color=#666666 size=1>
      <asp:Button id="SubmitTarget" runat="server" Text="Finish Registration" alt="Finish Registration" 
        border="0" name="RegisterContinue" OnClick="Save_Target"/>      
      </FONT></P>
      <P></P></FORM>
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
