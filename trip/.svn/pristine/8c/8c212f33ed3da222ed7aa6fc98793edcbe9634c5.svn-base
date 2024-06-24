<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="trip.vo.*" %>
<%@ page import="trip.dto.*" %> 
<%@ include file="../include/head.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
//-------------------- 값 수령 --------------------
String top_category  = request.getParameter("top_category");
String sub_category  = request.getParameter("sub_category");
String vip_whether   = request.getParameter("vip_whether");
String product_name  = request.getParameter("product_name");
String product_price = request.getParameter("product_price");
String start_date    = request.getParameter("start_date");
String stop_date     = request.getParameter("stop_date");
String detail_URL    = request.getParameter("detail_URL");

//받아온 값의 유효성 확인
if( top_category  == null || sub_category == null || vip_whether == null || product_name == null
|| product_price == null  || start_date   == null || stop_date   == null || detail_URL   == null
|| top_category.equals("")  || sub_category.equals("") || vip_whether.equals("") || product_name.equals("") 
|| product_price.equals("") || start_date.equals("")   || stop_date.equals("")   || detail_URL.equals("")    )
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("유효하지 않은 값입니다.");
		history.back();
		return;
	});
	</script>
	<%
}
//-------------------- DTO 선언 -------------------
advertDTO dto     = new advertDTO();
advertVO vo       = new advertVO();
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


//--------------------- 해당광고물 정보변경 -------------------
vo.setCategory(top_category);
vo.setSubclass(sub_category);
switch(vip_whether)
{
	case "Y" :
		vip_whether = "1";
		break;
	case "N" :
		vip_whether = "0";
		break;
}
vo.setVipWhether(vip_whether);
vo.setProductName(product_name);
vo.setPrice(product_price);
start_date = start_date.replace("T", " ");
stop_date = stop_date.replace("T", " ");
vo.setVipStartDate(start_date);
vo.setVipEndDate(stop_date);
vo.setDetailURL(detail_URL);

if(dto.Insert(vo) == false)
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("광고등록 중에 오류가 발생하였습니다.");
		history.back();
		return;
	});
	</script>
	<% 
	return;
}else
{	
	%>
	<script>
	$(document).ready(function(){
		
		alert("해당 광고물을 성공적으로 등록하였습니다.");
		document.location = "masterADview.jsp?<%= vo.getAdvertno() %>
		return;
	});
	</script>
	<% 
}



%>
