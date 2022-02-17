<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
%>

<HTML>
<HEAD>
<TITLE>게시판</TITLE>

<META http-equiv="Content-Type" content="text/html; charset=utf-8">

<style type='text/css'>
body {
    background: repeating-linear-gradient(
        45deg,
        #fdfdfd,
        #fdfdfd 10px,
        #ffffff 10px,
        #ffffff 20px
    );
}
a, a:visited { color: black; text-decoration: none;  }
a:hover { color: red; }
table.main {
	margin: auto;
	border-collapse: separate;
	border-spacing: 20px;
}
#header { text-align:right; }
#title { font-size: 22px; }
#line { height=3px;
	    border=double black;
	  }
</style>
<script type="text/javascript">
function remindTime(end, cnt) {
    var nt = new Date(); //현재시간을 구한다. 
  
    var et = new Date(end); // 종료시간만 가져온다.
    
    sec = parseInt(et - nt) / 1000;
    if (sec < 0) {
    	dd.innerHTML = "(입찰 마감)";
    	return;
    }
    
    min = parseInt(sec / 60);
    sec = parseInt(sec % 60);
    
    hour = parseInt(min / 60);
    min = parseInt(min % 60);
    
    if (hour < 10) hour = "0" + hour;
    if (min < 10) min = "0" + min; 
    if (sec < 10) sec = "0" + sec;
    
    dd.innerHTML = "(앞으로 " + hour + ":" + min + ":" + sec + ")";
}

function confirmComplete(r) {
	var conf = confirm("정말로 거래를 최종 완료하시겠습니까?");
	if (conf == true) {
		location.href = "ConfirmPass.jsp?num=<%=request.getParameter("num")%>&r=" + r;
	}
	else {
		return;
	}		
}
</script>
</HEAD>
<BODY>
<%
String num = request.getParameter("num");

