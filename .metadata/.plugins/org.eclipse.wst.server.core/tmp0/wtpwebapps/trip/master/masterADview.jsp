<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/head.jsp" %> 
<link rel="stylesheet" type="text/css" href="../css/masterGonggiwrite.css">    
<%
//-------------------- 값 수령 --------------------
String pageno      = request.getParameter("page");
String category    = request.getParameter("category");
String subclass    = request.getParameter("subclass");
String search_type = request.getParameter("search_type");
String sort_type   = request.getParameter("sort_type");
String detail_vip   = request.getParameter("detail_vip");
String keyword     = request.getParameter("keyword");
String advertno     = request.getParameter("advertno");

//페이징 기본설정
if( pageno      == null )  pageno      = "1";
if( category    == null )  category    = "";
if( subclass    == null )  subclass    = "";
if( search_type == null )  search_type = "category";
if( detail_vip == null )  detail_vip   = "N";
if( sort_type   == null )  sort_type   = "by_category";
if( keyword      == null ) keyword     = "";

if(pageno        == null || pageno.equals("")) 
{
	pageno  = "1";
}

int curpage = 1;
try{
		curpage = Integer.parseInt(pageno);
}catch(Exception e){  }
// -------------------- DTO 선언 -------------------
advertDTO dto       = new advertDTO();
advertVO vo         = new advertVO();
adkeywordDTO kdto   = new adkeywordDTO();
adkeywordVO kvo     = new adkeywordVO();
adksimilarDTO sdto = new adksimilarDTO();
adksimilarVO svo   = new adksimilarVO();
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

//게시물 번호 유효성 확인
if(advertno == null || advertno.equals(""))
{
	%>
	<script>
	$(document).ready(function(){
		
		alert("유효하지 않은 광고번호입니다.");
		history.back();
		return;
	});
	</script>
	<% 
	return;
}

//--------------------- 공지게시글 목록 조회 ------------------- 
vo = dto.Read(advertno);

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
//------------- 광고노출 시각화에 필요한 DTO, VO 선언 -------------
ad_exposureDTO ex_dto = new ad_exposureDTO();
ArrayList<ad_exposureVO> ex_list = ex_dto.GetExposure_info(advertno);
%>
<style>
.btn
{
	border: 0px; 
	font-size: 25px;
	border-radius: 0.2em;
	cursor: pointer;
	width: 80px;
	height: 40px;
	color: white; 
	margin-bottom : 20px;
}

.xx
{
	border-spacing: 20px 20px;

}

#info_view td, th
{
	padding-top    : 10px;
	padding-bottom : 10px;
}

#calender_table
{
	display : none;
}
#exposure_table
{
	display : none;
}

#keyword_table
{
	display : none;
}

</style>
<script>


$(document).ready(function(){
	
		// 달력 테이블 표시 버튼
		$("#show_calender_table_btn").click(function()
		{
			if($("#calender_table").is(":visible"))
			{
				$("#calender_table").css("display","none");
				$("#show_calender_table_btn").html("달력 표시")
			}else
			{
				$("#calender_table").toggle();
				$("#show_calender_table_btn").html("달력 숨기기")
			}
		});
		
		// 광고노출 테이블 토글 버튼
		$("#show_exposure_table_btn").click(function()
		{
			if($("#exposure_table").is(":visible"))
			{
				$("#exposure_table").css("display","none");
				$("#show_exposure_table_btn").html("노출정보 표시")
			}else
			{
				$("#exposure_table").toggle();
				$("#show_exposure_table_btn").html("노출정보 숨기기")
			}
		});
		
		// 키워드 테이블 토글 버튼
		$("#show_keyword_table_btn").click(function()
		{
			if($("#keyword_table").is(":visible"))
			{
				$("#keyword_table").css("display","none");
				$("#show_keyword_table_btn").html("키워드란 표시")
			}else
			{
				$("#keyword_table").toggle();
				$("#show_keyword_table_btn").html("키워드란 숨기기")
			}
		});
		
		$("#show_keyword_table_btn")
		.mouseover(function(){
			$(this).css("background-color", "dimgray")
		})
		.mouseleave(function(){
			$(this).css("background-color", "gray")
		})
		
		
		$.ajax({
			type : "post",
			url : "masterADCalender.jsp",
			dataType : "html",
			success : function(result)
			{
				result = result.trim();
				$("#calender_td").html(result);

			}
		});
		
	});
	
	// 글목록 버튼
	function gotoList(obj)
	{
		document.location = "masterADindex.jsp?" + obj;
	}
	
	// 글수정 버튼
	function modifyBoard(obj)
	{
		if(confirm("해당 게시글을 수정하시겠습니까?") == true)
		{
			document.location = "masterADmodify.jsp?" + obj;
		}
	}
	
	// 글 삭제 버튼
	function deleteBoard(obj)
	{
		if(confirm("해당 게시글을 삭제하시겠습니까?") == true)
		{
			document.location = "masterADdelete.jsp?" + obj;
		}
	}
	
	

	
