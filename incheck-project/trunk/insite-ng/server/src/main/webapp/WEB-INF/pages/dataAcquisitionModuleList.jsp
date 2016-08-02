<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="dataAcquisitionModuleList.title"/></title>
    <meta name="heading" content="<fmt:message key='dataAcquisitionModuleList.heading'/>"/>
    <meta name="menu" content="DataAcquisitionModuleMenu"/>
</head>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/config/editDataAcquisitionModule"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<display:table name="dataAcquisitionModules" class="table" requestURI="" id="dataAcquisitionModuleList" export="true" pagesize="25">
    <display:column property="id" sortable="true" href="editDataAcquisitionModule" media="html"
        paramId="id" paramProperty="id" titleKey="dataAcquisitionModule.id"/>
    <display:column property="id" media="csv excel xml pdf" titleKey="dataAcquisitionModule.id"/>
    <display:column property="serialNumber" sortable="true" titleKey="dataAcquisitionModule.serialNumber"/>  
    <display:column property="deviceType" sortable="true" titleKey="dataAcquisitionModule.deviceType"/>
    <display:column property="description" sortable="true" titleKey="dataAcquisitionModule.description"/>
    <display:setProperty name="paging.banner.item_name"><fmt:message key="dataAcquisitionModuleList.dataAcquisitionModule"/></display:setProperty>
    <display:setProperty name="paging.banner.items_name"><fmt:message key="dataAcquisitionModuleList.dataAcquisitionModules"/></display:setProperty>
    <display:setProperty name="export.excel.filename"><fmt:message key="dataAcquisitionModuleList.title"/>.xls</display:setProperty>
    <display:setProperty name="export.csv.filename"><fmt:message key="dataAcquisitionModuleList.title"/>.csv</display:setProperty>
    <display:setProperty name="export.pdf.filename"><fmt:message key="dataAcquisitionModuleList.title"/>.pdf</display:setProperty>
</display:table>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/config/editDataAcquisitionModule"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<script type="text/javascript">
    highlightTableRows("dataAcquisitionModuleList");
</script>
