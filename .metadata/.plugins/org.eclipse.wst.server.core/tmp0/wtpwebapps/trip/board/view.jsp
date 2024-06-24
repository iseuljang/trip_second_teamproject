<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="trip.util.*" %>
<%@ include file="../include/head.jsp" %>
<link rel="stylesheet" type="text/css" href="../css/view.css">    
<%
request.setCharacterEncoding("UTF-8");

String uno = request.getParameter("uno");
String bkind       = request.getParameter("kind");
String pageno     = request.getParameter("page");
String type       = request.getParameter("type");
String bno        = request.getParameter("no");
String[] season   = request.getParameterValues("season"  );
String[] local    = request.getParameterValues("local"   );
String[] human    = request.getParameterValues("human"   );
String[] move     = request.getParameterValues("move"    );
String[] schedule = request.getParameterValues("schedule");
String[] uinout   = request.getParameterValues("uinout"  );
String keyword   = request.getParameter("keyword"  );
 
if(bkind  == null) bkind  = "I";
if(pageno  == null) pageno  = "1";
if(type    == null) type    = "T";
if(keyword == null) keyword = "";
keyword = keyword.replace("\"","&quot;");
//키워드를 공백을 기준으로 나눠서 배열에 저장
String[] keylist = keyword.split(" ");
if(bno == null || bno.equals(""))
{
	response.sendRedirect("../firstmain/lobby.jsp");
	return;	
}

//파라메터를 생성한다.
/* String search_param = "";
search_param += "&season=" + season;
search_param += "&local=" + local;
search_param += "&human=" + human;
search_param += "&move=" + move;
search_param += "&schedule=" + schedule;
search_param += "&uinout=" + uinout; */
String search_param = "";
search_param += Param.getParam(season,"season");
search_param += "&";
search_param += Param.getParam(local,"local");
search_param += "&";
search_param += Param.getParam(human,"human");
search_param += "&";
search_param += Param.getParam(move,"move");
search_param += "&";
search_param += Param.getParam(schedule,"schedule");
search_param += "&";
search_param += Param.getParam(uinout,"uinout");

String param = "";
param += "type=" + type;
param += "&";
param += "page=" + pageno;
param += "&";
param += "no=" + bno;
param += "&";
param += "keyword=" + keyword;
param += "&";
param += "kind=" + bkind;
param += "&";
param += search_param;

// 본문 에서 긍정확률 70% 이상 문단 조회 
advertDTO advdto = new advertDTO();
int limit = 5; // 5개까지 출력
int s_count = 0;
s_count = advdto.SimilarTotal(bno);
//==== vip광고 출력할때 사용 =====
int num = 1;
int Pri = 1;
//===========================
ArrayList<positiveVO> mlist = advdto.positive_order(bno, limit);

// 분석된 키워드 순위 
int limit2 = 5; // 5개까지 출력
ArrayList<positiveVO> bkeyword = advdto.bkeyword(bno, limit2);

//분석된 광고키워드
int limit4 = 5;
ArrayList<positiveVO> similarad = advdto.similarad(bno,limit4);

//게시물 정보를 조회한다.
boardDTO bdto  = new boardDTO();
boardVO  bvo   = bdto.Read(bno, true);

//게시물 첨부파일 조회한다.
attachDTO adto = new attachDTO();
ArrayList<attachVO>  avos  = adto.Read(bno);

//첨부파일이 없는 게시물 볼때 오류방지하기 위해 첫번째 배열에 빈값넣음
if(avos.size() == 0)
{
	attachVO avo  = new attachVO();
	avo.setAno("");
	avo.setFname("");
	avo.setPname("");
	avo.setBno("");
	avos.add(avo);
}

//맛집정보 리스트 조회
bestlocalfoodDTO BFdto = new bestlocalfoodDTO();
ArrayList<bestlocalfoodVO> BFlist  = BFdto.Get_BFlist(bno);
//맛집지역 조회
bestlocalfoodVO BFlocal = BFdto.Get_BFlocal(bno);

// ========================= 광고노출 관련 코드(유이강) ===============================
// --------------- 쿠키가 있을 시 받아옴 ---------------
Cookie[] cookie_list = request.getCookies();
//쿠키 유뮤 판단용 flag 생성
boolean remember_ad1 = false;
boolean remember_ad2 = false;
boolean remember_ad3 = false;

// 노출정보를 담기위한 DTO, VO 선언
ad_exposureDTO ex_dto  = new ad_exposureDTO();

%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script> <!-- 차트 라이브러리 추가 -->
<script>

