<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server" language="c#">
  /*System.String connectionString = "server=209.133.228.101;uid=beshert;pwd=bkm71;database=beshert"; */
    System.String connectionString = "server=localhost;uid=beshert;pwd=bkm71;database=beshert";

  /* Called on page load */
  protected void Page_Load(Object sender, EventArgs e) {
    if ( ! IsPostBack ) {
      if ( Session["user"] == null ){
        Session["requestor"] = "Register2.aspx"; 
        Response.Redirect("Login.aspx");       
      }
      all_DataBind();
      Session.Timeout = 60;
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

  /* Returns date since which is single */
		public String getSingleSince(String years,String months) {
			years = years.Trim();
			months = months.Trim(); 
			try {
				if ( years.Length >0 || years.Length >0 ){
					int iYears = years.Length >0 ? Int32.Parse(years) : 0;
					int iMonths = months.Length >0 ? Int32.Parse(months) : 0;
					TimeSpan span = new TimeSpan(0,iYears*8766+iMonths*730,0,0);
					DateTime sinceDate = DateTime.Today - span;
					return ""+sinceDate.Year+"-"+sinceDate.Month+"-"+sinceDate.Day;
				} else {
					return "";
				} 
      } catch (System.FormatException sfe)  {
		    return "";
	    }
	}

  /* Format string for SQL - if not empty, encloses in '', otherwise return string "NULL" */
  String formatStrSql(String src) {
    if (src==null || src.Length<1) {
      return "NULL";
    }
    String result = src.Replace("'","`").Replace("\"","``");
    return "'" + result + "'";
  }

  /* Bind data to controls */
  void all_DataBind() {
    SqlConnection connection = new SqlConnection(connectionString);
    connection.Open();
    fillListControl("ASTROLOGICAL",cmbAstrological,connection,"",false);
    fillListControl("ETHNICITY",cmbEthnicity,connection,"",false);
    fillListControl("RELIGION",cmbReligion,connection,"",false);
    fillListControl("SYNAGOGUE",cmbSynagogue,connection,"",false);
    fillListControl("KOSHER",cmbKosher,connection,"",false);
    fillListControl("BODY_TYPE",cmbBodyType,connection,"",false);
    fillListControl("HAIR_COLOR",cmbHairColor,connection,"",false);
    fillListControl("EYE_COLOR",cmbEyeColor,connection,"",false);
    fillListControl("MARITAL",cmbMarital,connection,"",true);
    fillListControl("COUNTRY",cmbBirthCountry,connection,"",false);
    fillListControl("COUNTRY",cmbGrewupCountry,connection,"",false);
    fillListControl("CHILDREN",cmbChildren,connection,"",false);
    fillListControl("DRINK",cmbDrink,connection,"",true);
    fillListControl("SMOKE",cmbSmoke,connection,"",false);
    fillListControl("HEALTH",cmbHealth,connection,"",true);
    fillListControl("INCOME",cmbIncome,connection,"",true);
    fillListControl("DEGREE",cmbDegree,connection,"",true);
    fillListControl("POLITICAL",cmbPolitical,connection,"",true);
    fillListControl("CHECKBOX_LIST",cblLanguages,connection,"WHERE SECTION = 'LANGUAGE'",true);
    fillListControl("CHECKBOX_LIST",cblOccupation,connection,"WHERE SECTION = 'OCCUPATION'",true);
    fillListControl("CHILDREN_WILL",rblChildren,connection,"",true);
    fillListControl("OBJECTIVE",cblObjective,connection,"",false);
    connection.Close();
    cmbAstrological.Items.Insert(0,new ListItem("Choose one",""));
    cmbIncome.Items.Insert(0,new ListItem("Choose one",""));
    cmbPolitical.Items.Insert(0,new ListItem("Choose one",""));
    cmbMarital.Items.Insert(0,new ListItem("Choose one",""));
    cmbChildren.SelectedIndex = 2;
    cmbBirthCountry.SelectedIndex = 227;
    cmbGrewupCountry.SelectedIndex = 227;
    rblChildren.SelectedIndex = 0;
    int j = 0;
    for (j=4; j<=8; j++) {
      cmbFeetHight.Items.Add(new ListItem(j.ToString(),j.ToString()));
    }
    for (j=0; j<12; j++) {
      cmbInchesHight.Items.Add(new ListItem(j.ToString(),j.ToString()));
    }
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

  /* Save form data in database */
  void Save_Data(Object sender, EventArgs e) {
    String userId = (String)Session["user"];
    String sOccupation="";
    for ( int i = 0; i< cblOccupation.Items.Count; i++ ) {
      if ( cblOccupation.Items[i].Selected ) {
        sOccupation = cblOccupation.Items[i].Value;
      }
    }
    String sChildWish="";
    for ( int j = 0; j< rblChildren.Items.Count; j++ ) {
      if ( rblChildren.Items[j].Selected ) {
        sChildWish = rblChildren.Items[j].Value;
      }
    }
    String sRelocate ="";
    if ( rbRelocateYes.Checked ) {
      sRelocate = "YES";
    } else if ( rbRelocateNo.Checked ) {
      sRelocate = "NO";
    } else {
      sRelocate = "CON";
    }
    StringBuilder sqlCommand = new StringBuilder();
    sqlCommand.Append("INSERT INTO PERSON_EXTRA ");
    sqlCommand.Append("(ID,CASUAL,LONGTERM,MARRIAGE,FRIENDSHIP,RELOCATE,CHILDREN_WILL,ASTROLOGICAL,BIRTH_COUNTRY,GREWUP_COUNTRY,");
    sqlCommand.Append("MARITAL_STATUS,SINGLE_SINCE,CHILDREN,NUM_CHILDREN,CHILD_AGES,ETHNICITY,RELIGION,SYNAGOGUE,KOSHER,");
    sqlCommand.Append("HEIGHT_INCHES,WEIGHT,BODY_TYPE,HAIR,EYE,DRINK,SMOKE,HEALTH,OCCUPATION,JOB_DESCRIPTION,INCOME,DEGREE,STUDIES,SCHOOL,POLITICAL) ");
    sqlCommand.Append("VALUES ('");
    sqlCommand.Append(userId);
    sqlCommand.Append("',");
    sqlCommand.Append(cblObjective.Items[0].Selected ?"1":"0");
    sqlCommand.Append(",");
    sqlCommand.Append(cblObjective.Items[2].Selected ?"1":"0");
    sqlCommand.Append(",");
    sqlCommand.Append(cblObjective.Items[3].Selected  ?"1":"0");
    sqlCommand.Append(",");
    sqlCommand.Append(cblObjective.Items[1].Selected  ?"1":"0");
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(sRelocate));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(sChildWish));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbAstrological.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbBirthCountry.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbGrewupCountry.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbMarital.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(getSingleSince(years_separated.Text,months_separated.Text)));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbChildren.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatIntSql(number_of_children.Text));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(children_age.Text));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbEthnicity.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbReligion.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbSynagogue.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbKosher.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(getHeight(cmbFeetHight.SelectedItem.Value,cmbInchesHight.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatIntSql(weight.Text));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbBodyType.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbHairColor.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbEyeColor.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbDrink.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbSmoke.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbHealth.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(sOccupation));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(job_description.Text));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbIncome.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbDegree.SelectedItem.Value));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(emphasis.Text));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(school.Text));
    sqlCommand.Append(",");
    sqlCommand.Append(formatStrSql(cmbPolitical.SelectedItem.Value));
    sqlCommand.Append(")");
    SqlConnection sqlConn = new SqlConnection(connectionString);
    sqlConn.Open();
    SqlCommand cleanPersonExtra = new SqlCommand("DELETE FROM PERSON_EXTRA WHERE ID ='" + userId + "'",sqlConn);      
    cleanPersonExtra.ExecuteNonQuery();
    SqlCommand insertPersonExtra = new SqlCommand(sqlCommand.ToString(),sqlConn);
    insertPersonExtra.ExecuteNonQuery();
    SqlCommand deleteFeatures = new SqlCommand("DELETE FROM PERSON_FEATURE WHERE ID='" + userId + "'",sqlConn);
    deleteFeatures.ExecuteNonQuery();
    String sFeature="";
    SqlCommand insertFeatures = new SqlCommand("INSERT INTO PERSON_FEATURE(ID,FEATURE) VALUES('"+userId+"',@sFeature)",sqlConn);
    SqlParameter param = new SqlParameter("@sFeature",SqlDbType.Char,4);
    insertFeatures.Parameters.Add(param);
    for ( int k = 0; k< cblLanguages.Items.Count; k++ ) {
      if ( cblLanguages.Items[k].Selected ) {
        param.Value = cblLanguages.Items[k].Value;
        insertFeatures.ExecuteNonQuery();
      }
    }
    sqlConn.Close();
  }

  /* Save data and continue */
  void Save_Extra_Continue(Object sender, EventArgs e) {
    if ( Page.IsPostBack && Page.IsValid ) {
      Save_Data(sender,e);
      Response.Redirect("Register3.aspx");
    }
  }
  
  /* Save data and exit */
  void Save_Extra_Exit(Object sender, EventArgs e) {
    if ( Page.IsPostBack && Page.IsValid ) {
      Save_Data(sender,e);
      Response.Redirect("Done.aspx");
    } 
  }

  /* Check that at least one objective is selected */
  void ObjectiveSelected_Server(Object sender,ServerValidateEventArgs args){
    int totalSelected = 0;
    for ( int k = 0; k< cblObjective.Items.Count; k++ ) {
      if ( cblObjective.Items[k].Selected ) {
        totalSelected++;
      }
    }
    if ( totalSelected > 0 ) {
      args.IsValid = true;
    } else {
      args.IsValid = false;
    }
  }
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<script language="JavaScript">
<!--

  /* Check that at least one objective is selected */
  function ObjectiveSelected_Client(source, value) {
    var totalSelected = 0;    
    var selected = false;
    for (var i = 0; i < 4; i++) {
      eval("selected = document.forms('person_extra').cblObjective_"+i+".checked;");
      if (selected) { totalSelected++; };
      selected = false;
    }
    if( totalSelected < 1 ) {
      value.IsValid = false;
    } else {
      value.IsValid = true;
    }
  }
