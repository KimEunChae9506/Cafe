<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./header.jsp" %>
<script type="text/javascript">
function finalPay() {
    var xhr = new XMLHttpRequest(); 
    var p = $("#paymoney").val();
	p =  parseInt(p);
	document.getElementById("payment").style.display = 'block';
	document.getElementById("userpay").innerHTML = p;

		if(p == ""){
			alert("금액을 넣어주세요");
		}
		
		if(p < ${totalPrice}){
			alert("금액이 부족합니다");
			//document.getElementById("changediv").innerHTML = ${totalPrice} - p + "원 을 더 넣어주세요";
			$("#changediv").html(${totalPrice} - p + "원 을 더 넣어주세요");
		}
				
		if(p >= ${totalPrice}){
			var $frm = $('.frmPay :input');
			var param = $frm.serialize();
			
			document.getElementById("changediv").style.display = 'none';
			document.getElementById("finalPay").style.display = 'block';
			document.getElementById("change").innerHTML = p - ${totalPrice} + "원";
			
		    xhr.onreadystatechange = function() {
		      if (xhr.readyState === 4) {
		        if (xhr.status === 200) {
		        	alert("결제성공");
			    	document.getElementById("main").style.display = 'block';
			    	if(${user.phone != null}){
				    		document.getElementById("userUpdate").style.display = 'block';
				    		document.getElementById("userDelete").style.display = 'block';
					}
		        }else{
		        	alert("결제실패");
		        }
		      }
		    };

		    xhr.open("POST", "/cafe/finalPay", true);
		    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		    xhr.send(param);
		  }
}


//엔터 체크	
function pressCheck() {   
	if (window.event.keyCode == 13) {
		finalPay();
	} else{
		return false;
	}
}

var usr = {
	usrUpdate: function(originP,newP){
	//파라미터로 변경폰넘버 인풋을 넣고, 보내는 데이타도 파람인거지
		$.ajax({
			data : {"phone" : originP, "phone2" : newP},//카트vo 모든 인풋
			url : "/cafe/userUpdate",
			type : "POST",
			dataType : "text" //컨트롤러에서 반환하는 값이 string 이니까
		}).done(function(data, state, msg){
			alert("수정성공");
			location.href = "/cafe/menu";
		}).fail(function(result, state, msg){
			alert("수정실패. 중복된 정보가 있습니다");
			alert(result+"/"+ state+"/"+ msg);
		}).always(function(){
			alert("초기화면으로 돌아갑니다");
		});
	},
	useDelete: function(phone){
		$.ajax({
			url:"/cafe/userDelete",
			data : {"phone" : phone},
			//dataType : "text",
			type : "POST"
		}).done(function(data){
			console.log("data ---->" + data);
			alert("탈퇴성공");
		}).fail(function(xhr,state,errorThrown){
			alert("탈퇴실패");
		}).always(function(){
		})
	}
 };
 
function userUpdate(){
	/* var xhr = new XMLHttpRequest(); 
	var $frm = $('.frmUserUpdate :input');
	var param = $frm.serialize();
	xhr.onreadystatechange = function() {
	      if (xhr.readyState === 4) {
	        if (xhr.status === 200) {
	        	alert("수정성공");
	        	location.href = "/cafe/menu";
	        } else{
	        	alert("수정실패. 중복된 정보가 있습니다");
	        }
	      }
	    };

	    xhr.open("POST", "/cafe/userUpdate", true);
	    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	    xhr.send(param);  */
	var originP = $("#frmUserUpdate input[name='phone']").val();
	var newP = $("#frmUserUpdate input[name='phone2']").val();
    //num = $("#updatePhone").val();
    usr.usrUpdate(originP,newP);
}

//수정엔터체크
function pressCheck2() {   
	if (window.event.keyCode == 13) {
		userUpdate();
	} else{
		return false;
	}
}

function userDelete(){
	/* var xhr = new XMLHttpRequest(); 
	var $frm = $('.frmPay :input');
	var param = $frm.serialize(); */

	if(confirm("탈퇴하시겠습니까?")){
	/* xhr.onreadystatechange = function() {
	      if (xhr.readyState === 4) {
	        if (xhr.status === 200) {
	        	alert("탈퇴성공");
	        	location.href = "/cafe/menu";
	        } else{
	        	alert("탈퇴실패");
	        }
	      }
	    };
	    xhr.open("POST", "/cafe/userDelete", true);
	    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	    xhr.send(param); */

	    var phone = $("input[name='phone']").val();
	    usr.useDelete(phone);

	}
}