$("#serch1-1").click(function(){
	document.location = "../firstmain/main.jsp?season=봄";
});	



	$(document).ready(function()
	{
		
		
		
		//맨위로 가는 버튼
		$(window).scroll(function() { 
			if ($(this).scrollTop() > 450) { //250 넘으면 버튼이 보여짐니다. 
				$('#toTop').fadeIn(); 
				$('#toTop').css('left', $('#sidebar').offset()); // #sidebar left:0 죄표 
			} else { 
				$('#toTop').fadeOut(); 
			} 
		}); 
		// 버튼 클릭시 
		$("#toTop").click(function() { 
			$('html, body').animate({ scrollTop : 0 // 0 까지 animation 이동합니다. 
			}, 400); // 속도 400 return false; 
		}); 
		
		// 중간에 있는 버튼(광고넣을곳)
		$(window).scroll(function() { 
			if ($(this).scrollTop() < 300) { // 커지면동안 버튼이 보여짐니다. 
				$('#toMiddle').fadeIn(); 
				$('#toMiddle').css('left', $('#sidebar').offset()); // #sidebar left:0 죄표 
			} 
			/*
			else if (($(document).height()-$(window).height()) > 2000) { 
				$('#toMiddle').fadeOut(); 
			} */
		}); 
		
		//맨아래로 가는 버튼
		$(window).scroll(function() { 
			if ($(this).scrollTop() > 300) { // 작은동안 버튼이 보여짐니다. 
				$('#toDown').fadeIn(); 
				$('#toDown').css('left', $('#sidebar').offset()); // #sidebar left:0 죄표 
			} else if (($(document).height()-$(window).height()) > 200) { 
				$('#toDown').fadeOut(); 
			} 
		}); 
		// 버튼 클릭시 
		$("#toDown").click(function() { 
			$('html, body').animate({ scrollTop : $('body').height() // 0 까지 animation 이동합니다. 
			}, 400); // 속도 400 return false; 
		}); 
		
		
		/* 글목록버튼 */
		$("#index_btn").click(function(){
			if("<%= bkind %>" == "I")
			{
				document.location = "../board/index.jsp?<%= param %>";
			}else if("<%= bkind %>" == "S")
			{
				document.location = "../board/search.jsp?<%= param %>";
			}else if("<%= bkind %>" == "B")
			{
				document.location = "../user/bookmark.jsp?page=<%= pageno %>&uno=<%= uno %>&kind=<%= bkind%>";
			}else if("<%= bkind %>" == "R")
			{
				document.location = "../user/bookreply.jsp?page=<%= pageno %>&uno=<%= uno %>&kind=<%= bkind%>";
			}else if("<%= bkind %>" == "W")
			{
				document.location = "../user/bookwrite.jsp?page=<%= pageno %>&uno=<%= uno %>&kind=<%= bkind%>";
			}
		});
		/* 수정버튼 */
		$("#modify_btn").click(function(){
			document.location = "../board/modify.jsp?<%= param %>";
		});
		/* 삭제버튼 */
		$("#delete_btn").click(function(){
			if(confirm("삭제하시겠습니까") == false)
			{
				return;			
			}
			document.location = "../board/delete.jsp?<%= param %>";
		});
		
		$(".btn-like").click(function() 
		{
			$(this).toggleClass("done");
		});
		
		
		loadReply_list();
		loadreco_table();
		
		
	 	document.addEventListener('click', () => 
	 	{
		    const modal = document.querySelector('.modal');
		    const btnCloseModal = document.querySelector('.btn-close-modal');
		    
		    // 모달 열기 함수
		    function openModal(adURL) 
		    {
		    	$("#adURL").attr("href",adURL);
		    	$("#spanURL").html(adURL);
		        modal.style.display = 'flex';
		        // =================== modal 열시 쿠키 생성(유이강) ===================
		        /*
		        
		        
		        */
		    }
		    
		    // 각 광고 항목에 클릭 이벤트 추가
		    const adItems = [
		        {button: document.querySelector('#b_item1 .ad1-2'), adUrlElement: document.querySelector('#b_item1 #adurl')},
		        {button: document.querySelector('#b_item2 .ad1-2'), adUrlElement: document.querySelector('#b_item2 #adurl')},
		        {button: document.querySelector('#b_item3 .ad1-2'), adUrlElement: document.querySelector('#b_item3 #adurl')}
		    ];
		    
		    adItems.forEach(item => {
		        item.button.addEventListener('click', () => {
		            const adURL = item.adUrlElement.value;
		            openModal(adURL);
		        });
		    });
		
		    // 모달 닫기
		    btnCloseModal.addEventListener('click', () => {
		        modal.style.display = 'none';
		    });
		
		    // 모달 외부 클릭 시 닫기
		    window.addEventListener('click', (e) => {
		        if (e.target === modal) {
		            modal.style.display = 'none';
		        }
		    });
		});
	 	
	 	
	 	
		
		/* 게시물 첫번째 첨부파일 이미지 상단배너에 삽입 */
		$("#intro_table").css("background-size", "cover")
						 .css("background-image","url(../upload/<%= avos.get(0).getFname() %>)");
		
		
		var scrolltop = $(document).scrollTop();
        console.log(scrolltop);
        var height = $(document).height();
        console.log(height);
        var height_win = $(window).height();
        console.log(height_win);
		
	});
	
	//vip 상품 출력
	function loadvip_item(Pri,num) 
	{
        $.ajax({
            url: "loadvip_item.jsp",
            type: "get",
            data: { 
            		Pri : Pri,
            		bno : <%= bno %>
            	},
            success: function(data) 
            {
                $("#vip_item" + num).html(data);
            }
        });
    }
	
	//댓글 리스트
	function loadReply_list() 
	{
        $.ajax({
            url: "loadReply_list.jsp",
            type: "get",
            data: { no: "<%= bno %>" },
            success: function(data) 
            {
                $("#replyList").html(data);
            }
        });
    }
	
	/* 댓글작성버튼 */
	function Addreply()
	{
		if(confirm("댓글을 작성하시겠습니까?") == false)
		{
			return;
		}
		
		if($("#rnote").val() == "")
		{
			alert("댓글 내용을 입력하세요.");
			$("#rnote").focus();
			return;
		}	
		
		$.ajax({
			type : "post",
			url  : "r_writeok.jsp",
			data : 
			{
				no      : "<%= bno %>",
				rnote   : $("#rnote").val(),
			},
			datatype : "html",
			success : function(result)
			{
				loadReply_list();
			}
		});
	}
	
	/* 댓글삭제버튼 */
	function reply_delete(rno)
	{
		if(confirm("댓글을 삭제하시겠습니까?") == false )
		{
			return;
		}
		$.ajax({
			type : "post",
			url  : "r_deleteok.jsp",
			data : 
			{
				rno     : rno
			},
			datatype : "html",
			success : function(result)
			{
				alert("댓글이 삭제되었습니다.");
				loadReply_list();
			}
		});
	};
	
	var originalHTML = "";
	var originalbtn  = "";
	
	function reply_update(rno, bno)
	{
		if(confirm("댓글을 수정하시겠습니까?") == false )
		{
			return;
		}
		
		var rnote = $("#"+rno).text().trim();
		originalHTML = $('#'+rno).html(); // 이전 HTML을 저장해둠
		originalbtn = $('#reply_div'+rno).html().trim(); // 이전 버튼을 저장해둠
		console.log(originalHTML);
		console.log(originalbtn);
		
		$('#'+rno).html(
			"<textarea id='edit_urnote"+rno+"' style='width:740px; height:80px; resize:none;'>"+rnote+"</textarea>"
		);
		
		$('#reply_div'+rno).html(
			`<span class='reply_btn' onclick='reply_updateSave("\${rno}",\${bno})' id='btnEdit'>완료</span> 
			<input type="reset" id="reply_reset" value="취소" onclick='replyCancel(\${rno})'>`
		);
	}
	
	function replyCancel(rno) 
	{
	    $('#'+rno).html(originalHTML); 
	    $('#reply_div'+rno).html(originalbtn); 
	}
	
	function reply_updateSave(rno, bno)
	{
		var rnote = $("#edit_urnote"+rno).val();
		
		if(rnote == "")
		{
			alert("댓글 내용을 입력해주세요.")
			$("#edit_urnote"+rno).focus();
			return;
		}
		
		$.ajax({
			type : "post",
			url  : "r_modifyok.jsp",
			data : 
			{
				no      : bno,
				rnote   : rnote,
				rno     : rno
			},
			datatype : "html",
			success : function(result)
			{
				alert("댓글이 수정되었습니다.");
				$('#'+rno).html('<span>'+ rnote +'</span>'); 
				$('#reply_div'+rno).html(originalbtn); 
			}
		});
	}
	
	
	
	
	function DoBook(bno)
	{
		if(confirm("북마크하시겠습니까?") == false )
		{
			return;
		}
		
		$.ajax({
			type : "post",
			url  : "bookok.jsp",
			data : 
			{
				no : bno
			},
			datatype : "html",
			success : function(result)
			{
				result = result.trim();
				switch(result)
				{
				case "ERROR" :
					alert("이미 북마크된 게시물입니다");
					break;
				case "OK" :
					alert("북마크되었습니다");
					window.location.reload();
					break;
				}
			}
		});
	}
	
	//추천 테이블
	function loadreco_table() 
	{
        $.ajax({
            url: "loadreco_table.jsp",
            type: "get",
            data: { no: "<%= bno %>" },
            success: function(data) 
            {
                $("#reco_table").html(data);
            }
        });
    }
	
	
	//추천
	function DoReco_up(bno,rcstate)
	{
		if(confirm("추천하시겠습니까?") == false )
		{
			return;
		}
		
		recoup_count = $("#recoup_count").text();
		console.log(rcstate);
		
		$.ajax({
			type : "post",
			url  : "reco_upok.jsp",
			data : 
			{
				no : bno
			},
			datatype : "html",
			success : function(result)
			{
				result = result.trim();
				switch(result)
				{
				case "ERROR" :
					alert("이미 추천된 게시물입니다");
					break;
				case "OK" :
					alert("추천되었습니다");
		            loadreco_table();
		            break;
				}
			}
		});
	}
	
	//추천한 사용자가 비추천을 누를 경우 추천수를 1 감소하고 비추천수를 1증가
	//비추천
	function DoReco_down(bno,rcstate)
	{
		if(confirm("비추천하시겠습니까?") == false )
		{
			return;
		}
		
		recodown_count = $("#recodown_count").text();
	    recoup_count = $("#recoup_count").text();
		
		$.ajax({
			type : "post",
			url  : "reco_downok.jsp",
			data : 
			{
				no : bno
			},
			datatype : "html",
			success : function(result)
			{
				result = result.trim();
				switch(result)
				{
				case "ERROR" :
					alert("이미 비추천된 게시물입니다");
					break;
				case "OK" :
					alert("비추천되었습니다");
		            loadreco_table();
		            break;
				}
			}
		});
	}
	
	//이미 추천한 게시물인 경우 추천취소 가능
	//추천 취소하면 추천수만 1 감소
	//추천 취소
	function DoReco_delete(bno)
	{
		if(confirm("추천 취소하시겠습니까?") == false )
		{
			return;
		}
		
		recoup_count = $("#recoup_count").text();
		
		$.ajax({
			type : "post",
			url  : "recodelete.jsp",
			data : 
			{	
				bno :  bno
			},
			datatype : "html",
			success : function(result)
			{
				result = result.trim();
				switch(result)
				{
					case "ERROR" :
						alert("추천취소오류");
						break;
					case "OK" :
						alert("추천 취소되었습니다");
			            loadreco_table();
	                    break;
				}
			}
		});
	}
	
	//이미 비추천한 게시물인 경우 비추천취소 가능
	//비추천 취소하면 비추천수만 1 감소
	//비추천 취소
	function DoReco_down_delete(bno)
	{
		if(confirm("비추천 취소하시겠습니까?") == false )
		{
			return;
		}
		recodown_count = $("#recodown_count").text();
		
		$.ajax({
			type : "post",
			url  : "recodowndelete.jsp",
			data : 
			{	
				bno :  bno
			},
			datatype : "html",
			success : function(result)
			{
				result = result.trim();
				switch(result)
				{
					case "ERROR" :
						alert("비추천취소오류");
						break;
					case "OK" :
						alert("비추천 취소되었습니다");
			            loadreco_table();
	                    break;
				}
			}
		});
	}
