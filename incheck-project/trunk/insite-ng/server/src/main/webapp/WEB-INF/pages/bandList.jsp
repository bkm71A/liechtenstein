<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="bandList.title"/></title>
    <meta name="heading" content="<fmt:message key='bandList.heading'/>"/>
    <meta name="menu" content="BandMenu"/>
</head>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/editBand"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<display:table name="bands" class="table" requestURI="" id="bandList" export="true" pagesize="25">
    <display:column property="id" sortable="true" href="editBand" media="html"
        paramId="id" paramProperty="id" titleKey="band.id"/>
    <display:column property="id" media="csv excel xml pdf" titleKey="band.id"/>
    <display:column property="bandCoefficient" sortable="true" titleKey="band.bandCoefficient"/>
    <display:column property="endFrequency" sortable="true" titleKey="band.endFrequency"/>
    <display:column property="name" sortable="true" titleKey="band.name"/>
    <display:column property="startFrequency" sortable="true" titleKey="band.startFrequency"/>

    <display:setProperty name="paging.banner.item_name"><fmt:message key="bandList.band"/></display:setProperty>
    <display:setProperty name="paging.banner.items_name"><fmt:message key="bandList.bands"/></display:setProperty>

    <display:setProperty name="export.excel.filename"><fmt:message key="bandList.title"/>.xls</display:setProperty>
    <display:setProperty name="export.csv.filename"><fmt:message key="bandList.title"/>.csv</display:setProperty>
    <display:setProperty name="export.pdf.filename"><fmt:message key="bandList.title"/>.pdf</display:setProperty>
</display:table>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/editBand"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<script type="text/javascript">
    highlightTableRows("bandList");
</script>
