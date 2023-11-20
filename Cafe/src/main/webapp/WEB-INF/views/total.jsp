<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">

function sortChange(){
	
	var sort = $("#selectSort").val();
	var sortDiv = "";
	$.ajax({
	    url : "/cafe/sort",
	    //dataType: "json",
	    type: "POST",
	    data : {"sort" : sort},
	    success: function(data) 
	    {	
	    	for(var i in data){
	    		sortDiv += "<form name = \"frmCart\" id = \"frmCart\" method=\"post\" action=\"./cartCancel\">";
		    	sortDiv += "<div class='cartbox'>";
		    	sortDiv += "<input type='hidden' name='cartc' id = 'cartc' value=''>";
				sortDiv += "<span class='hspan' style='width: 93px; text-align:center;'>"+data[i].names +"</span>";
				sortDiv += "<span class= 'hspan' style='width: 20px; text-align:center;'>x"+ data[i].num +"</span>";
				if(i.shot == 0){
					sortDiv += "<div class='hspan' style='width: 20px;'>x 0</div>";
				} else {
					sortDiv += "<span class='hspan' style='width: 20px; text-align:left;'>x" + data[i].shot + "</span>";
				}
				sortDiv += "<span class='hspan' style='width: 50px; text-align:center;'>" + data[i].price + "원</span>";
				sortDiv += "<i class='fa fa-times' id='cartCancel' onclick = 'cartCancel(" + i + ");'></i>";
				sortDiv += "</div>";
				sortDiv += "</form>";
	    	} 
			
	    	$("#append").html(sortDiv);//append는 안 지우고 쌓고, html은 새로 쌓고
	    },
	    error: function (jqXHR, textStatus, errorThrown)
	    {
	    	alert("정렬에러");
	    }
		});
}
$(document).ready(function(){
	//$('#sort').val('SALESTATCD/ASC,OFFLSALERANK/ASC,CONRORDER/ASC,SALEQTY/DESC,REALMDLNM/ASC,WEIGHT/DESC,UID/ASC').prop("selected",true);
	//$('label[for = sort]').text('매장순');
	//회원확인창 이동
	$("#pay").click(function(){

		if (${totalPrice == null}){
			alert("한 개 이상 주문해주세요");
		} else {
		    if (${payBt == null}){//메뉴선택 창에서 결제하기 눌렀을 때. 회원확인창으로 이동하여야 한다.
		        location.href = "userChk";
		    } else { //회원확인'창' 거치고 난 후. 아직 회원확인(로그인)은 안 함.
		    	if (${user.phone != null}){//**회원확인(로그인) 함** 결제창에서 결제 전 뒤로 간 후(/coupon = 쿠폰 확인후) 결제하기 눌렀을 시 
			    	if (${backChk == 1}){ //**결제 하고** 쿠폰확인창(뒤로가기)로 결제후 뒤로 간 후(/coupon = 갱신된 쿠폰 확인후) 결제 버튼 눌렀을 시
				    	alert("이미 결제하셨습니다. 초기화면으로 이동합니다.");
				    	location.href = "menu";
				    } else { //alert(a == 2 ? 22 : 33); //**결제 안 하고** 결제창까지 가기 전 페이지들 (메뉴,쿠폰 창)
					    if (${payBt == 2}){//로그인 상태 유지(쿠키)로 메뉴에서 바로 쿠폰화면으로 넘어가게
							location.href = "coupon";
						} else {//로그인 상태인 채로 쿠폰창에서 결제창 넘어가기
							location.href = "pay?phoneNum=${user.phone}"; //뒤 파라미터 상관 x
						}
					}
				} else {//**로그인 안 되어 있**는 상태.
					location.href = "pay";//유저체크창에서 다음 갈 때
				}
			}
		}		
	})
});
</script>
	<aside class="totalbox">
		 <select id = "selectSort"  onchange="sortChange()" style = "float:right">
			<option value="">정렬</option>
			<option value="n">이름순</option>
			<option value="c">개수순</option>
		 </select>
		<div id = "append" class="append">
		 <c:forEach items="${cartList}" var="list" varStatus="status">
			 <form name = "frmCart" id = "frmCart" method="post" action="./cartCancel">
				 <div class="cartbox">
				 <input type="hidden" name="cartc" id = "cartc" value=""><!--${status.index} 안먹음  -->
					 <span class="hspan" style="width: 93px; text-align:center;">${list.names}</span>
					 <span class="hspan" style="width: 20px; text-align:center;">x ${list.num}</span>
					<c:if test="${list.shot} == 0"></c:if><!-- ???? -->
						<c:choose>
							<c:when test="${list.shot == 0}"><div class="hspan" style="width: 20px;">x 0</div></c:when>
							<c:otherwise><span class="hspan" style="width: 20px; text-align:left;">x ${list.shot}</span></c:otherwise>
						</c:choose>
					<span class="hspan" style="width: 50px; text-align:center;">${list.price}원</span>
					<i class="fa fa-times" id="cartCancel" onclick = "cartCancel('${status.index}');"></i>
				 </div>
			 </form>
		 </c:forEach>
		</div>
		<div style="height:50px; background-color: #F8E0F1">
			<span id = "totalPrice">
				<b>총가격:&nbsp;&nbsp;&nbsp;&nbsp;${totalPrice} 원</b>
			</span>	
		</div>
			<input  id="cancel" class="btfont" type="button" value="전체취소">
			<input id="pay" class="btfont" type="button" value="결제"> 
	</aside>