// -->
	</script>
<HEAD><TITLE>BESHERT</TITLE>
<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">
<meta name="Author" content="Slava Kovalenko, Slava_K, BKM71">
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
<META content="MSHTML 6.00.2726.2500" name=GENERATOR></HEAD>
<BODY text=#000000 bgColor=#ffffff leftMargin=0 
background=images/background.jpe topMargin=0 
onload="MM_preloadImages('images/navigation/search1-on.jpg','images/navigation/speed2-on.jpg','images/navigation/personal3-on.jpg','images/navigation/travel4-on.jpg')" 
marginheight="0" marginwidth="0">
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD width="11%" height=83><A 
      href="index.htm"><IMG height=95 
      src="images/logo_top.jpe" width=111 border=0></A></TD>
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
      href="index.htm"><IMG height=33 
      src="images/logo_buttom.jpe" width=111 border=0></A></TD>
    <TD width="19%" height=23><A 
      onmouseover="MM_swapImage('nav1','','images/navigation/search1-on.jpg',1)" 
      onmouseout=MM_swapImgRestore() 
      href="Register.aspx"><IMG 
      height=33 src="images/search1-on.jpe" width=189 border=0 
      name=nav1></A></TD>
    <TD width="16%" height=23><A 
      onmouseover="MM_swapImage('nav2','','images/navigation/speed2-on.jpg',1)" 
      onmouseout=MM_swapImgRestore() 
      href="speed.htm"><IMG 
      class=newspaper height=33 src="images/speed2-off.jpe" width=166 
      border=0 name=nav2></A></TD>
    <TD width="19%" height=23><A 
      onmouseover="MM_swapImage('nav3','','images/navigation/personal3-on.jpg',1)" 
      onmouseout=MM_swapImgRestore() 
      href="personal.htm"><IMG height=33 
      src="images/personal3-off.jpe" width=198 border=0 
