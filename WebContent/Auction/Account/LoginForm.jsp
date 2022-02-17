
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
</head>
<body>
<div style="text-align:center;">
<h1>Login</h1>
<%
String id = (String) session.getAttribute("AuctionID");
if (id == null) {
%>
	<form action="LoginPass.jsp" method="post">
	ID : <input type="text" name="id"><br>
	PW : <input type="password" name="pw"><p>
	<input type="submit" value="Login">
	</form>
<% } else { %>
	<script>
	alert('이미 로그인되어 있습니다.');
	location.href = "../Product/Listboard.jsp";
	</script>
<% } %>
</div>
</body>
</html>