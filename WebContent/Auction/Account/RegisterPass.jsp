<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Register</title>

</head>
<body>

<%
String id = request.getParameter("id");
String pw = request.getParameter("pass");
String name = request.getParameter("name");
String contact = request.getParameter("num0") + request.getParameter("num1") + request.getParameter("num2");
String address = request.getParameter("address");

Class.forName("com.mysql.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";

Connection conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");
PreparedStatement pstmt = null;
String strSQL ="INSERT INTO memberList(ID, pwd, name, contact, address)";
strSQL = strSQL + "VALUES(?, SHA2(?, 256), ?, ?, ?)";

pstmt = conn.prepareStatement(strSQL);
pstmt.setString(1, id);
pstmt.setString(2, pw);
pstmt.setString(3, name);
pstmt.setString(4, contact);
pstmt.setString(5, address);
pstmt.executeUpdate();

pstmt.close();
conn.close();
%>
<script>
alert("<%= name %> 님 회원가입을 환영합니다. 로그인해 주세요.");
location.href = "LoginForm.jsp";
</script>
</body>
</html>