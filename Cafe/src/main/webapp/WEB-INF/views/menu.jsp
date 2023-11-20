<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./header.jsp" %>
<script type="text/javascript">


$(document).ready(function(){
/* 	$.ajax({
	    url : "/cafe/total",
	    //dataType: "json",
	    type: "POST",
	    success: function(data)
	    {	
			alert(data);
	    },
	    error: function (jqXHR, textStatus, errorThrown)
	    {
	    	alert("회원확인실패");
	    }
	}); */

	if(${couontError == 1}){
			alert("상품은 10개까지 선택 가능합니다.");
	}
	//쿠키 삭제(자바단에서 안 됨. 애초 스크립트로 저장 했으니 스크립트로 삭제)
	$("input:checkbox[name='logout']").click(function(){
		if($(this).prop("checked")){
			$(this).prop("checked",true);
			document.cookie = 'cookieId=; expires=Thu, 01 Jan 1970 00:00:01 GMT;domain=localhost;path=/;';
			$.ajax({
				url : "/cafe/logout",
				type : "POST"
			}).done(function(){
				alert("로그아웃 체크하셨습니다.");
			}).fail(function(result,xhr,msg){
				alert("로그아웃 실패");
			}).always(function(){
			})
		} else {
			$(this).prop("checked",false);
		}				
	})				
	

})

</script>

<div class="menubox" id="menubox">
<c:if test = "${payBt == 2 }">
	<input type="checkbox" name = "logout" id = "logout" ${logout eq 'Y'?'checked':''} >로그아웃
</c:if>
 <script>
	var logChk = "안뇽"; //jsp에서 지정한 변수가, 참조하는 js에서 그대로 쓰일 수 있다.
 </script>
	<c:forEach items="${menuList}" var="list">	
			<c:choose>
				<c:when test="${list.stock > 0}">
				<div id="menu" onclick = "popUp('${list.names}','${list.price}','${list.id}','${list.stock}');" >
				<input type = "image" alt="사진" src="${list.cafe}" class="img" >
					<div class="bdiv">
						<img src = "/resource/images/핑크.png" onerror = "this.src='/resource/images/커피.jpg'">	
					</div>
					<span class="menuname">
					 <!--  <a href = "javascript:popUp('${list.names}','${list.price}','${list.id}','${list.stock}');">
						${list.names}
					</a> -->
					${list.names}
					</span>
					<span class="menuprice">
						&nbsp;&nbsp;${list.price}&nbsp; &#8361;
					</span>
				</div>	
				</c:when>
				<c:otherwise>
				<div id="menu"><input type = "image" alt="사진" src="${list.cafe}" class="soldout cursor"><span class="soldouts">sold out</span>
					<div class="bdiv">
						<img style="cursor:default" src = "/resource/images/핑크.png">	
					</div>
					<span class="menuname" style="cursor:default">	
						${list.names}
					</span>
					<span class="menuprice" style="cursor:default">
						${list.price}&nbsp; &#8361;
					</span>
					</div>
				</c:otherwise>
			</c:choose>								
	</c:forEach>	
</div>
<form id = "frmMenu" method="post" style="z-index:100; position:absolute">
<input type="hidden" id="in_final" name="final" value="">
<input type="hidden" id="in_name" name="frmname" value="">
<input type="hidden" id="in_id" name = "in_id" value="">
<input type="hidden" id="in_stock" name = "stock" value="">
<div id = "pop" class= "popUp" style="opacity:1;" onmouseover = "tooltip(this);">
		<i class="fa fa-times"  id="close"></i>
		<span id="p_name" class= "in_popup"></span>
		<span id="p_price" class= "in_popup_p"></span>
			<div class= "in_popup_num font">수량:&nbsp;&nbsp;&nbsp;&nbsp;
				<i class="fa fa-minus"  id="n_minus"></i>
					<input type="text" name = "popup_num" id="popup_num" value="1">
				<i class="fa fa-plus" style="margin-left:125px" id="n_plus"></i>
			</div>
			<div class= "in_popup_shot font">샷추가:&nbsp;<br>(+500원)
				<i class="fa fa-minus"  id="s_minus"></i>
					<input type="text" id="popup_shot" value="0" name = "popup_shot" >
				<i class="fa fa-plus" style="margin-left:117px" id="s_plus"></i>
			</div>
		    <span id="final" class= "in_popup_p"></span><span class= "in_popups">원</span>
	<div class="putchk">
			<input  id="put_c" class="put_c btfont" type="button" value="취소">
			<input id="put" class="put_p btfont" type="button" value="담기">
	</div>
</div>
</form>
<%@ include file="./total.jsp" %>
</div>
<%@ include file="./footer.jsp" %>
