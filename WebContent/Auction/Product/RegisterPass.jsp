<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy,java.util.*"%>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Register</title>

</head>
<body>

<%
Class.forName("com.mysql.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";
Connection conn = DriverManager.getConnection(url,"root","Ki9^Ra6^"); 
Statement stmt = conn.createStatement();

String strSQL = "SELECT Max(registerNumber) AS rNum FROM productList";

ResultSet rs = stmt.executeQuery(strSQL); 
rs.next();
int num = rs.getInt("rNum") + 1;
rs.close();

String saveFolder = "C:/Users/JGH/Desktop/학교/jspapp/MyAuction/WebContent/Auction/ImageStorage/" + Integer.toString(num);

File Folder = new File(saveFolder);
if (!Folder.exists()) {
	try { Folder.mkdir(); } 
	catch(Exception e) { e.getStackTrace(); }
}

String encType = "utf-8";
int sizeLimit = 10 * 1024 * 1024;
MultipartRequest multi = new MultipartRequest(request,saveFolder,sizeLimit,encType,new DefaultFileRenamePolicy());

String imgFile = multi.getFilesystemName("img");
String title = multi.getParameter("title");
String contents = multi.getParameter("inst");
String price = multi.getParameter("price");
String endDate = multi.getParameter("date") + " " + multi.getParameter("time"); // yyyy-mm-dd hh:mm(:ss)
String payment = multi.getParameter("box");

String name = (String) session.getAttribute("AuctionName");
String id = (String) session.getAttribute("AuctionID");

PreparedStatement pstmt = null;
strSQL = "INSERT INTO productList(registerNumber, title, description, defaultImage, currentPoint, endDate, sellerName, sellerID, payment)";
strSQL = strSQL + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
pstmt = conn.prepareStatement(strSQL);
pstmt.setInt(1, num);
pstmt.setString(2, title);
pstmt.setString(3, contents);
pstmt.setString(4, imgFile);
pstmt.setInt(5, Integer.parseInt(price));
pstmt.setString(6, endDate);
pstmt.setString(7, name);
pstmt.setString(8, id);
pstmt.setInt(9, Integer.parseInt(payment));
pstmt.executeUpdate();
pstmt.close();

strSQL = "INSERT INTO payrelation(buyerID, payedPoint, productNumber, productTitle, sellerid, endDate)"
       + "VALUE (?, ?, ?, ?, ?, ?)";
pstmt = conn.prepareStatement(strSQL);
pstmt.setString(1, "null");
pstmt.setInt(2, Integer.parseInt(price));
pstmt.setInt(3, num);
pstmt.setString(4, title);
pstmt.setString(5, id);
pstmt.setString(6, endDate);
pstmt.executeUpdate();
pstmt.close();

stmt.close();
conn.close();
%>
<script>
location.href = "Listboard.jsp";
</script>
</body>
</html>