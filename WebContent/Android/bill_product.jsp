<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" import="java.util.*, org.json.simple.*, org.json.simple.parser.JSONParser, java.text.SimpleDateFormat, myPackage.postJson" %>

<%
JSONObject jObject = new JSONObject();

Connection conn = null;
Statement stmt = null;

String strSQL = null;

try {
	request.setCharacterEncoding("UTF-8");
	String buyerID = request.getParameter("buyerID");
	int resid = Integer.parseInt(request.getParameter("resid"));
	int point = Integer.parseInt(request.getParameter("point"));
	
    Class.forName("com.mysql.jdbc.Driver");
    
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/myadevv?serverTimezone=Asia/Seoul", "myadevv", "Ki9^Ra6^09917");

    stmt = conn.createStatement();
  
    ResultSet rs = null;
    java.util.Date now = new java.util.Date();
    java.text.SimpleDateFormat form = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    strSQL = "SELECT title, sellerID, endDate FROM productlist WHERE registerNumber = " + resid;
    rs = stmt.executeQuery(strSQL);

   	rs.next();
   	String title = rs.getString("title");
   	String sellerID = rs.getString("sellerID");
	java.util.Date end = new java.util.Date(rs.getTimestamp("endDate").getTime());
    rs.close();
	
	String endDate = form.format(end);
   	
	PreparedStatement pstmt = null;
	
	strSQL = "SELECT t.buyerid, t.payedPoint FROM payRelation AS t, "
			   + "(SELECT productNumber, max(payedPoint) AS maxPoint FROM payRelation GROUP BY productNumber) AS t2 "
			   + "WHERE t.payedPoint = t2.maxPoint AND t.productNumber = t2.productNumber AND t.productNumber = " + resid;
	pstmt = conn.prepareStatement(strSQL);
	rs = pstmt.executeQuery(strSQL);
	
	if (rs.next()) {
		String lowerID = rs.getString("buyerid");
		int lowerPoint = rs.getInt("payedPoint");
		pstmt.close();

		strSQL = "UPDATE simplememberlist SET point = point + " + lowerPoint + " WHERE id = '" + lowerID + "'";
		pstmt = conn.prepareStatement(strSQL);
		pstmt.executeUpdate();
	}
	rs.close();
	pstmt.close();
	
	strSQL = "UPDATE productlist SET currentPoint = " + point + ", status = 1 WHERE registerNumber = " + resid;
	pstmt = conn.prepareStatement(strSQL);
	pstmt.executeUpdate();
	pstmt.close();

	strSQL = "UPDATE simplememberlist SET point = point - " + point + " WHERE id = '" + buyerID + "'";
	pstmt = conn.prepareStatement(strSQL);
	pstmt.executeUpdate();
	pstmt.close();
	
	strSQL = "UPDATE payRelation SET status = 1 WHERE productNumber = " + resid;
	pstmt = conn.prepareStatement(strSQL);
	pstmt.executeUpdate();
	pstmt.close();
	
	strSQL = "INSERT INTO payRelation(productNumber, payedPoint, sellerID, buyerID, productTitle, endDate)"
		       + "VALUES(?, ?, ?, ?, ?, ?)";
	pstmt = conn.prepareStatement(strSQL);
	pstmt.setInt(1, resid);
	pstmt.setInt(2, point);
	pstmt.setString(3, sellerID);
	pstmt.setString(4, buyerID);
	pstmt.setString(5, title);
	pstmt.setString(6, endDate);
	pstmt.executeUpdate();
	pstmt.close();
	
	out.print("OK");
}
catch(SQLException e) {
	out.print(e.getMessage());
    e.printStackTrace();
}
catch(Exception e) {
	out.print(e.getMessage());
    e.printStackTrace();
}
finally {
    try {
        stmt.close();
        conn.close();
    } catch(Exception ignored) {}
}
%>