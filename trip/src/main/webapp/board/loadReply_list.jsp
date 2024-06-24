<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, trip.vo.*, trip.dto.*" %>
<%
    String bno = request.getParameter("no");
	userVO login  = (userVO)session.getAttribute("login");

    replyDTO rdto = new replyDTO();
    ArrayList<replyVO> rlist = rdto.GetList(bno);

    for (replyVO rvo : rlist) {
%>
    <form>
        <table border="0" style="width: 60%;" align="center">
            <tr>
                <td colspan="4"><hr style="width: 100%; border:0px; height:1px; background: linear-gradient(to left, transparent, #87CEEA, transparent);"></td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-size : 40px; width:150px;">
                    <%
                        String icon = "😄";
                        switch (rvo.getUicon()) {
                            case "1": icon = "😄"; break;
                            case "2": icon = "😅"; break;
                            case "3": icon = "😆"; break;
                            case "4": icon = "😀"; break;
                            case "5": icon = "😨"; break;
                            case "6": icon = "👿"; break;
                            case "7": icon = "😝"; break;
                            case "8": icon = "😷"; break;
                            case "9": icon = "😴"; break;
                            case "10": icon = "😱"; break;
                        }
                    %>
                    <%= icon %>
                </td>
                <td style="font-size: 20px;" width="150" id="runick"><%= rvo.getUnick() %></td>
                <td style="font-size: 15px;" id="rwdate">&nbsp;&nbsp;&nbsp;<%= rvo.getRwdate() %></td>
                <td style="text-align: right; height: 20px; padding-right: 100px;">
                    <%
                        if (login != null && (login.getUno().equals(rvo.getUno()) || login.getAdmin().equals("Y"))) {
                    %>
                    <div id="reply_div<%= rvo.getRno() %>">
                        <span class="reply_btn" id="reply_modify" onclick="reply_update(<%= rvo.getRno() %>,<%= bno%>);">수정</span>
                        <span class="reply_btn" id="reply_delete" onclick="reply_delete(<%= rvo.getRno() %>);">삭제</span>
                    </div>
                    <%
                        }
                    %>
                </td>
            </tr>
            <tr>
                <td colspan="3" style="padding-bottom: 30px;" id="<%= rvo.getRno() %>"><span><%= rvo.getRnote() %></span></td>
            </tr>
        </table>
    </form>
<%
    }
%>
