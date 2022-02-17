<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>

<%
request.setCharacterEncoding("UTF-8");
String id = request.getParameter("id");
int point = Integer.parseInt(request.getParameter("point"));

String result = "";

try {
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/myadevv?serverTimezone=Asia/Seoul";

	Connection conn = DriverManager.getConnection(url, "myadevv", "Ki9^Ra6^09917");
	PreparedStatement pstmt = null;
	String strSQL = "UPDATE simplememberlist SET point = " + point
		+ " WHERE id = '" + id + "'";

	pstmt = conn.prepareStatement(strSQL);
	pstmt.executeUpdate();

	pstmt.close();
	conn.close();
	
	result = "OK";
}
catch(SQLException e) {
	result = e.getMessage();
}
finally {
	out.print(result);
}
%>
