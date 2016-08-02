<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server" language="c#">
  System.String connectionString = "server=localhost;uid=bkm71;pwd=2718235;database=beshert";

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
      state_DataBind();
    }
  }

  /* Bind data to controls */
  void state_DataBind() {
    SqlConnection sqlConn = new SqlConnection(connectionString);
    SqlCommand stateSelect = new SqlCommand("SELECT CODE,DESCRIPTION FROM STATE ORDER BY DESCRIPTION",sqlConn);
    sqlConn.Open();
    SqlDataReader reader = stateSelect.ExecuteReader();
    state.DataSource = reader;
    state.DataTextField = "DESCRIPTION";
    state.DataValueField = "CODE";
    state.DataBind();
    state.SelectedIndex = 11;
    int startYear = DateTime.Today.Year-70;
    for (int i=startYear; i<=startYear+52; i++) {
      cmbYear.Items.Add(new ListItem(i.ToString(),i.ToString()));
    }
    reader.Close();
    sqlConn.Close();
  }

  /* Save form data in database */
  void Save_Data(Object sender, EventArgs e) {
      System.String sqlInsert = "INSERT PERSON (ID,EMAIL,PASSWORD,FIRST_NAME,LAST_NAME,STREET," +
      "APT,CITY,STATE,ZIP,HOME_PHONE,WORK_PHONE,CELL_PHONE,SEX,BIRTHDATE) VALUES ('"
      + username.Text + "','" + email.Text + "','" + password.Text + "','" +first_name.Text+ "','" 
      +last_name.Text+ "','" +street.Text+ "','" +apt.Text+ "','" 
      +city.Text+ "','" +state.SelectedItem.Value + "','" +zip.Text+ "','" +HomeAreaCode.Text+HomeLocalExchange.Text+HomePhone.Text + "','" 
      +WorkAreaCode.Text+WorkLocalExchange.Text+WorkPhone.Text+WorkExt.Text+ "','" +MobileAreaCode.Text+MobileLocalExchange.Text
      +MobilePhone.Text + "','" +(male.Checked ?"M":"F")+ "','" + cmbYear.SelectedItem.Value+"-"+cmbMonth.SelectedItem.Value+"-"
      +cmbDay.SelectedItem.Value + "')";
      SqlConnection sqlConn = new SqlConnection(connectionString);
      sqlConn.Open();
      SqlCommand insertPerson = new SqlCommand(sqlInsert,sqlConn);
      insertPerson.ExecuteNonQuery();
      sqlConn.Close();
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

  /* Ensure that privacy checkbox checked */
  void ValidatePrivacy_Server(Object sender,ServerValidateEventArgs args){
    if ( privacy.Checked ) {
      args.IsValid = true;
    } else {
      args.IsValid = false;
    }
  }

  /* Ensure that terms checkbox checked */
  void ValidateTerms_Server(Object sender,ServerValidateEventArgs args){
    if ( terms.Checked ) {
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
    int year = Int32.Parse(cmbYear.SelectedItem.Text);
    if ( DateTime.Today.Year - year < 18 ) {
     args.IsValid = false;
    } else {
     args.IsValid = true;
    }
  }

</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
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

  /* Ensure that privacy checkbox is checked 
  function PrivacyChecked_Client(source, value) {
    if ( document.forms("person_basic").privacy.checked==true ) {
      value.IsValid = true;
    } else {
      value.IsValid = false;
    }
  }    

   Ensure that terms checkbox is checked */
  function TermsChecked_Client(source, value) {
    if ( document.forms("person_basic").terms.checked==true ) {
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

  /* TODO */
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
	<HEAD>
		<TITLE>Register</TITLE>
		<META http-equiv="Content-Type" content="text/html; charset=utf-8">
		<BODY>
			<LINK href="css/beshert.css" type="text/css" rel="stylesheet">
				<TABLE id="Table1" style="Z-INDEX: 101; LEFT: 8px; POSITION: absolute; TOP: 8px" cellSpacing="0" cellPadding="0" width="569" border="0">
					<TBODY>
						<TR>
							<TD vAlign="top">
							</TD>
							<TD vAlign="top" noWrap align="left" width="576">
								<TABLE id="Table2" height="100%" cellSpacing="0" cellPadding="0" width="100%" align="left" border="0">
									<TBODY>
										<TR vAlign="top">
											<TD noWrap>
												<BR>
												<TABLE id="Table3" style="WIDTH: 700px; HEIGHT: 34px" cellSpacing="0" cellPadding="0" width="577" border="0">
													<TBODY>
														<TR>
															<TD class="ContentHead" style="HEIGHT: 20px">
																<FONT color="#fbffbf">Create a New Account</FONT>
																<BR>
															</TD>
														</TR>
													</TBODY>
												</TABLE>
												<IMG height="1" src="" width="92" align="left"> <SPAN class="ErrorText" id="MyError">
												</SPAN>
												<TABLE id="Table4" height="100%" cellSpacing="0" cellPadding="0" width="500" border="0">
													<TBODY>
														<TR vAlign="top">
															<TD style="HEIGHT: 198px" width="550" colSpan="2" height="198">
																<BR>
																<FONT face="Times New Roman">
																	<form runat="server" id="person_basic" name="person_basic" action="Register.aspx" method="post">
																		<FONT size="3"><SPAN class="NormalBold">Create a User Name</SPAN></FONT>
																		<asp:TextBox runat="server" maxLength="25" id="username" name="username" />
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="username" Display="Dynamic" ErrorMessage="* 'User Name' must not be left blank." />
																		<asp:RegularExpressionValidator id="username_re" runat="server" ValidationExpression="\w+" ErrorMessage="* User Name should consist of latin characters and numbers, no spaces are allowed." Display="Dynamic" ControlToValidate="username" />
																		<asp:CustomValidator runat="server" id="username_unique" name="username_unique" ControlToValidate="username" OnServerValidate="EnsureUserNameUnique" Display="Dynamic" ErrorMessage="* This User Name already exists, please select another." />
																		<BR>
																		Email :
																		<asp:TextBox id="email" runat="server" maxLength="50" name="email"></asp:TextBox>
																		<asp:RegularExpressionValidator id="emailValidator" runat="server" style="DISPLAY: none; FONT-SIZE: 9pt; COLOR: red; FONT-FAMILY: verdana" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="* Please enter a valid E-mail address" Display="Dynamic" ControlToValidate="email"></asp:RegularExpressionValidator>
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="email" Display="Dynamic" ErrorMessage="* 'Email' must not be left blank." />
																		<BR>
																		Re-enter email address:
																		<asp:TextBox id="email_reenter" runat="server" maxLength="25" name="email_reenter"></asp:TextBox>
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="email_reenter" Display="Dynamic" ErrorMessage="* 'Email' must not be left blank." />
																		<asp:CompareValidator runat="server" ControlToValidate="email_reenter" ControlHookup="email" ControlToCompare="email" Operator="Equal" Display="Dynamic" ErrorMessage="* e-mail fields do not match." />
																		<BR>
																		Password
																		<asp:TextBox id="password" runat="server" TextMode="Password" maxLength="10" name="password"></asp:TextBox>
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="password" Display="Dynamic" ErrorMessage="* 'Password' must not be left blank." />
																		<asp:CustomValidator runat="server" ControlToValidate="password" 
                                    OnServerValidate="CheckPwdLength_Server"
                                    ClientValidationFunction="CheckPwdLength_Client"
                                    Display="Dynamic" ErrorMessage="* 'Password' must be at least 4 characters." />
																		<BR>
																		Confirm Password
																		<asp:TextBox id="confirm_password" runat="server" TextMode="Password" maxLength="10" name="confirm_password"></asp:TextBox>
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="confirm_password" Display="Dynamic" ErrorMessage="* 'Password' must not be left blank." />
																		<asp:CompareValidator runat="server" ControlToValidate="confirm_password" ControlHookup="password" ControlToCompare="password" Operator="Equal" Display="Dynamic" ErrorMessage="* Password fields do not match." />
																		<H1>
																			Contact Information
																		</H1>
																		<HR>
																		First Name
																		<asp:TextBox runat="server" maxLength="40" id="first_name" name="first_name" />
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="first_name" Display="Dynamic" ErrorMessage="* 'First Name' must not be left blank." />
																		<BR>
																		Last Name
																		<asp:TextBox runat="server" maxLength="40" id="last_name" name="last_name" />
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="last_name" Display="Dynamic" ErrorMessage="* 'Last Name' must not be left blank." />
																		<BR>
																		Street
																		<asp:TextBox runat="server" maxLength="50" id="street" name="street" />
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="street" Display="Dynamic" ErrorMessage="* 'Street' must not be left blank." />
																		<BR>
																		Apt
																		<asp:TextBox runat="server" maxLength="10" id="apt" name="apt" width="50" />
																		<BR>
																		City
																		<asp:TextBox runat="server" maxLength="40" id="city" name="city" />
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="city" Display="Dynamic" ErrorMessage="* 'City' must not be left blank." />
																		<BR>
																		State
																		<asp:DropDownList runat="server" id="state" AutoPostBack="false" Height="21px" Width="120px" />
																		<BR>
																		Zip Code
																		<asp:TextBox runat="server" maxLength="11" id="zip" name="zip" />
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="zip" Display="Dynamic" ErrorMessage="* 'Zip Code' must not be left blank." />
																		<asp:RegularExpressionValidator id="zip_re" runat="server" ValidationExpression="^\d{4}(\d|\d\-\d{4})$" ErrorMessage="* Please enter valid zip code." Display="Dynamic" ControlToValidate="zip" />
																		<BR>
																		Home phone&nbsp;(
																		<asp:TextBox runat="server" maxLength="3" id="HomeAreaCode" name="HomeAreaCode" width="50" />
																		&nbsp;)&nbsp;
																		<asp:TextBox runat="server" maxLength="3" id="HomeLocalExchange" name="HomeLocalExchange" width="50" />
																		&nbsp;-
																		<asp:TextBox runat="server" maxLength="4" id="HomePhone" name="HomePhone" width="80" />
																		<asp:RequiredFieldValidator runat="server" ControlToValidate="HomePhone" Display="Dynamic" ErrorMessage="* 'Home phone' must not be left blank." />
																		<asp:CustomValidator runat="server" ControlToValidate="HomePhone" 
                                    OnServerValidate="CheckPhone_Server"
                                    ClientValidationFunction="CheckPhone_Client"
                                    Display="Dynamic" ErrorMessage="* Wrong phone format." />
																		<BR>
																		Work phone ( optional)&nbsp;(
																		<asp:TextBox runat="server" maxLength="3" id="WorkAreaCode" name="WorkAreaCode" width="50" />
																		&nbsp;)&nbsp;
																		<asp:TextBox runat="server" maxLength="3" id="WorkLocalExchange" name="WorkLocalExchange" width="50" />
																		&nbsp;-
																		<asp:TextBox runat="server" maxLength="4" id="WorkPhone" name="WorkPhone" width="80" />
																		&nbsp;Ext.#&nbsp;
																		<asp:TextBox runat="server" maxLength="5" id="WorkExt" name="WorkExt" width="50" />
																		&nbsp;
																		<BR>
																		Cell Phone#&nbsp;(
																		<asp:TextBox runat="server" maxLength="3" id="MobileAreaCode" name="MobileAreaCode" width="50" />
																		&nbsp;)&nbsp;
																		<asp:TextBox runat="server" maxLength="3" id="MobileLocalExchange" name="MobileLocalExchange" width="50" />
																		&nbsp;-
																		<asp:TextBox runat="server" maxLength="4" id="MobilePhone" name="MobilePhone" width="80" />
																		<BR>
																		Birthdate Month&nbsp; 
																		<asp:DropDownList runat="server" id="cmbMonth" Height="21px" Width="100px">                                    
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
                                    </asp:DropDownList>&nbsp;&nbsp;&nbsp;
                                    Day <asp:DropDownList runat="server" id="cmbDay" Height="21px" Width="50px">
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
                                      </asp:DropDownList>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                      Year&nbsp; <asp:DropDownList runat="server" id="cmbYear" Height="21px" Width="78px" name="cmbYear">
																		</asp:DropDownList>
                                    <asp:CustomValidator runat="server" id="age_check" name="age_check" 
                                    ControlToValidate="cmbYear" OnServerValidate="CheckAge_Server"
                                    ClientValidationFunction="CheckAge_Client" 
                                    Display="Dynamic" ErrorMessage="* You must be at least 18 years old to register." 
                                    Wrapping=NoWrap />
																		<BR>
																		Gender
																		<asp:RadioButton runat="server" Checked="true" ID="male" Text="Male" GroupName = "sex" />
																		&nbsp;&nbsp;&nbsp;
																		<asp:RadioButton runat="server" ID="female" Text="Female" GroupName = "sex" />
																		<BR>
																		<a href="statement.html">Privacy Statement</a>
																		<br>
																		<asp:Checkbox runat="server" id="privacy" name="privacy" checked="false" Text="I affirm that I have read and agree to the Beshert Privacy Policy and<BR>Terms of Use Agreement. 
                                     I also confirm that I am at least 18 years of age." />
																		<asp:CustomValidator runat="server" ControlToValidate="HomeAreaCode" 
                                    OnServerValidate="ValidatePrivacy_Server"
                                    Display="Dynamic" ErrorMessage="* You must check this box in order to proceed." />
																		<BR>
																		<a href="statement.html">Terms and Conditions a</a>
																		<br>
																		<asp:Checkbox runat="server" id="terms" name="terms" checked="false" Text="I agree with terms and conditions" />
																		<BR>
																		<asp:CustomValidator runat="server" ControlToValidate="HomeAreaCode" 
                                    OnServerValidate="ValidateTerms_Server"
                                    Display="Dynamic" ErrorMessage="* You must check this box in order to proceed." />
																		<!-- -->
																		<BR>
																		<asp:Button id="SubmitExit" runat="server" Text="Save & Exit" alt="Save & Exit" border="0" name="RegisterExit" OnClick="Save_Basic" />
																		&nbsp;&nbsp;&nbsp;
																		<asp:Button id="SubmitContinue" runat="server" Text="Save & Continue" alt="Save & Continue" border="0" name="RegisterContinue" OnClick="Save_Continue" />
																	</form>
																	<BR>
															</TD>
														</TR>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
									</TBODY>
								</TABLE>
							</TD>
						</TR>
					</TBODY>
				</TABLE>
		</BODY>
</HTML>
