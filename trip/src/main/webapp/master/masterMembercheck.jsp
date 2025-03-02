<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/head.jsp" %> 
<link rel="stylesheet" type="text/css" href="../css/masterMembercheck.css">
<%
//-------------------- 값 수령 --------------------
String pageno        = request.getParameter("page");
String search_type   = request.getParameter("search_type");
String keyword       = request.getParameter("keyword");
String detail_retire = request.getParameter("detail_retire");
String detail_stop   = request.getParameter("detail_stop");
String detail_admin  = request.getParameter("detail_admin");
String detail_all    = request.getParameter("detail_all");
String sort_type     = request.getParameter("sort_type");

//페이징 기본설정
if( pageno == null || pageno.equals("")               )  pageno        = "1"; 
if( search_type   == null || search_type.equals("")   )  search_type   = "user_id";
if( detail_retire == null || detail_retire.equals("") )  detail_retire = "N";
if( detail_stop   == null || detail_stop.equals("")   )  detail_stop   = "N";
if( detail_admin  == null || detail_admin.equals("")  )  detail_admin  = "N";
if( detail_all    == null || detail_all.equals("")    )  detail_all    = "Y";
if( keyword       == null || keyword.equals("")       )  keyword	   = "";
if( sort_type     == null || search_type.equals("")   )  sort_type     = "by_number";


int curpage = 1;
try{
		curpage = Integer.parseInt(pageno);
}catch(Exception e){  }

//------------------ DTO 선언 ----------------------
userDTO dto = new userDTO();
userVO vo = new userVO();
//------------------ 페이징 설정 ----------------------
int total = dto.GetTotal(curpage, search_type, detail_retire, detail_stop, detail_admin, detail_all, keyword, sort_type);
int perPage = 20;
int maxpage = total / perPage;	
if( total % perPage != 0) maxpage++;

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

//------------------ 회원목록 받기 ----------------------
ArrayList<userVO> list = dto.GetUserList(curpage, search_type, detail_retire, detail_stop, detail_admin, detail_all, keyword, sort_type);
%>

<script>

$(document).ready(function(){
		
	$(".tr")
	.mouseover(function(){
		$(this).css("background-color", "#F0F1EC");
	})
	.mouseout(function()
	{
		$(this).css("background-color", "");
	});
	
	// 수동으로 전체선택시, 전체선택 버튼이 자동으로 체크되고 
	// 하나라도 체크가 안 되면, 자동으로 전체선택버튼 체크가 풀림 
	$(".checkbox1").click(function(){
		
		var selAll = $('input:checkbox[name=selAll]');
		var each_view = $('input:checkbox[name=checkbox1]');
		var checked_view = $('input:checkbox[name=checkbox1]:checked');
		
		if(each_view.length == checked_view.length)  
		{
			// **제이쿼리로 찾기 때문에 selAll은 제이쿼리 객체에 담겨져있는 원소임**
			selAll[0].checked = true;
		
		}else 
		{
			selAll[0].checked = false;
		}
		
	});
	
	// ------------- 검색 버튼 중 모두 버튼이 체크 될때----------------
	$("#detail_all").click(function(){
	
		$("input:checkbox[class=search_check_type]").prop("checked", false);  
		$("input:checkbox[id=detail_all]").prop("checked", true); 
	});
	
	$(".search_check_type").click(function(){
		
		$("input:checkbox[id=detail_all]").prop("checked", false);  
	});
		
	if($(".search_check_type").is(':checked') == true)
	{
		$("input:checkbox[id=detail_all]").prop("checked", false); 
	}
});
	
//------------- 유저 조회 버튼 ----------------
function usercheck()
{	
	keyword = $("#user_keyword").val();
	user_search_type = $("select[name=user_search_type]").val()
	
	if( keyword == "")
	{
		if(user_search_type == "user_id")
		{
			$("#user_search").focus();
			alert("유저 아이디를 입력을 해주세요");
			return;
		}
		
		if(user_search_type == "user_name")
		{
			$("#user_search").focus();
			alert("유저 이름을 입력해주세요");
			return;
		}
		
		if(user_search_type == "user_nick")
		{
			$("#user_search").focus();
			alert("유저 닉네임을 입력해주세요");
			return;
		}
		
		if(user_search_type == "user_email")
		{
			$("#user_search").focus();
			alert("유저의 이메일을 입력해주세요");
			return;
		}
	}
	
	userCheckRun(user_search_type, keyword);
}

