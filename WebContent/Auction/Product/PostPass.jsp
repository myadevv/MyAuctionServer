<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PostPro</title>
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");
Class.forName("com.mysql.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";
Connection conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");

PreparedStatement pstmt = null;
ResultSet rs = null;

int productNum = Integer.parseInt(request.getParameter("num"));
String postNum = (String)request.getParameter("postNum"); 
request.getParameter("chargePoints");

String strSQL = "UPDATE productList SET status = ? WHERE registerNumber = ?";
pstmt = conn.prepareStatement(strSQL);
pstmt.setString(1, postNum);
pstmt.setInt(2, productNum);
pstmt.executeUpdate();
	
pstmt.close();
conn.close();
%>
<script>
	alert("송장 번호 <%=postNum%>가 정상적으로 입력되었습니다.")
	location.href = "View.jsp?num=<%=productNum%>"
</script>
</body>