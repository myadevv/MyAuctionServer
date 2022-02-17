<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LoginPro</title>
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");
Class.forName("com.mysql.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";
Connection conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");

PreparedStatement pstmt = null;
ResultSet rs = null;

String id = (String) session.getAttribute("AuctionID");
int chargePoints = Integer.parseInt(request.getParameter("chargePoints"));
int totalPoints = (int)session.getAttribute("AuctionPoints") + chargePoints; 

String strSQL = "UPDATE memberList SET points = ? WHERE ID = ?";
pstmt = conn.prepareStatement(strSQL);
pstmt.setInt(1, totalPoints);
pstmt.setString(2, id);
pstmt.executeUpdate();
	
pstmt.close();
conn.close();

session.setAttribute("AuctionPoints", totalPoints);
%>
<script>
	alert("<%= Integer.toString(chargePoints) %>P를 충전하여 총 <%= Integer.toString(totalPoints) %>P가 되었습니다.")
	location.href = "../Product/Listboard.jsp"
	parent.leftFrame.location.href='../MainMenu.jsp'
</script>
</body>