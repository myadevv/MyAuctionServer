<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" import="java.util.*, org.json.simple.*, org.json.simple.parser.JSONParser, java.text.SimpleDateFormat, myPackage.postJson" %>

<%
JSONObject jObject = new JSONObject();

Connection conn = null;
Statement stmt = null;

String strSQL = null;

try {
	String strData = postJson.getrequestBody(request);
	JSONParser parser = new JSONParser();
	JSONObject data = (JSONObject)parser.parse(strData);
	
	long resid = (long)data.get("resid");

    Class.forName("com.mysql.jdbc.Driver");
    
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/myadevv?serverTimezone=Asia/Seoul", "myadevv", "Ki9^Ra6^09917");

    stmt = conn.createStatement();
  
    ResultSet rs = null;
    java.util.Date now = new java.util.Date();

    strSQL = "SELECT * FROM productlist WHERE registerNumber = " + resid;
    rs = stmt.executeQuery(strSQL);

   	rs.next();
	jObject.put("imageDir", rs.getString("defaultImage"));
	jObject.put("title", rs.getString("title"));
	jObject.put("price", rs.getInt("currentPoint"));
	jObject.put("description", rs.getString("description"));
	
	java.util.Date startDate = new java.util.Date(rs.getTimestamp("registerDate").getTime());
	java.text.SimpleDateFormat transFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	java.util.Date endDate = new java.util.Date(rs.getTimestamp("endDate").getTime());
	
	jObject.put("registerDate", transFormat.format(startDate));
	jObject.put("endDate", transFormat.format(endDate));
	jObject.put("name", rs.getString("sellerID"));
	//innerObj.put("hits", rs.getInt("hits"));

    rs.close();
    
    strSQL = "SELECT buyerID FROM payRelation WHERE productNumber = " + resid + " AND status = 0";
    rs = stmt.executeQuery(strSQL);
    if (rs.next())
    	jObject.put("buyerID", rs.getString("buyerID"));
    rs.close();
}
catch(SQLException e) {
	jObject.clear();
	jObject.put("data", e.getMessage());
    e.printStackTrace();
}
catch(Exception e) {
	jObject.clear();
	jObject.put("data", e.getMessage());
    e.printStackTrace();
}
finally {
	out.print(jObject.toJSONString());
    try {
        stmt.close();
        conn.close();
    } catch(Exception ignored) {}
}
%>