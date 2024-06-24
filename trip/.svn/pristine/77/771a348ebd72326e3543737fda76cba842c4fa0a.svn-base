<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="trip.vo.*" %>
<%@ page import="trip.dto.*" %> 
<%@ include file="../include/head.jsp" %> 
<%
request.setCharacterEncoding("UTF-8");

//-------------------- 값 수령 --------------------
String advertno = request.getParameter("advertno");
String pageno = request.getParameter("page");

advertDTO dto = new advertDTO();
adminboardDTO adto = new adminboardDTO();

// -------------------- 해당 공지글 삭제 --------------------
// 관리자 권한이 없을시
if(adto.CheckAdmin(login.getUid()) == false)
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("해당 회원은 관리자 권한이 없습니다.");
		history.back();
		return;
	});
	</script>
	<% 
	return;
}

// 광고물 번호 유효성 확인
if(advertno == null || advertno.equals(""))
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("유효하지 않은 공지글입니다.");
		history.back();
		return;
	});
	</script>
	<% 
	return;
}

// 광고물 삭제
if( dto.Delete(advertno) == false )
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("삭제 오류입니다.");
		history.back();
		return;
	});
	</script>
	<% 
}else
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("삭제가 완료되었습니다.");
		document.location = "../master/masterADindex.jsp?page=" + <%= pageno %>;
		return;
	});
	</script>
	<% 
}
%>
