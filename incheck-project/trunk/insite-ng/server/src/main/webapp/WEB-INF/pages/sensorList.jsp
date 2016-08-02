<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="sensorList.title"/></title>
    <meta name="heading" content="<fmt:message key='sensorList.heading'/>"/>
    <meta name="menu" content="SensorMenu"/>
</head>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/config/editSensor"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<display:table name="sensors" class="table" requestURI="" id="sensorList" export="true" pagesize="25">
    <display:column property="id" sortable="true" href="editSensor" media="html"
        paramId="id" paramProperty="id" titleKey="sensor.id"/>
    <display:column property="id" media="csv excel xml pdf" titleKey="sensor.id"/>
    <display:column property="name" sortable="true" titleKey="sensor.name"/>    
    <display:column property="comments" sortable="true" titleKey="sensor.comments"/>
    <display:setProperty name="paging.banner.item_name"><fmt:message key="sensorList.sensor"/></display:setProperty>
    <display:setProperty name="paging.banner.items_name"><fmt:message key="sensorList.sensors"/></display:setProperty>

    <display:setProperty name="export.excel.filename"><fmt:message key="sensorList.title"/>.xls</display:setProperty>
    <display:setProperty name="export.csv.filename"><fmt:message key="sensorList.title"/>.csv</display:setProperty>
    <display:setProperty name="export.pdf.filename"><fmt:message key="sensorList.title"/>.pdf</display:setProperty>
</display:table>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/config/editSensor"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<script type="text/javascript">
    highlightTableRows("sensorList");
</script>