//------------- 유저 조회 함수 ----------------
function userCheckRun(user_search_type, keyword)
{	
	$.ajax({
		type : "post",
		url : "masterMembercheckok.jsp",
		data : 
		{
			user_search_type : user_search_type,
			keyword          : keyword
		},
		dataType : "html",
		success : function(result)
		{
			result = result.trim();
			$("#user_show").html(result);

		}
	});
} 

// ------------- 게시물 전체 체크 버튼 ----------------
function select_all(obj)
{
	if($(obj).is(":Checked") == true)
	{
		var choose_all = $(obj).is(":Checked");
		var each_view = $('input:checkbox[name=checkbox1]');
		
		$(each_view).each(function(){
			this.checked = true;
		
		});
	}else if($(obj).is(":Checked") == false)
	{
		var choose_all = $(obj);
		var each_view = $('input:checkbox[name=checkbox1]');
		
		$(each_view).each(function(){
			this.checked = false;
		
		});
	}
}
	
// --------------- 유저선택 함수 -------------------
function view(obj)
{
	document.location = 'masterMembercheckView.jsp?' + obj;
}
//--------------- 검색 함수 -------------------
function DoSearch()
{
	var retire = "N";
	var stop   = "N";
	var admin  = "N";
	var all    = "N";
	
	if($("#detail_retire").is(':checked') == true)
	{
		retire = $("#detail_retire").val();
	}
	
	if($("#detail_stop").is(':checked') == true)
	{
		stop = $("#detail_stop").val();
	}
	
	if($("#detail_admin").is(':checked') == true)
	{
		admin = $("#detail_admin").val();
	}
	
	if($("#detail_all").is(':checked') == true)
	{
		all = $("#detail_all").val();
	}
	
	document.location = "masterMembercheck.jsp?page=<%= pageno %>" + "&search_type=" + $("#search_type").val() + "&keyword=" + $("#keyword").val()  + "&detail_retire=" + retire  + "&detail_stop=" + stop  + "&detail_admin=" + admin	+ "&detail_all=" + all + "&sort_type=" + $("#sort_type").val();
	
}

//--------------- 정렬 함수 -------------------
function DoSort()
{
	document.location = "masterMembercheck.jsp?search_type=<%= search_type %>&keyword=<%= keyword %>&detail_retire=<%= detail_retire %>&detail_stop=<%= detail_stop %>&detail_admin=<%= detail_admin %>&detail_all=<%= detail_all %>&sort_type=" + $("#sort_type").val();
}
	
</script>
<style>


#tr_top 
{
	border-top: 2px solid gray;
	background-color: lightgray;
}

.tr 
{
	cursor : hand; cursor : pointer;
	border-bottom: 1px solid lightgray;
	text-align: center;
	font-size: 25px;
}
</style>
	
