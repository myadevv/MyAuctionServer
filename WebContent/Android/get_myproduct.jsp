<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" import="java.util.*, org.json.simple.*, org.json.simple.parser.JSONParser, java.text.SimpleDateFormat, myPackage.postJson" %>
<%
request.setCharacterEncoding("UTF-8");

Connection conn = null;
Statement stmt = null;

String strSQL = null;
JSONObject jObject = new JSONObject(); // 객체를 담을 JSON 오브젝트 생성
JSONArray jArray = new JSONArray(); // 객체 리스트를 담을 JSON 배열 생성

int i = 0;

try {
	String strData = postJson.getrequestBody(request);
	JSONParser parser = new JSONParser();
	JSONObject data = (JSONObject)parser.parse(strData);
	
	String id = (String)data.get("id");
	
    Class.forName("com.mysql.jdbc.Driver");
    
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/myadevv?serverTimezone=Asia/Seoul", "myadevv", "Ki9^Ra6^09917");

    stmt = conn.createStatement();
  
    ResultSet rs = null;
    java.util.Date now = new java.util.Date();
    SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd");

    strSQL = "SELECT * FROM productlist WHERE sellerID = \"" + id + "\" ORDER BY registerNumber ASC";
    rs = stmt.executeQuery(strSQL);
    	
    while (rs.next()) {
    	int productNum = rs.getInt("registerNumber");
    	
		JSONObject innerObj = new JSONObject();
		innerObj.put("registerNo", rs.getInt("registerNumber"));
		innerObj.put("imageDir", rs.getString("defaultImage"));
		innerObj.put("title", rs.getString("title"));
		innerObj.put("price", rs.getInt("currentPoint"));
		innerObj.put("description", rs.getString("description"));
		//innerObj.put("registerDate", rs.getTimestamp("registerDate").getTime());
		//innerObj.put("endDate", rs.getTimestamp("endDate").getTime());
		
		java.util.Date startDate = new java.util.Date(rs.getTimestamp("registerDate").getTime());
		java.text.SimpleDateFormat transFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date endDate = new java.util.Date(rs.getTimestamp("endDate").getTime());
		
		innerObj.put("registerDate", transFormat.format(startDate));
		innerObj.put("endDate", transFormat.format(endDate));
		innerObj.put("name", rs.getString("sellerID"));
		innerObj.put("hits", rs.getInt("hits"));
		
    	strSQL = "SELECT count(*) FROM payRelation WHERE productNumber = " + productNum;
	    Statement nstmt = conn.createStatement();
		ResultSet nrs = nstmt.executeQuery(strSQL);
		nrs.next();
		if (nrs.getInt(1) > 0)
			innerObj.put("payedStatus", "True");
		else
			innerObj.put("payedStatus", "False");
		
		jArray.add(0, innerObj);
    }
    if (!jArray.isEmpty())
    	jObject.put("data", jArray);
    else
    	jObject.put("data", "No data");
    
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