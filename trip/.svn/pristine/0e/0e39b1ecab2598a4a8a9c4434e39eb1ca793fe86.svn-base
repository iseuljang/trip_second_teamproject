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

//회원번호 유효성 확인
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
</style>
<script>
	$(document).ready(function(){
	});
	
	// 유저목록 버튼
	function gotoList(obj)
	{
		document.location = "masterMembercheck.jsp?" + obj;
	}
	
	// 유저정보 수정 버튼
	function modifyUser(obj)
	{
		if(confirm("해당 회원정보를 수정하시겠습니까?") == true)
		{
			document.location = "masterMemberModify.jsp?" + obj;
		}
	}
	
	//------------- 유저 정지 체크 버튼 ----------------
	function userStop(uno)
	{
		var stop_date = $("#stop_date").val();
		
		if(confirm("정지하시겠습니까?") == false)
		{
			return;
		}
		
		//$("#user_info_div").remove()
		$.ajax({
			type : "post",
			url : "masterMemberViewStop.jsp",
			data : 
			{
				uno : uno,
				stop_date : stop_date
			},
			dataType : "html",
			success : function(result)
			{
				//result = result.trim();
				location.reload();
				
			}
		});
	}
	
	//------------- 유저 정지해제 버튼 ----------------
	function lift_sanctions(uno)
	{
		
		if(confirm("정지를 해제하시겠습니까?") == false)
		{
			return;
		}
		
		$.ajax({
			type : "post",
			url : "masterMemberViewRelease.jsp",
			data : 
			{
				uno : uno
			},
			dataType : "html",
			success : function(result)
			{
				location.reload();
				
			}
		});
	}
</script>
<body>
	<form method="post" name="masterADview" id="masterADview" action="masterADwrite.jsp">
	
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
							<button type="button" class ="btn" id="modify_btn" style="background-color : royalblue; margin-right : 20px; font-size : 15px;" 							
							onclick="modifyUser('<%= link_str %>')">회원정보 수정</button>
							<button type="button" class ="btn" id="list_btn" style="background-color : green; margin-right : 100px; font-size : 15px;" 
							onclick="gotoList('<%= link_str %>')">목록으로</button>
						</td>
					</tr>
					<tr>
					<div id="user_info_div">
					<table border = "1"  id="user_info_table" style="font-size : 25px; width : 800px; height : 600px; text-align : center; margin-right : 400px;">
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
								<%= vo.getUnick() %>
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
								<% 
								String icon = "";
								if(vo.getUicon() == null || vo.getUicon().equals(""))
								{
									icon = "없음";
								}else
								{
									switch (vo.getUicon())
									{
					               		case "1": icon   = "😄"; break;	
					               		case "2": icon   = "😆"; break;  
					               		case "3": icon   = "😅"; break;  
					               		case "4": icon   = "😀"; break;  
					               		case "5": icon   = "😨"; break;  
					               		case "6": icon   = "👿"; break;  
					               		case "7": icon   = "😝"; break;  
					               		case "8": icon   = "😷"; break;  
					               		case "9": icon   = "😴"; break;  
					               		case "10": icon  = "😱"; break;  
					                }
								}
								%>
								<td colspan="3">
									<%= icon %>
								</td>
							</tr>
							<tr>
								<td>
									<b>관심분야</b>
								</td>
							<td colspan="3">
								<table border="1" width="90%" height="90%" style="font-size : 18px;">
									<tr>
										<td><b>선호계절</b></td>
										<td><b>선호지역</b></td>
										<td><b>선호동행수</b></td>
									</tr>
									<tr>
										<td><%= season %></td>
										<td><%= local %></td>
										<td><%= human %></td>
									</tr>
									<tr>
										<td><b>선호이동수단</b></td>
										<td><b>선호일정</b></td>
										<td><b>선호 장소</b></td>
									</tr>
									<tr>
										<td><%= move %></td>
										<td><%= schedule %></td>
										<td><%= uinout %></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<b>회원이용정지</b>
							</td>
							<td colspan="3">
								<input type="datetime-local" id="stop_date" name="stop_date" style="width : 350px; height : 50px; font-size : 25px;" onchange="setMinValue()">
								&nbsp;&nbsp;
								<button type="button" name="stop2_btn" id="stop2_btn" onclick="userStop(<%= vo.getUno() %>);" 
								style="width : 40px; height :30px; font-size : 15px; border-color : #ED3D45; background-color : #F0565E; border-radius: 10px;">
									정지
								</button>
								<button type="button" name="lift_sanctions_btn" id="lift_sanctions_btn" onclick="lift_sanctions(<%= vo.getUno() %>);"
								style="width : 40px; height :30px; font-size : 15px; border-color : #3D87EA; background-color : #28A6E0; border-radius: 10px;">
									해제
								</button>
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
									%><%= vo.getUstopend() %> 까지<%
								}
								%>
							</td>
						</tr>
					</table>
					</div>
			</td>
		</tr>
	</table>
	<div style="height : 400px;"> </div>
	</form>
	<script>
	let stop_date = document.getElementById('stop_date');
	let date = new Date(new Date().getTime() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, -5);

	stop_date.value = date;
	stop_date.setAttribute("min", date);
	
	function setMinValue()
	{	
		if(stop_date.value < date)
		{
			alert('현재 시간보다 이전의 날짜는 설정할 수 없습니다.');
			stop_date.value = date;
	    }
	}
	</script>
</body>
</html>