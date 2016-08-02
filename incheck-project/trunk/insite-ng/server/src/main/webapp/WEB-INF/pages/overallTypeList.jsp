<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="overallTypeList.title"/></title>
    <meta name="heading" content="<fmt:message key='overallTypeList.heading'/>"/>
    <meta name="menu" content="OverallTypeMenu"/>
</head>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/config/editOverallType"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<display:table name="overallTypes" class="table" requestURI="" id="overallTypeList" export="true" pagesize="25">
    <display:column property="id" sortable="true" href="editOverallType" media="html"
        paramId="id" paramProperty="id" titleKey="overallType.id"/>
    <display:column property="id" media="csv excel xml pdf" titleKey="overallType.id"/>
    <display:column property="name" sortable="true" titleKey="overallType.name"/>
    <display:column property="description" sortable="true" titleKey="overallType.description"/>
    <display:setProperty name="paging.banner.item_name"><fmt:message key="overallTypeList.overallType"/></display:setProperty>
    <display:setProperty name="paging.banner.items_name"><fmt:message key="overallTypeList.overallTypes"/></display:setProperty>

    <display:setProperty name="export.excel.filename"><fmt:message key="overallTypeList.title"/>.xls</display:setProperty>
    <display:setProperty name="export.csv.filename"><fmt:message key="overallTypeList.title"/>.csv</display:setProperty>
    <display:setProperty name="export.pdf.filename"><fmt:message key="overallTypeList.title"/>.pdf</display:setProperty>
</display:table>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/config/editOverallType"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<script type="text/javascript">
    highlightTableRows("overallTypeList");
</script>