</script>
<!-- 상단부분 -->
<table border="0" style="width: 100%; height: 50px; background-color: lightgray; position: relative; top: -5px;">
	<tr>
		<td width="120px">
		&nbsp;
		</td>
		<td class="keywords">
			<%
			//키워드표시(null 값이 아니고 "null"값도 아니면 표시) 
			if(bvo.getSeason() != null && !bvo.getSeason().equals("null"))
			{
				%>
				<span style="color: hotpink; padding-left: 30px;">&nbsp;&nbsp;&nbsp;&nbsp;<%= bvo.getSeason() %> </span>
				<%
			}
			if(bvo.getLocal() != null && !bvo.getLocal().equals("null"))
			{
				%>
				<span style="color: saddlebrown;"> <%= bvo.getLocal() %> </span>
				<%
			}
			if(bvo.getHuman() != null && !bvo.getHuman().equals("null"))
			{
				%>
				<span style="color: orangered;"> <%= bvo.getHuman() %> </span>
				<%
			}
			if(bvo.getMove() != null && !bvo.getMove().equals("null"))
			{
				%>
				<span style="color: royalblue;"> <%= bvo.getMove() %> </span>
				<%
			}
			if(bvo.getSchedule() != null && !bvo.getSchedule().equals("null"))
			{
				%>
				<span style="color: darkmagenta;"> <%= bvo.getSchedule() %> </span>
				<%
			}
			if(bvo.getUinout() != null && !bvo.getUinout().equals("null"))
			{
				%>
				<span style="color: ghostwhite;"> <%= bvo.getUinout() %> </span>
				<%
			}
			%>
		</td>
		<td class="buttons_td" width="650px;">
			<%
			//비로그인시
			if(login == null){}
			//로그인 상태와 본인이 쓴 게시물이 맞을시
			else if(login != null && login.getUno().equals(bvo.getUno()) || login.getAdmin().equals("Y"))
			{
				%>
				<button type="button" class="buttons" id="modify_btn">수정</button>
				<button type="button" class="buttons" id="delete_btn">삭제</button>
				<%
			}
			%>
			<%
			if(login != null)
			{
				%>
				<button type="button" class="buttons" id="bookbtn" onclick="DoBook(<%= bvo.getBno() %>);">북마크</button>
				<%
			}else
			{
				%>
				<button type="button" class="buttons" id="bookbtn" onclick="alert('로그인 후 북마크 가능합니다.')">북마크</button>
				<%				
			}
			%>
			<button type="button" class="buttons" id="index_btn">글목록</button>
		</td>
		<td width="120px">
		&nbsp;
		</td>
	</tr>
</table>	
<!-- 본문부분 -->
<table border="0" style="width: 60%; height: 350px;" align="center" id="intro_table">
	<tr>
		<td class="intro"><h1 style="color: whitesmoke; text-align:left; height:110px;">&nbsp;&nbsp;&nbsp;<%= bvo.getBtitle() %></h1></td>
	</tr>
	<tr>
		<td class="intro" height="10"><h3 style="color: whitesmoke; text-align:left;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= bvo.getUnick() %></h3></td>
	</tr>	
	<tr>
		<td class="intro" height="10" style="text-align:left; height:50px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= bvo.getBwdate() %> ㅣ <%= bvo.getBhit() %></td>
	</tr>
