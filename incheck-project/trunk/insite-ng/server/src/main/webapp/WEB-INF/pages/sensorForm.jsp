<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="sensorDetail.title"/></title>
    <meta name="heading" content="<fmt:message key='sensorDetail.heading'/>"/>
</head>

<s:form id="sensorForm" action="saveSensor" method="post" validate="true">
    <li style="display: none">
        <s:hidden key="sensor.id"/>
    </li>
    <s:textfield key="sensor.comments" required="false" maxlength="100" cssClass="text medium"/>
    <%-- Slava TODO : change this to read the identifier field from the other pojo 
    <s:select name="sensor.dam.id" list="damList" listKey="id" listValue="id"></s:select> --%>
    <s:textfield key="sensor.name" required="true" maxlength="100" cssClass="text medium"/>

    <li class="buttonBar bottom">
        <s:submit cssClass="button" method="save" key="button.save" theme="simple"/>
        <c:if test="${not empty sensor.id}">
            <s:submit cssClass="button" method="delete" key="button.delete"
                onclick="return confirmDelete('Sensor')" theme="simple"/>
        </c:if>
        <s:submit cssClass="button" method="cancel" key="button.cancel" theme="simple"/>
    </li>
</s:form>

<script type="text/javascript">
    Form.focusFirstElement($("sensorForm"));
</script>
