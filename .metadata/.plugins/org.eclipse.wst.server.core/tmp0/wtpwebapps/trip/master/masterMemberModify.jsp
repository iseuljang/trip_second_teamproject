<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/head.jsp" %> 
<link rel="stylesheet" type="text/css" href="../css/masterGonggiwrite.css">    
<%
//-------------------- 값 수령 --------------------
String pageno        = request.getParameter("page");
String search_type   = request.getParameter("search_type");
String detail_retire = request.getParameter("detail_retire");
String detail_ustop  = request.getParameter("detail_ustop");
String detail_admin  = request.getParameter("detail_admin");
String detail_all    = request.getParameter("detail_all");
String keyword       = request.getParameter("keyword");
String sort_type     = request.getParameter("sort_type");
String uno           = request.getParameter("uno");

//페이징 기본설정
if(pageno == null || pageno.equals("")) 
pageno  = "1"; 
if( search_type   == null )  search_type   = "";
if( detail_retire == null )  detail_retire = "N";
if( detail_ustop  == null )  detail_ustop  = "N";
if( detail_admin  == null )  detail_admin  = "N";
if( detail_all    == null )  detail_all    = "Y";
if( keyword       == null )  keyword       = "";
if( sort_type     == null )  sort_type     = "by_number";


int curpage = 1;
try{
		curpage = Integer.parseInt(pageno);
}catch(Exception e){  }
// -------------------- DTO 선언 -------------------
userDTO dto = new userDTO();
userVO vo = new userVO();
//--------------------- 접근제어 ------------------

// 비로그인시
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

// 관리자 권한이 없을시
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

// 회원번호 유효성 확인
if(uno == null || uno.equals(""))
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
//----------------- 이모티콘 받기 -----------------
String emo;

if(vo.getUicon() == null || vo.getUicon().equals(""))
{
	emo = "";
}
else
{
	emo = vo.getUicon();
}
//----------------- 관심분야 받기 -----------------
String user_season   = "";
String user_local    = "";
String user_human    = "";
String user_move     = "";
String user_schedule = "";
String user_uinout   = "";

//선호계절 받기
if(vo.getSeason() == null || vo.getSeason().equals(""))
{
	user_season = "없음";
}else
{
	user_season = vo.getSeason();
}

//선호지역 받기
if(vo.getLocal() == null || vo.getLocal().equals(""))
{
	user_local = "없음";
}else
{
	user_local = vo.getLocal();
}

//선호동행수 받기
if(vo.getHuman() == null || vo.getHuman().equals(""))
{
	user_human = "없음";
}else
{
	user_human = vo.getHuman();
}

//선호이동수단 받기
if(vo.getMove() == null || vo.getMove().equals(""))
{
	user_move = "없음";
}else
{
	user_move = vo.getMove();
}

//선호일정 받기
if(vo.getSchedule() == null || vo.getSchedule().equals(""))
{
	user_schedule = "없음";
}else
{
	user_schedule = vo.getSchedule();
}

//선호장소 받기
if(vo.getUinout() == null || vo.getUinout().equals(""))
{
	user_uinout = "없음";
}else
{
	user_uinout = vo.getUinout();
}
%>
<style>
.btn
{
	border: 0px; 
	font-size: 25px;
	border-radius: 0.2em;
	cursor: pointer;
	width: 100px;
	height: 50px;
	color: white; 
	margin-bottom : 20px;
}

.xx
{
	border-spacing: 20px 20px;

}

.select_class
{
	width  : 120px;
	height : 10px;
	font-size : 15px;
	text-align : center;
	

}
</style>
<script>
	// ---------------- 수정최소 버튼 -------------------
	function CancelModify(obj)
	{
		history.back();
	}
	
	// ------------------- 수정완료 버튼 -------------------
	function doModify()
	{
		if(confirm("해당 회원정보를 수정하시겠습니까?") == true)
		{
			$("#masterMemberModify").submit();
		}
	}
