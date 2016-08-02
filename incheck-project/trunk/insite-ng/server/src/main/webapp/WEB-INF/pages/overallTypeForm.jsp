<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="overallTypeDetail.title"/></title>
    <meta name="heading" content="<fmt:message key='overallTypeDetail.heading'/>"/>
</head>

<s:form id="overallTypeForm" action="saveOverallType" method="post" validate="true">
    <li style="display: none">
        <s:hidden key="overallType.id"/>
    </li>
    <s:textfield key="overallType.name" required="true" maxlength="50" cssClass="text medium"/>    
    <s:textfield key="overallType.description" required="true" maxlength="255" cssClass="text medium"/>
    <li class="buttonBar bottom">
        <s:submit cssClass="button" method="save" key="button.save" theme="simple"/>
        <c:if test="${not empty overallType.id}">
            <s:submit cssClass="button" method="delete" key="button.delete"
                onclick="return confirmDelete('OverallType')" theme="simple"/>
        </c:if>
        <s:submit cssClass="button" method="cancel" key="button.cancel" theme="simple"/>
    </li>
</s:form>

<script type="text/javascript">
    Form.focusFirstElement($("overallTypeForm"));
</script>
