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

String id = request.getParameter("id");
String pw = request.getParameter("pw");

try {
	String strSQL = "SELECT * FROM memberList WHERE id = ? AND pwd = SHA2(?, 256)";
	pstmt = conn.prepareStatement(strSQL);
	pstmt.setString(1, id);
	pstmt.setString(2, pw);
	rs = pstmt.executeQuery();
	if (rs.next()) {
		String name = rs.getString("name");
		int points = rs.getInt("points");
		session.setAttribute("AuctionID", id);
		session.setAttribute("AuctionName", name);
		session.setAttribute("AuctionPoints", points);
		out.println("<script>alert('" + name + " 님 환영합니다.');</script>");
		%>
		<script>
		location.href = "../Product/Listboard.jsp"
		parent.leftFrame.location.href='../MainMenu.jsp'
		</script>
		<%
	}
	else { %>
		<script>alert("아이디 혹은 비밀번호가 틀렸습니다.");
		location.href = "LoginForm.jsp"
		</script>
	<% }
} catch (SQLException e) { //  (11) P.37의 Try문 연계
	out.print("SQL에러 " + e.toString());
} catch (Exception ex) {
	out.print("JSP에러 " + ex.toString());
} finally { //  (12) 무조건 시행
	rs.close();
	pstmt.close();
	conn.close();
}
%>
</body>
</html>