<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="trip.vo.*" %>
<%@ page import="trip.dto.*" %> 
<%@ include file="../include/head.jsp" %>
<%
request.setCharacterEncoding("UTF-8");

//-------------------- 값 수령 --------------------
String pageno        = request.getParameter("for_link_page");
String search_type   = request.getParameter("for_link_search_type");
String detail_retire = request.getParameter("for_link_retire");
String detail_ustop  = request.getParameter("for_link_ustop");
String detail_admin  = request.getParameter("for_link_admin");
String detail_all    = request.getParameter("for_link_all");
String keyword       = request.getParameter("for_link_keyword");
String sort_type     = request.getParameter("for_link_sort_type");
String uno           = request.getParameter("uno");


String new_unick = request.getParameter("new_unick");
String season    = request.getParameter("season");
String local     = request.getParameter("local");
String human     = request.getParameter("human");
String move      = request.getParameter("move");
String schedule  = request.getParameter("schedule");
String uinout    = request.getParameter("uinout");
String uicon     = request.getParameter("uicon");

//페이징 기본설정
if(pageno == null || pageno.equals("")) 
	pageno  = "1"; 
if( search_type   == null )  search_type   = "";
if( detail_retire == null )  detail_retire = "N";
if( detail_ustop  == null )  detail_ustop  = "N";
if( detail_admin  == null )  detail_admin  = "N";
if( detail_all    == null )  detail_all	   = "Y";
if( keyword       == null )  keyword	   = "";
if( sort_type     == null )  sort_type     = "by_number";


int curpage = 1;
try{
		curpage = Integer.parseInt(pageno);
}catch(Exception e){  }
//-------------------- DTO 선언 -------------------
userDTO dto = new userDTO();
userVO vo = new userVO();
//--------------------- 접근제어 ------------------

//비로그인시
if(login == null)
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("로그인이 필요합니다.");
		if(confirm("로그인 페이지로 이동하시겠습니까?") == true)
		{
			document.location = "../user/login.jsp";
			return;
		}else
		{
			document.location = "../firstmain/lobby.jsp";
			return;
		}
	});
	</script>
	<% 
	return;
}

//관리자 권한이 없을시
adminboardDTO adto = new adminboardDTO();
adminboardVO avo = new adminboardVO();

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

//회원번호 유효성 확인
if(uno == null || uno.equals(""))
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("유효하지 않은 회원번호입니다.");
		history.back();
		return;
	});
	</script>
	<% 
	return;
}

//--------------------- 해당회원 정보조회 ------------------- 
vo = dto.CheckUser(uno);
if(vo == null || vo.equals(""))
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("해당 공지글을 조회할 수 없습니다.");
		history.back();
		return;
	});
	</script>
	<% 
	return;
}

//--------------------- 해당회원 정보변경 -------------------
vo.setUnick(new_unick);
vo.setSeason(season);
vo.setLocal(local);
vo.setHuman(human);
vo.setMove(move);
vo.setSchedule(schedule);
vo.setUinout(uinout);
if(uicon == null)
{
	uicon = "";
}
vo.setUicon(uicon);

if(dto.ModifyUser(vo) == false)
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("수정 중에 오류가 발생하였습니다.");
		history.back();
		return;
	});
	</script>
	<% 
	return;
}else
{	
	String link_str = "";
	link_str += "page="+ pageno;
	link_str += "&search_type="+ search_type;
	link_str += "&detail_retire="+ detail_retire;
	link_str += "&detail_ustop="+ detail_ustop;
	link_str += "&detail_admin="+ detail_admin;
	link_str += "&detail_all="+ detail_all;
	link_str += "&keyword="+ keyword;
	link_str += "&sort_type="+ sort_type;
	link_str += "&uno="+ uno;
	%>
	<script>
	$(document).ready(function(){
		
		alert("유저정보를 성공적으로 변경하였습니다.");
		document.location = "masterMembercheckView.jsp?<%= link_str %>"
		return;
	});
	</script>
	<% 
}



%>
