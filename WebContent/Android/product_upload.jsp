<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy,
                 java.util.*, java.io.*, myPackage.postJson, java.sql.*"%>
<%
request.setCharacterEncoding("UTF-8");

try {
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/myadevv?serverTimezone=Asia/Seoul";
	Connection conn = DriverManager.getConnection(url,"myadevv","Ki9^Ra6^09917"); 
	Statement stmt = conn.createStatement();
	
	String strSQL = "SELECT Max(registerNumber) AS rNum FROM productlist";
	
	ResultSet rs = stmt.executeQuery(strSQL); 
	rs.next();
	int num = rs.getInt("rNum") + 1;
	rs.close();

	//String saveFolder = "C:/Users/JGH/Desktop/학교/jspapp/MyAuction/WebContent/Android/Image/" + Integer.toString(num);
	String saveFolder = request.getServletContext().getRealPath("/Android/Image/" + Integer.toString(num));
	
	File Folder = new File(saveFolder);
	if (!Folder.exists()) {
		try {
			if (!Folder.mkdir())
				throw new IOException("Can't make directory");
		}
		catch(Exception e) {
			e.getStackTrace();
		}
	}
	
	String encType = "utf-8";
	int sizeLimit = 10 * 1024 * 1024;
	MultipartRequest multi = new MultipartRequest(request, saveFolder, sizeLimit, encType, new DefaultFileRenamePolicy());

	String imgFile = multi.getFilesystemName("img");
	String title = multi.getParameter("title");
	String contents = multi.getParameter("description");
	String price = multi.getParameter("price");
	String endDate = multi.getParameter("endDate"); // yyyy-mm-dd hh:mm(:ss)
	String name = multi.getParameter("name");
	
	PreparedStatement pstmt = null;
	strSQL = "insert into productlist(title, description, defaultImage, currentPoint, endDate, sellerID)"
		      + "values(?, ?, ?, ?, ?, ?)";
	
	pstmt = conn.prepareStatement(strSQL);
	pstmt.setString(1, title);
	pstmt.setString(2, contents);
	pstmt.setString(3, imgFile);
	pstmt.setInt(4, Integer.parseInt(price));
	pstmt.setString(5, endDate);
	pstmt.setString(6, name);
	pstmt.executeUpdate();
	pstmt.close();
	
	out.print("OK");
}
catch(SQLException e) {
	out.print(e.getMessage());
	e.printStackTrace();
}
catch(EOFException e) {
	out.print(e.getMessage());
	e.printStackTrace();
}
catch(IOException e) {
	out.print(e.getMessage());
	e.printStackTrace();
}
%>