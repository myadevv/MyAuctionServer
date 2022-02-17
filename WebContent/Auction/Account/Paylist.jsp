<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<style>
* { font-family: "Malgun Gothic", generic-family; }
body {
    background: repeating-linear-gradient(
        45deg,
        #fdfdfd,
        #fdfdfd 10px,
        #ffffff 10px,
        #ffffff 20px
    );
}
hr { border: dotted 1; }
img { align: center; }
table {
	margin: auto;
	border-collapse: separate;
}
 margin: 30px 5%; }
tr { margin: 15px 5px; }
a, a:visited { color: black; text-decoration: none;  }
a:hover { color: red; }
</style>
<script type="text/javascript">
function getMemberInfo(id, name, contact) {
	alert(id + " (" + name +") 님의 연락처 : " + contact);
	return;
}
</script>

<title>PayList</title>
</head>
<body>
<%
String pageNum = request.getParameter("AuctionPageNum");

if (pageNum == null) { // 처음 이 페이지 방문시 페이지번호 초기화 
	pageNum = "1";
}

int listSize = 10;
int cnt = 0;
int i = 0;

Class.forName("com.mysql.jdbc.Driver");

String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";
Connection conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");
Statement stmt = conn.createStatement();

String strSQL = "SELECT count(*) FROM payrelation WHERE buyerid = '" + (String)session.getAttribute("AuctionID") + "'";
ResultSet rs = stmt.executeQuery(strSQL);
rs.next();
cnt = rs.getInt(1);
rs.close();
%>
<div style="text-align:center;">
<h1>최근 입찰 내역</h1>
<% if (cnt > 0) { %>
	<table border="1" cellspacing="0" width="70%">
		<tr align="center" bgcolor="LIGHTGRAY">
    		<td width="10%">No.</td> 
    		<td width="50%">상품명</td> 
    		<td width="15%">입찰가</td> 
    		<td width="15%">판매자명 </td> 
    		<td width="10%">상태</td>
    	</tr>
	<%
	strSQL = "SELECT t.relationNumber, t.productNumber, t.productTitle, t.payedPoint, t.sellerid, t.status, t.endDate FROM payrelation AS t, "
		   + "(SELECT productNumber, max(payedPoint) AS maxPoint FROM payrelation "
		   + "WHERE buyerid = '" + (String)session.getAttribute("AuctionID") + "' GROUP BY productNumber) AS t2 "
		   + "WHERE t.payedPoint = t2.maxPoint AND t.productNumber = t2.productNumber " 
		   + "ORDER BY t.relationNumber DESC";
	
	rs = stmt.executeQuery(strSQL);
	
	for (i = 0; i < listSize; i++) {
		if (rs.next()) {
			int num = rs.getInt("relationNumber");
			int productNum = rs.getInt("productNumber");
			String title = rs.getString("productTitle");
			int price = rs.getInt("payedPoint");
			String sellerID = rs.getString("sellerid");
			int status = rs.getInt("status");
		%>
    		<tr align="center">
    			<td><%=num %></td>
        		<td><a href="../Product/View.jsp?num=<%=productNum%>"><%=title %></a></td>
        		<td><%=price %></td>
        		<td>
        		<%
        			strSQL = "select t.name, t.contact from memberlist as t, "
        				   + "(select sellerid from productlist where registernumber = " + productNum + ") as t2 "
        				   + "where t.id = t2.sellerid";
					Statement nstmt = conn.createStatement();
					ResultSet nrs = nstmt.executeQuery(strSQL);
					nrs.next();
					String sellerName = nrs.getString("name");
					String sellerCon = nrs.getString("contact");
        		%>
        		<a href="javascript:getMemberInfo('<%=sellerID%>', '<%=sellerName%>', '<%=sellerCon%>')"><%=sellerID %></a></td>
        		<td>
        		<%
        			nrs.close();
        			nstmt.close();
        			strSQL = "SELECT t.buyerid FROM payrelation AS t, "
        				   + "(SELECT productNumber, max(payedPoint) AS maxPoint FROM payrelation GROUP BY productNumber) AS t2 "
        				   + "WHERE t.payedPoint = t2.maxPoint AND t.productNumber = t2.productNumber AND t.productNumber = " + productNum;
    				nstmt = conn.createStatement();
    				nrs = nstmt.executeQuery(strSQL);
        			nrs.next();
        			if (!((String)session.getAttribute("AuctionID")).equals(nrs.getString("buyerid"))) {
        				%> 상위 입찰됨 <%
        			}
        			else {
        				nrs.close();
        				nstmt.close();
        				java.util.Date nt = new java.util.Date();
        				java.util.Date et = rs.getTimestamp("endDate");
        				if (nt.compareTo(et) < 0) { %> 입찰 중 <% }
        				else {
        					strSQL = "SELECT status FROM productlist WHERE registerNumber = " + productNum;
        					nstmt = conn.createStatement();
        					nrs = nstmt.executeQuery(strSQL);
                			nrs.next();
        					if (!nrs.getString("status").equals("0") && status == 1) { %> 거래 완료 <% }
        					else { %> 거래 중 <% }
        					nrs.close();
        					nstmt.close();
        				}
        			} %>
        		</td>
    		</tr>
<% 		}
	}
%> </table>
<% } else { %>
	현재 입찰 정보가 존재하지 않습니다.<br>
<% } %>
<br><hr width="75%">
<%
strSQL = "SELECT count(*) FROM payrelation WHERE sellerid = '" + (String)session.getAttribute("AuctionID") + "'";
rs = stmt.executeQuery(strSQL);
rs.next();
cnt = rs.getInt(1);
rs.close();
%>
<h1>최근 등록 내역</h1>
<% if (cnt > 0) { %>
	<table border="1" cellspacing="0" width="70%">
		<tr align="center" bgcolor="LIGHTGRAY">
    		<td width="10%">No.</td> 
    		<td width="50%">상품명</td> 
    		<td width="15%">입찰가</td> 
    		<td width="15%">입찰자명 </td> 
    		<td width="10%">상태</td>
    	</tr>
	<%
	strSQL = "SELECT registerNumber, title, currentPoint, endDate, status FROM productList WHERE "
		     + "sellerid = '" + (String)session.getAttribute("AuctionID") + "'";
	rs = stmt.executeQuery(strSQL);
	
	for (i = 0; i < listSize; i++) {
		if (rs.next()) {
			int num = rs.getInt("registerNumber");
			String title = rs.getString("title");
			int price = rs.getInt("currentPoint");
			String status = rs.getString("status");
			java.util.Date nt = new java.util.Date();
			java.util.Date et = rs.getTimestamp("endDate");
			
	    	strSQL = "SELECT t.buyerid, t.status FROM payrelation AS t, "
			       + "(SELECT productNumber, max(payedPoint) AS maxPoint FROM payrelation WHERE productNumber = " + num + ") AS t2 "
			       + "WHERE t.payedPoint = t2.maxPoint AND t.productNumber = t2.productNumber";
	    	Statement nstmt = conn.createStatement();
			ResultSet nrs = nstmt.executeQuery(strSQL);
			nrs.next();
		%>
    		<tr align="center">
    			<td><%=num %></td>
        		<td><a href="../Product/View.jsp?num=<%=num%>"><%=title %></a></td>
        		<td><%=price %></td>
        		<td>
        		<%
        			if (nt.compareTo(et) < 0) { %> 입찰 중 <% }
        			else if (nrs.getString("buyerid").equals("null")) { %> 입찰자 없음 <% }
        			else { %> <a href=""><%=nrs.getString("buyerid")%></a> <% }
        		%>
        		</td>
        		<td>
        		<%
        			if (nt.compareTo(et) < 0) { %> 입찰 중 <% }
        			else {
        				if (nrs.getString("buyerid").equals("null")) {
        					%> 유찰됨 <%
        				}
        				else if (!status.equals("0") && nrs.getInt("status") == 1) {
        					%> 거래 완료 <%
        				} 
        				else { %> 거래 중 <% }
        			} %>
        		</td>
    		</tr>
<% 		}
	}
%> </table>
<% } else { %>
	현재 등록한 물품이 없습니다.<br>
<% } stmt.close(); %>
<br><hr width="75%">
<br>* 최근 10건의 입찰 및 등록 정보만 표시됩니다.
<br>* 입찰 중에는 판매 물품의 입찰자명이 표시되지 않습니다.
</div>
</body>
</html>