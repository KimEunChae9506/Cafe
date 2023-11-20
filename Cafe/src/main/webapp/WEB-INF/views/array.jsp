<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){

var array = ["a","b","c"];	
var array2 = {"aa":"a", "bb" :"b", "c":[{"cc":"count"}]};
var html = "";
$.each(array,function(idx,list){
	
	 /* html += '<div>';
	 html += array[idx];
	 html += '</div>';
	$("#arr").html(html); */
	//alert($("#arr").val()):
	//alert(list);
});

$.each(array2.c,function(idx,list2){
	//alert(list2.cc);
});

$.each(array2,function(idx,list3){
	//alert(list3);
})

//.을 찍고 들어가는건 객체일 경우.

$.map(array,function(list,idx){
	var a = list;
	console.log(">>"+a);
	//return a;
	 html += '<div>';
	 html += array[idx];
	 html += '</div>';

	 
	$("#arr").html(html);
})


});

</script>
</head>
<body>
${text }
<div id = "arr">
</div>
</body>
</html>