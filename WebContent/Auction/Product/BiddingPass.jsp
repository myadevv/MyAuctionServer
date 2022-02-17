<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BiddingPro</title>
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");
Class.forName("com.mysql.jdbc.Driver");
String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";
Connection conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");

String id = (String) session.getAttribute("AuctionID");
int payPoints = Integer.parseInt(request.getParameter("payPoints"));
int totalPoints = (int)session.getAttribute("AuctionPoints") - payPoints;
int productNum = Integer.parseInt(request.getParameter("num"));

Statement stmt = conn.createStatement();
String strSQL = "SELECT title, sellerid, endDate FROM productList WHERE registerNumber = " + productNum;

ResultSet rs = stmt.executeQuery(strSQL);
rs.next();
String productTitle = rs.getString("title");
String sellerID = rs.getString("sellerid");
java.sql.Timestamp endDate = rs.getTimestamp("endDate");
rs.close();
stmt.close();

strSQL = "SELECT t.buyerid, t.payedPoint FROM payrelation AS t, "
	   + "(SELECT productNumber, max(payedPoint) AS maxPoint FROM payrelation GROUP BY productNumber) AS t2 "
	   + "WHERE t.payedPoint = t2.maxPoint AND t.productNumber = t2.productNumber AND t.productNumber = " + productNum;
PreparedStatement pstmt = conn.prepareStatement(strSQL);
rs = pstmt.executeQuery(strSQL);
rs.next();
String lowerID = rs.getString("buyerid");
int lowerPoint = rs.getInt("payedPoint");
pstmt.close();

strSQL = "UPDATE memberlist SET points = points + " + lowerPoint + " WHERE id = '" + lowerID + "'";
%> <script>alert("<%=strSQL%>")</script> <%
pstmt = conn.prepareStatement(strSQL);
pstmt.executeUpdate();
pstmt.close();

strSQL = "INSERT INTO payrelation (buyerID, payedPoint, productNumber, productTitle, sellerID, endDate) "
	   + "VALUE (?, ?, ?, ?, ?, ?)";
pstmt = conn.prepareStatement(strSQL);
pstmt.setString(1, id);
pstmt.setInt(2, payPoints);
pstmt.setInt(3, productNum);
pstmt.setString(4, productTitle);
pstmt.setString(5, sellerID);
pstmt.setTimestamp(6, endDate);
pstmt.executeUpdate();
pstmt.close();

strSQL = "UPDATE productlist SET currentPoint = " + payPoints + " WHERE registerNumber = " + productNum;
pstmt = conn.prepareStatement(strSQL);
pstmt.executeUpdate();
pstmt.close();

strSQL = "UPDATE memberlist SET points = " + totalPoints + " WHERE id = '" + id + "'";
pstmt = conn.prepareStatement(strSQL);
pstmt.executeUpdate();
pstmt.close();

conn.close();

session.setAttribute("AuctionPoints", totalPoints);
%>
<script>
	alert("입찰이 완료되었습니다. 현황은 [내 거래 내역 보기]에서 확인할 수 있습니다.");
	location.href = "View.jsp?num=<%=productNum%>"
	parent.leftFrame.location.href='../MainMenu.jsp'
</script>
</body>