name=nav3></A></TD>
    <TD width="11%" background=images/image-backg-small1.jpe 
      height=23><A 
      onmouseover="MM_swapImage('nav4','','images/navigation/travel4-on.jpg',1)" 
      onmouseout=MM_swapImgRestore() 
      href="events.htm"><IMG height=33 
      src="images/travel4-off.jpe" width=132 border=0 name=nav4></A></TD>
    <TD width="24%" background=images/image-backg-small1.jpe 
    height=23>&nbsp;</TD></TR></TBODY></TABLE><A class=beshert 
href="index.htm">: home</A><SPAN 
class=beshert> : </SPAN><FONT class=beshert color=#333333><A class=beshert 
href="contact.htm">contact 
info</A></FONT><SPAN class=beshert> :<FONT color=#666666> </FONT></SPAN><FONT 
color=#666666><FONT color=#999999><A class=beshert 
href="privacyinfo.htm">privacy 
info</A></FONT></FONT><SPAN class=beshert> :</SPAN><FONT class=beshert 
color=#666666> <A class=beshert 
href="terms2.htm">terms &amp; conditions 
</A></FONT><SPAN class=beshert>:</SPAN><FONT color=#666666><SPAN class=beshert> 
</SPAN><A class=beshert 
href="mediacoverage.htm">media 
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
      <P><FONT class=beshertCopy face="Verdana, Arial, Helvetica, sans-serif" 
      color=#666666 size=1><SPAN class=subnavigCopy>Login Information 
      </SPAN></FONT></P>
      <form runat="server" id="person_extra" name="person_extra" action="Register2.aspx" method="post">
      <P><FONT class=subnavigCopy color=#666666 size=2>Objectives</FONT><FONT 
      face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1>/ Choose 
      all that apply</FONT></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR><TD>
      <FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1>
      <asp:CheckBoxList runat="server" id="cblObjective" CellPadding="1" CellSpacing="4" CssClass="textSK"
      RepeatLayout="Table" RepeatDirection="Horizontal" Width="70%" />
      </FONT></TD></TR><TR><TD>
			    <asp:CustomValidator runat="server" ControlToValidate="cmbMarital" class=validatorSK
          OnServerValidate="ObjectiveSelected_Server"
          ClientValidationFunction="ObjectiveSelected_Client"
          Display="Dynamic" ErrorMessage="* Please select at least one objective." />
