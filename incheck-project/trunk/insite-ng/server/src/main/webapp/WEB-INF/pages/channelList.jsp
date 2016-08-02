<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="channelList.title"/></title>
    <meta name="heading" content="<fmt:message key='channelList.heading'/>"/>
    <meta name="menu" content="ChannelMenu"/>
</head>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/config/editChannel"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<display:table name="channels" class="table" requestURI="" id="channelList" export="true" pagesize="25">
    <display:column property="id" sortable="true" href="editChannel" media="html"
        paramId="id" paramProperty="id" titleKey="channel.id"/>
    <display:column property="id" media="csv excel xml pdf" titleKey="channel.id"/>
    <display:column property="comments" sortable="true" titleKey="channel.comments"/>
    <%-- display:column sortProperty="isDynamic" sortable="true" titleKey="channel.isDynamic">
        <input type="checkbox" disabled="disabled" <c:if test="${channelList.channelType}">checked="checked"</c:if>/>
    </display:column --%>

    <display:setProperty name="paging.banner.item_name"><fmt:message key="channelList.channel"/></display:setProperty>
    <display:setProperty name="paging.banner.items_name"><fmt:message key="channelList.channels"/></display:setProperty>

    <display:setProperty name="export.excel.filename"><fmt:message key="channelList.title"/>.xls</display:setProperty>
    <display:setProperty name="export.csv.filename"><fmt:message key="channelList.title"/>.csv</display:setProperty>
    <display:setProperty name="export.pdf.filename"><fmt:message key="channelList.title"/>.pdf</display:setProperty>
</display:table>

<input type="button" style="margin-right: 5px" class="button" onclick="location.href='<c:url value="/config/editChannel"/>'" value="<fmt:message key="button.add"/>"/>
<input type="button" class="button" onclick="location.href='<c:url value="/mainMenu"/>'" value="<fmt:message key="button.done"/>"/>

<script type="text/javascript">
    highlightTableRows("channelList");
</script>
