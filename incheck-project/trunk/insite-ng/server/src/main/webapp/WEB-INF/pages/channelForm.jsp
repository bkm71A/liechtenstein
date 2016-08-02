<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="channelDetail.title"/></title>
    <meta name="heading" content="<fmt:message key='channelDetail.heading'/>"/>
</head>

<s:form id="channelForm" action="saveChannel" method="post" validate="true">
    <li style="display: none">
        <s:hidden key="channel.id"/>
    </li>
    <s:textfield key="channel.comments" required="false" maxlength="300" cssClass="text medium"/>
<li>
    <s:checkbox key="channel.isDynamic" cssClass="checkbox" theme="simple"/>
    <!-- For some reason, key prints out the raw value for the label (i.e. true) instead of the i18n key: https://issues.apache.org/struts/browse/WW-1958-->
    <s:label for="channelForm_channel_isDynamic" value="%{getText('channel.isDynamic')}" cssClass="choice desc" theme="simple"/>
</li>
    <%-- Slava TODO : change this to read the identifier field from the other pojo 
    <s:select name="channel.measureType.id" list="measureTypeList" listKey="id" listValue="id"></s:select>
     todo: change this to read the identifier field from the other pojo 
    <s:select name="channel.sensor.id" list="sensorList" listKey="id" listValue="id"></s:select> --%>

    <li class="buttonBar bottom">
        <s:submit cssClass="button" method="save" key="button.save" theme="simple"/>
        <c:if test="${not empty channel.id}">
            <s:submit cssClass="button" method="delete" key="button.delete"
                onclick="return confirmDelete('Channel')" theme="simple"/>
        </c:if>
        <s:submit cssClass="button" method="cancel" key="button.cancel" theme="simple"/>
    </li>
</s:form>

<script type="text/javascript">
    Form.focusFirstElement($("channelForm"));
</script>