</TD></TR></TABLE>

      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>

        <TR>
          <TD width="24%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Willing to relocate?</FONT></TD>
					<TD width="8%"><asp:RadioButton runat="server" ID="rbRelocateYes" GroupName = "relocate"/><FONT class="textSK"> Yes</FONT></TD>
					&nbsp;&nbsp;&nbsp;
					<TD width="9%"><asp:RadioButton runat="server" Checked="true" ID="rbRelocateNo" GroupName = "relocate"/>
          <FONT class="textSK"> No</FONT></TD>
					&nbsp;&nbsp;&nbsp;
					<TD width="17%"><asp:RadioButton runat="server" ID="rbRelocateConsider" GroupName = "relocate"/>
          <FONT class="textSK"> Would consider </FONT></TD>
          <TD width="14%">&nbsp;</TD>
          <TD width="11%">&nbsp;</TD>
          <TD width="9%">&nbsp;</TD>
          <TD width="8%">&nbsp;</TD></TR>
        <TR>
          <TD width="24%" height=2><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Would you like to have children if married?</FONT></TD>
<TD height=2 colspan=3>
<FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1>
          <asp:RadioButtonList runat="server" id="rblChildren" CellPadding="4" CellSpacing="0"
          CssClass="subgraybold"
          RepeatLayout="table" RepeatColumns="3" RepeatDirection="Vertical" Width="100%"/></FONT>
          <TD width="14%" height=2>&nbsp;</TD>
          <TD width="11%" height=2>&nbsp;</TD>
          <TD width="9%" height=2>&nbsp;</TD>
          <TD width="8%" height=2>&nbsp;</TD></TR>
