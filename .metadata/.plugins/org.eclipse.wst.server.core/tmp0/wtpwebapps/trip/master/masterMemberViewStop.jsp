<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="trip.vo.*" %>
<%@ page import="trip.dto.*" %>   
<%
//--------------------- 값 받아옴 ---------------------
String stop_date = request.getParameter("stop_date");
String uno = request.getParameter("uno");

//--------------------- 유효성 체크 ---------------------
if( stop_date == null || stop_date.equals(""))
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("유호한 정지일을 입력해주세요");
		return;
	});
	</script>
	<% 
	return;
}

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
stop_date = stop_date.replace("T", " ");
userVO vo = new userVO();
userDTO dto = new userDTO();

//------------------ 정지 후 회원정보 받아오기 ----------------------
if(dto.Stop2(stop_date,uno) == false)
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("회원정지에 실패하였습니다.");
		return;
	});
	</script>
	<% 
	return;
}

vo = dto.CheckUser(uno);
//----------------- 관심분야 받기 -----------------
String season   = "";
String local    = "";
String human    = "";
String move     = "";
String schedule = "";
String uinout   = "";

//선호계절 받기
if(vo.getSeason() == null || vo.getSeason().equals(""))
{
	season = "없음";
}else
{
	season = vo.getSeason();
}

//선호지역 받기
if(vo.getLocal() == null || vo.getLocal().equals(""))
{
	local = "없음";
}else
{
	local = vo.getLocal();
}

//선호동행수 받기
if(vo.getHuman() == null || vo.getHuman().equals(""))
{
	human = "없음";
}else
{
	human = vo.getHuman();
}

//선호이동수단 받기
if(vo.getMove() == null || vo.getMove().equals(""))
{
	move = "없음";
}else
{
	move = vo.getMove();
}

//선호일정 받기
if(vo.getSchedule() == null || vo.getSchedule().equals(""))
{
	schedule = "없음";
}else
{
	schedule = vo.getSchedule();
}

//선호장소 받기
if(vo.getUinout() == null || vo.getUinout().equals(""))
{
	uinout = "없음";
}else
{
	uinout = vo.getUinout();
}

%>
<script>
</script>