<body>
	<form method="get" name="masterMembercheck" id="masterMembercheck" action="masterMembercheckok.jsp"
	onsubmit="return false">
	<div style="margin-top:100px"></div>
	<table border="0" width="90%" style="margin-top:0px">
		<tr>
			<td id="td1" style="vertical-align: top; width : 50px;">
				<a href="masterMembercheck.jsp" id="href1"><b style="color:#1ABC9C">회원조회</b></a>
				<hr>
				<a href="masterGonggiwrite.jsp" id="href2"><b>공지사항</b></a>
				<hr>
				<a href="masterADindex.jsp" ><b>광고 관리</b></a>
				<hr>
				
				<div style=" margin-top : 100px; font-size : 30px;">빠른 회원 조회</div>
				<table border="0" width="90%" align="center" id="user_search_table" style="font-size:15px;">
					<tr>
						<td>
						<span style="display: inline-block;">
							<select id="user_search_type" name="user_search_type" style="width: 80px; height: 25px; font-size: 15px; margin-right : 10px;">
								<option value="user_id" >아이디</option>
								<option value="user_name" >이름</option>
								<option value="user_nick" >닉네임</option>
								<option value="user_email" >이메일</option>
							</select>
							<input type="text" name="user_keyword" id="user_keyword" value="" placeholder="입력해주세요" style="width: 150px;">
							<button type="button" id="check_btn" onclick="usercheck();"><b>조회</b></button>
							</span>
						</td>
					</tr>
				</table>
				<div id="user_show" style="font-size : 10px;">
				<!-- 이곳에 조회된 유저정보가 표시됩니다. -->
				</div>
			</td>
			<td style="background-color:gray;"></td>
			<td id="td2">
				<br>
				<table width="100%">
				<tr>
					<td style="height : 50px" colspan="8">
						<span style="display: inline-block;">
							<label>탈퇴</label><input type="checkbox" id="detail_retire" class="search_check_type" name="detail_retire" value="Y" <%= detail_retire.equals("Y") ? "checked" : "" %>>
							<label>정지</label><input type="checkbox" id="detail_stop"   class="search_check_type" name="detail_stop"   value="Y" <%= detail_stop.equals("Y") ? "checked" : "" %>>
							<label>관리자</label><input type="checkbox" id="detail_admin" class="search_check_type" name="detail_admin" value="Y" <%= detail_admin.equals("Y") ? "checked" : "" %>>
							<label>상관없음</label><input type="checkbox" id="detail_all"  name="detail_all" value="Y" <%= detail_all.equals("Y") ? "checked" : "" %>>
							<select id="search_type" name="search_type" style="width: 100px; height: 25px; font-size: 15px; margin-right : 10px;">
								<option value="user_id" <%= search_type.equals("user_id") ? "selected" : "" %>>아이디</option>
								<option value="user_name" <%= search_type.equals("user_name") ? "selected" : "" %>>이름</option>
								<option value="user_nick" <%= search_type.equals("user_nick") ? "selected" : "" %>>닉네임</option>
								<option value="user_email" <%= search_type.equals("user_email") ? "selected" : "" %>>이메일</option>
							</select>
							<input type="text" id="keyword" name="keyword" value="<%= keyword %>" style="border : 1">
							<input type="button" onclick="DoSearch();" id="search"  value="검색" class="search_btn">
						</span>
						<span style="display: inline-block; float: right;">
							<select id="sort_type" name="sort_type" style="width: 100px; height: 25px; font-size: 15px; margin-right : 5px;">
								<option value="by_number" <%= sort_type.equals("by_number") ? "selected" : "" %>>최근등록순</option>
								<option value="in_order" <%= sort_type.equals("in_order") ? "selected" : "" %>>가나다순</option>
							</select>
							<input type="button" onclick="DoSort();" id="sort"  value="정렬하기" class="sort_btn">
						</span>
					</td>
				</tr>
				<tr class="top_tr" id="tr_top">
				<th style="text-align : left; width : 50px;">
					전체 선택 &nbsp;
					<input type="checkbox" id="selAll" name="selAll" onclick="select_all(this);">
				</th>
				<th style="width : 50px;">번호</th>
				<th style="width : 50px;">아이디</th>
				<th style="width : 50px;">이름</th>
				<th style="width : 50px;">닉네임</th>
				<th style="width : 100px;">이메일</th>
				<th style="width : 50px;">탈퇴여부</th>
				<th style="width : 50px;">관리자여부</th>
				</tr>
				<%
				int seqNo = total - ((curpage - 1) * 20);
				for(userVO uvo : list)
				{
					String link_str = "";
					link_str += "page="+ pageno;
					link_str += "&search_type="+ search_type;
					link_str += "&keyword="+ keyword;
					link_str += "&sort_type="+ sort_type;
					link_str += "&detail_retire="+ detail_retire;
					link_str += "&detail_stop="+ detail_stop;
					link_str += "&detail_admin="+ detail_admin;
					link_str += "&detail_all="+ detail_all;
					link_str += "&uno=" + uvo.getUno();
					%>
					<tr class="tr" id="repeat_tr" style="font-size : 20px">
						<td>
							<input type="checkbox" name="checkbox1"  class="checkbox1" value="<%= uvo.getUno() %>">
						</td>
						<td style="width : 50px; font-size : 15px;" onclick="view('<%= link_str %>');"><%= seqNo -- %></td>
						<td style="width : 50px; font-size : 15px;" onclick="view('<%= link_str %>');"><%= uvo.getUid() %></td>
						<td style="width : 50px; font-size : 15px;" onclick="view('<%= link_str %>');"><%= uvo.getUname() %></td>
						<td style="width : 50px; font-size : 15px;" onclick="view('<%= link_str %>');"><%= uvo.getUnick() %></td>
						<td style="width : 100px; font-size : 15px;" onclick="view('<%= link_str %>');"><%= uvo.getEmail() %></td>
						<td style="width : 50px; font-size : 15px;" onclick="view('<%= link_str %>');"><%= uvo.getUretire() %></td>
						<td style="width : 50px; font-size : 15px;" onclick="view('<%= link_str %>');"><%= uvo.getAdmin() %></td>
					</tr>
					<% 
				}
				%>
				<tr>
					<td colspan= "7" style="font-size: 25px; text-align:center; padding left : 300px; border : 0;" >
					<%
					// **페이징 시작블럭번호와 끌블럭 번호를 계산 
					int startBlock = ((curpage - 1) / 10) * 10 + 1; // -> ex) 1,  11, 21 ,31
					int endBlock = startBlock + 9;					// -> ex) 10, 20, 30 ,40
					
					// endBlock이 최대 페이지 번호보다 크면 안됨
					if( endBlock > maxpage)
					{
						endBlock = maxpage;
					}	
		
					//이전 페이지 블럭을 표시한다.
					if(startBlock != 1)
					{
						%><a href="masterMembercheck.jsp?page=<%= startBlock - 1 %>&search_type=<%= search_type %>&detail_retire=<%= detail_retire %>&detail_stop=<%= detail_stop %>&admin=<%= detail_admin %>&detail_all=<%= detail_all %>&keyword=<%= keyword %>&sort_type=<%= sort_type %>">◀</a>&nbsp;<%
					}	
					
					//화면에 블럭 페이징을 표시한다.
					for(int pno = startBlock ; pno <= endBlock; pno++)
					{
						if( curpage == pno)
						{
							//현재 페이지 이면....
							%><a href="masterMembercheck.jsp?page=<%= pno %>&search_type=<%= search_type %>&detail_retire=<%= detail_retire %>&detail_stop=<%= detail_stop %>&admin=<%= detail_admin %>&detail_all=<%= detail_all %>&keyword=<%= keyword %>&sort_type=<%= sort_type %>"><b style="color:red;">&nbsp;&nbsp;&nbsp;(<%= pno %>)</b></a>&nbsp;<%
						}else
						{
							%><a href="masterMembercheck.jsp?page=<%= pno %>&search_type=<%= search_type %>detail_&retire=<%= detail_retire %>&detail_stop=<%= detail_stop %>&detail_admin=<%= detail_admin %>&detail_all=<%= detail_all %>&keyword=<%= keyword %>&sort_type=<%= sort_type %>">&nbsp;&nbsp;&nbsp;<%= pno %></a>&nbsp;<%	
						}
					}
					
					//다음 페이지 블럭을 표시한다.
					if(endBlock < maxpage)
					{
						%><a href="masterMembercheck.jsp?page=<%= endBlock + 1 %>&search_type=<%= search_type %>&detail_retire=<%= detail_retire %>&detail_stop=<%= detail_stop %>&detail_admin=<%= detail_admin %>&detail_all=<%= detail_all %>&keyword=<%= keyword %>&sort_type=<%= sort_type %>">▶</a>&nbsp;<%
					}
					%>
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