</TBODY></TABLE>
      <P>&nbsp;</P>
      <P></P>
      <P class=TITLES2><SPAN class=subnavig2Copy><FONT class=subnavig2Copy 
      face="Verdana, Arial, Helvetica, sans-serif" color=#ff9933 size=5>Your 
      Personal Characteristics</FONT></SPAN></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="14%" height=34><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Astrological Sign</FONT> </TD>
          <TD width="60%" height=34><FONT color=#666666>
          <asp:DropDownList runat="server" id="cmbAstrological"/> </FONT></TD>
          <TD width="26%" height=34>&nbsp;</TD></TR>
        <TR>
          <TD width="14%" height=32><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Country of birth</FONT></TD>
          <TD width="60%" height=32><FONT color=#666666>
          <asp:DropDownList runat="server" id="cmbBirthCountry"/> </FONT></TD>
          <TD width="26%" height=32>&nbsp;</TD></TR>
        <TR>
          <TD width="14%" height=32><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Country where you grew up </FONT></TD>
          <TD width="60%" height=32><FONT color=#666666>
          <asp:DropDownList runat="server" id="cmbGrewupCountry"/> 
            </FONT></TD>
          <TD width="26%" height=32>&nbsp;</TD></TR></TBODY></TABLE>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavigCopy>Languages you speak</SPAN>/check all that 
      apply</FONT></P>
          <asp:CheckBoxList runat="server" id="cblLanguages" CssClass="subgraybold"
          RepeatLayout="table" RepeatColumns="3" RepeatDirection="Vertical" Width="70%"/>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><BR></FONT></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="12%"><FONT class=subnavigCopy 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Marital status</FONT></TD>
          <TD width="20%"><FONT color=#666666>
          <asp:DropDownList runat="server" id="cmbMarital"/>
          </FONT></TD>
          <TD align=right width="30%"><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1>If 
            divorced, widowed or separated, for how long?&nbsp;</FONT></TD>
          <TD colspan=2><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1>
          <asp:TextBox runat="server" maxLength="2" Columns="2" id="years_separated" name="years_separated" />&nbsp;year(s)&nbsp;
          <asp:TextBox runat="server" maxLength="2" Columns="2" id="months_separated" name="months_separated" />&nbsp;months
          </FONT></TD></TR>
      <TR><TD colspan=2><asp:RequiredFieldValidator runat="server" ControlToValidate="cmbMarital"  class=validatorSK
          InitialValue="" Display="Dynamic" ErrorMessage="* Please select marital status." /></TD>
        <TD colspan=3>
          <asp:CompareValidator runat="server" id="check_single" Type="Integer" Operator="DataTypeCheck"  class=validatorSK
            ControlToValidate="years_separated" Display="Dynamic" ErrorMessage="* Years should be numeric value." />
          <asp:CompareValidator runat="server" id="check_single2" Type="Integer" Operator="DataTypeCheck" class=validatorSK 
            ControlToValidate="months_separated" Display="Dynamic" ErrorMessage="* Months should be numeric value." />          
        </TD></TR>
        <TR>
          <TD width="12%" height=34><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>How many children?</FONT></TD>
          <TD width="22%" height=34><FONT color=#666666>          
          <asp:TextBox runat="server" maxLength="2" Columns="2" Text="0" id="number_of_children" name="number_of_children" />
           </FONT></TD>
          <TD align=right colspan=2 width="40%" height=34><asp:CompareValidator runat="server"  class=validatorSK
          id="check_num_of_chld" Type="Integer" Operator="DataTypeCheck" 
            ControlToValidate="number_of_children" Display="Dynamic" ErrorMessage="* This should be numeric value." /></TD>
          <TD width="26%" height=34>&nbsp;</TD><TD width="26%" height=27>&nbsp;</TD></TR>
        <TR>
          <TD width="12%" height=27><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Children</FONT></TD>
          <TD width="22%" height=27><FONT color=#666666>
          <asp:DropDownList runat="server" id="cmbChildren"/> </FONT></TD>
          <TD align=right width="30%" height=27><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Children's Age</FONT></TD>
          <TD width="16%" height=27><FONT color=#666666>
          <asp:TextBox runat="server" maxLength="15" id="children_age" name="children_age" /> </FONT></TD>
          <TD width="26%" height=27>&nbsp;</TD></TR>
        <TR>
          <TD width="12%" height=27>&nbsp;</TD>
          <TD align=right width="22%" height=27><FONT color=#666666></FONT></TD>
          <TD width="24%" height=27>&nbsp;</TD>
          <TD width="16%" height=27>&nbsp;</TD>
          <TD width="26%" height=27>&nbsp;</TD></TR></TBODY></TABLE>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><BR></FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><B class=subnavigCopy>Religious background</B>/Choose 
