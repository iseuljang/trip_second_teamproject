<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="trip.vo.*" %>
<%@ page import="trip.dao.*" %>    
<%@ page import="trip.dto.*" %>    
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%
String category;

category = request.getParameter("category");
if(category == null)
{
	category = "패션";
}
out.println(category);
advertDTO dto = new advertDTO();

ArrayList<advertVO> sub_list = dto.GetSubCategory(category);
for(advertVO advo : sub_list)
{
	%>
	<tr>
		<td class="sub_category" onclick="click_sub_category('<%= advo.getSubclass() %>');" id="<%= advo.getSubclass() %>"><%= advo.getSubclass() %></td>
	</tr>
	<%
}
%>
<style>
.sub_category
{
	background-color : ghostwhite;
}
</style>
<script>
$(document).ready(function(){
	//------------------------------ 하위 카테고리에 마우스를 올릴시 ------------------------------
	$(".sub_category").mouseover(function()
	{
		$(this).css("background-color", "lightgray");
	})
	.mouseleave(function()
	{
		// 마우스 내릴시
		$(this).css("background-color", "ghostwhite");
	})
});
</script>