</script>
<body>
	<form method="post" name="masterADview" id="masterADview" action="masterADwrite.jsp">
		
		<!-- 중간부분입니다 -->
		<div style="margin-top:100px"></div>
		<div style="margin-top:100px"></div>
		<table border="0" width="90%" style="vertical-align:top;">
			<tr>
				<td id="td1" style="vertical-align:top; width : 300px;">
					<a href="masterMembercheck.jsp" ><b>회원조회</b></a>
					<hr>
					<a href="masterGonggiwrite.jsp" ><b>공지사항</b></a>
					<hr>
					<a href="masterADindex.jsp" ><b style="color:#1ABC9C">광고 관리</b></a>
					<hr>
				</td>
				<td style="background-color:gray;"></td>
				<td id="td2">
					<table border="0" width="90%" align="center" style="border-collapse: collapse;" id="view">
						<tr>
							<td colspan="5" align="right">
								<% 
								String link_str = "";
								link_str += "page="+ pageno;
								link_str += "&category="+ category;
								link_str += "&subclass="+ subclass;
								link_str += "&search_type="+ search_type;
								link_str += "&keyword="+ keyword;
								link_str += "&detail_vip="+ detail_vip;
								link_str += "&start_date="+ vo.getVipStartDate();
								link_str += "&stop_date="+ vo.getVipEndDate();
								link_str += "&sort_type="+ sort_type;
								link_str += "&advertno="+ vo.getAdvertno();
								%>
								<button type="button" class ="btn" id="list_btn" style="background-color : #008000;  font-size : 15px; margin-right : 80px;" 
								onclick="gotoList('<%= link_str %>')">목록으로</button>
								<button type="button" class ="btn" id="modify_btn" style="background-color : #7CADFF; font-size : 15px; margin-right : 10px;" 
								onclick="modifyBoard('<%= link_str %>')">광고물 수정</button>
								<button type="button" class ="btn" id="delete_btn" style="background-color : #EF4E4E; font-size : 15px;"
								 onclick="deleteBoard('<%= link_str %>');">삭제하기</button>
							</td>
						</tr>
						<tr>
							<td>
												<table border="1" width="70%" style="text-align : center;" id="info_view">
													<tr>
														<th width="120px">상위 카테고리</th>
														<td width="150px"><%= vo.getCategory() %></td>
														<th width="120px">하위 카테고리</th> 
														<td width="150px"><%= vo.getSubclass() %> </td>
													</tr>
													<tr>
														<th>상품 번호</th> 
														<td><%= vo.getAdvertno() %></td>
														<th>상품 VIP여부</th> 
														<%
															String vipWhether = "";
															
															if(vo.getVipWhether().equals("0"))
															{
																vipWhether = "N";
															}else if(vo.getVipWhether().equals("1"))
															{
																vipWhether = "Y";
															}
														%>
														<td><%= vipWhether %></td>
													</tr>
													<tr>
														<th>상품명</th>
														<td colspan="3"><%= vo.getProductName() %></td>
													</tr>
													<tr>
														<th>상품 가격</th> 
														<td><%= vo.getPrice() %>원</td>
														<th>VIP 선정 횟수</th> 
														<td><%= vo.getVipTimes() %></td>
													</tr>
													<tr>
														<th>VIP 유지기간</th> 
														<% 
															String startDay = "";
															String endDay = "";
														
															if(vo.getVipWhether().equals("1") && vo.getVipStartDate() != null && vo.getVipEndDate() != null)
															{
																startDay = vo.getVipStartDate();
																endDay = vo.getVipEndDate();
																
																if((startDay.substring(0,4)).equals((endDay.substring(0,4))))
																{
																	endDay = endDay.substring(5);
																}
																%><td colspan="3"><%= startDay %> ~ <%= endDay %></td><%
															}else
															{
																%><td colspan="3">해당사항 없음</td><%
															}
														%>
														
													</tr>
													<tr>
														<th>광고 이미지</th>
														<td colspan="3"><img src="<%= vo.getImageURL() %>"></td>
													</tr>
													<tr>
														<th>상품 상세 URL</th>
														<td colspan="3" style="font-size : 15px; text-align : left;"><a href="<%= vo.getDetailURL() %>"><%= vo.getDetailURL() %></a></td>
													</tr>
								</table>
								
							</td>
						</tr>
					</table>
					<div style="position : relative; left : 0px; margin-top : 10px;">
						<button type="button" id="show_calender_table_btn" class="btn" style="background-color : gray; font-size : 15px; width : 150px;">달력란 표시</button>
					</div>
					<table border="1" width="60%" style="text-align : center;" id="calender_table">
						<tr>
							<th colspan="4">달력</th>
						</tr>
						<tr>
							<td colspan="4" id="calender_td"></td>
						</tr>
						<tr>
						</tr>
					</table>
					<div style="position : relative; left : 0px; margin-top : 10px;">
						<button type="button" id="show_exposure_table_btn" class="btn" style="background-color : gray; font-size : 15px; width : 150px;">노출정보 표시</button>
					</div>
					<table border="1" width="60%" style="text-align : center;" id="exposure_table">
					<tr>
						<th colspan="3">해당광고 노출 정보(최근 20번)</th>
					</tr>
					<tr>
						<td colspan="1">총 노출횟수</td>
						<%
						String exposure_count;
						if(vo.getExposure_count() == null || vo.getExposure_count().equals(""))
						{
							exposure_count = "해당사항 없음";
						}else
						{
							exposure_count = vo.getExposure_count();
						}
						%>
					<td colspan="2"><%= exposure_count %></td>
					</tr>
					<tr>
						<td>노출된 날짜</td>
						<td>노출된 게시물</td>
						<td>유저 정보</td>
					</tr>
					<%
						int count = 0;
					
						for(ad_exposureVO ex_vo : ex_list)
						{
							if(ex_vo.getExposure_date() != null && ex_vo.getBno() != null && ex_vo.getUno() != null)
							{
								%>
								<tr>
									<td><%= ex_vo.getExposure_date() %></td>
									<td><%= ex_vo.getBno() %></td>
									<td><%= ex_vo.getUno() %></td>
								</tr>
								<%
								count++;
								if( count >= 20)
								{
									break;
								}
							}else
							{
								%>
								<tr>
									<td colspan="3">노출된 적 없음</td>
								</tr>
								<%
							}
						}
					
					%>
					</table>
					<div style="position : relative; left : 0px; margin-top : 10px;">
						<button type="button" id="show_keyword_table_btn" class="btn" style="background-color : gray; font-size : 15px; width : 150px;">키워드란 표시</button>
					</div>
					<table border="1" style="font-size : 15px; text-align : center; margin-left : 66px;" id="keyword_table">
						<% 
						ArrayList<adkeywordVO> list1 = kdto.GetKeyword(vo.getAdvertno());
						%>
							<tr>
								<td rowspan="<%= list1.size()*2 %>"  width="150px">광고 키워드</td>	
						<%
						for(adkeywordVO each_vo : list1)
						{
							%>
									<td rowspan="2" width="70px"><%= each_vo.getKeyword() %></td>
									<td width="100px">유사키워드</td>
									<% 
										ArrayList<adksimilarVO> list2 = sdto.GetSimilarKeyword(each_vo.getAdkeyno());
										for(adksimilarVO sim_vo : list2)
										{
											%>
												<td width="100px"><%= sim_vo.getAdkskey() %></td>
											<% 
										}
									%> 
								</tr>
								<tr>
									<td>유사도</td>
									<% 
										for(adksimilarVO sim_vo : list2)
										{
											%>
												<td><%= sim_vo.getAdksfr() %></td>
											<% 
										}
									%> 
								</tr>
							<%
						}
						%>
					</table>
				</td>
			</tr>
		</table>
		<div style="height : 600px;"></div>
	</form>
</body>
</html>