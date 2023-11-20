<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<aside class="totalbox">
		<div class="append">
		 <c:forEach items="${cartList}" var="list" varStatus="status">
		 <form id = "cartfrm" method="post">
		 <input type="hidden" name="cartc" value="${status.index}">
		 <div class="cartbox">
		 <span class="hspan" style="width: 93px; text-align:center;">${list.name}</span>
		<span class="hspan" style="width: 20px; text-align:center;">x ${list.num}</span>
		<c:if test="${list.shot} == 0"></c:if>
		<c:choose>
			<c:when test="${list.shot == 0}"><div class="hspan" style="width: 20px;">x 0</div></c:when>
			<c:otherwise><span class="hspan" style="width: 20px; text-align:left;">x ${list.shot}</span></c:otherwise>
		</c:choose>
		<span class="hspan" style="width: 50px; text-align:center;">${list.price}원</span>
		 <i class="fa fa-times"  id="cartcancel"></i>
		 </div>
		 </form>
		 </c:forEach>
		</div>
		<div style="height:50px; background-color: #F8E0F1">
		<span id = "totalprice">
			총가격:&nbsp;&nbsp;&nbsp;&nbsp;${totalprice} 원
		</span>	
		</div>
			<input  id="cancel" class="btfont" type="button" value="전체취소">
			<input id="pay2" class="btfont" type="button" value="결제">
	</aside>
