<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="trip.vo.*" %>
<%@ page import="trip.dto.*" %>
<%@ page import="java.util.*" %>
<%
//--------------------- 값 받아옴 ---------------------
String user_search_type = request.getParameter("user_search_type");
String keyword = request.getParameter("keyword");

// --------------------- 유효성 체크 ---------------------
if( user_search_type == null || user_search_type.equals(""))
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("유저 조회 타입을 설정해주세요");
		return;
	});
	</script>
	<% 
	return;
}

if( keyword == null || keyword.equals(""))
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("유호한 값을 입력해주세요");
		return;
	});
	</script>
	<% 
	return;
}


userDTO dto = new userDTO();
userVO vo = new userVO();

//--------------------- 유저 정보 조회 ---------------------
ArrayList<userVO> list = dto.ShowUser(user_search_type, keyword);
System.out.println(list.size());
if( list.size() == 0)
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("해당 회원은 존재하지 않습니다. 다시 한번 확인해주세요.");
		return;
	});
	</script>
	<% 
	return;
	
}

if( list.size() > 1)
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("중복된 아이디나 이름, 닉네임의 회원이 있습니다.");
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

vo = list.get(0);
// 선호계절 받기
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

// 선호일정 받기
if(vo.getSchedule() == null || vo.getSchedule().equals(""))
{
	schedule = "없음";
}else
{
	schedule = vo.getSchedule();
}

// 선호장소 받기
if(vo.getUinout() == null || vo.getUinout().equals(""))
{
	uinout = "없음";
}else
{
	uinout = vo.getUinout();
}

//-------------- 중복된 타입과 키워드로 검색시 알림(보류)---------------

%>
<style>
</style>
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

//------------- 유저 정지 체크 버튼 ----------------
function userStop(uno)
{
	var stop_date = $("#stop_date").val();
	
	alert(stop_date);
	if(confirm("정지하시겠습니까?") == false)
	{
		return;
	}
	
	$.ajax({
		type : "post",
		url : "masterMemberStop.jsp",
		data : 
		{
			uno : uno,
			stop_date : stop_date
		},
		dataType : "html",
		success : function(result)
		{
			result = result.trim();
			$("#user_show").html(result);
		}
	});
}
</script>
	<table border = "1" style="font-size : 18px; width : 400px; height : 350px;" >
		<tr>
			<td>
				<b>아이디</b>
			</td>
			<td style="width : 120px;">
				<%= vo.getUid() %>
			</td>
			<td>
				<b>이름</b>
			</td>
			<td>
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
			<td style="font-size : 14px;">
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
				<b>사용자<br>이모티콘</b>
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
				<table border="1" width="100%" style="font-size : 12px;">
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
				<input type="datetime-local" id="stop_date" name="stop_date" style="width : 200px" onchange="setMinValue()">
				&nbsp;&nbsp;
				<button type="button" name="stop_btn" id="stop_btn" onclick="userStop(<%= vo.getUno() %>);">
					<b>정지</b>
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
			<td id="user_stop_date" style="font-size : 12px;">
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
	