</table>
<table border="0" align="center" style="width: 60%;">
	<tr>
		<td align="center" colspan="2" style="padding: 50px;"><i  style="font-size: 50px; font-weight: bolder; text-shadow:1px 1px 10px #444;"><%= bvo.getBtitle() %></i></td>
		<td align="right">
			<button type="button" id="toTop" style="width:60px; height:60px; cursor:pointer; cursor:hand; line-height: -3em; font-size: 25px; border-radius: 0.5em; background-color: rightgray; margin-left:120px;">
				▲
			</button>
			<!-- 맛집추천 -->
			<button type="button" id="toMiddle" style="width:200px; height:600px; cursor:pointer; cursor:hand; line-height: -3em; font-size: 25px; border-radius: 0.5em; background-color: white; margin-left:60px;">
				<table border='0' align='center' style="width: 190px; height:550px; border-radius: 0.5em;">
					<tr>
						<td style="font-size:1.400rem; font-weight:700; height:30px;"><%= BFlocal.getBFlocal() %><br>추천 맛집</td>
					</tr>
					<%
					for(bestlocalfoodVO BFvo : BFlist)
					{
						%>
						<tr>
							<td style="height:120px;">
								<a href=<%= BFvo.getBFurl() %> target="_blank"><img src=<%= BFvo.getBFimageurl() %> alt="음식사진" style="width: 180px; height:120px; border-radius: 0.5em;"/></a>
							</td>
						</tr>
						<tr>
							<td style="font-size:1.125rem; font-weight:700; height:25px; text-align:left;"><%= BFvo.getBFtitle() %></td>
						</tr>
						<tr>
							<td style="font-size:14px; font-weight:500; height:20px; text-align:left;"><%= BFvo.getBFcategory() %></td>
						</tr>
						<%
					}
					%>
				</table>
			</button>
			<!-- 맛집추천 끝 -->
			<button type="button" id="toDown" style="width:60px; height:60px; cursor:pointer; cursor:hand; line-height: -3em; font-size: 25px; border-radius: 0.5em; background-color: rightgray; margin-left:120px;">
				▼
			</button>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<%
			//게시물 첨부파일 이미지(없으면 표시하지않음) 
			if(avos.isEmpty() != true)
			{
				if(!avos.get(0).getFname().equals(""))
				{
					%>
					<img src="../upload/<%= avos.get(0).getFname() %> " style="width:1140px;">
					<%
				}
			}
			%>
		</td>
	</tr>
	<tr>
		<td colspan="2" id="note">
			<%		
			String bnote = bvo.getBnote();
			bnote = bnote.replace("<","&lt;");
			bnote = bnote.replace(">","&gt;");
			bnote = bnote.replace("\n","<br>");
			%>
			<%= bnote %>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<%
			if(avos.size() > 1)
			{
				ArrayList<attachVO>  avos_4  = adto.Read(bno);
				avos_4.remove(0);
				//게시물 첨부파일 이미지(없으면 표시하지않음) 
				if(avos.isEmpty() != true)
				{
					for(attachVO  avo : avos_4)
					{
						if(!avo.getFname().equals(""))
						{
							%>
							<img src="../upload/<%= avo.getFname() %> " style="width:1140px;">
							<%
						}
					}
				}
			}
			%>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<%
			//게시물 첨부파일 다운로드(없으면 표시하지않음) 
			for(attachVO avo : avos)
			{
				if(!avo.getAno().equals(""))
				{
					%>
					첨부파일 : <a href="download.jsp?no=<%= avo.getAno() %>"><%= avo.getPname() %></a><br>
					<%
				}
			}
			%>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table border='0' anlign='center' >
				<tr>
					<!-- 1번째 광고 -->
					<td width="320px" height="100" id="ad_item1">
					<%  String Adurl ="";
						ArrayList<positiveVO> similarad_limit = advdto.similarad_limit(bno,0);
						if(similarad_limit != null)
						{
							positiveVO pvo1 = similarad_limit.get(0);
							advertVO advo1 = advdto.ad_limit(pvo1.getBsad());
							if(advo1 != null)
							{
								Adurl = advo1.getDetailURL();
								%>	
								<div id="b_item1">
								<div id="ad1-1" class="ad1-1"  style="background-image:url(<%= advo1.getImageURL() %>);"></div>
									<div id="ad1-2" class="ad1-2"> <!-- 광고하단 1 -->
									<div id="for_cookie_div1">
									<input type="hidden" id="adurl" name="adurl" value="<%= Adurl %>">
									<table border ="0" style="margin-top:20px; height:20px">
									<tr><th style="height:48px; word-break:break-all;" colspan="2"><%=advo1.getProductName() %></th></tr>
									<tr><td style="width:166; text-align: left; padding-top: 10px; padding-left: 20px;"><button id="btn-open-modal1" class="btn-open-modal">Modal열기</button></td>
									<td style="width:154; text-align: right; padding-top: 10px; padding-right: 20px;"><%= advo1.getPrice() %>원</td></tr>
									</table>
									</div>
								</div>
								</div>
								<%
								if(login != null)
								{
									%>
										<!-- ======================= 버튼 클릭시 쿠키(로그인용) 굽기 ====================== -->
										<script>
											$(document).ready(function(){
												$("#for_cookie_div1, #btn-open-modal1").on('click', function(e){
													
													if(getCookieVal("<%= login.getUno() %>") != null)
													{
														console.log("기존의 광고 쿠키(현재 로그인한 유저) 삭제")
														delCookie("<%= login.getUno() %>");
													}
													
													console.log("1번째 광고를 쿠키(현재 로그인한 유저)로 저장")
													setCookie("<%= login.getUno() %>", '<%= advo1.getAdvertno() %>')
													console.log(getCookieVal("<%= login.getUno() %>"))
												});
											});
										</script>
									<%
								}else
								{
									%>
										<!-- ======================= 버튼 클릭시 쿠키(비로그인용) 굽기 ====================== -->
										<script>
											$(document).ready(function(){
												$("#for_cookie_div1, #btn-open-modal1").on('click', function(e){
													
													if(getCookieVal('not_login') != null)
													{
														console.log("기존의 광고 쿠키(비로그인용) 삭제")
														delCookie('not_login');
													}
													
													console.log("1번째 광고를 쿠키(비로그인용)로 저장")
													setCookie('not_login', '<%= advo1.getAdvertno() %>')
													console.log(getCookieVal('not_login'))
												});
											});
										</script>
							 		<%
								}
						 		
								// ------------- 해당 광고노출 정보를 테이블에 저장 -------------
								ad_exposureVO ex_vo1    = new ad_exposureVO();
								
								ex_vo1.setAdvertno(advo1.getAdvertno());
								ex_vo1.setBno(bno);
								if(login != null)
								{
									ex_vo1.setUno(login.getUno());
								}
								boolean ex_vo1_whether = true;
								
								ex_dto.Insert(ex_vo1, ex_vo1_whether);
								
							}else
							{
								%>
								<div id="b_item1">
								<div id="vip_item1"></div>
								</div>
								<script>loadvip_item("<%= Pri%>","<%= num%>");</script>
								<%	
								Pri++;
							}
					 		num++;
						}else
						{	%>
							<div id="b_item1">
							<div id="vip_item1"></div>
							</div>
							<script>loadvip_item("<%= Pri%>","<%= num%>");</script>
							<%	
							Pri++;
							num++;
						}
						%>
					</td>
					<!-- 2번째 광고 -->
					<td width="320px" height="100">
					<%  
					if(s_count > 1)
					{   
						ArrayList<positiveVO> similarad_limit2 = advdto.similarad_limit(bno,1);
						
						if(similarad_limit2 != null)
						{
							positiveVO pvo2 = similarad_limit2.get(0);
							advertVO advo2 = advdto.ad_limit(pvo2.getBsad());
							if(advo2 != null)
							{
								Adurl = advo2.getDetailURL();
								%>	
								<div id="b_item2">
								<div id="ad1-1" class="ad1-1"  style="background-image:url(<%= advo2.getImageURL() %>);"></div>
								<div id="ad1-2" class="ad1-2"> <!-- 광고하단 1 -->
									<div id="for_cookie_div2">
									<input type="hidden" id="adurl" name="adurl" value="<%= advo2.getDetailURL() %>">
									<table border ="0" style="margin-top:20px; height:20px">
									<tr><th style="height:48px; word-break:break-all;" colspan="2"><%=advo2.getProductName() %></th></tr>
									<tr><td style="width:166; text-align: left; padding-top: 10px; padding-left: 20px;"><button id="btn-open-modal2" class="btn-open-modal">Modal열기</button></td>
									<td style="width:154; text-align: right; padding-top: 10px; padding-right: 20px;"><%= advo2.getPrice() %>원</td></tr>
									</table>
									</div>
								</div>
								</div>
								<%
								if(login != null)
								{
									%>
										<!-- ======================= 버튼 클릭시 쿠키(로그인용) 굽기 ====================== -->
										<script>
											$(document).ready(function(){
												$("#for_cookie_div2, #btn-open-modal2").on('click', function(e){
													
													if(getCookieVal("<%= login.getUno() %>") != null)
													{
														console.log("기존의 광고 쿠키(현재 로그인한 유저) 삭제")
														delCookie("<%= login.getUno() %>");
													}
													
													console.log("2번째 광고를 쿠키(현재 로그인한 유저)로 저장")
													setCookie("<%= login.getUno() %>", '<%= advo2.getAdvertno() %>')
													console.log(getCookieVal("<%= login.getUno() %>"))
												});
											});
										</script>
									<%
								}else
								{
									%>
										<!-- ======================= 버튼 클릭시 쿠키(비로그인용) 굽기 ====================== -->
										<script>
											$(document).ready(function(){
												$("#for_cookie_div2, #btn-open-modal2").on('click', function(e){
													
													if(getCookieVal('not_login') != null)
													{
														console.log("기존의 광고 쿠키(비로그인용) 삭제")
														delCookie('not_login');
													}
													
													console.log("2번째 광고를 쿠키(비로그인용)로 저장")
													setCookie('not_login', '<%= advo2.getAdvertno() %>')
													console.log(getCookieVal('not_login'))
												});
											});
										</script>
									<%
								}
								// ------------- 해당 광고노출 정보를 테이블에 저장 -------------
								ad_exposureVO ex_vo2    = new ad_exposureVO();
								
								ex_vo2.setAdvertno(advo2.getAdvertno());
								ex_vo2.setBno(bno);
								if(login != null)
								{
									ex_vo2.setUno(login.getUno());
								}
								boolean ex_vo2_whether = true;
								
								ex_dto.Insert(ex_vo2, ex_vo2_whether);
							}else
							{
								%>
								<div id="b_item2">
								<div id="vip_item2"></div>
								</div>
								<script>loadvip_item("<%= Pri%>","<%= num%>");</script>
								<%	
								Pri++;
							}
							num++;
						}else
						{
							%>
							<div id="b_item2">
							<div id="vip_item2"></div></div>
							<script>loadvip_item("<%= Pri%>","<%= num%>");</script>
							<%	
							Pri++;
							num++;
						}
					}else
					{
						%>
							<div id="b_item2">
							<div id="vip_item2"></div>
							</div>
							<script>loadvip_item("<%= Pri%>","<%= num%>");</script>
						<%	
						Pri++;
						num++;
					}
					%>
					</td>
					<!-- 3번째 광고 -->
					<td width="320px" height="100">
					<%  
					if(s_count > 2)
					{
						
						Cookie[] cookies = request.getCookies();
						String rem_advertno = "";
						String rem_advertno_login = "";
						
						if( cookies != null)
						{
							for(Cookie c : cookies)
							{
								if(login == null)
								{
									if(c.getName().equals("not_login"))
									{
										rem_advertno = c.getValue();
									}
								}
								if(login != null)
								{
									if(c.getName().equals(login.getUno()))
									{
										rem_advertno_login = c.getValue();
									}
								}
								
							}
						}						// ================================= 쿠키 저장시(로그인시) 출력 =============================
												// ====================================================================================
												if( !rem_advertno_login.equals("") && login != null)
												{
													advertVO rem_vo_login = advdto.Read(rem_advertno_login);
													Adurl = rem_vo_login.getDetailURL();
													%>
													
													<div id="b_item3">
													<div id="ad1-1" class="ad1-1"  style="background-image:url(<%= rem_vo_login.getImageURL() %>);"></div>
													<div id="ad1-2" class="ad1-2"> <!-- 광고하단 1 -->
														<div id="for_cookie_div3">
														<input type="hidden" id="adurl" name="adurl" value="<%= Adurl %>">
														<table border ="0" style="margin-top:20px; height:20px">
														<tr><th style="height:48px; word-break:break-all;" colspan="2"><%=rem_vo_login.getProductName() %></th></tr>
														<tr><td style="width:166; text-align: left; padding-top: 10px; padding-left: 20px;"><button id="btn-open-modal3" class="btn-open-modal">Modal열기</button></td>
														<td style="width:154; text-align: right; padding-top: 10px; padding-right: 20px;"><%= rem_vo_login.getPrice() %>원</td></tr>
														</table>
														</div>
													</div>
													</div>
													<!-- ======================= 버튼 클릭시 쿠키(로그인용) 굽기 ====================== -->
													<script>
														$(document).ready(function(){
															$("#for_cookie_div3, #btn-open-modal3").on('click', function(e){
																
																if(getCookieVal("<%= login.getUno() %>") != null)
																{
																	console.log("기존의 광고 쿠키(현재 로그인한 유저) 삭제")
																	delCookie("<%= login.getUno() %>");
																}
																
																console.log("3번째 광고를 쿠키(현재 로그인한 유저)로 저장")
																setCookie("<%= login.getUno() %>", '<%= rem_vo_login.getAdvertno() %>')
																console.log(getCookieVal("<%= login.getUno() %>"))
															});
														});
													</script>
											 		<%
													// ------------- 해당 광고노출 정보를 테이블에 저장 -------------
													ad_exposureVO rem_vo3_login    = new ad_exposureVO();
													
											 		rem_vo3_login.setAdvertno(rem_vo_login.getAdvertno());
											 		rem_vo3_login.setBno(bno);
													if(login != null)
													{
														rem_vo3_login.setUno(login.getUno());
													}
													boolean rem_vo3_login_whether = true;
													ex_dto.Insert(rem_vo3_login, rem_vo3_login_whether);
												}else if(!rem_advertno.equals("") && login == null)
												{
													// ================================= 쿠키 저장시(비로그인시) 출력 =============================
													// ====================================================================================
													advertVO rem_vo = advdto.Read(rem_advertno);
													Adurl = rem_vo.getDetailURL();
													%>
													
													<div id="b_item3">
													<div id="ad1-1" class="ad1-1"  style="background-image:url(<%= rem_vo.getImageURL() %>);"></div>
													<div id="ad1-2" class="ad1-2"> <!-- 광고하단 1 -->
														<div id="for_cookie_div3">
														<input type="hidden" id="adurl" name="adurl" value="<%= Adurl %>">
														<table border ="0" style="margin-top:20px; height:20px">
														<tr><th style="height:48px; word-break:break-all;" colspan="2"><%=rem_vo.getProductName() %></th></tr>
														<tr><td style="width:166; text-align: left; padding-top: 10px; padding-left: 20px;"><button id="btn-open-modal3" class="btn-open-modal">Modal열기</button></td>
														<td style="width:154; text-align: right; padding-top: 10px; padding-right: 20px;"><%= rem_vo.getPrice() %>원</td></tr>
														</table>
														</div>
													</div>
													</div>
													<!-- ======================= 버튼 클릭시 쿠키(비로그인용) 굽기 ====================== -->
													<script>
														$(document).ready(function(){
															$("#for_cookie_div3, #btn-open-modal3").on('click', function(e){
																
																if(getCookieVal('not_login') != null)
																{
																	console.log("기존의 광고 쿠키(비로그인용) 삭제")
																	delCookie('not_login');
																}
																
																console.log("3번째 광고를 쿠키(비로그인용)로 저장")
																setCookie('not_login', '<%= rem_vo.getAdvertno() %>')
																console.log(getCookieVal('not_login'))
															});
														});
													</script>
											 		<%
													// ------------- 해당 광고노출 정보를 테이블에 저장 -------------
													ad_exposureVO rem_vo3    = new ad_exposureVO();
													
											 		rem_vo3.setAdvertno(rem_vo.getAdvertno());
											 		rem_vo3.setBno(bno);
													if(login != null)
													{
														rem_vo3.setUno(login.getUno());
													}
													boolean rem_vo3_whether = true;
													ex_dto.Insert(rem_vo3, rem_vo3_whether);
												}else
												{
												
												
													// ================================= 구워진 쿠키 없을시 유사도 측정 ============================
													// ====================================================================================
													ArrayList<positiveVO> similarad_limit3 = advdto.similarad_limit(bno, 2);
													if(similarad_limit3 != null)
													{
														positiveVO pvo3 = similarad_limit3.get(0);
														advertVO advo3 = advdto.ad_limit(pvo3.getBsad());
														if(advo3 != null)
														{
															Adurl = advo3.getDetailURL();
															%>	
															<div id="b_item3">
															<div id="ad1-1" class="ad1-1"  style="background-image:url(<%= advo3.getImageURL() %>);"></div>
															<div id="ad1-2" class="ad1-2"> <!-- 광고하단 1 -->
																<div id="for_cookie_div3">
																<input type="hidden" id="adurl" name="adurl" value="<%= Adurl %>">
																<table border ="0" style="margin-top:20px; height:20px">
																<tr><th style="height:48px; word-break:break-all;" colspan="2"><%=advo3.getProductName() %></th></tr>
																<tr><td style="width:166; text-align: left; padding-top: 10px; padding-left: 20px;"><button id="btn-open-modal3" class="btn-open-modal">Modal열기</button></td>
																<td style="width:154; text-align: right; padding-top: 10px; padding-right: 20px;"><%= advo3.getPrice() %>원</td></tr>
																</table>
																</div>
															</div>
															</div>
															<!-- ======================= 버튼 클릭시 쿠키 굽기 ====================== -->
															<script>
																$(document).ready(function(){
																	$("#for_cookie_div3, #btn-open-modal3").on('click', function(e){
																		
																		if(getCookieVal('not_login') != null)
																		{
																			console.log("기존의 광고 쿠키(비로그인용) 삭제")
																			delCookie('not_login');
																		}
																		
																		console.log("3번째 광고를 쿠키(비로그인용)로 저장")
																		setCookie('not_login', '<%= advo3.getAdvertno() %>')
																		console.log(getCookieVal('not_login'))
																	});
																});
															</script>
													 		<%
															// ------------- 해당 광고노출 정보를 테이블에 저장 -------------
															ad_exposureVO ex_vo3    = new ad_exposureVO();
															
															ex_vo3.setAdvertno(advo3.getAdvertno());
															ex_vo3.setBno(bno);
															if(login != null)
															{
																ex_vo3.setUno(login.getUno());
															}
															boolean ex_vo3_whether = true;
															
															ex_dto.Insert(ex_vo3, ex_vo3_whether);
														}else
														{
															%>
															<div id="b_item3">
															<div id="vip_item3"></div>
															</div>
															<script>loadvip_item("<%= Pri%>","<%= num%>");</script>
															<%
															Pri++;
														}
														num++;
													}else
													{
														%>
														<div id="b_item3">
														<div id="vip_item3"></div>
														</div>
														<script>loadvip_item("<%= Pri%>","<%= num%>");</script>
														<%
														Pri++;
														num++;
													}
												}
						
					}else
					{
						%>
							<div id="b_item3">
							<div id="vip_item3"></div>
							</div>
							<script>loadvip_item("<%= Pri%>","<%= num%>");</script>
						<%	
						Pri++;
						num++;
					}
					%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" style="width:50%; text-align: center; padding-right: 20px; padding-top: 50px;">
			<div id="reco_table">
			<!-- 추천 버튼 로드될 부분 -->
			</div>
		</td>
	</tr>
