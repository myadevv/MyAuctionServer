<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송장 번호 입력</title>
<script type="text/javascript">
function Check() {
	if (Form.postNum.value.length < 1) {
		alert("송장 번호를 입력하세요.");
		Form.chargePoints.focus();
		return false;
	}
}
</script>
</head>
<body>
<div style="text-align:center;">
<h1>송장 번호 입력</h1>
<form action="PostPass.jsp?num=<%=request.getParameter("num")%>" name="Form" method="post" OnSubmit="return Check()">
송장 번호를 입력하세요 : <input type="text" size="10" maxlength="10" name="postNum"><br><br>
<input type="submit" value="입력 완료">
</form>
</div>
</body>
</html>