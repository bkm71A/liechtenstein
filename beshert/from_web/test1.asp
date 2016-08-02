<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>BESHERT</title> 
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <meta content="Slava Kovalenko, Slava_K, BKM71" name="Author" />
    <script language="JavaScript">
<!--
function MM_swapimgRestore() { //v3.0
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
    <link href="../css/beshert.css" type="text/css" rel="stylesheet" />
    <meta content="MSHTML 6.00.2726.2500" name="GENERATOR" />
</head>
<body text="#000000" leftmargin="0" background="img/background.jpe" topmargin="0" onload="MM_preloadImages('img/navigation/search1-on.jpg','img/navigation/speed2-on.jpg','img/navigation/personal3-on.jpg','img/navigation/travel4-on.jpg')" marginwidth="0" marginheight="0">
    <table cellspacing="0" cellpadding="0" width="100%" border="0">
        <tbody>
            <tr>
                <td width="11%" height="83">
                    <a href="http://www.iimaginestudio.com/beshert/index.htm"><img height="95" src="img/logo_top.jpe" width="111" border="0" /></a></td>
                <td valign="bottom" width="19%" height="83">
                    <table height="30" cellspacing="0" cellpadding="0" width="101%" border="0">
                        <tbody>
                            <tr>
                                <td width="28%">
                                    &nbsp;</td>
                                <td class="subnavig2" width="72%">
                                    &nbsp;</td>
                            </tr>
                        </tbody>
                    </table>
                </td>
                <td width="16%" height="83">
                    &nbsp;</td>
                <td width="19%" height="83">
                    &nbsp;</td>
                <td width="11%" height="83">
                    &nbsp;</td>
                <td width="24%" height="83">
                    &nbsp;</td>
            </tr>
            <tr>
                <td width="11%" height="23">
                    <a href="http://www.iimaginestudio.com/beshert/index.htm"><img height="33" src="img/logo_buttom.jpe" width="111" border="0" /></a></td>
                <td width="19%" height="23">
                    <a onmouseover="MM_swapImage('nav1','','img/navigation/search1-on.jpg',1)" onmouseout="MM_swapimgRestore()" href="http://www.iimaginestudio.com/beshert/yourprofile.htm"><img height="33" src="img/search1-on.jpe" width="189" border="0" name="nav1" /></a></td>
                <td width="16%" height="23">
                    <a onmouseover="MM_swapImage('nav2','','img/navigation/speed2-on.jpg',1)" onmouseout="MM_swapimgRestore()" href="http://www.iimaginestudio.com/beshert/speed.htm"><img class="newspaper" height="33" src="img/speed2-off.jpe" width="166" border="0" name="nav2" /></a></td>
                <td width="19%" height="23">
                    <a onmouseover="MM_swapImage('nav3','','img/navigation/personal3-on.jpg',1)" onmouseout="MM_swapimgRestore()" href="http://www.iimaginestudio.com/beshert/personal.htm"><img height="33" src="img/personal3-off.jpe" width="198" border="0" name="nav3" /></a></td>
                <td width="11%" background="img/image-backg-small1.jpe" height="23">
                    <a onmouseover="MM_swapImage('nav4','','img/navigation/travel4-on.jpg',1)" onmouseout="MM_swapimgRestore()" href="http://www.iimaginestudio.com/beshert/events.htm"><img height="33" src="img/travel4-off.jpe" width="132" border="0" name="nav4" /></a></td>
                <td width="24%" background="img/image-backg-small1.jpe" height="23">
                    &nbsp;</td>
            </tr>
        </tbody>
    </table>
    <a class="beshert" href="http://www.iimaginestudio.com/beshert/index.htm">: home</a><span class="beshert"> : </span><font class="beshert" color="#333333"><a class="beshert" href="http://www.iimaginestudio.com/beshert/contact.htm">contact
    info</a></font><span class="beshert"> :<font color="#666666"> </font></span><font color="#666666"><font color="#999999"><a class="beshert" href="http://www.iimaginestudio.com/beshert/privacyinfo.htm">privacy
    info</a></font></font><span class="beshert"> :</span><font class="beshert" color="#666666"> <a class="beshert" href="http://www.iimaginestudio.com/beshert/terms2.htm">terms
    &amp; conditions </a></font><span class="beshert">:</span><font color="#666666"><span class="beshert"> </span><a class="beshert" href="http://www.iimaginestudio.com/beshert/mediacoverage.htm">media
    coverage</a></font><span class="beshert"> : 
    <br />
    </span> 
    <table cellspacing="0" cellpadding="0" width="100%" border="0">
        <tbody>
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
        </tbody>
    </table>
    <br />
    <table cellspacing="0" cellpadding="0" width="100%" border="0">
        <tbody>
            <tr>
                <td width="0%" height="26">
                    &nbsp;</td>
                <td width="7%" height="26">
                    &nbsp;</td>
                <td class="TITLES2" valign="top" width="90%" height="26">
                    <font size="2">QUESTIONARY <span class="TITLES">:: Submit your Profile</span></font></td>
                <td width="3%" height="26">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="beshertCopy" valign="top" width="0%" height="819">
                    <font color="#ffffff"></font></td>
                <td class="beshertCopy" valign="top" align="left" width="7%" height="819">
                    &nbsp;</td>
                <td class="subnavig2Copy" valign="center" width="90%" height="819">
                    <p>
                        <font class="beshertCopy" face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1"><span class="subnavigCopy">Login
                        Information </span></font>
                    </p>
                    <form id="person_basic" name="person_basic" action="dafault.aspx" method="post" runat="server">
                        <table cellspacing="0" cellpadding="0" width="100%" border="0">
                            <tbody>
                                <tr>
                                    <td width="22%">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Create
                                        a user name</font></td>
                                    <td width="13%">
                                        <font color="#666666" size="1">
										<INPUT TYPE="text" NAME="username" id="usermane" maxLength="25">
                                        </font></td>
                                    <td width="65%">
                                        &nbsp; 
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator1" runat="server" ErrorMessage="* 'User Name' must not be left blank." Display="Dynamic" ControlToValidate="username"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator class="validatorSK" id="username_re" runat="server" ErrorMessage="* User Name should consist of latin characters and numbers, no spaces are allowed." Display="Dynamic" ControlToValidate="username" ValidationExpression="\w+"></asp:RegularExpressionValidator>
                                        <asp:CustomValidator class="validatorSK" id="username_unique" runat="server" name="username_unique" ErrorMessage="* This User Name already exists, please select another." Display="Dynamic" ControlToValidate="username" OnServerValidate="EnsureUserNameUnique"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="22%">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Email
                                        address</font></td>
                                    <td width="13%">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="email" runat="server" name="email" maxLength="50"></asp:TextBox>
                                        </font></td>
                                    <td width="65%">
                                        &nbsp; 
                                        <asp:RegularExpressionValidator class="validatorSK" id="emailValidator" runat="server" ErrorMessage="* Please enter a valid E-mail address" Display="Dynamic" ControlToValidate="email" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator2" runat="server" ErrorMessage="* 'Email' must not be left blank." Display="Dynamic" ControlToValidate="email"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="22%" height="10">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Re-enter
                                        email address</font></td>
                                    <td width="13%" height="10">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="email_reenter" runat="server" name="email_reenter" maxLength="25"></asp:TextBox>
                                        </font></td>
                                    <td width="65%" height="10">
                                        &nbsp; 
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator3" runat="server" ErrorMessage="* 'Email' must not be left blank." Display="Dynamic" ControlToValidate="email_reenter"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator class="validatorSK" id="CompareValidator1" runat="server" ErrorMessage="* e-mail fields do not match." Display="Dynamic" ControlToValidate="email_reenter" Operator="Equal" ControlToCompare="email" ControlHookup="email"></asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="22%">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Password</font></td>
                                    <td width="13%">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="password" runat="server" name="password" maxLength="10" TextMode="Password"></asp:TextBox>
                                        </font></td>
                                    <td width="65%">
                                        &nbsp; 
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator4" runat="server" ErrorMessage="* 'Password' must not be left blank." Display="Dynamic" ControlToValidate="password"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator class="validatorSK" id="CustomValidator1" runat="server" ErrorMessage="* 'Password' must be at least 4 characters." Display="Dynamic" ControlToValidate="password" OnServerValidate="CheckPwdLength_Server" ClientValidationFunction="CheckPwdLength_Client"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="22%">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Re-enter
                                        password </font></td>
                                    <td width="13%">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="confirm_password" runat="server" name="confirm_password" maxLength="10" TextMode="Password"></asp:TextBox>
                                        </font></td>
                                    <td width="65%">
                                        &nbsp; 
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator5" runat="server" ErrorMessage="* 'Password' must not be left blank." Display="Dynamic" ControlToValidate="confirm_password"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator class="validatorSK" id="CompareValidator2" runat="server" ErrorMessage="* Password fields do not match." Display="Dynamic" ControlToValidate="confirm_password" Operator="Equal" ControlToCompare="password" ControlHookup="password"></asp:CompareValidator>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <p>
                            <font class="subnavig" face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1"><span class="subnavigCopy">Contact
                            Information</span><span class="beshert"> (Your contact information is for administrative
                            purposes only. It will not be disclosed to other members and it will remain private.) </span></font>
                        </p>
                        <table cellspacing="0" cellpadding="0" width="100%" border="0">
                            <tbody>
                                <tr>
                                    <td width="18%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">First
                                        name</font></td>
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="first_name" runat="server" name="first_name" maxLength="40"></asp:TextBox>
                                        </font></td>
                                    <td width="64%" height="22">
                                        &nbsp; 
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator6" runat="server" ErrorMessage="* 'First Name' must not be left blank." Display="Dynamic" ControlToValidate="first_name"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Last Name</font></td>
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="last_name" runat="server" name="last_name" maxLength="40"></asp:TextBox>
                                        </font></td>
                                    <td width="64%" height="22">
                                        &nbsp; 
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator7" runat="server" ErrorMessage="* 'Last Name' must not be left blank." Display="Dynamic" ControlToValidate="last_name"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Gender</font></td>
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:DropDownList id="ddlGender" runat="server" AutoPostBack="false"></asp:DropDownList>
                                        </font></td>
                                    <td width="64%" height="22">
                                        &nbsp;</td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Date of
                                        birth</font></td>
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:DropDownList id="cmbMonth" runat="server">
                                            <asp:Listitem Value="1" Text="January" />
                                            <asp:Listitem Value="2" Text="February" />
                                            <asp:Listitem Value="3" Text="March" />
                                            <asp:Listitem Value="4" Text="April" />
                                            <asp:Listitem Value="5" Text="May" />
                                            <asp:Listitem Value="6" Text="June" />
                                            <asp:Listitem Value="7" Text="July" />
                                            <asp:Listitem Value="8" Text="August" />
                                            <asp:Listitem Value="9" Text="September" />
                                            <asp:Listitem Value="10" Text="October" />
                                            <asp:Listitem Value="11" Text="November" />
                                            <asp:Listitem Value="12" Text="December" />
                                        </asp:DropDownList>
                                        </font></td>
                                    <td width="64%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:DropDownList id="cmbDay" runat="server">
                                            <asp:Listitem Value="1" Text="1" />
                                            <asp:Listitem Value="2" Text="2" />
                                            <asp:Listitem Value="3" Text="3" />
                                            <asp:Listitem Value="4" Text="4" />
                                            <asp:Listitem Value="5" Text="5" />
                                            <asp:Listitem Value="6" Text="6" />
                                            <asp:Listitem Value="7" Text="7" />
                                            <asp:Listitem Value="8" Text="8" />
                                            <asp:Listitem Value="9" Text="9" />
                                            <asp:Listitem Value="10" Text="10" />
                                            <asp:Listitem Value="11" Text="11" />
                                            <asp:Listitem Value="12" Text="12" />
                                            <asp:Listitem Value="13" Text="13" />
                                            <asp:Listitem Value="14" Text="14" />
                                            <asp:Listitem Value="15" Text="15" />
                                            <asp:Listitem Value="16" Text="16" />
                                            <asp:Listitem Value="17" Text="17" />
                                            <asp:Listitem Value="18" Text="18" />
                                            <asp:Listitem Value="19" Text="19" />
                                            <asp:Listitem Value="20" Text="20" />
                                            <asp:Listitem Value="21" Text="21" />
                                            <asp:Listitem Value="22" Text="22" />
                                            <asp:Listitem Value="23" Text="23" />
                                            <asp:Listitem Value="24" Text="24" />
                                            <asp:Listitem Value="25" Text="25" />
                                            <asp:Listitem Value="26" Text="26" />
                                            <asp:Listitem Value="27" Text="27" />
                                            <asp:Listitem Value="28" Text="28" />
                                            <asp:Listitem Value="29" Text="29" />
                                            <asp:Listitem Value="30" Text="30" />
                                            <asp:Listitem Value="31" Text="31" />
                                        </asp:DropDownList>
                                        <asp:DropDownList id="cmbYear" runat="server" name="cmbYear" Width="78px" Height="21px"></asp:DropDownList>
                                        </font><font face="Verdana, Arial, Helvetica, sans-serif" color="#ff9933" size="1"><b>Must
                                        be 18+</b></font></td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" colspan="2" height="22">
                                        <asp:CustomValidator class="validatorSK" id="age_check" runat="server" name="age_check" ErrorMessage="* You must be at least 18 years old to register." Display="Dynamic" ControlToValidate="cmbYear" OnServerValidate="CheckAge_Server" ClientValidationFunction="CheckAge_Client" Wrapping="NoWrap"></asp:CustomValidator>
                                        <asp:CustomValidator class="validatorSK" id="date_check" runat="server" name="date_check" ErrorMessage="* Invalid date." Display="Dynamic" ControlToValidate="cmbYear" OnServerValidate="CheckBirthdayValid" Wrapping="NoWrap"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Street</font></td>
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="street" runat="server" name="street" maxLength="50"></asp:TextBox>
                                        </font></td>
                                    <td width="64%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Apt. 
                                        <asp:TextBox id="apt" runat="server" name="apt" maxLength="10" width="50"></asp:TextBox>
                                        </font>
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator8" runat="server" ErrorMessage="* 'Street' must not be left blank." Display="Dynamic" ControlToValidate="street"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">City</font></td>
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="city" runat="server" name="city" maxLength="40"></asp:TextBox>
                                        </font></td>
                                    <td width="64%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">State/Province 
                                        <asp:DropDownList id="state" runat="server" AutoPostBack="false"></asp:DropDownList>
                                        </font>
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator9" runat="server" ErrorMessage="* 'City' must not be left blank." Display="Dynamic" ControlToValidate="city"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" height="30">
                                        <font color="#666666" size="1">Country</font> 
                                    </td>
                                    <td width="18%" height="30">
                                        <input readonly="readonly" value="USA" name="textfield11" />
                                    </td>
                                    <td width="64%" height="30">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Zip Code 
                                        <asp:TextBox id="zip" runat="server" name="zip" maxLength="11"></asp:TextBox>
                                        </font>
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator10" runat="server" ErrorMessage="* 'Zip Code' must not be left blank." Display="Dynamic" ControlToValidate="zip"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator class="validatorSK" id="zip_re" runat="server" ErrorMessage="* Please enter valid zip code." Display="Dynamic" ControlToValidate="zip" ValidationExpression="^\d{4}(\d|\d\-\d{4})$"></asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Home Phone</font></td>
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="HomeAreaCode" runat="server" name="HomeAreaCode" maxLength="3" width="30"></asp:TextBox>
                                        &nbsp; 
                                        <asp:TextBox id="HomeLocalExchange" runat="server" name="HomeLocalExchange" maxLength="3" width="40"></asp:TextBox>
                                        - 
                                        <asp:TextBox id="HomePhone" runat="server" name="HomePhone" maxLength="4" width="50"></asp:TextBox>
                                        </font></td>
                                    <td width="64%" height="22">
                                        &nbsp; 
                                        <asp:RequiredFieldValidator class="validatorSK" id="RequiredFieldValidator11" runat="server" ErrorMessage="* 'Home phone' must not be left blank." Display="Dynamic" ControlToValidate="HomePhone"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator class="validatorSK" id="CustomValidator2" runat="server" ErrorMessage="* Wrong phone format." Display="Dynamic" ControlToValidate="HomePhone" OnServerValidate="CheckPhone_Server" ClientValidationFunction="CheckPhone_Client"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%" height="22">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Work (optional)</font></td>
                                    <td width="18%" height="22">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="WorkAreaCode" runat="server" name="WorkAreaCode" maxLength="3" width="30"></asp:TextBox>
                                        &nbsp; 
                                        <asp:TextBox id="WorkLocalExchange" runat="server" name="WorkLocalExchange" maxLength="3" width="40"></asp:TextBox>
                                        - 
                                        <asp:TextBox id="WorkPhone" runat="server" name="WorkPhone" maxLength="4" width="50"></asp:TextBox>
                                        </font></td>
                                    <td width="64%" height="22">
                                        &nbsp;<font color="#666666" size="1">Ext.# 
                                        <asp:TextBox id="WorkExt" runat="server" name="WorkExt" maxLength="5" width="50"></asp:TextBox>
                                        </font></td>
                                </tr>
                                <tr valign="center" align="left">
                                    <td width="18%">
                                        <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">Cell Phone
                                        (optional)</font></td>
                                    <td width="18%">
                                        <font color="#666666" size="1">
                                        <asp:TextBox id="MobileAreaCode" runat="server" name="MobileAreaCode" maxLength="3" width="30"></asp:TextBox>
                                        &nbsp; 
                                        <asp:TextBox id="MobileLocalExchange" runat="server" name="MobileLocalExchange" maxLength="3" width="40"></asp:TextBox>
                                        - 
                                        <asp:TextBox id="MobilePhone" runat="server" name="MobilePhone" maxLength="4" width="50"></asp:TextBox>
                                        </font></td>
                                    <td width="64%">
                                        &nbsp;</td>
                                </tr>
                            </tbody>
                        </table>
                        <p>
                            <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1"><span class="subnavig"><b><font class="subgraybold" face="Arial, Helvetica, sans-serif" color="#333333" size="2">
                            <asp:Checkbox id="chkAgree" runat="server" name="chkAgree" Text="" checked="false"></asp:Checkbox>
                            I have read and agree to Beshert<a class="beshertblueCopy" href="http://www.iimaginestudio.com/beshert/privacyinfo.htm"> Privacy
                            Statement</a> and <a class="beshertblueCopy" href="http://www.iimaginestudio.com/beshert/terms2.htm">Terms
                            &amp; Conditions</a>. I am at least 18 years old.</font></b></span></font>
                        </p>
                        <p>
                            &nbsp; 
                            <asp:CustomValidator class="validatorSK" id="CustomValidator3" runat="server" ErrorMessage="* You must check this box in order to proceed." Display="Dynamic" ControlToValidate="HomeAreaCode" OnServerValidate="ValidatePrivacy_Server"></asp:CustomValidator>P< 
      P>
                        </p>
                        <p>
                            <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666"><span class="subnavig2">Choose
                            One:</span></font><span class="subnavig2"><font color="#666666"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> </font></font></span>
                        </p>
                        <p>
                            <font color="#666666"><font color="#666666"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                            <asp:RadioButton id="rbPublic" runat="server" GroupName="publish" Checked="true"></asp:RadioButton>
                            </font></font><font face="Verdana, Arial, Helvetica, sans-serif" color="#999999" size="1">I
                            would like my profile (without contact information) to be shown to Beshert's clients
                            in order to be matched up for a potential introduction.</font></font>
                        </p>
                        <p>
                            <font face="Verdana, Arial, Helvetica, sans-serif" color="#666666" size="1">
                            <asp:RadioButton id="rbNotPublic" runat="server" GroupName="publish"></asp:RadioButton>
                            <font color="#999999">Please contact me before Beshert shows my profile to anyone.</font></font>
                        </p>
                        <p>
                            &nbsp;
                        </p>
                        <p class="beshertCopy">
                            <font color="#666666" size="1">
                            <asp:Button id="SubmitExit" onclick="Save_Basic" runat="server" name="RegisterExit" Text="Save &amp; Exit" border="0" alt="Save &amp; Exit"></asp:Button>
                            </font>
                        </p>
                        <p class="beshertCopy">
                            <font color="#666666" size="1">
                            <asp:Button id="SubmitContinue" onclick="Save_Continue" runat="server" name="RegisterContinue" Text="Save &amp; Continue" border="0" alt="Save &amp; Continue"></asp:Button>
                            <br />
                            </font>
                        </p>
                        <p>
                        </p>
                    </form>
                    <table cellspacing="0" cellpadding="0" width="100%" border="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div align="center"><a href="http://www.iimaginestudio.com/" target="_blank"><span class="beshert">2003
                                        BESHERT. All Rights Reserved . Design by <b>i imagine studio.</b></span></a> 
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <p>
                    </p>
                </td>
                <td width="3%" height="819">
                </td>
            </tr>
        </tbody>
    </table>
</body>
</html>
