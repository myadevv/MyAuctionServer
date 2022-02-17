<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, org.json.simple.*, org.json.simple.parser.JSONParser, myPackage.postJson"%>
<%
request.setCharacterEncoding("UTF-8");

JSONObject userdata = new JSONObject();

try {
	String strData = postJson.getrequestBody(request);
	JSONParser parser = new JSONParser();
	JSONObject data = (JSONObject)parser.parse(strData);
	
	String id = (String)data.get("id");
	String pw = (String)data.get("pw");
	
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/myadevv?serverTimezone=Asia/Seoul";
	Connection conn = DriverManager.getConnection(url, "myadevv", "Ki9^Ra6^09917");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String strSQL = "SELECT id, password, point FROM simplememberlist WHERE id = ? AND password = SHA2(?, 256)";

	pstmt = conn.prepareStatement(strSQL);
	pstmt.setString(1, id);
	pstmt.setString(2, pw);
	rs = pstmt.executeQuery();
	if (rs.next()) {
		pstmt.close();
		
		strSQL = "SELECT count(*) FROM productlist WHERE CURRENT_TIMESTAMP > endDate AND status < 2 AND sellerID = ?";
		pstmt = conn.prepareStatement(strSQL);
		pstmt.setString(1, id);
		ResultSet nrs = pstmt.executeQuery();
		nrs.next();
		if (nrs.getInt(1) > 0) {
			strSQL = "UPDATE simplememberlist SET point = point + ("
				+ "SELECT ifnull(sum(currentPoint), 0) FROM productlist "
				+ "WHERE CURRENT_TIMESTAMP > endDate AND status = 1 AND sellerID = ?)"
				+ " WHERE id = ?";
			pstmt = conn.prepareStatement(strSQL);
			pstmt.setString(1, id);
			pstmt.setString(2, id);
			pstmt.executeUpdate();
			pstmt.close();
			
			strSQL = "UPDATE productlist SET status = 2 "
					+ "WHERE CURRENT_TIMESTAMP > endDate AND status < 2 AND sellerID = ?";
			pstmt = conn.prepareStatement(strSQL);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			pstmt.close();
			
			userdata.put("update", "OK");
		}
		else
			userdata.put("update", "No");
		nrs.close();
		
		strSQL = "SELECT point FROM simplememberlist WHERE id = ?";
		pstmt = conn.prepareStatement(strSQL);
		pstmt.setString(1, id);
		nrs = pstmt.executeQuery();
		nrs.next();
		
		userdata.put("result", "OK");
		//userdata.put("username", rs.getString);    별명 추가시 사용할 것
		userdata.put("point", nrs.getInt("point"));
		nrs.close();
	}
	else {
		userdata.put("result", "Fail");
	}

	rs.close();
	pstmt.close();
	conn.close();
}
catch(SQLException e) {
	e.printStackTrace();
	if (!userdata.isEmpty())
		userdata.clear();
	userdata.put("result", e.getMessage());
}
catch(Exception e) {
	e.printStackTrace();
	if (!userdata.isEmpty())
		userdata.clear();
	userdata.put("result", e.getMessage());
}
finally {
	out.print(userdata.toJSONString());
}
%>