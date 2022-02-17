<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>

<%
request.setCharacterEncoding("UTF-8");
String id = request.getParameter("id");
String pw = request.getParameter("pw");

String result = "";

try {
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/myadevv?serverTimezone=Asia/Seoul";

	Connection conn = DriverManager.getConnection(url, "myadevv", "Ki9^Ra6^09917");
	PreparedStatement pstmt = null;
	String strSQL ="INSERT INTO simplememberlist(ID, password)";
	strSQL = strSQL + "VALUES(?, SHA2(?, 256))";

	pstmt = conn.prepareStatement(strSQL);
	pstmt.setString(1, id);
	pstmt.setString(2, pw);
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