Class.forName("com.mysql.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul"; // DB 지정
Connection conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
	String strSQL = "SELECT * FROM productList WHERE registerNumber = ?";
	pstmt = conn.prepareStatement(strSQL);
	pstmt.setInt(1, Integer.parseInt(num));
	rs = pstmt.executeQuery();
	rs.next();

	int rNum = rs.getInt("registerNumber");
	String topImage = rs.getString("defaultImage");
	String title = rs.getString("title");
	String description = rs.getString("description");
	int price = rs.getInt("currentPoint");
	java.text.SimpleDateFormat transFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	java.util.Date startDate = new java.util.Date(rs.getTimestamp("registerDate").getTime());
	String start = transFormat.format(startDate);
	java.util.Date endDate = new java.util.Date(rs.getTimestamp("endDate").getTime());
	String end = transFormat.format(endDate);
	String id = rs.getString("sellerID");
	String name = rs.getString("sellerName");
	int hits = rs.getInt("hits");
	String status = rs.getString("status");
	rs.close();
	pstmt.close();
%>

	<table width="100%" class="main">
		<tr>
			<td align="left" width="50%"><img src=<%= "../ImageStorage/" + rNum + "/" + topImage %>
							      			  width="100%" height="auto">
			</td>
		<td>
			<table>
				<tr><td id="title"><b><%= title %></b></td></tr>
				<tr><td id="description"><%= description %></td></tr>
			</table>
		</td>
		</tr>
	</table>
	<hr id="line" width="75%">
	<table width="100%" class="main">
		<tr>
			<td id="header" width="50%"><b>등록자명</b></td>
			<td><%= name %> (<%= id %>)</td>
		</tr>
		<tr>
			<td id="header" width="50%"><b>등록 날짜</b></td>
			<td><%= start %></td>
		</tr>
		<tr>
			<td id="header" width="50%"><b>경매 종료 날짜</b></td>
			<td><%= end %> <font color="red"><b id="dd">(앞으로 ??:??:??)</b></font></td>
		</tr>
		<tr>
			<td id="header" width="50%"><b>현재 가격</b></td>
			<td><%= price %>P</td>
		</tr>
	</table>
	
	<script>setInterval( function() { remindTime(<%= endDate.getTime() %>); }, 1000);</script>
	
	<div style="text-align:center;">
	<%
	strSQL = "SELECT t.relationNumber, t.buyerid, t.status FROM payrelation AS t, "
		   + "(SELECT productNumber, max(payedPoint) AS maxPoint FROM payrelation WHERE productNumber = " + num + ") AS t2 "
		   + "WHERE t.payedPoint = t2.maxPoint AND t.productNumber = t2.productNumber";
	pstmt = conn.prepareStatement(strSQL);
	rs = pstmt.executeQuery();
	rs.next();
	if (!id.equals((String)session.getAttribute("AuctionID"))) {
	       if (endDate.compareTo(new java.util.Date()) > 0) { %>
		<a href="BiddingForm.jsp?num=<%=num%>&p=<%=price%>" style="font-size:30px;"><b>[입찰하기]</b></a>
	    <% } else {
	    	if (((String)session.getAttribute("AuctionID")).equals(rs.getString("buyerid"))) {
	    		if (status.equals("0")) { %>
	    			<a style="font-size:24px"><b>판매자로부터의 송장 번호 입력을 기다리는 중입니다...</b></a>
		    	<% }
	    		else if (rs.getInt("status") == 0) { %>
	    			<a href="javascript:confirmComplete(<%=rs.getInt("relationNumber")%>)" style="font-size:30px"><b>[거래 완료 확인]</b></a>
	    		<% }
	    		else { %>
	    			<a style="font-size:24px"><b>거래가 완료된 상품입니다.</b></a>
	    		<% }
	    	}
	    	else { %>
	    		<a style="font-size:24px"><b>입찰이 종료된 상품입니다.</b></a>
	    	<% }
	    }
	}
	else if (endDate.compareTo(new java.util.Date()) > 0) { %>
		<a style="font-size:24px"><b>입찰 기간이 종료되지 않은 상품입니다.</b></a>
	<% }
	else if (rs.getString("buyerid").equals("null")) { %>
		<a style="font-size:24px"><b>입찰자가 없어 유찰된 상품입니다.</b></a>
	<% }
	else {
	    if (status.equals("0")) { %>
	    	<a href="PostForm.jsp?num=<%=num%>" style="font-size:30px"><b>[송장 번호 입력]</b></a>
	    <% }
	    else if (rs.getInt("status") == 0) { %>
	    	<a style="font-size:24px"><b>구매자로부터의 거래 완료 확인을 기다리는 중입니다...</b></a>
	    <% }
	    else { %>
    		<a style="font-size:24px"><b>거래가 완료된 상품입니다.</b></a>
    	<% }
	   } %>
	    <br><br>
		<hr id="line" width="75%">
		<font size="2">등록 번호 : <%=num %> | 조회수 : <%=hits %></font>
		<br><br>
	<% if (id.equals((String) session.getAttribute("AuctionID")))
		   if (endDate.compareTo(new java.util.Date()) > 0) { %>
			<a href="ProductModify_Pass.jsp?num=<%=num%>">[정보 수정]</a>
			<a href="ProductDelete_Pass.jsp?num=<%=num%>">[상품 삭제]</a>
		<% } %>
		<a href='Listboard.jsp'>[돌아가기]</a>
	</div>
	<br><br>

<%
	hits++; // 조회수 올리기
	strSQL = "UPDATE productList SET hits = ? WHERE registerNumber = ?";
	pstmt = conn.prepareStatement(strSQL);
	pstmt.setInt(1, hits);
	pstmt.setInt(2, rNum);
	pstmt.executeUpdate();
	pstmt.close();
	
} catch (SQLException e) { //  (11) P.37의 Try문 연계
	out.print("SQL에러 " + e.toString());
} catch (Exception ex) {
	out.print("JSP에러 " + ex.toString());
} finally { //  (12) 무조건 시행
	conn.close();
}
%>
	
</BODY>
</HTML>