one</FONT></P>

      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD align=left height=17 width="16%"><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Ethnicity </FONT></TD>
          <TD align=left height=17><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:DropDownList runat="server" id="cmbEthnicity"/></FONT></TD>
          <TD align=left height=17>&nbsp;</TD>
          <TD align=left height=17>&nbsp;</TD></TR>
        <TR>
          <TD align=left height=17 width="16%"><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Religion </FONT></TD>
          <TD align=left height=17><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:DropDownList runat="server" id="cmbReligion"/></TD>
          <TD align=left height=17>&nbsp;</TD>
          <TD align=left height=17>&nbsp;</TD></TR>
        <TR>
          <TD align=left height=17 width="16%"><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Attending Synagogue</FONT></TD>
          <TD align=left height=17><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:DropDownList runat="server" id="cmbSynagogue"/></FONT></TD>
          <TD align=left height=17>&nbsp;</TD>
          <TD align=left height=17>&nbsp;</TD></TR>
        <TR>
          <TD align=left height=17 width="16%"><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Keeping kosher</FONT></TD>
          <TD align=left height=17><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:DropDownList runat="server" id="cmbKosher"/></FONT></TD>
          <TD align=left height=17>&nbsp;</TD>
          <TD align=left height=17>&nbsp;</TD></TR></TBODY></TABLE>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><BR></FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><B class=subnavigCopy>Physical Characteristics</B></FONT></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="11%"><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Height </FONT></TD>
          <TD width="11%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>
            <asp:DropDownList runat="server" id="cmbFeetHight" name="cmbFeetHight"/>feet
<asp:DropDownList runat="server" id="cmbInchesHight" name="cmbInchesHight"/>          
          inches&nbsp;&nbsp;&nbsp;&nbsp;

            </FONT></TD>
          <TD width="7%"><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Hair Color </FONT></TD>
          <TD width="26%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>
            <asp:DropDownList runat="server" id="cmbHairColor"/> </FONT></TD></TR>
        <TR>
          <TD width="11%" height=29><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><SPAN class=subgraybold>Weight </SPAN>(optional)</FONT></TD>
          <TD width="22%" height=29><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:TextBox runat="server" maxLength="3" Columns="4" id="weight" name="weight" /> pounds</FONT></TD>
          <TD width="7%" height=29><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Eye Color</FONT></TD>
          <TD width="26%" height=29><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:DropDownList runat="server" id="cmbEyeColor"/> </FONT></TD></TR>
<TR>
          <asp:CompareValidator runat="server" id="check_weight" Type="Integer" Operator="DataTypeCheck"  class=validatorSK
            ControlToValidate="weight" Display="Dynamic" ErrorMessage="* This should be numeric value." />
</TR>

        <TR>
          <TD width="11%" height=27><FONT class=subgraybold 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Body type </FONT></TD>
          <TD width="22%" height=27><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:DropDownList runat="server" id="cmbBodyType"/> </FONT></TD>
          <TD width="7%" height=27>&nbsp;</TD>
          <TD width="26%" height=27>&nbsp; </TD></TR></TBODY></TABLE>
      <P>&nbsp;</P>
      <P><FONT class=subnavigCopy face="Verdana, Arial, Helvetica, sans-serif" 
      color=#666666 size=1>Health</FONT></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="20%" height=26><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1>Do 
            you drink?</FONT></TD>
          <TD width="12%" height=26><FONT color=#666666>
          <asp:DropDownList runat="server" id="cmbDrink"/>
            </FONT></TD>
          <TD width="10%" height=26>&nbsp;</TD>
          <TD width="56%" height=26>&nbsp;</TD>
          <TD width=0% height=26>&nbsp;</TD>
          <TD width=0% height=26>&nbsp;</TD>
          <TD width="2%" height=26>&nbsp;</TD></TR>
        <TR>
          <TD width="20%" height=25><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 size=1>Do 
            you smoke?</FONT></TD>
          <TD width="12%" height=25><FONT color=#666666>
          <asp:DropDownList runat="server" id="cmbSmoke"/></FONT>
          <TD width="10%" height=25>&nbsp;</TD>
          <TD width="56%" height=25>&nbsp;</TD>
          <TD width=0% height=25>&nbsp;</TD>
          <TD width=0% height=25>&nbsp;</TD>
          <TD width="2%" height=25>&nbsp;</TD></TR>
        <TR>
          <TD width="20%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>How is your health?</FONT></TD>
          <TD width="12%"><FONT color=#666666>
          <asp:DropDownList runat="server" id="cmbHealth"/></FONT></TD>
          <TD width="10%">&nbsp;</TD>
          <TD width="56%">&nbsp;</TD>
          <TD width=0%>&nbsp;</TD>
          <TD width=0%>&nbsp;</TD>
          <TD width="2%">&nbsp;</TD></TR></TBODY></TABLE>
      <P>&nbsp;</P>
      <P>&nbsp;</P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavigCopy>Occupation</SPAN>/choose 
