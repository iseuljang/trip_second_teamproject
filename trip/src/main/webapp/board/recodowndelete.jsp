<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="trip.vo.*" %>
<%@ page import="trip.dto.*" %> 
<%
request.setCharacterEncoding("UTF-8");
userVO login  = (userVO)session.getAttribute("login");

String bno = request.getParameter("bno");

boardDTO dto = new boardDTO(); 


if(dto.recoDelete(login.getUno(), bno) == true)
{
	out.println("OK");
	out.println("비추천 취소되었습니다.");
}else
{
	out.println("ERROR");
}
%>
