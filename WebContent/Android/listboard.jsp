<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" import="java.util.*, org.json.simple.*, java.text.SimpleDateFormat" %>

<%
Connection conn = null;
Statement stmt = null;

String strSQL = null;
String keyword = null;
JSONObject jObject = new JSONObject(); // 객체를 담을 JSON 오브젝트 생성
JSONArray jArray = new JSONArray(); // 객체 리스트를 담을 JSON 배열 생성

String pageNum = "1";
if (pageNum == null)
	pageNum = "1";
int listSize = 10;
int currentPage = Integer.parseInt(pageNum); // 현재 열람한 페이지 번호
int startRow = (currentPage - 1) * listSize + 1; // 현재 페이지의 시작 레코드 번호
int endRow = currentPage * listSize; //  현재 페이지의 마지막 페이지 번호
int lastRow = 0; // 전체 레코드의 순번
int i = 0;

try {
    Class.forName("com.mysql.jdbc.Driver");
    
    //String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";
	//conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");
    
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/myadevv?serverTimezone=Asia/Seoul", "myadevv", "Ki9^Ra6^09917");

    stmt = conn.createStatement();
  
    ResultSet rs = null;
    java.util.Date now = new java.util.Date();
    SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd");
    if (keyword == null) {
  	    //strSQL = "SELECT count(*) FROM productlist WHERE endDate > CURRENT_TIMESTAMP";
    	strSQL = "SELECT count(*) FROM productlist WHERE endDate > CURRENT_TIMESTAMP";
    }
    else {
  	    strSQL = "SELECT count(*) FROM productlist WHERE title LIKE '%" + keyword + "%'"
  	       + "AND endDate > CURRENT_TIMESTAMP";
    }
    
    rs = stmt.executeQuery(strSQL);
    rs.next();
    lastRow = rs.getInt(1);
    rs.close();
    
    if (lastRow > 0) {
    	if (keyword == null) {
    		strSQL = "SELECT * FROM productlist WHERE endDate > CURRENT_TIMESTAMP AND "
    			   + "registerNumber BETWEEN " + startRow + " AND " + endRow + " ORDER BY registerNumber ASC";
    		rs = stmt.executeQuery(strSQL);
    	}
    	else {
    		strSQL = "SELECT * FROM productlist WHERE title LIKE '%" + keyword + "%'"
    			   + " AND endDate > CURRENT_TIMESTAMP ORDER BY registerNumber ASC";
    		rs = stmt.executeQuery(strSQL);
    	}
    	
    	for (i = 0; i < listSize; i++) {
    		if (rs.next()) {
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
    			
    			jArray.add(0, innerObj);
    		}
    	}
    	jObject.put("data", jArray);
        rs.close();
    }
    else {
    	jObject.put("data", "No data");
    }
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