</table>
<hr>
<div class="modal"><!-- 모달창 내용 시작 -->
    <div class="modal_body">
    <span class="btn-close-modal">&times;</span> 
    	<table border="0" style="width:100%; height:100%";>
    	<tr>
    		<td colspan="3"  style="height:250px"><div id ="spon0" class ="spon0"></div></td> <!-- 맨 위 상단 -->
    	</tr>
    	<tr>
    		<td style="width:580px;height:300px" id ="spon1" class ="inbtn"><!-- Q1. 긍정확률  -->
    			<table border="1" id ="spon1-1" class ="spon1-1" style="width:500px; height:170px;" >
					<tr>
						<th style="height:30px;">연번</th>
						<th style="width:420px;">내용</th>
						<th>긍정확률</th>
					</tr>
					
					<%   int spon1 = 1;
						for(positiveVO vo : mlist)
							{
							%>	
					<tr>				
						<th><%= spon1 %></th>
						<th style="background-color:#FAC428;"><%= vo.getBpsent() %></th>
						<th><%= vo.getBposi() %></th>
					</tr>	
						 <% spon1 ++;}%>
    			</table>
    		</td>    
    		<td style="width:580px;height:300px" id ="spon2" class ="inbtn"> <!-- Q2. 분석된 키워드  -->
    		<table border="1" id ="spon2-1" class ="spon2-1" style="width:500px; height:170px;" >
					<tr>
						<th style="height:30px; width:60px;">연번</th>
						<th style="width:220px;">키워드</th>
						<th>언급된 횟수</th>
					</tr>
					<% 
					   int spon2 = 1;
						for(positiveVO vo : bkeyword)
							{
							%>	
					<tr>				
						<th><%= spon2 %></th>
						<th style="background-color:#FAC428;"><%= vo.getBkey() %></th>
						<th><%= vo.getBkfr() %></th>
					</tr>	
						 <% spon2 ++;}%>
    			</table>
    		</td>
		</tr>    	
    	<tr>
    		<td style="width:580px;height:300px" id ="spon3" class ="inbtn"> <!-- Q3. 분석된 유사도 -->
    		<table border="1" id ="spon3-1" class ="spon3-1" style="width:500px; height:170px;" >
    		<tr>
    			<td>
    				<table border="1" style="width:250px; height:170px;">
						<tr>
							<th style="height:30px; width:70px;">키워드</th>
							<th style="width:90px;">유사 키워드</th>
							<th>유사도</th>
						</tr>
						<% 
						//분석된 유사도
						positiveVO pvo = advdto.K_Read(bno);   
						int limit3 = 20;
						if(pvo != null)  // 분석된 키워드가 없으면 오류 나지 않도록
						{	
						ArrayList<positiveVO> bsimilar = advdto.bsimilar(bno, limit3);
						   int spon3 = 1;
							for(positiveVO vo : bsimilar)
							{
								if(spon3 <=10)
								{%>	
						<tr>				
							<th><%= vo.getBkey() %></th>
							<th style="background-color:#FAC428;"><%= vo.getBskey() %></th>
							<th><%= vo.getBsfr() %></th>
						</tr>	
							 <% 
							 		spon3++;
								}
							 }
						}else
						{%>
						<tr>				
							<td colspan="3" style="font-size:20px">분석된 유사도가 없습니다.</td>
						</tr>	
						<%}
						%>
					</table >
				</td>
				<td>
    				<table border="1" style="width:250px; height:170px;">
						<tr>
							<th style="height:30px; width:70px;">키워드</th>
							<th style="width:90px;">유사 키워드</th>
							<th>유사도</th>
						</tr>
						<% 
						//분석된 유사도
						if(pvo != null)  // 분석된 키워드가 없으면 오류 나지 않도록
						{	
						ArrayList<positiveVO> bsimilar = advdto.bsimilar(bno, limit3);
						   int spon3_1 = 1;
							for(positiveVO vo : bsimilar)
							{
								if(spon3_1 > 10)
								{%>	
						<tr>				
							<th><%= vo.getBkey() %></th>
							<th style="background-color:#FAC428;"><%= vo.getBskey() %></th>
							<th><%= vo.getBsfr() %></th>
						</tr>	
							 <% 
							 		spon3_1++;
								}else
									spon3_1++;
							 }
						}else
						{%>
						<tr>				
							<td colspan="3" style="font-size:20px">분석된 유사도가 없습니다.</td>
						</tr>	
						<%}
						%>
					</table>
				</td>
				</tr>
    		</table>
    		</td>
    		<td style="width:580px;height:300px" id ="spon4" class ="inbtn"> <!-- Q4. 유사한 상품 -->
    			<table border="1" id ="spon2-1" class ="spon2-1" style="width:500px; height:170px;" >
					<tr>
						<th style="height:30px; width:50px;">연번</th>
						<th style="width:115px;">키워드</th>
						<th style="width:115px;">유사 키워드</th>
						<th style="width:115px;">유사도</th>
						<th style="width:115px;">상품 카테고리</th>
					</tr>
					<% 
					   int spon4 = 1;
						for(positiveVO vo : similarad)
						{
							if(vo.getBsad() != null)
							{
								%>	
								<tr>				
									<th><%= vo.getBsno() %></th>
									<th><%= vo.getBkey() %></th>
									<th><%= vo.getBskey() %></th>
									<th><%= vo.getBsfr() %></th>
									<th style="background-color:#FAC428;"><%= vo.getBsad() %></th>
								</tr>	
							 <% spon4 ++;
							} 
						}%>
    			</table>
    		</td>
		</tr>    	
    	<tr>
    		<td colspan="3" style="text-align:center;"><a href="#" id="adURL" target="_blank" class="btn-close-modal" >상품 구매하러가기>>></a></td>
    	</tr>
    	</table>
    </div>
