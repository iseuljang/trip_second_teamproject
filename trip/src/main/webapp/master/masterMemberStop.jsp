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
<table border = "1" style="font-size : 18px; width : 450px; height : 350px;" >
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
	               		case "1": icon  = "😄"; break;	
	               		case "2": icon  = "😆"; break;  
	               		case "3": icon  = "😅"; break;  
	               		case "4": icon  = "😀"; break;  
	               		case "5": icon  = "😨"; break;  
	               		case "6": icon  = "👿"; break;  
	               		case "7": icon  = "😝"; break;  
	               		case "8": icon  = "😷"; break;  
	               		case "9": icon  = "😴"; break;  
	               		case "10": icon  = "😱"; break;  
	                }
				}
				%>
				<td colspan="3">
					<div style="display: inline-block;">
						<div style="display: inline-block;">
							<table border="1" width="250px;" style="font-size : 12px;">
								<tr>
									<td style="font-size : 20px" colspan="3">
										<%= icon %>
									</td>
								</tr>
							</table>
						</div>
						<div style="display: inline-block; margin-bottom : 0px;">
								<button type="button">변경</button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<b>관심분야</b>
				</td>
			<td colspan="3">
				<div style="display: inline-block; align : left; margin-left : 10px; width : 250px;">
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
				</div>
				<div style="display: inline-block;">
					<button type="button">변경</button>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<b>회원이용정지</b>
			</td>
			<td colspan="3">
				<input type="datetime-local" id="stop_date" name="stop_date" style="width : 150px" onchange="setMinValue()">
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