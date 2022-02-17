<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LoginPro</title>
</head>
<body>

<%
Class.forName("com.mysql.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";
Connection conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");
Statement stmt = conn.createStatement();

ResultSet rs = null;

int num = Integer.parseInt(request.getParameter("num"));
int relNum = Integer.parseInt(request.getParameter("r"));

String strSQL = "UPDATE payrelation SET status = 1 WHERE relationNumber = " + Integer.toString(relNum);
stmt.executeUpdate(strSQL);

strSQL = "SELECT t.payedPoint, t.sellerid FROM payrelation AS t, "
	   + "(SELECT productNumber, max(payedPoint) AS maxPoint FROM payrelation WHERE productNumber = " + num + ") AS t2 "
	   + "WHERE t.payedPoint = t2.maxPoint AND t.productNumber = t2.productNumber AND t.buyerid = '" + (String)session.getAttribute("AuctionID") + "'"; 
rs = stmt.executeQuery(strSQL);
rs.next();
int points = rs.getInt("payedPoint");
String ID = rs.getString("sellerid");

strSQL = "UPDATE memberlist SET points = points + " + points + " WHERE id = '" + ID + "'";
stmt.executeUpdate(strSQL);

rs.close();
stmt.close();
conn.close();
%>

<script>
alert("거래가 최종적으로 완료되었습니다!!!");
location.href = "../Account/Paylist.jsp";
</script>
</body>
</html>