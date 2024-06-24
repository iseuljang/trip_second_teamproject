<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, trip.vo.*, trip.dto.*" %>

<%
    String bno = request.getParameter("no");
	userVO login  = (userVO)session.getAttribute("login");
	boardDTO bdto  = new boardDTO();
	boardVO  bvo   = bdto.Read(bno, true);
%>

<%
if(login != null)
{
	recomandVO rcvo = bdto.recoShow(login.getUno(), bvo.getBno());
	if(rcvo != null)
	{
		if(rcvo.getRcstate().equals("1"))
		{
		%>
		<button class="btn-like" id="like" style="text-shadow: 0 0 0 #ea0; font-size: 40px;" onclick="DoReco_delete(<%= bvo.getBno() %>);">
			👍🏻
		</button>
		<button class="btn-like" id="unlike" style="font-size: 40px;" onclick="DoReco_down(<%= bvo.getBno() %>,1);">👎🏻</button>
		<br>
		추천: <span id="recoup_count"><%= bdto.recoTotal(bno) %></span>&nbsp;
   		비추천: <span id="recodown_count"><%= bdto.recodownTotal(bno) %></span>
		<%
		}
		else if(rcvo.getRcstate().equals("2"))
		{
			%>
			<button class="btn-like" id="like" style="font-size: 40px;" onclick="DoReco_up(<%= bvo.getBno() %>,2);">
				👍🏻
			</button>
			<button class="btn-like" id="unlike" style="text-shadow: 0 0 0 #ea0; font-size: 40px;" onclick="DoReco_down_delete(<%= bvo.getBno() %>);">👎🏻</button>
			<br>
			추천: <span id="recoup_count"><%= bdto.recoTotal(bno) %></span>&nbsp;
	   		비추천: <span id="recodown_count"><%= bdto.recodownTotal(bno) %></span>
			<%
		}
	}else
	{
		%>
		<button class="btn-like" id="like" style="font-size: 40px;" onclick="DoReco_up(<%= bvo.getBno() %>,0);">
			👍🏻
		</button>
		<button class="btn-like" id="unlike" style="font-size: 40px;" onclick="DoReco_down(<%= bvo.getBno() %>,0);">👎🏻</button>
		<br>
		추천: <span id="recoup_count"><%= bdto.recoTotal(bno) %></span>&nbsp;
   		비추천: <span id="recodown_count"><%= bdto.recodownTotal(bno) %></span>
		<%
	}
}else
{
	%>
	<button class="btn-like" id="like" style="font-size: 40px;" onclick="alert('로그인 후 추천 가능합니다.')">👍🏻</button>
	<button class="btn-like" id="unlike" style="font-size: 40px;" onclick="alert('로그인 후 비추천 가능합니다.')">👎🏻</button>
	<br>
	추천: <span id="recoup_count"><%= bdto.recoTotal(bno) %></span>&nbsp;
	비추천: <span id="recodown_count"><%= bdto.recodownTotal(bno) %></span>
	<%				
}
%>