</div><!-- 모달창 내용 끝 -->
   

<!-- 모달창 속 모달창 1번내용 시작 -->
<div class="inmodal">
  <div class="inmodal-content">
    <span class="inclose">&times;</span>                         
    <table border="0" style="width:100%; height:100%; background-image: url(../image/inmodal1.png); background-repeat: no-repeat;" >
    	<tr>
    		<td>
    			<div style="margin-top:180px">
	    			<table border="1" id ="spon1-1" class ="spon1-1" style="width:1150px; height:600px; font-size:16px" >
						<tr>
							<th style="height:30px; width:70px;">연번</th>
							<th >내용</th>
							<th style="width:100px;">긍정확률</th>
						</tr>
						
						<%  int inlimit = 20; //0번부터 20개까지 출력
							ArrayList<positiveVO> inmlist = advdto.positive_order(bno, inlimit);
							spon1 = 1;
							for(positiveVO vo : inmlist)
								{
								%>	
						<tr>				
							<th><%= spon1 %></th>
							<th style="background-color:#B6EAFF; text-align:left;">&nbsp;&nbsp;<%= vo.getBpsent() %></th>
							<th><%= vo.getBposi() %></th>
						</tr>	
							 <% spon1 ++;}%>
	    			</table>
    			</div>
    		</td>    
		</tr>   
    </table>
  </div>
