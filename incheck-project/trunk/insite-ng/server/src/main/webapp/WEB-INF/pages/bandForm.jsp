<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="bandDetail.title"/></title>
    <meta name="heading" content="<fmt:message key='bandDetail.heading'/>"/>
</head>

<s:form id="bandForm" action="saveBand" method="post" validate="true">
    <li style="display: none">
        <s:hidden key="band.id"/>
    </li>
    <s:textfield key="band.bandCoefficient" required="true" maxlength="255" cssClass="text medium"/>
    <s:textfield key="band.endFrequency" required="true" maxlength="255" cssClass="text medium"/>
    <s:textfield key="band.name" required="true" maxlength="100" cssClass="text medium"/>
    <s:textfield key="band.startFrequency" required="true" maxlength="255" cssClass="text medium"/>

    <li class="buttonBar bottom">
        <s:submit cssClass="button" method="save" key="button.save" theme="simple"/>
        <c:if test="${not empty band.id}">
            <s:submit cssClass="button" method="delete" key="button.delete"
                onclick="return confirmDelete('Band')" theme="simple"/>
        </c:if>
        <s:submit cssClass="button" method="cancel" key="button.cancel" theme="simple"/>
    </li>
</s:form>

<script type="text/javascript">
    Form.focusFirstElement($("bandForm"));
</script>
