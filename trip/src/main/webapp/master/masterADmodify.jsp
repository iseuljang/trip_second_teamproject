
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/head.jsp" %> 
<link rel="stylesheet" type="text/css" href="../css/masterGonggiwrite.css">    
<%
//-------------------- 값 수령 --------------------
String pageno      = request.getParameter("page");
String category    = request.getParameter("category");
String subclass    = request.getParameter("subclass");
String search_type = request.getParameter("search_type");
String detail_vip  = request.getParameter("detail_vip");
String start_date  = request.getParameter("start_date");
String stop_date   = request.getParameter("stop_date");
String sort_type   = request.getParameter("sort_type");
String keyword     = request.getParameter("keyword");
String advertno    = request.getParameter("advertno");

//페이징 기본설정
if( pageno      == null  )  pageno      = "1";
if( category    == null  )  category    = "";
if( subclass    == null  )  subclass    = "";
if( search_type == null  )  search_type = "category";
if( detail_vip == null   )  detail_vip  = "N";

if( start_date == null   )
{
	start_date  = "";
}else
{
	start_date = start_date.replace(" ","T");
}

if( stop_date == null    )
{
	stop_date   = "";
}else
{
	stop_date = stop_date.replace(" ","T");
}

if( sort_type   == null  )  sort_type   = "by_category";
if( keyword      == null )  keyword     = "";

if(pageno        == null || pageno.equals("")) 
{
	pageno  = "1";
}

int curpage = 1;
try{
		curpage = Integer.parseInt(pageno);
}catch(Exception e){  }
//-------------------- DTO 선언 -------------------
advertDTO dto     = new advertDTO();
advertVO vo       = new advertVO();
adkeywordDTO kdto = new adkeywordDTO();
adkeywordVO kvo   = new adkeywordVO();
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
		
		alert("유효하지 않은 광고물입니다.");
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
		
		alert("수정할 광고글이 존재하지 않습니다.");
		history.back();
		return;
	});
	</script>
	<% 
	return;
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
	
	// 기존의 카테고리로 설정 
	$("#top_category").val("<%= vo.getCategory() %>")
	selectChange()
	$("#sub_category").val("<%= vo.getSubclass() %>")
	
	
});
//------------------- 공지글 수정 버튼 ----------------------
function DoModify()
{
	 
	 if($("#adtitle").val() == "")
	 {
		 alert("제목을 입력하세요");
		 $("#adtitle").focus();
		 return;
	 }
	 if($("#fname").val() == "")
	 {
		 alert("파일을 업로드 해주세요");
		 return;
	 }
	 if($("#startday").val() == "")
	 {
		 alert("시작일을 입력해주세요");
		 return;
	 }
	 if($("#endday").val() == "")
	 {
		 alert("종료일을 입력해주세요");
		 return;
	 }
	if( confirm("게시물을 수정하시겠습니까?")==true)
	 {
		$("#mastermodify").submit();
	 }
}

