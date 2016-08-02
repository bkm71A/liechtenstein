<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="dataAcquisitionModuleDetail.title"/></title>
    <meta name="heading" content="<fmt:message key='dataAcquisitionModuleDetail.heading'/>"/>
</head>

<s:form id="dataAcquisitionModuleForm" action="saveDataAcquisitionModule" method="post" validate="true">
    <li style="display: none">
        <s:hidden key="dataAcquisitionModule.id"/>
    </li>
    <s:textfield key="dataAcquisitionModule.serialNumber" required="true" maxlength="255" cssClass="text medium"/>
    <s:textfield key="dataAcquisitionModule.deviceType" required="true" maxlength="255" cssClass="text medium"/>
    <s:textfield key="dataAcquisitionModule.description" required="true" maxlength="100" cssClass="text medium"/>
    <li class="buttonBar bottom">
        <s:submit cssClass="button" method="save" key="button.save" theme="simple"/>
        <c:if test="${not empty dataAcquisitionModule.id}">
            <s:submit cssClass="button" method="delete" key="button.delete"
                onclick="return confirmDelete('DataAcquisitionModule')" theme="simple"/>
        </c:if>
        <s:submit cssClass="button" method="cancel" key="button.cancel" theme="simple"/>
    </li>
</s:form>

<script type="text/javascript">
    Form.focusFirstElement($("dataAcquisitionModuleForm"));
</script>
