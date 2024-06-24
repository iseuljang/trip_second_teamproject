<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%
int year = 0;
int month = 0;

String get_year  = request.getParameter("year"); 
String get_month = request.getParameter("month");

if(get_year == null || get_year == null || get_month.equals("") || get_month.equals("")) 
{
	Calendar today = Calendar.getInstance();
	year = today.get(Calendar.YEAR);
	month = today.get(Calendar.MONTH);
	
}else
{
	year = Integer.parseInt(request.getParameter("year"));
	month = Integer.parseInt(request.getParameter("month"));

	if(month == -1)
	{
		month = 11;
		year--;
	}
	
	if(month == 12)
	{
		month = 0;
		year++;
	}

}

	Calendar firstDate = Calendar.getInstance();
	firstDate.set(Calendar.YEAR, year);
	firstDate.set(Calendar.MONTH, month);
	firstDate.set(Calendar.DATE, 1);
	int firstDay = firstDate.get(Calendar.DAY_OF_WEEK);
	int lastDate = firstDate.getActualMaximum(Calendar.DATE);
	
	int startBlankCnt = firstDay - 1;
	int endBlankCnt = 0;
	if((startBlankCnt+lastDate)%7 != 0)
	{
		endBlankCnt = 7 - (startBlankCnt+lastDate) % 7;
	}
	
	int tdCnt = startBlankCnt + lastDate + endBlankCnt;
%>
<script src="../js/jquery-3.7.1.js"></script>
<script>

var year  = <%= year %>
var month = <%= month %>

function goto_last_month()
{
	
	$.ajax({
		type : "post",
		url  : "masterADCalender.jsp",
		data :
		{
			year  : year,
			month : month-1
		},
		dataType : "html",
		success : function(result)
		{
			result = result.trim();
			$("#calender_td").html(result);

		}
	});
	
}

function goto_next_month()
{
	
	$.ajax({
		type : "post",
		url  : "masterADCalender.jsp",
		data :
		{
			year  : year,
			month : month+1
		},
		dataType : "html",
		success : function(result)
		{
			result = result.trim();
			$("#calender_td").html(result);

		}
	});
}


</script>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>달력</title>
		<style>
			
		</style>
	</head>
	<body>
		<div style="text-align : center;">
			<button type="button" onclick="goto_last_month()">이전 달</button>
			<%=year%>년 <%=month+1%>월
			<button type="button" onclick="goto_next_month()">다음 달</button>
		</div>
		<table border="1" width="500px" height="300px">
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
			<tr>
				<%
					for(int i = 1; i <= tdCnt; i++) 
					{
						%>
						<td>
							<%
							if(i > startBlankCnt && i <= startBlankCnt + lastDate) 
							{
								if(i % 7 == 0)
								{
									%><span><%=i-startBlankCnt%></span><%
								}else if(i%7 == 1) 
								{
									%><span><%=i-startBlankCnt%></span><%
								
								}else
								{
									%><%=i-startBlankCnt%><%
								}	
							}else 
							{
								%>&nbsp;<%
							}
							%>
						</td>
						<%	
						if(i!=tdCnt && i%7 == 0)
						{
							%></tr><tr><%
						}
					}
				%>
			</tr>
		</table>
	</body>
</html>