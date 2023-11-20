<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./header.jsp" %>
<style type="text/css">
	input[type="number"]::-webkit-inner-spin-button, input[type="number"]::-webkit-outer-spin-button{-webkit-appearance:none;margin:0;}
</style>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#joinuser").on("click",function(){
		if(confirm("입력하신 가입정보가 " + $("#joinname").val() + "  /  " + $("#joinnum").val() + " 맞습니까?")){
			var $frm = $('.joinfrm :input');
			var param = $frm.serialize();
			$.ajax({
			    url : "/cafe/join",
			    dataType: "json",
			    type: "POST",
			    data : param,
			    success: function(data)
			    {
					alert("가입완료");
					location.href = "/cafe/userChk";
			    },
			    error: function (jqXHR, textStatus, errorThrown)
			    {
			    	alert("이미 가입한 회원입니다");
			    }
			}); 

			/* $.ajax({
				url : "/cafe/join",
			    dataType: "json",
			    type: "POST",
			    data : param
			}).done(function(result,state,resultMap){
				alert("1="+result + "2="+state + "3=" + resultMap);
				alert("가입완료");
				
			}).fail(function(resultMap,resultName,responseErrorMsg){
				alert("1=" + resultMap + "2=" + resultName + "3=" + responseErrorMsg);
				alert("이미 가입된 회원입니다");
			}).always(function(){
				alert("완료");
				location.href="/cafe/userChk";
			}); */
		}

		
	});
});
</script>
<div class="userchkbox">
<i id="back" class="fa fa-arrow-left"></i>
<form name="joinfrm" class="joinfrm">
	<div class="loginYN" style="left:150px; top:-50px">
		<div class= "in_popup_num align font">이름</div>
			<div class= "in_popup_shot align">
					<input type="text" class="phonesubmit" id="joinname" value="" name = "name" >
			</div>
		<div class= "in_popup_num align font" style="margin-top:150px">번호</div>
			<div class= "in_popup_shot align" style="margin-top:200px; top:40px;">
					<input type="number" class="phonesubmit" id="joinnum" value="" name = "phone" >
			</div>
		<div class="putchk align" style="top:350px; left:-5px;">
			<input  id="joinc" class="joinsubmit btfont" style = "margin-right:4px; background-color:#F5A9E1;" type="button" value="취소">
			<input  id="joinuser" class="joinsubmit btfont" style = "background-color:#8A0868;" type="button" value="가입">
	</div>
	</div>
</form>	
</div>
<%@ include file="./total.jsp" %>
</div>
<%@ include file="./footer.jsp" %>

			