</script>
<body>
	<form method="post" name="masterMemberModify" id="masterMemberModify" action="masterMemberModifyOk.jsp">
	<input type="hidden" id="for_link_page" value="<%= pageno %>" name="for_link_page">
	<input type="hidden" id="for_link_search_type" value="<%= search_type %>" name="for_link_search_type">
	<input type="hidden" id="for_link_retire" value="<%= detail_retire %>" name="for_link_retire">
	<input type="hidden" id="for_link_ustop" value="<%= detail_ustop %>" name="for_link_ustop">
	<input type="hidden" id="for_link_admin" value="<%= detail_admin %>" name="for_link_admin">
	<input type="hidden" id="for_link_all" value="<%= detail_all %>" name="for_link_all">
	<input type="hidden" id="for_link_keyword" value="<%= keyword %>" name="for_link_keyword">
	<input type="hidden" id="for_link_sort_type" value="<%= sort_type %>" name="for_link_sort_type">
	<input type="hidden" id="uno" value="<%= uno %>" name="uno">
	
	<!-- 중간부분입니다 -->
	<div style="margin-top:100px"></div>
	<table border="0" width="90%" style="vertical-align:top;">
		<tr>
			<td id="td1" style="vertical-align: top; width : 300px;">
				<a href="masterMembercheck.jsp" id="href1"><b style="color:#1ABC9C">회원조회</b></a>
				<hr>
				<a href="masterGonggiwrite.jsp" id="href2"><b>공지사항</b></a>
				<hr>
				<a href="masterADindex.jsp" ><b>광고 관리</b></a>
				<hr>
			</td>
			<td style="background-color:gray;"></td>
			<td id="td2">
				<table border="0" width="100%" align="center" style="border-collapse: collapse;" id="view">
					<tr>
						<td align="right" colspan="4">
							<% 
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
							<button type="button" class ="btn" id="list_btn" style="background-color : green; margin-right : 280px; font-size : 15px;" 
							onclick="gotoList('<%= link_str %>')">수정 취소</button>
						</td>
					</tr>
				</table>
					<table border = "1" style="font-size : 25px; width : 800px; height : 600px; text-align : center; margin-right : 400px;">
						<tr>
							<td>
								<b>아이디</b>
							</td>
							<td style="width : 250px;">
								<%= vo.getUid() %>
							</td>
							<td>
								<b>이름</b>
							</td>
							<td style="width : 250px;">
								<%= vo.getUname() %>
							</td>
						</tr>
						<tr>
							<td>
								<b>닉네임</b>
							</td>
							<td>
								<input type="text" name="new_unick" id="new_unick" value="<%= vo.getUnick() %>">
							</td>
							<td>
								<b>탈퇴여부</b>
							</td>
							<td>
								<%
								if(vo.getUretire() == null || vo.getUretire().equals("N"))
								{
									%> N <%
								}else if(vo.getUretire().equals(""))
								{
									%> 잘못된 값 <%
								}
								else
								{
									%> Y <%
								}
								%>
							</td>
						</tr>
						<tr>
							<td>
								<b>이메일</b>
							</td>
							<td colspan="3">
								<%= vo.getEmail() %>
							</td>
						</tr>
						<tr>
							<td>
								<b>사용자 이모티콘</b>
							</td>
							<td colspan="3">
								<span style="font-size:40px">😄</span><input type="radio" name="uicon" value="1" <%= emo.equals("1") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="font-size:40px">😆</span><input type="radio" name="uicon" value="2" <%= emo.equals("2") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="font-size:40px">😅</span><input type="radio" name="uicon" value="3" <%= emo.equals("3") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="font-size:40px">😀</span><input type="radio" name="uicon" value="4" <%= emo.equals("4") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="font-size:40px">😨</span><input type="radio" name="uicon" value="5" <%= emo.equals("5") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;<br>
								<span style="font-size:40px">👿</span><input type="radio" name="uicon" value="6" <%= emo.equals("6") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="font-size:40px">😝</span><input type="radio" name="uicon" value="7" <%= emo.equals("7") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="font-size:40px">😷</span><input type="radio" name="uicon" value="8" <%= emo.equals("8") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="font-size:40px">😴</span><input type="radio" name="uicon" value="9" <%= emo.equals("9") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;
								<span style="font-size:40px">😱</span><input type="radio" name="uicon" value="10" <%= emo.equals("10") ? "checked" : "" %> style="width:20px;height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;			
							</td>
						</tr>
							<tr>
								<td>
									<b>관심분야</b>
								</td>
							<td colspan="3">
								<table border="1" width="90%" style="font-size : 18px;">
									<tr>
										<td><b>선호계절</b></td>
										<td><b>선호지역</b></td>
										<td><b>선호동행수</b></td>
									</tr>
									<tr>
										<td>
											<select id="season" name="season" class="select_class">
												<option value="" <%= user_season.equals("") ? "selected" : "" %>>계절</option>
												<option value="봄" <%= user_season.equals("봄") ? "selected" : "" %>>봄</option>
												<option value="여름" <%= user_season.equals("여름") ? "selected" : "" %>>여름</option>
												<option value="가을" <%= user_season.equals("가을") ? "selected" : "" %>>가을</option>
												<option value="겨울" <%= user_season.equals("겨울") ? "selected" : "" %>>겨울</option>
											</select>
										</td>
										<td>
											<select id="local" name="local" class="select_class">
												<option value="" <%= user_local.equals("") ? "selected" : "" %>>지역</option>
												<option value="서울경기도" <%= user_local.equals("서울경기도") ? "selected" : "" %>>서울,경기도</option>
												<option value="강원도" <%= user_local.equals("강원도") ? "selected" : "" %>>강원도</option>
												<option value="충청도" <%= user_local.equals("충청도") ? "selected" : "" %>>충청도</option>
												<option value="전북" <%= user_local.equals("전북") ? "selected" : "" %>>전라북도</option>
												<option value="전남" <%= user_local.equals("전남") ? "selected" : "" %>>전라남도</option>
												<option value="경북" <%= user_local.equals("경북") ? "selected" : "" %>>경상북도</option>
												<option value="경남" <%= user_local.equals("경남") ? "selected" : "" %>>경상남도</option>
												<option value="제주" <%= user_local.equals("제주") ? "selected" : "" %>>제주도</option>
											</select>
										</td>
										<td>
											<select id="human" name="human" class="select_class">
												<option value="" <%= user_human.equals("") ? "selected" : "" %>>동행</option>
												<option value="가족" <%= user_human.equals("가족") ? "selected" : "" %>>가족</option>
												<option value="연인" <%= user_human.equals("연인") ? "selected" : "" %>>연인</option>
												<option value="친구" <%= user_human.equals("친구") ? "selected" : "" %>>친구</option>
												<option value="반려견" <%= user_human.equals("반려견") ? "selected" : "" %>>반려견</option>
											</select>	
										</td>
									</tr>
									<tr>
										<td><b>선호이동수단</b></td>
										<td><b>선호일정</b></td>
										<td><b>선호 장소</b></td>
									</tr>
									<tr>
										<td>
											<select id="move" name="move" class="select_class">
												<option value="" <%= user_move.equals("") ? "selected" : "" %>>이동</option>
												<option value="버스" <%= user_move.equals("버스") ? "selected" : "" %>>버스</option>
												<option value="기차" <%= user_move.equals("기차") ? "selected" : "" %>>기차</option>
												<option value="자가용" <%= user_move.equals("자가용") ? "selected" : "" %>>자가용</option>
												<option value="자전거" <%= user_move.equals("자전거") ? "selected" : "" %>>자전거</option>
											</select>
										</td>
										<td>
											<select id="schedule" name="schedule" class="select_class">
												<option value="" <%= user_schedule.equals("") ? "selected" : "" %>>일정</option>
												<option value="당일" <%= user_schedule.equals("당일") ? "selected" : "" %>>당일</option>
												<option value="숙박" <%= user_schedule.equals("숙박") ? "selected" : "" %>>숙박</option>
											</select>
										</td>
										<td>
											<select id="uinout" name="uinout" class="select_class">
												<option value="" <%= user_uinout.equals("") ? "selected" : "" %>>장소</option>
												<option value="실내" <%= user_uinout.equals("실내") ? "selected" : "" %>>실내</option>
												<option value="실외" <%= user_uinout.equals("실외") ? "selected" : "" %>>실외</option>
											</select>	
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<b>정지여부</b>
							</td>
							<td id="user_stop_whether">
								<%
								if(vo.getUstop() == null || vo.getUstop().equals("N"))
								{
									%> N <%
								}else if(vo.getUstop().equals(""))
								{
									%> <%
								}else
								{
									%> Y <%
								}
								%>
							</td>
							<td>
								<b>정지기간</b>
							</td>
							<td id="user_stop_date" style="font-size : 18px;">
								<%
								if(vo.getUstopend() == null || vo.getUstopend().equals(""))
								{
									%> 해당사항 없음 <%
								}else
								{
									%><%= vo.getUstopend() %><%
								}
								%>
							</td>
						</tr>
					</table>
					<table border="0" width="100%" align="center" style="border-collapse: collapse;" id="view">
					<tr>
						<td align="right">
							<button type="reset" class ="btn" id="delete_btn" style="background-color : deeppink; font-size : 15px; margin-top : 50px;">초기화</button>&nbsp;&nbsp;&nbsp;&nbsp;
							<button type="button" class ="btn" id="modify_btn" style="background-color : royalblue; margin-right : 170px; font-size : 15px;"
							onclick="doModify();">수정완료</button>
						</td>
					</tr>
				</table>
					
			</td>
		</tr>
	</table>
	<div style="height : 400px;"> </div>
	</form>
</body>
</html>