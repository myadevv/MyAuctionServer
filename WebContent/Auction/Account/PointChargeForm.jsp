<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Point Charge</title>

<script type="text/javascript">
function Check() {
	if (Form.chargePoints.value.length < 1) {
		alert("충전할 포인트를 입력하세요.");
		Form.chargePoints.focus();
		return false;
	}
}
</script>

</head>
<body>
<div style="text-align:center;">
<h1>Charge Point</h1>
<%
String id = (String) session.getAttribute("AuctionID");
Integer points = (Integer) session.getAttribute("AuctionPoints");

if (id != null && points != null) {
%>
	현재 보유 포인트 : <%= Integer.toString(points) %>P
	<br><br>
	<form action="PointChargePass.jsp" name="Form" method="post" OnSubmit="return Check()">
	충전할 포인트 : <input type="text" size="7" maxlength="7" name="chargePoints"> P
	<br><br>
	<input type="submit" value="충전하기">
	</form>
<% }
else { %>
	<script>
	alert("먼저 로그인 해 주세요.")
	location.href = "../Product/Listboard.jsp";
	</script>
<% } %>
</div>
</body>
</html>