one<BR></FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><BR>
          <asp:RadioButtonList runat="server" id="cblOccupation"
           CssClass="subgraybold"
          RepeatLayout="table" RepeatColumns="3" RepeatDirection="Vertical" Width="100%"/>      
      <P><FONT class=subnavigCopy face="Verdana, Arial, Helvetica, sans-serif" 
      color=#666666 size=1>Job Description</FONT></P>
      <TABLE height=30 cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD vAlign=center align=left width=100 height=17><FONT 
            class=subgraybold face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Income</FONT></TD>
          <TD vAlign=center align=left width=100 height=17><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:DropDownList runat="server" id="cmbIncome"/></FONT></TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD width="1%" height=32>&nbsp;</TD></TR>
        <TR>
          <TD vAlign=center align=left width=100 height=17><FONT 
            class=subgraybold face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Highest Academic Degree Earned</FONT></TD>
          <TD vAlign=center align=left width=100 height=17><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1><asp:DropDownList runat="server" id="cmbDegree"/></FONT></TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD width="1%" height=33>&nbsp;</TD></TR>
        <TR>
          <TD vAlign=center align=left width=100 height=17><FONT 
            class=subgraybold face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Emphasis of Studies</FONT></TD>
          <TD vAlign=center align=left width=100 height=17><FONT 
            color=#666666><asp:TextBox runat="server" maxLength="30" Columns="40" id="emphasis" name="emphasis" /></FONT></TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD width="1%" height=26>&nbsp;</TD></TR>
        <TR>
          <TD vAlign=center align=left width=100 height=17><FONT 
            class=subgraybold face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1><BR>School from which your highest degree was 
            obtained </FONT></TD>
          <TD vAlign=center align=left width=100 height=17><FONT 
            color=#666666><asp:TextBox runat="server" maxLength="40" Columns="40" id="school" name="school" /></FONT></TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD width="1%" height=26>&nbsp;</TD></TR>
        <TR>
          <TD vAlign=center align=left width=100 height=17><FONT 
            class=subgraybold face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Job Description</FONT></TD>
          <TD vAlign=center align=left width=100 height=17><FONT 
            color=#666666><asp:TextBox runat="server" maxLength="100" Columns="40" id="job_description" name="job_description" /></FONT></TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD vAlign=center align=left width=100 height=17>&nbsp;</TD>
          <TD width="1%" height=26>&nbsp;</TD></TR>          
          </TBODY></TABLE>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavigCopy>Political views</SPAN> 
<asp:DropDownList runat="server" id="cmbPolitical"/>      
      </FONT></P>
      <P></P>
      <P class=beshertCopy><FONT color=#666666 size=1><asp:Button id="SubmitExit" runat="server" Text="Save &amp; Exit" alt="Save & Exit" border="0" 
          name="RegisterExit" OnClick="Save_Extra_Exit" /> 
      </FONT></P>
      <P class=beshertCopy><FONT color=#666666 size=1><asp:Button id="SubmitContinue" runat="server" Text="Save &amp; Continue" alt="Save & Continue" 
          border="0" name="RegisterContinue" OnClick="Save_Extra_Continue" /> 
      <BR></FONT></P>
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
