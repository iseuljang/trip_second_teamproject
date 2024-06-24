<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/head.jsp" %> 
<link rel="stylesheet" type="text/css" href="../css/masterwriteok.css">    
<%
//--------------------- 접근제어 ------------------
//비로그인시 접근제어
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

//관리자 권한 확인
adminboardDTO dto = new adminboardDTO();
if(dto.CheckAdmin(login.getUid()) == false)
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
%>
	<script>
	$(document).ready(function()
	{
		
		$('input[name=vip_whether]').change(function(){
			if($(this).val() == 'Y')
			{
				$(".date_setting_tr").css("display","");
				
			}else if($(this).val() == 'N')
			{
				$(".date_setting_tr").css("display","none");
			}
		});
				
	});
	
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
	
	// ---------------- 글작성 버튼 -------------------
	function DoRegis()
	{
		if($("#top_category").val() == "")
		{
			alert("상위 카테고리를 선택해주세요");
			$("#productName").focus();
			return;
		}
		
		if($("#sub_category").val() == "")
		{
			alert("하위 카테고리를 선택해주세요");
			$("#sub_category").focus();
			return;
		}

		if($("#productName").val() == "")
		{
			alert("상품명을 입력하세요");
			$("#productName").focus();
			return;
		}
		if($("#imageURL").val() == "")
		{
			alert("이미지 URL을 입력해주세요");
			$("#imageURL").focus();
			return;
		}
		
		if( confirm("게시물을 작성하시겠습니까?")==true)
		{
			$("#masterADwrite").submit();
		}
	}
	</script>
	<body>
		<form id="masterADwrite" name="masterADwrite" method="post" action="masterADwriteok.jsp">
		<input type="hidden" name="uno" id="uno" value="<%= login.getUno() %>">
			<div>
				<table border="1" style="width : 80%; margin-top : 200px;">
					<tr>
						<td style="text-align : center; width : 400px;">
							<div style="font-size : 25px; font-weight : bold;">상위 카테고리</div>
							<select id="top_category" onchange="selectChange()" name="top_category" style="width : 200px; text-align : center; font-size : 20px;">
								<option value="">선택해주세요</option>
							<%
								advertDTO adto = new advertDTO();
								advertVO avo = new advertVO();
								List<advertVO> top_list = adto.GetCategory();
								for(advertVO advo : top_list)
								{
									%><option value="<%= advo.getCategory() %>"><%= advo.getCategory() %></option><% 
								}
							%>
							</select>
						</td>
						<td style="text-align : center; width : 400px;">
							<div style="font-size : 25px; font-weight : bold;">하위 카테고리</div>
							<select id="sub_category" name="sub_category" style="width : 200px; text-align : center; font-size : 20px;">
							<option value="">선택해주세요</option>
							</select> 
						</td>
						<td style="font-size : 25px; font-weight : bold; text-align : center;">상품명</td>
						<td>
							<input type="text"  id="product_name" name="product_name" placeholder="상품명을 입력해주세요." 
							style="border:none; width : 90%; height : 40px; font-size : 20px; margin-left : 5%;"><br>
						 </td>
					</tr>
					<tr>
						<td style="font-size : 25px; font-weight : bold; text-align : center;">상품 가격</td>
						<td>
							<input type="text"  id="product_price" name="product_price" placeholder="상품 가격을 입력해주세요." 
							style="border:none; width : 90%; height : 40px; font-size : 20px; margin-left : 5%;"><br>
						</td>
						<td style="font-size : 25px; font-weight : bold; text-align : center;">상품 VIP 여부</td>
						<td style="font-size : 25px; font-weight : bold; text-align : center;"> 
							<label>Y
							<input type="radio" name="vip_whether" id="vip_whether_Y" value="Y">
							</label>
							<label style="margin-left : 40px;">N
							<input type="radio" name="vip_whether" id="vip_whether_N" value="N" checked>
							</label>
						</td>
					</tr>
					<tr class="date_setting_tr" style="display : none;">
						<td style="font-size : 25px; font-weight : bold; text-align : center;">
							VIP 시작일
						</td>
						<td style="font-size : 25px; font-weight : bold; text-align : center;">
							<input type="datetime-local" class="date_setting" id="start_date" name="start_date" style="width : 300px; height : 30px; font-size : 22px;" onchange="setStartMinValue()">
						</td>
						<td style="font-size : 25px; font-weight : bold; text-align : center;">
							VIP 종료일
						</td>
						<td style="font-size : 25px; font-weight : bold; text-align : center;">
							<input type="datetime-local" class="date_setting" id="stop_date" name="stop_date" style="width : 300px; height : 30px; font-size : 22px;" onchange="setStopMinValue()">
						</td>
					</tr>
					<tr>
						 <td colspan="7">
						 <div style="margin-left : 5%; font-size : 25px; font-weight : bold;">상품 이미지 URL 주소(230x230ex 권장)</div>
							<input type="text"  id="image_URL" name="image_URL" placeholder="이미지 URL을 입력해주세요." 
							style="border:none; width : 90%; height : 40px; font-size : 20px; margin-left : 5%;"><br>
						 </td>
					 </tr>
					 <tr>
						 <td colspan="7">
						 <div style="margin-left : 5%; font-size : 25px; font-weight : bold;">상세 페이지 주소</div>
							<input type="text"  id="detail_URL" name="detail_URL" placeholder="상품이 등록되어 있는 상세 URL을 입력해주세요." 
							style="border:none; width : 90%; height : 40px; font-size : 20px; margin-left : 5%;"><br>
						 </td>
					 </tr>
				</table>
			</div>
			<!--  하단 -->
			<div style="width : 90%; height : 100px; background-color : lightgray; text-align : right; margin-top : 30px;">
				<div class="cancel" style="display : inline-block; margin-right : 30px; margin-top : 10px;">취소</div>
				<div class="submit" style="display : inline-block; margin-right : 90px; margin-top : 10px;" onclick="DoRegis();">상품 등록</div>
			</div>
			<div style="height : 700px;"></div>
		</form>
		<script>
		
		let date = new Date(new Date().getTime() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, -5);
		let start_date = document.getElementById('start_date');
		start_date.value = date;
		start_date.setAttribute("min", date);
		
		let stop_date  = document.getElementById('stop_date');
		stop_date.value = date;
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