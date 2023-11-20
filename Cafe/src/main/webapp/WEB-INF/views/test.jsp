<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core" %>




<c:if test = "${tests ne null}">
${tests}
</c:if>

<c:import url = "/cafe/getJstlTest">
	<c:param name = "paramName" value = "ÀºÃ¤Â¯Â¯" />
</c:import>
