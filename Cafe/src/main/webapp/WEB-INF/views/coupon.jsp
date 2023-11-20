<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./header.jsp" %>
<script type="text/javascript">
//폰번호 로그인
$(document).ready(function(){
	
	$("#couponY").click(function(){
		var $frm = $('.frmCoupon :input');
		var param = $frm.serialize();
		if(${user.coupon + totalNum} < 20){
			if(confirm("결제하시겠습니까?")){
				$.ajax({
				    url : "/cafe/couponPay",
				    //dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data)
				    {	
						location.href = "/cafe/pay";
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("회원확인실패");
				    }
				});
			}
		}else{
					popUp('','','','');
				}
	});

   $("#copuPayChkSubmit").click(function(){//쿠폰개수 20개 이상이라 선택시 뜨는 팝업창 ajax
		var $frm = $('.frmCoupon :input');
		var param = $frm.serialize();
			if(confirm("결제하시겠습니까?")){
				$.ajax({
				    url : "/cafe/couponPay",
				    //dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data)
				    {	
						location.href = "/cafe/pay";
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("쿠폰확인실패");
				    }
				});
			}
	}); 
});

</script>
<div class="couponbox">
	<div class="couponuser">
		<span class=couponusername> ${user.name} 님, 쿠폰 &nbsp;<b
			style="color: #ffff00; font-size: 25px">${totalNum}</b>&nbsp;개 적립 예정입니다
		</span> 
		<span id="couponchkbt"> 
			<input type="button" class="btfont couponchk" value="쿠폰 개수 확인하기">
		</span>
	</div>
	<div class="couponuse" style="display: none" id="couponview">
		<div class="couponview">
			<c:forEach var="i" begin="1" end="${user.coupon}">
				<div class="couponshape"></div>
			</c:forEach>
			<c:if test = "${empty backChk}">
				<c:forEach var="i" begin="1" end="${totalNum}">
					<div class="couponshape" style="background-color: #ffff00;"></div>
				</c:forEach>
			</c:if>
			<span style="width: 600px; height: 50px; float: left;">고객님의 보유 쿠폰은 총 <b>${user.coupon}</b> 개 입니다
			</span>
		</div>
		<c:choose>
			<c:when test="${user.coupon >= 10 && empty backChk}">
				<span class="couponYN"> 고객님은 쿠폰이 10개 이상이어서 아메리카노 한 잔 무료 혜택을
					받으실 수 있습니다<br> 쿠폰을 사용하시겠습니까?
				</span>
			</c:when>
			<c:when test="${user.coupon + totalNum >= 10 && empty backChk}">
				<span class="couponYN"> 고객님은 이번 적립까지 쿠폰이 10개 이상이어서 아메리카노 한 잔
					무료 혜택을 받으실 수 있습니다<br> 쿠폰을 사용하시겠습니까?
				</span>
			</c:when>
		</c:choose>
		<div id="pop" class="popUp" style="opacity: 1; margin-top: -140px">
			<form class="frmCoupon">
				<i class="fa fa-times" id="close"></i>
				<div class="in_popup_num font">
					수량:&nbsp;&nbsp;&nbsp;&nbsp; <i class="fa fa-minus" id="c_minus"></i>
					<input type="text" class="popup_num" name="popup_num_coup"
						id="popup_num_coup" value="1" style="width: 80px" readonly>
					<i class="fa fa-plus" style="margin-left: 180px; margin-top: -20px" id="c_plus"></i>
				</div>
				<input type="hidden" name="phoneNum" value="${user.phone}"> 
				<input type="hidden" id = "coupPayNum" name = "coupPayNum" value="${user.coupon / 10}">
			</form>
			<div class="in_popup_shot align"></div>
			 <div class="putchk align" style="left: -5px;">
				<input id="copuPayChkSubmit" style="background-color: #8A0868" class="phonesubmit font btfont" type="button" value="확인">
			</div>
		</div>
		<c:if test="${user.coupon >= 10 || user.coupon + totalNum >= 10 && empty backChk}">
			<span style="left: 25px; top: 350px; height: 100px; position: absolute; float: left; width: 600px;">
				<input id="couponY" class="btfont" style="background-color: #ffb5da; color: #8A0868" type="button" value="예"> 
				<a href="/cafe/pay?phoneNum=${user.phone}">
					<input id="couponN" class="btfont" style="background-color: #E0ECF8; color: #8A0868" type="button" value="아니오">
				</a>
			</span>
		</c:if>
	</div>
</div>
<%@ include file="./total.jsp" %>
</div>
<%@ include file="./footer.jsp" %>