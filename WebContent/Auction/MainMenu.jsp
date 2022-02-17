<%@ page contentType="text/html; charset=utf-8"%>
<head>
<style>
body { background: aliceblue; }
div { margin : 15px; }
a, a:visited { color: black; text-decoration: none;  }
a:hover { color: red; }
</style>
</head>
<body>
<div style="text-align:right;">
	<h1>Menu</h1>
	<%
	String id = (String) session.getAttribute("AuctionID");
	if (id != null) {
		String name = (String) session.getAttribute("AuctionName");
		int points = (int) session.getAttribute("AuctionPoints");
		out.println("<B>" + name + " 님"); %> <br>
	<%	out.println("(" + id + ")"); %> <P>
	<%  out.println("보유 포인트 : " + Integer.toString(points) + "P</B>"); %> <P>
	<A href="Account/Logout.jsp" target="rightFrame">로그아웃</A><P>
	<A target="rightFrame">개인 정보 관리</A><P>
	<A href="Account/PointChargeForm.jsp" target="rightFrame">포인트 충전</A><P>
	<A href="Product/RegisterForm.jsp" target="rightFrame">물품 등록</A><P>
	<A href="Account/Paylist.jsp" target="rightFrame">내 거래 내역 보기</A><P>
	<% } else { %>
	<A href="Account/LoginForm.jsp" target="rightFrame">로그인</A><P>
	<A href="Account/RegisterForm.jsp" target="rightFrame">회원 가입</A><P>
	<% } %>
	<A href="Product/Listboard.jsp" target="rightFrame">메인 화면으로</A><P>
</div>
</body>