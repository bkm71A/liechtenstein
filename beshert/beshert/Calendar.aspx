<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server" language="c#">
  System.String connectionString = "server=localhost;uid=beshert;pwd=bkm71;database=beshert";


</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<script language="JavaScript">
<!--
// -->
	</script>
	<HEAD>
		<TITLE>Register</TITLE>
		<META http-equiv="Content-Type" content="text/html; charset=utf-8">
		<BODY>
			<LINK href="css/beshert.css" type="text/css" rel="stylesheet">
			Calendar&nbsp; 
        <form  runat="server" enctype="multipart/form-data" id="calendar_besh" name="calendar_besh" method="post">

      <asp:Calendar id="tblCalendar" runat="server" Font-Name="Verdana" Font-Size="Large" Font-Bold="True" Font-Italic="False" 
      ForeColor="yellow" BackColor="blue" Alignment="Center" Wrapping="NoWrap" ShowDayHeader="True">

           <OtherMonthDayStyle ForeColor="gray">
           </OtherMonthDayStyle>

           <TitleStyle BackColor="Blue"
                       ForeColor="White">
           </TitleStyle>

           <DayStyle BackColor="White">
           </DayStyle>

           <SelectedDayStyle BackColor="LightGray"
                             Font-Bold="True">
           </SelectedDayStyle>

      </asp:Calendar>

</form>







		</BODY>
</HTML>