</div><!-- 모달창 속 모달창 1번내용 끝 -->

<!-- 모달창 속 모달창 2번내용 시작 -->
<div class="inmodal">
  <div class="inmodal-content">
    <span class="inclose">&times;</span>                         
    <table border="0" style="width:100%; height:100%; background-image: url(../image/inmodal2.png); background-repeat: no-repeat;" >
    	<tr>	
    		<td>
    			<div style="margin-top:180px">
	    			<table border="1" id ="spon2-1" class ="spon2-1" style="width:1150px; height:600px; font-size:24px" >
						<tr>
							<th style="height:30px; width:70px;">연번</th>
							<th>키워드</th>
							<th style="width:130px;">언급된 횟수</th>
						</tr>
						<% 
							// 분석된 키워드 순위 
							int inlimit2 = 20; // 20개까지 출력
							ArrayList<positiveVO> inbkeyword = advdto.bkeyword(bno, inlimit2);
							System.out.println("inbkeyword size() : " + inbkeyword.size() );
							
						    spon2 = 1;
							for(positiveVO vo : inbkeyword)
								{
								%>	
						<tr>				
							<th><%= spon2 %></th>
							<th style="background-color:#B6EAFF;"><%= vo.getBkey() %></th>
							<th><%= vo.getBkfr() %></th>
						</tr>	
							 <% spon2 ++;}%>
	    			</table>
    			</div>
    		</td>
		</tr>    	
    </table>
  </div>
</div><!-- 모달창 속 모달창 2번내용 끝 -->

