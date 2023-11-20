<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./header.jsp" %>
<script type="text/javascript">
//폰번호 로그인
	
	function setCookie(name,value){
		var date = new Date();
		date.setTime(date.getTime()+(60 * 60 * 24 * 7));
		document.cookie = name + "=" + value + ";expires=" + date.toUTCString()+ ";path=/";
	}
	
	function userChk(){
		var p = $("#phoneNum").val();

		if ($("input[name=loginChk]:checked").prop("checked")){ //로그인 유지하기 체크 돼있을 때
			setCookie("cookieId", p);
		}
		if (p == ""){
			alert("번호를 입력해주세요");
		} else {
		$.ajax({
		    url : "/cafe/login",
		    //dataType: "json",
		    type: "POST",
		    data : {"phoneNum" : p},
		    success: function(data) //컨트롤러에서 리스폰스로 클라이언트로 전달 된 데이터(폰번호)
		    {	
				alert("회원확인완료");
				location.href = "/cafe/coupon";
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	alert("가입 되지 않은 회원입니다");
		    }
			});
		}
	}

	function pressCheck(){
		if (window.event.keyCode == 13) {
			userChk();
		} else {
			return false;
		}
	}

function back() {
	window.history.back();
}
</script>
<!--<c:import url="/cafe/json" /> 테스트-->
<div class="userchkbox">
<i id="back" class="fa fa-arrow-left" onclick="javascript:back();"></i>
	<div class="loginYN">
		<input  id="point" class="btfont" type="button" style = "background-color:#FE2E9A; font-size: 20px; border-radius: 10px;" value="쿠폰적립" onclick="popUp('','','','');">
		<input id="nouserpay" class="btfont" style = "background-color:#FE2E9A; font-size: 20px; border-radius: 10px;" type="button" value="결제하기">
		<input id="join" class="btfont" style = "background-color:#F7819F; font-size: 15px; border-radius: 10px;" type="button" value="회원가입">
	</div>
</div>
<form class="userchkfrm" name = "userchkfrm" style="z-index:100; position:absolute">
<div id = "pop" class= "popUp font" style="opacity:1; text-align:center;">
		<i class="fa fa-times"  id="close"></i>
		로그인 상태 유지하기<input type = "checkbox" id = "loginChk" name = "loginChk">		
			<div class= "in_popup_num align" style="font-size: 15px;">번호입력
			</div>
			<div class= "in_popup_shot align" >
					<input type="text" class="phoneNum" id = "phoneNum" value="" name = "phoneNum" onkeypress="pressCheck();">
			</div>
	<div class="putchk align" style="left:-5px;">
		<input  id="phonesubmit" style="background-color: #8A0868" onclick = "userChk();" class="phonesubmit btfont" type="button" value="확인">
	</div>
</div>
</form>
<%@ include file="./total.jsp" %>
</div>
<%@ include file="./footer.jsp" %>