function selectChange()
{ 
	var fashion = [ "여성패션", "남성패션", "남녀공용패션", "유아동패션" ];

	var beauty = [
		"럭셔리","스킨케어","클린/비건뷰티","클렌징/필링", "더마코스메틱", "메이크업", "향수", "남성화장품", 
		"네일", "뷰티소품", "어린이화장품", "로드샵", "헤어", "바디", "선물세트/키트"
		]; 
		
	var child = [
		"유아동패션", "기저귀", "물티슈", "분유/어린이식품", "어린이 건강식품", "수유용품", "이유용품/유아식기", "매트/안전용품",
		"유모차/웨건", "카시트", "아기띠/외출용품", "욕실용품/스킨케어", "위생/건강/세제", "유아동침구", "유아가구/인테리어", "완구/교구", 
		"출산준비물/선물", "임부/태교용품" 
		];
	
	var food = [
		"유기농/친환경 전문관", "과일", "견과/건과", "채소", "쌀/잡곡", "축산/계란", "수산물/건어물", "생수/음료",
		"커피/원두/차", "과자/초콜릿/시리얼", "면/통조림/가공식품", "가루/조미료/오일", "장/소스/드레싱/식초", "유제품/아이스크림", "냉장/냉동/간편요리", "건강식품", 
		"선물세트관", "반찬/간편식/대용식", "곤약/방탄커피 외"
		];
	
	var kitchen_utensils = [
		"주방가전", "냄비/프라이팬", "주방조리도구", "그릇/홈세트", "수저/커트러리", "컵/텀블러/와인용품", "주전자/커피/티용품", "주방수납/정리",
		"밀폐저장/도시락", "주방잡화", "일회용품/종이컵", "보온/보냉용품", "1인가구 주방용품", 
		];
	
	var household_goods = [
		"헤어", "바디/세안", "구강/면도", "화장지/물티슈", "생리대/성인기저귀", "기저귀", "세탁세제",
		"청소/주방세제", "탈취/방향/살충", "건강/의료용품", "세탁/청소용품", "욕실용품", "생활전기용품", "수납/정리", "주방수남/잡화"
		];
	
	var home_interior = [
		"여름 침구샵", "싱글하우스", "홈데코", "가구", "수납/정리", "침구", "커튼/블라인드", "카페트/쿠션/거실화",
		"수예/수선", "욕실용품", "조명/스탠드", "셀프인테리어", "원예/가드닝", "생활전기용품", "공구/철물/DIY", "안전/신호용품", 
		"세탁/청소용품"
		];
	
	var home_appliances = [
		"TV/영상가전", "냉장고", "세탁기/건조기", "생활가전", "청소기", "계절가전", "뷰티/헤어가전", "건강가전",
		"주방가전", "노트북", "데스크탑", "모니터", "휴대폰", "태블릿PC", "스마트워치/밴드", "게임", 
		"키보드/마우스", "저장장치", "프린터/복합기", "PC부품",
		"PC주변기기", "음향기기", "카메라", "전동킥보드/자전거", "차량용 디지털", "1인방송 전문관", "휴대폰/액세서리"
		];
	
	var sports = [
		"캠핑전문관", "홈트레이닝", "수영/수상스포츠", "골프", "자전거", "킥보드/스케이트", "낚시", "유아동등산/아웃도어패션",
		"스포츠신발", "남성스포츠의류", "여성스포츠의류", "유아스포츠의류", "스포츠잡화", "구기스포츠", "라켓스포츠", "헬스/요가/댄스", 
		"복싱/검도/태권도", "기타스포츠", "스키/겨울스포츠"
		];
	
	var car_supplies = [
		"봄철 차량관리", "인테리어", "익스테리어", "세차/카케어", "차량용 전자기기", "차량관리/소모품", "RV/아웃도어", "부품/안전/공구",
		"오토바이용품"
		];
	
	var book_record_DVD = [
		"유아/어린이", "소설/에세이/시", "초중고참고서", "가정 살림", "건강 취미", "경제 경영", "과학/공학", "국어/외국어/사전",
		"대학교재", "만화/라이트노벨", "사회/정치", "수험서/자격증", "여행", "역사", "스마트워치/예술", "인문", 
		"자기계발", "잡지", "종교", "청소년", "해외도서", "IT컴퓨터", "CD/LP", "DVD/블루레이"
		];
	
	var toy_hobby = [
		"신생아/영아완구", "로봇/작동완구", "역할놀이", "블록놀이", "인형", "물놀이/계절완구", "승용완구", "스포츠/야외완구",
		"실내대형완구", "STEAM완구", "학습완구/교구", "보드게임", "RC완구/부품", "퍼즐/큐브/피젯토이", "프라모델", "피규어/다이캐스트", 
		"콘솔/휴대용게임기", "파티/미술용품", "DIY", "악기/음향기기", "원예/가드닝", "수집품", "연령별완구", "키덜트샵"
		];
	
	var office_supplies = [
		"사무용품 전문관", "미술/화방용품", "캐릭터 문구", "학용품/수업준비", "필기류", "노트/메모지", "다이어리/플래너", "바인더/파일",
		"파티/이벤트", "데코/포장용품", "카드/엽서/봉투", "앨범", "복사용품/라벨지", "보드/칠판/광고" 
		];
	
	var pet_supplies = [
		"강아지 사료", "강아지 간식", "강아지 영양제", "강아지 용품", "고양이 사료", "고양이 간식", "고양이 영양제", "고양이 용품",
		"펫티켓 산책용품", "관상어 용품", "소동물/가축용품" 
		];
	
	var health_food = [
		"건강기능식품", "성인용 건강식품", "여성용 건강식품", "남성용 건강식품", "임산부 건강식품", "시니어 건강식품", "어린이 선강식품", "비타민/미네랄",
		"영양제", "허브/식물추출물", "홍삼/인삼", "건강즙/음료", "꿀/프로폴리스", "건강분말/건강환", "헬스보충식품", "다이어트/이너뷰티", 
		"헬스/요가용품", "건강도서", "건강/의료용품", "샐러드/닭가슴살"
		];
	
	var change_sub;
	if( $("#top_category").val() == "패션")
	{  
		change_sub = fashion;
		
	}else if( $("#top_category").val() == "뷰티")
	{  
		change_sub = beauty;
		
	}else if( $("#top_category").val() == "출산/유아동")
	{  
		change_sub =  child;
		
	}else if( $("#top_category").val() == "식품")
	{  
		change_sub =  food;
		
	}else if( $("#top_category").val() == "주방용품")
	{  
		change_sub =  kitchen_utensils;
		
	}else if( $("#top_category").val() == "생활용품")
	{  
		change_sub =  household_goods;
		
	}else if( $("#top_category").val() == "홈인테리어")
	{  
		change_sub =  home_interior;
		
	}else if( $("#top_category").val() == "가전디지털")
	{  
		change_sub =  home_appliances;
		
	}else if( $("#top_category").val() == "스포츠/레저")
	{  
		change_sub =  sports;
		
	}else if( $("#top_category").val() == "자동차용품")
	{  
		change_sub =  car_supplies;
		
	}else if( $("#top_category").val() == "도서/음반/DVD")
	{	
		change_sub =  book_record_DVD;
		
	}else if( $("#top_category").val() == "완구/취미")
	{  
		change_sub =  toy_hobby;
		
	}else if( $("#top_category").val() == "문구/오피스")
	{  
		change_sub =  office_supplies;
		
	}else if( $("#top_category").val() == "반려동물용품")
	{  
		change_sub =  pet_supplies;
		
	}else if( $("#top_category").val() == "헬스/건강식품")
	{  
		change_sub =  health_food;
	}else if( $("#top_category").val() == "")
	{  
		change_sub =  ["선택해주세요"];
	}
	
	$('#sub_category').empty();
	
	for(var count = 0; count < change_sub.length; count++)
	{
		var option = $("<option>" + change_sub[count] + "</option>");
		$('#sub_category').append(option);            
	} 
}

