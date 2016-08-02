<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server" language="c#">
  /*System.String connectionString = "server=209.133.228.101;uid=beshert;pwd=bkm71;database=beshert"; */
    System.String connectionString = "server=localhost;uid=beshert;pwd=bkm71;database=beshert";

  /* Check that user name is unique */
  void EnsureUserNameUnique(Object sender,ServerValidateEventArgs args){
    SqlConnection conn = new SqlConnection(connectionString);
    conn.Open();
    SqlCommand checkUnique = new SqlCommand("SELECT ID FROM PERSON WHERE ID='" + username.Text.Trim()+"'",conn);
    SqlDataReader reader = checkUnique.ExecuteReader();
    if (reader.Read()) {
      args.IsValid = false;
    } else {
      args.IsValid = true;
    }
    reader.Close();
    conn.Close();
  }

  /* Called on page load */
  protected void Page_Load(Object sender, EventArgs e) {
    if ( ! IsPostBack ) {
      Session.Timeout = 60;
      all_DataBind();
    }
  }

  /* Sealed */
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

  /* Bind data to controls */
  void all_DataBind() {
    SqlConnection connection = new SqlConnection(connectionString);
    connection.Open();
    fillListControl("STATE",state,connection,"",false);
    fillListControl("GENDER",ddlGender,connection,"",false);
    fillListControl("COUNTRY",ddlCountry,connection,"",false);
    connection.Close();

    state.SelectedIndex = 11;
    ddlGender.SelectedIndex = 1;
    ddlCountry.SelectedIndex = 227;

    int startYear = DateTime.Today.Year-100;
    for (int i=startYear; i<=startYear+82; i++) {
      cmbYear.Items.Add(new ListItem(i.ToString(),i.ToString()));
    }
  }

  /* Save form data in database */
  void Save_Data(Object sender, EventArgs e) {

      System.String sqlInsert = "INSERT PERSON (ID,EMAIL,PASSWORD,FIRST_NAME,LAST_NAME,STREET," +
      "APT,CITY,STATE,COUNTRY,ZIP,HOME_PHONE,WORK_PHONE,CELL_PHONE,SEX,BIRTHDATE,PUBLISH,REGISTRATION_DATE) VALUES ("
      + formatStrSql(username.Text) + "," + formatStrSql(email.Text) + "," + formatStrSql(password.Text) + "," 
      +formatStrSql(first_name.Text)+ "," + formatStrSql(last_name.Text) + "," + formatStrSql(street.Text)+ "," 
      +formatStrSql(apt.Text)+ "," +formatStrSql(city.Text)+ ",'" +state.SelectedItem.Value + "','" 
      +ddlCountry.SelectedItem.Value + "',"
      +formatStrSql(zip.Text)+ ",'" +HomeAreaCode.Text+HomeLocalExchange.Text+HomePhone.Text + "','" 
      +WorkAreaCode.Text+WorkLocalExchange.Text+WorkPhone.Text+WorkExt.Text+ "','" +MobileAreaCode.Text+MobileLocalExchange.Text
      +MobilePhone.Text + "','" +ddlGender.SelectedItem.Value+ "','" + cmbYear.SelectedItem.Value+"-"+cmbMonth.SelectedItem.Value+"-"
      +cmbDay.SelectedItem.Value+ "','" + (rbPublic.Checked ?"Y":"N")+ "',getdate())";
            Response.Write(sqlInsert);
      SqlConnection sqlConn = new SqlConnection(connectionString);
      sqlConn.Open();
      SqlCommand cleanPerson = new SqlCommand("DELETE FROM PERSON WHERE ID ='" + username.Text + "'",sqlConn);      
      cleanPerson.ExecuteNonQuery();
      SqlCommand insertPerson = new SqlCommand(sqlInsert,sqlConn);
      insertPerson.ExecuteNonQuery();
      sqlConn.Close();
      Session["user"] = username.Text;
  }

  /* Save data and continue */
  void Save_Continue(Object sender, EventArgs e) {
    if ( Page.IsPostBack && Page.IsValid ) {
      Save_Data(sender,e);
      Response.Redirect("Register2.aspx");
    }
  }
  
  /* Save data and exit */
  void Save_Basic(Object sender, EventArgs e) {
    if ( Page.IsPostBack && Page.IsValid ) {
      Save_Data(sender,e);
      Response.Redirect("Done.aspx");
    } 
  }

  /* Check that password is at least 4 characters */
  void CheckPwdLength_Server(Object sender,ServerValidateEventArgs args){
    if ( args.Value.Length < 4 ) {
      args.IsValid = false;
    } else {
      args.IsValid = true;
    }
  }

  /* Ensure that agree checkbox checked */
  void ValidatePrivacy_Server(Object sender,ServerValidateEventArgs args){
    if ( chkAgree.Checked ) {
      args.IsValid = true;
    } else {
      args.IsValid = false;
    }
  }

  /* Check if home number is of good format */
  void CheckPhone_Server(object source, ServerValidateEventArgs args)
  {
    if ((HomeAreaCode.Text.Length != 3) || (HomeLocalExchange.Text.Length != 3) ||
      (HomePhone.Text.Length !=4 )){
      args.IsValid = false;
    } else {
      args.IsValid = true;
    }
  }

  /* Check age of the applicant */
  void CheckAge_Server(Object sender,ServerValidateEventArgs args){
    if (isBirthdayValid()){
      int year = Int32.Parse(cmbYear.SelectedItem.Value);
      int month = Int32.Parse(cmbMonth.SelectedItem.Value);
      int day = Int32.Parse(cmbDay.SelectedItem.Value);
      int years = (DateTime.Now- new DateTime(year,month,day)).Days /365;
        if ( years < 18 ) {
         args.IsValid = false;
        } else {
         args.IsValid = true;
        }
    } else {
     args.IsValid = true; // run CheckBirthdayValid validation in this case
    }
  }

  /* Ensure date is valid, for example 31 february is not */
  void CheckBirthdayValid(Object sender,ServerValidateEventArgs args){
     args.IsValid = isBirthdayValid();
  }

  /* Ensure date is valid, for example 31 february is not */
  bool isBirthdayValid(){
    int year = Int32.Parse(cmbYear.SelectedItem.Value);
    int month = Int32.Parse(cmbMonth.SelectedItem.Value);
    int day = Int32.Parse(cmbDay.SelectedItem.Value);
    bool isDateValid = true;
		try 
		{
			DateTime dt= new DateTime(year,month,day);
		} catch (Exception ex) {
      isDateValid = false;
		}
    return isDateValid;
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
	<script language="JavaScript">
<!--
  /* trim string */
  function trimString(str) {
    while (str.charAt(0) == ' ') str = str.substring(1);
    while (str.charAt(str.length - 1) == ' ') str = str.substring(0, str.length - 1);
    return str;
  }

  /* Check if phone is of good format */
  function CheckPhone_Client(source, args) {
    var area = trimString(document.forms("person_basic").elements("HomeAreaCode").value);
    var exch = trimString(document.forms("person_basic").elements("HomeLocalExchange").value);
    var ph = trimString(document.forms("person_basic").elements("HomePhone").value);
    if ( (area.length !=3) || (exch.length !=3) || (ph.length !=4) ) {
      args.IsValid = false;
    } else {
      args.IsValid = true;
    }
  }

  /* Password must be at least 4 characters */
  function CheckPwdLength_Client(source, value) {
    if( value.Value.length < 4 ) {
      value.IsValid = false;
    } else {
      value.IsValid = true;
    }
  }

  /* Ensure that agree checkbox is checked 
  function PrivacyChecked_Client(source, value) {
    if ( document.forms("person_basic").chkAgree.checked==true ) {
      value.IsValid = true;
    } else {
      value.IsValid = false;
    }
  }    

  /* Ensure that client is at least 18 years old */
  function CheckAge_Client(source, value) {
    var age = parseInt(value.Value);
    if( (new Date()).getFullYear() - age < 18 ) {
      value.IsValid = false;
    } else {
      value.IsValid = true;
    }
  }  

  /* TODO  Unused */
  function validatePagePhones()
  {
    var sMissing = 'The following information is required\:\n \n'
    var aHomePhoneFields = new Array(['HomeAreaCode','HomeLocalExchange','HomePhone'],
	                              ['Home Area Code','Home Local Exchange','Home Phone']);
	  var aOtherPhoneFields = new Array(['WorkAreaCode','WorkLocalExchange','WorkPhone','MobileAreaCode','MobileLocalExchange','MobilePhone'],
	                                    ['Work Area Code','Work Local Exchange','Work Phone','Mobile Area Code','Mobile Local Exchange','Mobile Phone']);
    var oFormObj;
    var sFormObjVal;
    var isValid = true;
 	  for (var i = 0; i < aHomePhoneFields[0].length; i++)
 	  {
 	    oFormObj = document.person_basic.elements[aHomePhoneFields[0][i]];
 	    sFormObjVal = trimString(oFormObj.value);
  	  
  	  // valdiate Home Phone fields
  	  if (sFormObjVal.length <= 0) {
  			 sMissing=sMissing + '-Please enter information for ' + aHomePhoneFields[1][i] + '\n';
         isValid = false;
      } else {
  			 // make sure values in phone fields are numeric
  			 if ((sFormObjVal.length > 0) && (isNaN(sFormObjVal))) {
  	  	   sMissing=sMissing + '-' + aHomePhoneFields[1][i] + ' must be numeric\n';
           isValid = false;
  			 }
      }
 	  }

    // validate remaining phone numbers
    // if data has been entered, make sure it is numeric
    for (var i = 0; i < aOtherPhoneFields[0].length; i++) {
      oFormObj = document.person_basic.elements[aOtherPhoneFields[0][i]];
      sFormObjVal = trimString(oFormObj.value);
      // make sure values in phone fields are numeric
      if ((sFormObjVal.length > 0) && (isNaN(sFormObjVal))) {
  	    sMissing=sMissing + '-' + aOtherPhoneFields[1][i] + ' must be numeric\n';
        isValid = false;
      }
    }
    if ( ! isValid) {
      alert(sMissing);
      return false;
    } else {
      return true;
    }
  }

// -->
	</script>
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
      <form runat="server" id="person_basic" name="person_basic" action="dafault.aspx" method="post">
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="22%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Create a user name</FONT></TD>
          <TD width="13%"><FONT color=#666666 size=1>
          <asp:TextBox runat="server" maxLength="25" id="username" name="username" />
            </FONT></TD>
          <TD width="65%">&nbsp;
						<asp:RequiredFieldValidator runat="server" ControlToValidate="username" Display="Dynamic" class=validatorSK
            ErrorMessage="* 'User Name' must not be left blank." />
						<asp:RegularExpressionValidator id="username_re" runat="server" ValidationExpression="\w+" class=validatorSK
            ErrorMessage="* User Name should consist of latin characters and numbers, no spaces are allowed." Display="Dynamic" ControlToValidate="username" />
						<asp:CustomValidator runat="server" id="username_unique" name="username_unique" class=validatorSK
            ControlToValidate="username" OnServerValidate="EnsureUserNameUnique" Display="Dynamic"
            ErrorMessage="* This User Name already exists, please select another." />
          </TD></TR>
        <TR>
          <TD width="22%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Email address</FONT></TD>
          <TD width="13%"><FONT color=#666666 size=1>
						<asp:TextBox id="email" runat="server" maxLength="50" name="email"></asp:TextBox>
            </FONT></TD>
          <TD width="65%">&nbsp;
						<asp:RegularExpressionValidator id="emailValidator" runat="server" class=validatorSK 
            ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
            ErrorMessage="* Please enter a valid E-mail address" Display="Dynamic" ControlToValidate="email"></asp:RegularExpressionValidator>
						<asp:RequiredFieldValidator runat="server" ControlToValidate="email" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'Email' must not be left blank." />
          </TD></TR>
        <TR>
          <TD width="22%" height=10><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Re-enter email address</FONT></TD>
          <TD width="13%" height=10><FONT color=#666666 size=1>
						<asp:TextBox id="email_reenter" runat="server" maxLength="25" name="email_reenter"></asp:TextBox>
          </FONT></TD>
          <TD width="65%" height=10>&nbsp;
						<asp:RequiredFieldValidator runat="server" ControlToValidate="email_reenter" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'Email' must not be left blank." />
						<asp:CompareValidator runat="server" ControlToValidate="email_reenter" class=validatorSK
            ControlHookup="email" ControlToCompare="email" Operator="Equal" Display="Dynamic" ErrorMessage="* e-mail fields do not match." />
          </TD></TR>
        <TR>
          <TD width="22%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Password</FONT></TD>
          <TD width="13%"><FONT color=#666666 size=1>
						<asp:TextBox id="password" runat="server" TextMode="Password" maxLength="10" name="password"></asp:TextBox>
            </FONT></TD>
          <TD width="65%">&nbsp;
						<asp:RequiredFieldValidator runat="server" ControlToValidate="password" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'Password' must not be left blank." />
						<asp:CustomValidator runat="server" ControlToValidate="password" class=validatorSK
            OnServerValidate="CheckPwdLength_Server"
            ClientValidationFunction="CheckPwdLength_Client"
            Display="Dynamic" ErrorMessage="* 'Password' must be at least 4 characters." />
          </TD></TR>
        <TR>
          <TD width="22%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Re-enter password </FONT></TD>
          <TD width="13%"><FONT color=#666666 size=1>
						<asp:TextBox id="confirm_password" runat="server" TextMode="Password" maxLength="10" name="confirm_password"></asp:TextBox>
            </FONT></TD>
          <TD width="65%">&nbsp;
						<asp:RequiredFieldValidator runat="server" ControlToValidate="confirm_password" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'Password' must not be left blank." />
						<asp:CompareValidator runat="server" ControlToValidate="confirm_password" class=validatorSK
            ControlHookup="password" ControlToCompare="password" Operator="Equal" 
            Display="Dynamic" ErrorMessage="* Password fields do not match." />
          </TD></TR></TBODY></TABLE>
      <P><FONT class=subnavig face="Verdana, Arial, Helvetica, sans-serif" 
      color=#666666 size=1><SPAN class=subnavigCopy>Contact 
      Information</SPAN><SPAN class=beshert> (Your contact information is for 
      administrative purposes only. It will not be disclosed to other members 
      and it will remain private.) </SPAN></FONT></P>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="18%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>First name</FONT></TD>
          <TD width="18%" height=22><FONT color=#666666 size=1>
						<asp:TextBox runat="server" maxLength="40" id="first_name" name="first_name" />
          </FONT></TD>
          <TD width="64%" height=22>&nbsp;
						<asp:RequiredFieldValidator runat="server" ControlToValidate="first_name" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'First Name' must not be left blank." />
          </TD></TR>
        <TR vAlign=center align=left>
          <TD width="18%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Last Name</FONT></TD>
          <TD width="18%" height=22><FONT color=#666666 size=1>
          <asp:TextBox runat="server" maxLength="40" id="last_name" name="last_name" /> </FONT></TD>
          <TD width="64%" height=22>&nbsp;
						<asp:RequiredFieldValidator runat="server" ControlToValidate="last_name" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'Last Name' must not be left blank." />
          </TD></TR>
        <TR vAlign=center align=left>
          <TD width="18%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Gender</FONT></TD>
          <TD width="18%" height=22><FONT color=#666666 size=1>
          <asp:DropDownList runat="server" id="ddlGender" AutoPostBack="false"/> </FONT></TD>
          <TD width="64%" height=22>&nbsp;</TD></TR>
        <TR vAlign=center align=left>
          <TD width="18%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Date of birth</FONT></TD>
          <TD width="18%" height=22><FONT color=#666666 size=1>
						<asp:DropDownList runat="server" id="cmbMonth">                                    
              <asp:Listitem Value="1" Text="January"/>
              <asp:Listitem Value="2" Text="February"/>                                    
              <asp:Listitem Value="3" Text="March"/>                                    
              <asp:Listitem Value="4" Text="April"/> 
              <asp:Listitem Value="5" Text="May"/> 
              <asp:Listitem Value="6" Text="June"/> 
              <asp:Listitem Value="7" Text="July"/> 
              <asp:Listitem Value="8" Text="August"/> 
              <asp:Listitem Value="9" Text="September"/> 
              <asp:Listitem Value="10" Text="October"/> 
              <asp:Listitem Value="11" Text="November"/> 
              <asp:Listitem Value="12" Text="December"/> 
            </asp:DropDownList>
          </FONT></TD>
          <TD width="64%" height=22><FONT color=#666666 size=1>
          <asp:DropDownList runat="server" id="cmbDay">
              <asp:Listitem Value="1" Text="1"/> 
              <asp:Listitem Value="2" Text="2"/> 
              <asp:Listitem Value="3" Text="3"/> 
              <asp:Listitem Value="4" Text="4"/> 
              <asp:Listitem Value="5" Text="5"/> 
              <asp:Listitem Value="6" Text="6"/> 
              <asp:Listitem Value="7" Text="7"/> 
              <asp:Listitem Value="8" Text="8"/> 
              <asp:Listitem Value="9" Text="9"/> 
              <asp:Listitem Value="10" Text="10"/> 
              <asp:Listitem Value="11" Text="11"/> 
              <asp:Listitem Value="12" Text="12"/> 
              <asp:Listitem Value="13" Text="13"/> 
              <asp:Listitem Value="14" Text="14"/> 
              <asp:Listitem Value="15" Text="15"/> 
              <asp:Listitem Value="16" Text="16"/> 
              <asp:Listitem Value="17" Text="17"/> 
              <asp:Listitem Value="18" Text="18"/> 
              <asp:Listitem Value="19" Text="19"/> 
              <asp:Listitem Value="20" Text="20"/> 
              <asp:Listitem Value="21" Text="21"/> 
              <asp:Listitem Value="22" Text="22"/> 
              <asp:Listitem Value="23" Text="23"/> 
              <asp:Listitem Value="24" Text="24"/> 
              <asp:Listitem Value="25" Text="25"/> 
              <asp:Listitem Value="26" Text="26"/> 
              <asp:Listitem Value="27" Text="27"/> 
              <asp:Listitem Value="28" Text="28"/> 
              <asp:Listitem Value="29" Text="29"/> 
              <asp:Listitem Value="30" Text="30"/> 
              <asp:Listitem Value="31" Text="31"/>                                 
              </asp:DropDownList> 
            <asp:DropDownList runat="server" id="cmbYear" Height="21px" Width="78px" name="cmbYear">
						</asp:DropDownList> </FONT><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#ff9933 
            size=1><B>Must be 18+</B></FONT></TD></TR>

        <TR vAlign=center align=left>
          <TD width="18%" height=22 colspan=2>
            <asp:CustomValidator runat="server" id="age_check" name="age_check"  class=validatorSK
            ControlToValidate="cmbYear" OnServerValidate="CheckAge_Server"
            ClientValidationFunction="CheckAge_Client" 
            Display="Dynamic" ErrorMessage="* You must be at least 18 years old to register." 
            Wrapping=NoWrap />
            <asp:CustomValidator runat="server" id="date_check" name="date_check"  class=validatorSK
            ControlToValidate="cmbYear" OnServerValidate="CheckBirthdayValid"
            Display="Dynamic" ErrorMessage="* Invalid date." 
            Wrapping=NoWrap />
          </TD></TR>
        <TR vAlign=center align=left>
          <TD width="18%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Street</FONT></TD>
          <TD width="18%" height=22><FONT color=#666666 size=1>
						<asp:TextBox runat="server" maxLength="50" id="street" name="street" />
           </FONT></TD>
          <TD width="64%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Apt. <asp:TextBox runat="server" maxLength="10" id="apt" name="apt" width="50" /> </FONT>
						<asp:RequiredFieldValidator runat="server" ControlToValidate="street" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'Street' must not be left blank." />            
            </TD></TR>
        <TR vAlign=center align=left>
          <TD width="18%" height=22><FONT color=#666666 size=1>City</FONT></TD>
          <TD width="18%" height=22><FONT color=#666666 size=1>
						<asp:TextBox runat="server" maxLength="40" id="city" name="city" />
           </FONT></TD>
          <TD width="64%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>State/Province <asp:DropDownList runat="server" id="state" AutoPostBack="false"/>
 </FONT>						<asp:RequiredFieldValidator runat="server" ControlToValidate="city" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'City' must not be left blank." />
</TD></TR>
        <TR vAlign=center align=left>
          <TD width="18%" height=30><FONT color=#666666 size=1>Country</FONT> 
          </TD>
          <TD width="18%" height=30>
          <asp:DropDownList runat="server" id="ddlCountry" AutoPostBack="false"/>          
         </TD>
          <TD width="64%" height=30><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Zip Code 
						<asp:TextBox runat="server" maxLength="11" id="zip" name="zip" /></FONT>
						<asp:RequiredFieldValidator runat="server" ControlToValidate="zip" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'Zip Code' must not be left blank." />
						<asp:RegularExpressionValidator id="zip_re" runat="server" class=validatorSK
            ValidationExpression="^\d{4}(\d|\d\-\d{4})$" ErrorMessage="* Please enter valid zip code." Display="Dynamic" ControlToValidate="zip" />
             </TD></TR>

        <TR vAlign=center align=left>
          <TD width="18%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Home Phone</FONT></TD>
          <TD width="18%" height=22><FONT color=#666666 size=1>
						<asp:TextBox runat="server" maxLength="3" id="HomeAreaCode" name="HomeAreaCode" width="30" />
						&nbsp;
						<asp:TextBox runat="server" maxLength="3" id="HomeLocalExchange" name="HomeLocalExchange" width="40" />
						-
						<asp:TextBox runat="server" maxLength="4" id="HomePhone" name="HomePhone" width="50" />
            </FONT></TD>
          <TD width="64%" height=22>&nbsp;
				<asp:RequiredFieldValidator runat="server" ControlToValidate="HomePhone" class=validatorSK
            Display="Dynamic" ErrorMessage="* 'Home phone' must not be left blank." />
						<asp:CustomValidator runat="server" ControlToValidate="HomePhone" class=validatorSK
            OnServerValidate="CheckPhone_Server"
            ClientValidationFunction="CheckPhone_Client"
            Display="Dynamic" ErrorMessage="* Wrong phone format." />          
          </TD></TR>
        <TR vAlign=center align=left>
          <TD width="18%" height=22><FONT 
            face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
            size=1>Work (optional)</FONT></TD>
          <TD width="18%" height=22><FONT color=#666666 size=1>
          <asp:TextBox runat="server" maxLength="3" id="WorkAreaCode" name="WorkAreaCode" width="30" />
					&nbsp;
						<asp:TextBox runat="server" maxLength="3" id="WorkLocalExchange" name="WorkLocalExchange" width="40" />
						-
						<asp:TextBox runat="server" maxLength="4" id="WorkPhone" name="WorkPhone" width="50" />
						
            </FONT></TD>
          <TD width="64%" height=22>&nbsp;<FONT color=#666666 size=1>Ext.#
						<asp:TextBox runat="server" maxLength="5" id="WorkExt" name="WorkExt" width="50" /></FONT> </TD></TR>
        <TR vAlign=center align=left>
          <TD width="18%"><FONT face="Verdana, Arial, Helvetica, sans-serif" 
            color=#666666 size=1>Cell Phone (optional)</FONT></TD>
          <TD width="18%"><FONT color=#666666 size=1>
            <asp:TextBox runat="server" maxLength="3" id="MobileAreaCode" name="MobileAreaCode" width="30" />
						&nbsp;
						<asp:TextBox runat="server" maxLength="3" id="MobileLocalExchange" name="MobileLocalExchange" width="40" />
						-
						<asp:TextBox runat="server" maxLength="4" id="MobilePhone" name="MobilePhone" width="50" />          
            </FONT></TD>
          <TD width="64%">&nbsp;</TD></TR></TBODY></TABLE>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><SPAN class=subnavig><B><FONT class=subgraybold 
      face="Arial, Helvetica, sans-serif" color=#333333 size=2>
      <asp:Checkbox runat="server" id="chkAgree" name="chkAgree" checked="false" Text="" />I have read and 
      agree to Beshert<A class=beshertblueCopy 
      href="privacyinfo.htm"> Privacy 
      Statement</A> and <A class=beshertblueCopy 
      href="terms2.htm">Terms &amp; 
      Conditions</A>. I am at least 18 years old.</FONT></B></SPAN></FONT></P>
      <P>&nbsp;						<asp:CustomValidator runat="server" ControlToValidate="HomeAreaCode"
            OnServerValidate="ValidatePrivacy_Server" class=validatorSK
            Display="Dynamic" ErrorMessage="* You must check this box in order to proceed." />
</P</P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666><SPAN 
      class=subnavig2>Choose One:</SPAN></FONT><SPAN class=subnavig2><FONT 
      color=#666666><FONT face="Verdana, Arial, Helvetica, sans-serif" size=1> 
      </FONT></FONT></SPAN></P>
      <P><FONT color=#666666><FONT color=#666666><FONT 
      face="Verdana, Arial, Helvetica, sans-serif" size=1>
						<asp:RadioButton runat="server" Checked="true" ID="rbPublic" GroupName = "publish" />
       </FONT></FONT><FONT 
      face="Verdana, Arial, Helvetica, sans-serif" color=#999999 size=1>I would 
      like my profile (without contact information) to be shown to Beshert's 
      clients in order to be matched up for a potential 
      introduction.</FONT></FONT></P>
      <P><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#666666 
      size=1><asp:RadioButton runat="server" ID="rbNotPublic" GroupName = "publish" />
      <FONT 
      color=#999999>Please contact me before Beshert shows my profile to 
      anyone.</FONT></FONT></P>
      <P>&nbsp;</P>

      <P class=beshertCopy><FONT color=#666666 size=1>
      <asp:Button id="SubmitExit" runat="server" Text="Save &amp; Exit" alt="Save & Exit" border="0" name="RegisterExit" OnClick="Save_Basic" />
      </FONT></P>
      <P class=beshertCopy><FONT color=#666666 size=1>
      <asp:Button id="SubmitContinue" runat="server" Text="Save &amp; Continue" alt="Save & Continue" border="0" name="RegisterContinue" OnClick="Save_Continue" /> 
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
