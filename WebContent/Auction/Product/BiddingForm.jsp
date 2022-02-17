<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bidding</title>

<script type="text/javascript">
function Inputcheck() {
	if (formmem.payPoints.value.length < 1) { 
      	alert("입찰가를 입력해주세요.");
    	formmem.payPoints.focus();
    	return false;
    }
	if (isNaN(formmem.payPoints.value)) {
		alert("입찰가를 숫자로 입력해주세요.");
		formmem.payPoints.focus();
		return false;
	}
	if (parseInt(formmem.payPoints.value) <= parseInt(<%=request.getParameter("p")%>)) { 
      	alert("입찰가보다 낮거나 같은 가격으로 입찰할 수 없습니다.");
    	formmem.payPoints.focus();
    	return false;
    }
	
	curPoints = <%=session.getAttribute("AuctionPoints")%>;
	totalPoints = parseInt(curPoints) - parseInt(formmem.payPoints.value);
	
	if (totalPoints < 0) {
		alert("보유 포인트보다 높은 가격으로 입찰할 수 없습니다.");
		formmem.payPoints.focus();
		return false;
	}
}
</script>

</head>
<body>
<div style="text-align:center;">
<h1>Bidding</h1>
<%
String id = (String) session.getAttribute("AuctionID");
Integer points = (Integer) session.getAttribute("AuctionPoints");
String num = request.getParameter("num");
String price = request.getParameter("p");

if (id != null && points != null) {
%>
	현재 물품 입찰가 : <%= price %>P <br>
	현재 보유 포인트 : <%= Integer.toString(points) %>P
	<br><br>
<%
	int pr = Integer.parseInt(price);
	if (pr > points) {
%>
		<font color="red"><b>입찰가보다 보유 포인트가 낮아 입찰할 수 없습니다.</b></font>
<% } else { %> 
		<form action="BiddingPass.jsp?num=<%=num%>"
		 method="post" name="formmem" onSubmit="return Inputcheck()">
		입찰 가격 : <input type="text" name="payPoints"><br>
		<input type="submit" value="입찰하기">
		</form>
<% }
} else { %>
	<script>
	alert("먼저 로그인 해 주세요.")
	location.href = "../Product/Listboard.jsp";
	</script>
<% } %>
</div>
</body>
</html>