//---------------- 글목록 버튼 -------------------
function goooList(obj)
{
	document.location = "masterADindex.jsp?" + obj;
}
//---------------- 광고 수정완료 버튼 -------------------
function DoModify()
{
	
	if( confirm("광고물 수정을 완료하시겠습니까?") == true)
	{
		$("#masterADmodify").submit();
	}
}

//---------------- 수정최소 버튼 -------------------
function CancelModify(obj)
{
	if( confirm("수정을 취소하시겠습니까?") == true)
	{
		history.back();
	}
}
</script>
<body>
	<form method="post" name="masterADmodify" id="masterADmodify" action="masterADmodifyOK.jsp">
	<input type="hidden" id="for_link_page" name="page" value="<%= pageno %>">
	<input type="hidden" id="for_link_category" name="category" value="<%= category %>">
	<input type="hidden" id="for_link_subclass" name="subclass" value="<%= subclass %>">
	<input type="hidden" id="for_link_search_type" name="search_type" value="<%= search_type %>">
	<input type="hidden" id="for_link_detail_vip" name="detail_vip" value="<%= detail_vip %>">
	<input type="hidden" id="for_link_sort_type" name="sort_type" value="<%= sort_type %>">
	<input type="hidden" id="for_link_keyword" name="keyword" value="<%= keyword %>">
	<input type="hidden" id="advertno" name="advertno" value="<%= advertno %>">
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
								link_str += "&detail_vip="+ detail_vip;
								link_str += "&keyword="+ keyword;
								link_str += "&sort_type="+ sort_type;
								link_str += "&advertno="+ vo.getAdvertno();
								%>
								<button type="button" class ="btn" id="list_btn" style="background-color : #008000;  font-size : 15px; margin-right : 60px;" 
								onclick="gotoList('<%= link_str %>')">글목록으로</button>
							</td>
						</tr>
						<tr>
							<td>
												<table border="1" width="70%" style="text-align : center; text">
													<tr class="xx">
														<th width="120px">상위 카테고리</th>
														<td width="150px">
														<select id="top_category" onchange="selectChange()" name="top_category" style="width : 150px; text-align : center; font-size : 15px;">
															<option value="">선택해주세요</option>
															<%
																advertDTO adto_for_cate = new advertDTO();
																advertVO avo_for_cate = new advertVO();
																List<advertVO> top_list = adto_for_cate.GetCategory();
																for(advertVO advo : top_list)
																{
																	%><option value="<%= advo.getCategory() %>"><%= advo.getCategory() %></option><% 
																}
															%>
														</select>
														</td>
														<th width="120px">하위 카테고리</th> 
														<td width="150px">
															<select id="sub_category" name="sub_category" style="width : 150px; text-align : center; font-size : 15px;">
																<option value="">선택해주세요</option>
															</select>
														</td>
													</tr>
													<tr>
														<th>상품 번호</th> 
														<td><%= vo.getAdvertno() %></td>
														<th>상품 VIP여부</th>
														<td>
															<label>Y</label>
															<input type="radio" name="vip_whether" id="vip_whether_Y" value="Y" <%= vo.getVipWhether().equals("1") ? "checked" : "" %>>
															<label style="margin-left : 40px;">N</label>
															<input type="radio" name="vip_whether" id="vip_whether_N" value="N" <%= vo.getVipWhether().equals("0") ? "checked" : "" %>>
														</td>
													</tr>
													<tr class="xx">
														<th>상품명</th>
														<td colspan="3">
															<input type="text" id="product_name" name="product_name" value="<%= vo.getProductName() %>" style="width : 90%;">
														</td>
													</tr>
													<tr>
														<th>상품 가격</th> 
														<td>
														<input type="text" id="product_price" name="product_price" value="<%= vo.getPrice() %>" style="width : 150px;">원
														</td>
														<th>VIP 선정 횟수</th> 
														<td><%= vo.getVipTimes() %></td>
													</tr>
													<tr>
														<th>VIP 시작일</th>
														<td colspan="1">
															<input type="datetime-local" class="date_setting" id="start_date" name="start_date" 
															style="width : 200px; height : 30px; font-size : 15px;" onchange="setStartMinValue()">
															<span class="block_date_setting" style="display : none">해당사항 없음</span>
														</td>
														<th>VIP 종료일</th>
														<td colspan="1">
															<input type="datetime-local" class="date_setting" id="stop_date" name="stop_date" 
															style="width : 200px; height : 30px; font-size : 15px;" onchange="setStopMinValue()">
															<span class="block_date_setting" style="display : none">해당사항 없음</span>
														</td>
													</tr>
													<tr class="xx">
														<th>광고 이미지</th>
														<td colspan="3"><img src="<%= vo.getImageURL() %>"></td>
													</tr>
													<tr>
														<th>상품 상세 URL</th>
														<td colspan="3" style="font-size : 15px; text-align : left;"><input type="text" name="detail_URL" id="detail_URL" style="width : 100%;"value="<%= vo.getDetailURL() %>"></td>
													</tr>
												</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="5" align="right">
					<button type="reset" class ="btn" id="reset_btn" 
					style="color : #EF5F8E; font-size : 15px; margin-right : 20px; border-color: red; background-color : white;">초기화</button>
					<button type="button" class ="btn" id="cancel_btn" style="background-color : #EF5F8E;  font-size : 15px; margin-right : 60px;" 
					onclick="CancelModify('<%= link_str %>')">수정 취소</button>
					<button type="button" class ="btn" id="modify_btn" style="background-color : #7CADFF; font-size : 15px; margin-right : 120px;"
					onclick="DoModify()">수정 완료</button>
				</td>
			</tr>
		</table>
		<div style="height : 600px;"></div>
	</form>
	<script>
	$(document).ready(function(){
		if($('input[id=vip_whether_N]').is(":checked") == true)
		{
			$(".date_setting").css("display","none");
			$(".block_date_setting").css("display","");
		}
		
		$('input[name=vip_whether]').change(function(){
			if($(this).val() == 'Y')
			{
				$(".date_setting").css("display","");
				$(".block_date_setting").css("display","none");
				
			}else if($(this).val() == 'N')
			{
				$(".date_setting").css("display","none");
				$(".block_date_setting").css("display","");
			}
		});
			
	});
	
	
	
	let date = new Date(new Date().getTime() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, -5);
	let start_date = document.getElementById('start_date');
	<% if(!start_date.equals(""))
		{
			%>
			start_date.value ="<%= start_date %>"
			console.log("<%= start_date %>")
			<%
		}else
		{
			%>
			start_date.value = date;
			<%
		}
		
	%>
	
	start_date.setAttribute("min", date);
	
	let stop_date  = document.getElementById('stop_date');
	<% if(!stop_date.equals(""))
	{
		%>
		stop_date.value ="<%= stop_date %>"
		console.log("<%= stop_date %>")
		<%
	}else
	{
		%>
		stop_date.value = date;
		<%
	}
	%>
	stop_date.setAttribute("min", date);
	
	function setStartMinValue()
	{	
		if(start_date.value < date)
		{
			alert('현재 시간보다 이전의 날짜는 설정할 수 없습니다.');
			start_date.value = date;
	    }
		
		stop_date.value = start_date.value;
		stop_date.setAttribute("min", start_date.value);
	}
	
	function setStopMinValue()
	{	
		if(stop_date.value < start_date.value)
		{
			alert('시작일보다 이전의 날짜는 설정할 수 없습니다.');
			start_date.value = date;
	    }
	}
	
	</script>
</body>
</html>