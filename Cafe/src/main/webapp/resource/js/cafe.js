/**
 * 
 */

var arr = ["1한글","2eng" ];

arr.sort(function(a,b){

	return b > a ? 1 :  b < a ? -1  : 0//내림차
	//a = 앞에꺼, b = 뒤에꺼. 뒤에꺼 빼기 앞에꺼(내림차 = 역순)이 1인건 내림차라는 뜻.
	//앞에꺼 빼기 뒤에꺼(b < a) 가 -1 이라는건 오름차가 아니라는것.
	//더 큰 문자에서 작은 문자를 빼는데, 순서중요! 즉 b는 더 크지만 순서는 뒤임. 뒤에서 앞을 빼는데  1(참)인건 내림차
});

console.log(arr[0]);
// 수량 설정 전 원래 메뉴 가격
var menuPrice;

//팝업창에 정보 보내기
function popUp(name,price,id,stock,aa){ //인자 하나 더들어가도 상관 x
	//alert(logChk);
	document.getElementById("pop").style.display = 'block';
	//document.getElementById("menubox").style.opacity = 0.5;
	$("#menubox").css({
		'opacity' : 0.5
	});
	//document.getElementById("p_name").innerHTML = name;
	$("#p_name").html(name);	
	//$("#p_name")[0].innerHTML = name;
	document.getElementById("p_price").innerHTML = price;
	document.getElementById("in_id").value = id;
	document.getElementById("in_stock").value = stock;
	document.getElementById("final").innerHTML = price;
	menuPrice = price;
}
//전체취소
function cancel(){
	document.getElementById("pop").style.display = 'none';
	document.getElementById("menubox").style.opacity = 1;
	document.getElementById("popup_num").value = "1";
}
//선택한 카트 인덱스 취소
function cartCancel(idx){
	document.getElementById("cartc").value = idx;
	document.getElementById("frmCart").submit();
}

function tooltip(aa) { 
	var $this = $(aa); //제이쿼리 객체화함. 그냥 [0] 가져오면 그냥 object라고만 뜸. 객체는 [0]인가봐 무조건
	console.log($this[0]);
}
$(document).ready(function(){
	//팝업창 닫기
	$("#close").click(function(){//x버튼
		cancel();
	})
	$("#put_c").click(function(){//취소버튼
		cancel();
	})
	//메뉴 수량 수기 입력
	$("#popup_num").on("input", function() {
	    var currentVal = $(this).val();
	    var price = document.getElementById("final").innerHTML;
	    price =  parseInt(menuPrice);
	    
	    document.getElementById("final").innerHTML = (price * currentVal);
	});
	
	//주문 수량, 샷 추가 증감
	$("#n_plus").click(function(){
		var p = $("#popup_num").val();
		var s = $("#popup_shot").val();
		var stock = parseInt($("#in_stock").val());
		var originPrice = document.getElementById("p_price").innerHTML;
		originPrice =  parseInt(originPrice); 
		var price = document.getElementById("final").innerHTML;
		price =  parseInt(price); 
		document.getElementById("popup_num").value = (p * 1) + 1; 
		if((stock - document.getElementById("popup_num").value) < 0){
			alert("재고가 부족합니다.");
			document.getElementById("popup_num").value = (p * 1); 
		}
		document.getElementById("final").innerHTML = (price * 1) + originPrice + (s*500);
	})
	$("#n_minus").click(function(){
		var p = $("#popup_num").val();
		var s = $("#popup_shot").val();
		var originPrice = document.getElementById("p_price").innerHTML;
		originPrice =  parseInt(originPrice); 
		var price = document.getElementById("final").innerHTML;
		price =  parseInt(price); 
		document.getElementById("popup_num").value = (p * 1) - 1;
		document.getElementById("final").innerHTML = (price * 1) - originPrice - (s*500);
		if(p < 2){
			document.getElementById("popup_num").value = p;
			document.getElementById("final").innerHTML = price;
		}
	})
	$("#s_plus").click(function(){
		var p = $("#popup_shot").val();
		var price = document.getElementById("final").innerHTML;
		price =  parseInt(price); 
		if(0 <= p < 2){
			document.getElementById("popup_shot").value = (p * 1) + 1;
			document.getElementById("final").innerHTML = (price * 1) + 500;
		}
		if(p > 1){
			alert("샷은 2개 이상 추가하실 수 없습니다.");
			document.getElementById("popup_shot").value = p;	
			document.getElementById("final").innerHTML = price;
		}
	})
	$("#s_minus").click(function(){
		var p = $("#popup_shot").val();
		var price = document.getElementById("final").innerHTML;
		price =  parseInt(price); 
		if(0 <= p < 2){
			document.getElementById("popup_shot").value = (p * 1) - 1;
			document.getElementById("final").innerHTML = (price * 1) - 500;
		}
		if(p < 1){
			document.getElementById("popup_shot").value = p;
			document.getElementById("final").innerHTML = price;
		}
	})
	//장바구니 담기
	$("#put").click(function(){
		var price = document.getElementById("final").innerHTML;
		
		document.getElementById("in_final").value = price;
		document.getElementById("in_name").value = document.getElementById("p_name").innerHTML;
		$("#frmMenu").attr("action","./total").submit();
	})
	/*//장바구니 선택 취소 -- idx를 못불러와서 function으로 바꿈
	$("#cartcancel").click(function(){
		$("#cartfrm").attr("action","./cartcancel").submit();
	})*/
	//장바구니 전체 취소
	$("#cancel").click(function(){
		location.href = "cancel";
	})
	//회원가입창 이동
	$("#join").click(function(){
		location.href = "join";
	})
	//회원가입 취소 뒤로 이동
	$("#joinc").click(function(){
		window.history.back();
	})
	//쿠폰개수 확인하기
	$("#couponchkbt").click(function(){
		//document.getElementById("couponview").style.display = 'block';
		$("#couponview").toggle();
	})
	//쿠폰 개수 20개 이상일 시 사용할 쿠폰 개수 선택
	$("#c_plus").click(function(){
		var p = $("#popup_num_coup").val();
		var coupPayNum = parseInt($("#coupPayNum").val());//원래 갖고있던 쿠폰개수 / 10
		document.getElementById("popup_num_coup").value = (p * 1) + 1;
		if((coupPayNum - document.getElementById("popup_num_coup").value) < 0){
			alert("쿠폰개수가 부족합니다.");
			document.getElementById("popup_num_coup").value = p; 
			num = num;
		}
	})
	$("#c_minus").click(function(){
		var p = $("#popup_num_coup").val();
		document.getElementById("popup_num_coup").value = (p * 1) - 1;		
		if(p < 2){
			document.getElementById("popup_num_coup").value = p;
		}
	})
	//비회원 결제창 이동
	$("#nouserpay").click(function(){
		location.href = "pay";
	})
	/*//쿠폰 아니오 결제창 이동 ------total.jsp에서 분기처리로 구현
	$("#couponN").click(function(){
		if(confirm("결제하시겠습니까?")){
			location.href = "pay";
		}		
	})*/
	//가격합산 창 결제하기 버튼
	/*$("#pay").click(function(){
		location.href = "pay";
	})*/
	//결제창 띄우기
	$("#payBt").click(function(){
		var p = $("#paymoney").val();
		document.getElementById("payment").style.display = 'block';
		document.getElementById("userpay").innerHTML = p;
	})
	//메인창 이동
	$("#main").click(function(){
		location.href = "menu";
	})
	
	
	
});