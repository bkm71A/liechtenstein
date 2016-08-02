<%@ page buffer="1024kb" language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<jsp:directive.page import="com.inchecktech.dpm.dao.DataBucket"/>
<jsp:directive.page import="com.inchecktech.dpm.beans.ICNode"/>
<jsp:directive.page import="com.inchecktech.dpm.beans.RawData"/>
<jsp:directive.page import="com.inchecktech.dpm.beans.RawData"/>
<jsp:directive.page import="com.inchecktech.dpm.beans.DSPCoreDump"/>

<jsp:directive.page import="java.util.Vector"/>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%
        response.setContentType("application/vnd.ms-excel");
%>

<html>
  <head>
    <base href="<%=basePath%>">
    
    <title></title>
    
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
        <meta http-equiv="expires" content="0">    
        <!--
        <link rel="stylesheet" type="text/css" href="styles.css">
        -->

  </head>
  
  <body>

        <table>

        <%
                DSPCoreDump dspCoreDump=DataBucket.getDSPCoreDump(Integer.parseInt(request.getParameter("chid")));

                if (dspCoreDump == null) {
                        %>
                        No Debug Data Available: The Channel <%=request.getParameter("chid")%> is most likley not in the debug mode...  Channel may experien
ce other problems preventing the data to be distributed to DPM engine.
                        <%

                } else {

                        List<List<Double>> dataSets = dspCoreDump.getDataSets();
                        List<String> dataSetLabels = dspCoreDump.getDataSetLabels();
                        List<String> metaData = dspCoreDump.getMetaData();

                        // print headers
                        %>
                        <tr><td>Overalls And Other Info</td>
                        <%
                        for (String str : dataSetLabels) {
                                %>
                                        <td>
                                <%=str%>
                                        </td>
                                <%
                        }
                        %>
                        </tr>
                        <%

                        // print data
                        int max = dspCoreDump.getMaxDataSetLength();
                                for (int i=0; i<max; i++) {

                                        %>
                                        <tr>
                                        <%

                                        %><td><%
                                        try {
                                                %><%=metaData.get(i)%></td><%
                                        } catch (Exception e) {
                                                %></td><%
                                        }

                                        for (int j=0; j<dataSets.size();j++) {
                                                %><td><%
                                                try {
                                                        %><%=dataSets.get(j).get(i)%></td><%
                                                } catch (Exception e) {
                                                        %></td><%
                                                }
                                        }
                                        %>
                                        </tr>
                                        <%
                                }


                }

        %>

        </table>

  </body>
</html>