function fresh(){//그냥 해본 페이지 새로고침 함수
	setTimeout('location.reload()',5000);
}

function getCookie(name){ //쿠키값 가져오기
	var cookName = "";
	cookName = name + "=";
	var cookie = document.cookie;
	
	var phoneCook = cookie.substring(cookie.indexOf("=")+1);
	console.log(cookName);
	console.log(cookName.length);
	console.log(cookie);
	console.log(unescape(cookie));
	console.log(phoneCook);

	document.getElementById("cookId").value = phoneCook;
	document.getElementById("paymoney").value = phoneCook;
}
$(document).ready(function(){
	//getCookie("cookieId"); 아이디값 저장 예시
//뒤로가기
$("#back").click(function(){
	if(${user == null}){ //회원확인창
		window.history.back();
	} else { //쿠폰확인창
		
		location.href = "/cafe/coupon";
		/* $.ajax({ //get으로 쿠폰 페이지 갖고올 때 이미 user 정보가 있어 굳이 ajax 필요없음
			url : "/cafe/coupon",
			type : "POST",
			data : {"phone" : $("#phone").val()},
			success : function()
			{	
				location.href = "/cafe/coupon";	
			},
			error : function(jqXHR, textStatus, errorThrown)
			{
				alert("회원확인실패");
			}
		}); 
		*/
	}
  })
});
</script>
<div class="couponbox">
<i id="back" class="fa fa-arrow-left"></i>
<form class="frmPay">
	<input type="hidden" id = "phone" name = "phone" value="${user.phone}">	
</form>

	<div class="couponuser">
		<span class=couponusername>
		<c:if test="${totalPrice <= 0}">
			<c:set var = "totalPrice" value = "0"></c:set>
		</c:if>
			<b>총 &nbsp;${totalPrice}&nbsp;원 입니다.
			금액을 넣어주십시오</b>
			<input type="hidden" id = "cookId"><!-- 쿠키값 가져오기 인풋 예제 -->
		</span>
		<span class="payment">
			<input id="paymoney" style="border:0;" onkeypress="pressCheck();" type="text" value="">
			<input id="payBt" type="button"  onclick = "finalPay();" class="btfont payBt" value="지출하기">
		</span>
	</div>
		<span id = "payment" class="couponYN" style="display:none">
			<span id = "userpay"></span>원 을 넣으셨습니다<br>
			<span id = "changediv"></span>
		</span>
		<span id="finalPay">
			결제 되었습니다.<br>
			잔액은 <span id = "change"></span> 입니다.			
		</span>
		<input id="main" class="join btfont none" style = "background-color:#F7819F; font-size: 15px; border-radius: 10px;" type="button" value="메인으로">
		<input id="userUpdate" class="join btfont none" style = "background-color:#F7819F; font-size: 15px; border-radius: 10px;" type="button" value="회원수정" onclick="popUp('','','','');">
		<input id="userDelete" class="join btfont none" onclick = "userDelete();" style = "background-color:#F7819F; font-size: 15px; border-radius: 10px;" type="button" value="화원탈퇴">
	<form class="frmUserUpdate" name = "frmUserUpdate" id = "frmUserUpdate" style="z-index:100; position:absolute">
		<div id = "pop" class= "popUp" style="opacity:1; text-align:center">
		<i class="fa fa-times"  id="close"></i>
			<span>${user.name} 님</span>
			<div class= "in_popup_num align font" style="font-size: 15px;">수정할 번호 입력
			</div>
			<div class= "in_popup_shot align" >
				<input type="hidden" id = "updatePhone" name = "phone" value="${user.phone}">	
				<input type="text" class="phoneNum" value="" id = "updatePhone2" name = "phone2" onkeypress="pressCheck2();">
			</div>
		<div class="putchk align" style="left:-5px;">
			<input  id="phone2submit" style="background-color: #8A0868" onclick = "userUpdate();" class="phonesubmit font btfont" type="button" value="확인">
		</div>
		</div>
	</form>
	</div>
<%@ include file="./total.jsp" %>
</div>
<%@ include file="./footer.jsp" %>