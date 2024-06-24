<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="trip.vo.*" %>
<%@ page import="trip.dto.*" %>   
<%
//--------------------- 값 받아옴 ---------------------
String uno = request.getParameter("uno");

//--------------------- 유효성 체크 ---------------------
if( uno == null || uno.equals(""))
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("유호한 회원번호를 입력해주세요");
		return;
	});
	</script>
	<% 
	return;
}
//------------------ DTO 선언 ----------------------
userVO vo = new userVO();
userDTO dto = new userDTO();

//------------------ 정지  ----------------------
if(dto.lift_sanctions(uno) == false)
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("회원정지해제에 실패하였습니다.");
		return;
	});
	</script>
	<% 
	return;
}

%>