<!-- 모달창 속 모달창 3번내용 시작 -->
<div class="inmodal">
  <div class="inmodal-content">
    <span class="inclose">&times;</span>                         
    <table border="0" style="width:100%; height:100%; background-image: url(../image/inmodal3.png); background-repeat: no-repeat;" >
    	<tr>
    		<td>
    			<div style="margin-top:180px">
		    		<table border="1" id ="spon3-1" class ="spon3-1" style="width:1150px; height:600px; font-size:16px; text-align:center;" >
			    		<tr>
			    			<td>
							<% // inbkeyword의 원소개수 * 10(최대)
								if(pvo != null)  // 분석된 키워드가 없으면 오류 나지 않도록
								{	%>	
									<table border="1" style="width:1150px; height:600px;">
										<!-- 제목 줄 시작 -->
										<tr>
									<%	int inlimit3 = 50;
										ArrayList<positiveVO> bsimilar = advdto.bsimilar(bno, inlimit3);
										// bsimilar의 원소 개수는 inbkeyword의 원소개수 * 10
										// columns는  (td 세칸씩 ) inbkeyword의 원소개수 만큼 있음
										System.out.println("bsimilar : " + bsimilar.size());
										
										int columns = inbkeyword.size();
										if( columns > bsimilar.size()/10 )
										{
											columns = bsimilar.size()/10;
										}
										System.out.println("columns : " + columns);
										// columns 숫자만큼 제목줄의 th를 생성
										// th * 3 * columns 
										for( int j = 0; j < columns; j++ )
										{	%>
											<th style="height:50px; width:270px;">키워드</th>
											<th style="width:250px;">유사<br> 키워드</th>
											<th style="width:200px;">유사도</th>
									<%	}	%>
										</tr>
										<!-- 제목 줄 끝 -->
										<!-- td 출력 :: 무조건 10줄 -->
									<%	for( int i = 0; i < 10; i++)
										{	%>
											<tr>
											<!-- 제목 줄에서 처럼 columns * 3의 갯수만큼 td를 생성 -->
										<%	for( int j = 0; j < columns; j++ )
											{
												System.out.println("index : " + (i + j*10 ));
											%>
													<!-- 각 칸의 인덱스는 i + j*10 -->
													<th style="height:50px; width:270px;"><%= bsimilar.get(i+j*10).getBkey() %></th>
													<td style="width:250px; background-color:#B6EAFF;"><%= bsimilar.get(i+j*10).getBskey() %></td>
													<td style="width:200px;"><%= bsimilar.get(i+j*10).getBsfr() %></td>
										<%	}	%>
											</tr>
									<%	}
								}	%>
								</table>
							</td>
							<td>
							</td>
						</tr>
		    		</table>
	    		</div>
    		</td>
		</tr>    	
    </table>
  </div>
</div><!-- 모달창 속 모달창 3번내용 끝 -->

<!-- 모달창 속 모달창 4번내용 시작 -->
<div class="inmodal">
  <div class="inmodal-content">
    <span class="inclose">&times;</span>                         
    <table border="0" style="width:100%; height:100%; background-image: url(../image/inmodal4.png); background-repeat: no-repeat;" >
    	<tr>
    		<td>
    			<div style="margin-top:180px">
	   				<table border="1" id ="spon2-1" class ="spon2-1" style="width:1150px; height:600px; font-size:24px" >
						<tr>
							<th style="height:30px; width:50px;">연번</th>
							<th style="width:150px;">키워드</th>
							<th style="width:150px;">유사 키워드</th>
							<th style="width:150px;">유사도</th>
							<th style="width:150px;">상품 카테고리</th>
						</tr>
						<% 
							//분석된 광고키워드
							int inlimit4 = 20;
							ArrayList<positiveVO> insimilarad = advdto.similarad(bno,limit4);
						   spon4 = 1;
							for(positiveVO vo : insimilarad)
							{
								if(vo.getBsad() != null)
								{
									%>	
									<tr>				
										<th><%= vo.getBsno() %></th>
										<th><%= vo.getBkey() %></th>
										<th><%= vo.getBskey() %></th>
										<th><%= vo.getBsfr() %></th>
										<th style="background-color:#B6EAFF;"><%= vo.getBsad() %></th>
									</tr>	
								 <% spon4 ++;
								} 
							}%>
	    			</table>
    			</div>
    		</td>
		</tr>    	
    </table>
  </div>
</div><!-- 모달창 속 모달창 4번내용 끝 -->

<script> <!-- 모달창 속 모달창 스크립트 -->
 	// Modal을 가져옵니다.
    var modals = document.getElementsByClassName("inmodal");
    // Modal을 띄우는 클래스 이름을 가져옵니다.
    var btns = document.getElementsByClassName("inbtn");
    // Modal을 닫는 close 클래스를 가져옵니다.
    var spanes = document.getElementsByClassName("inclose");
    var funcs = [];
     
    // Modal을 띄우고 닫는 클릭 이벤트를 정의한 함수
    function Modal(num) {
      return function() {
        // 해당 클래스의 내용을 클릭하면 Modal을 띄웁니다.
        btns[num].onclick =  function() {
            modals[num].style.display = "block";
            console.log(num);
        };
     
        // <span> 태그(X 버튼)를 클릭하면 Modal이 닫습니다.
        spanes[num].onclick = function() {
            modals[num].style.display = "none";
        };
      };
    }
     
    // 원하는 Modal 수만큼 Modal 함수를 호출해서 funcs 함수에 정의합니다.
    for(var i = 0; i < btns.length; i++) {
      funcs[i] = Modal(i);
    }
     
    // 원하는 Modal 수만큼 funcs 함수를 호출합니다.
    for(var j = 0; j < btns.length; j++) {
      funcs[j]();
    }
     
    // Modal 영역 밖을 클릭하면 Modal을 닫습니다.
    window.onclick = function(event) {
      if (event.target.className == "inmodal") {
          event.target.style.display = "none";
      }
    };
</script>
<!-- 하단부분 -->
<%
//로그인이 되어야만 댓글을 쓸수있음(비로그인은 댓글을 볼수만 잇음)
if(login != null)
{
	%>
	<table border="0" style="width: 70%;" align="center">
	
		<tr>
			<td align="right" style="text-align: center; font-size : 60px;">
			<%
				String icon = "😄";
				switch (login.getUicon())
				{
	    		case "1": icon  = "😄"; break;     				  
	    		case "2": icon  = "😅"; break;  
	    		case "3": icon  = "😆"; break;  
	    		case "4": icon  = "😀"; break;  
	    		case "5": icon  = "😨"; break;  
	    		case "6": icon  = "👿"; break;  
	    		case "7": icon  = "😝"; break;  
	    		case "8": icon  = "😷"; break;  
	    		case "9": icon  = "😴"; break;  
	    		case "10": icon  = "😱"; break;  
	            }
				%>
				<%= icon %>
				<%
			%>
			</td>
			<td>
				&nbsp;&nbsp;&nbsp;
				<input type="text" id="rnote" placeholder="내용을 입력해주세요">&nbsp;&nbsp;&nbsp;
				<button type="button" id="r_write" onclick="Addreply();" style="background-color: skyblue; width: 90px; height: 35px;">댓글 작성</button>
			</td>
		</tr>
	</table>	
	<%
}
%>
	<div id="replyList">
	<!-- 댓글 리스트가 로드될 부분 -->
	</div>

</body>
</html>