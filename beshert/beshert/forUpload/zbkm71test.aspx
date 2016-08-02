<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server" language="c#">
  System.String connectionString = "server=209.133.228.101;uid=beshert;pwd=bkm71;database=beshert";

  /* Called on page load */
  protected void Page_Load(Object sender, EventArgs e) {
    if ( ! IsPostBack ) {
      bind_table();
    }
  }

  /* Bind data to table */
  void bind_table() {
    String selectString = "SELECT P.ID [User Name],P.PASSWORD [Password], P.EMAIL [E-Mail Address], P.FIRST_NAME [First Name], P.LAST_NAME [Last Name], "
    +" P.STREET [Address Line],P.APT [Apartment], P.CITY [City], S.DESCRIPTION [State], P.ZIP [Zip Code], P.HOME_PHONE [Home Phone], "
    +"P.WORK_PHONE [Work Phone], P.CELL_PHONE [Cell Phone], P.SEX [Gender], P.BIRTHDATE [Birthday], "
    +"P.REGISTRATION_DATE [Registration Date] "
    +"FROM PERSON P INNER JOIN STATE S ON "
    +"P.STATE = S.CODE "
    +"ORDER BY ID ";
    SqlConnection connection = new SqlConnection(connectionString);
    connection.Open();
    SqlCommand getData = new SqlCommand(selectString,connection);
    SqlDataReader reader = getData.ExecuteReader();
    PERSON_TEST.DataSource = reader;
    PERSON_TEST.DataBind();
    reader.Close();
    connection.Close();
 }

</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html><head><title>Test page</title></head><body>
  <asp:DataGrid id="PERSON_TEST" runat="server" AutoGenerateColumns="True" GridLines="Vertical"
  Width="100%" CellPadding="4" CellSpacing="0" HeaderStyle-BackColor="maroon" HeaderStyle-ForeColor="#FFFFFF"
  HeaderStyle-Font-Size="10" HeaderStyle-Font-Bold="true" HeaderStyle-Font-Name="Verdana"
  ItemStyle-BackColor="Green"  ItemStyle-ForeColor="White"  ItemStyle-Font-Size="8"  ItemStyle-Font-Bold="true"  ItemStyle-Font-Name="Verdana"
  AlternatingItemStyle-BackColor="White"  AlternatingItemStyle-ForeColor="Black"  AlternatingItemStyle-Font-Size="8"  
  AlternatingItemStyle-Font-Bold="true"  AlternatingItemStyle-Font-Name="Verdana" />
</body></html>
