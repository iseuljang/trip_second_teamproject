<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, trip.vo.*, trip.dto.*" %>
<%
    userVO login  = (userVO)session.getAttribute("login");

    String Pri = request.getParameter("Pri");
    String bno = request.getParameter("bno");  //  <- 노출 정보 저장을 위해 추가
    
    advertDTO advdto = new advertDTO();
    advertVO vad = advdto.vip_ad(Integer.parseInt(Pri));
    String Adurl = vad.getDetailURL();
    
 	// ========================= 광고노출 관련 코드 ===============================
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
	}
	
	
	if(!rem_advertno_login.equals("") && login != null)
	{
		for(Cookie c : cookies)
		{
			if(c.getName().equals(login.getUno()))
			{
				c.setMaxAge(0);
				response.addCookie(c); 
			}
		}
		
		Cookie new_cookie = new Cookie( login.getUno(), vad.getAdvertno()); 
		new_cookie.setMaxAge(60*60*24);
		new_cookie.setPath("/"); 
		response.addCookie(new_cookie);
		
	}else if(!rem_advertno.equals("") && login == null)
	{
		for(Cookie c : cookies)
		{
			if(c.getName().equals("not_login"))
			{
				c.setMaxAge(0);
				response.addCookie(c); 
			}
		}
		
		Cookie new_cookie = new Cookie( "not_login", vad.getAdvertno()); 
		new_cookie.setMaxAge(60*60*24);
		new_cookie.setPath("/"); 
		response.addCookie(new_cookie);
	}else
	{
		Cookie new_cookie = new Cookie( "not_login", vad.getAdvertno()); 
		new_cookie.setMaxAge(60*60*24);
		new_cookie.setPath("/"); 
		response.addCookie(new_cookie);
	}

 	// ------------- 필요한 DTO, VO 선언 -------------
 	ad_exposureDTO ex_dto = new ad_exposureDTO();
	ad_exposureVO ex_vo_vip    = new ad_exposureVO();
	
	// ------------- 해당 광고(vip)노출 정보를 테이블에 저장 -------------
	ex_vo_vip.setAdvertno(vad.getAdvertno());
	ex_vo_vip.setBno(bno);
	
	if (login != null && login.getUno() != null)
	{
		ex_vo_vip.setUno(login.getUno());
	}
	boolean ex_vo_vip_whether = true;
	
	ex_dto.Insert(ex_vo_vip, ex_vo_vip_whether);
	
	
%>
	<div id="ad1-1" class="ad1-1"  style="background-image:url(<%= vad.getImageURL() %>);"></div>
	<div id="ad1-2" class="ad1-2"> <!-- 광고하단 1 -->
	<input type="hidden" id="adurl" name="adurl" value="<%= Adurl %>">
	<table border ="0" style="margin-top:20px; height:20px">
	<tr>
		<th style="height:48px; word-break:break-all;" colspan="2"><%= vad.getProductName() %></th>
	</tr>
	<tr>
	<td style="width:166; vertical-align:bottom; text-align: left; padding-top: 10px; padding-left: 20px;">
		<button class="btn-open-modal">Modal열기</button>
	</td>
	<td style="width:154; vertical-align:bottom; text-align: right; padding-top: 10px; padding-right: 20px;">
		<%= vad.getPrice() %>원
	</td>
	</tr>
	</table>
	</div>
