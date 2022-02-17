<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
body { background: lightgreen; }
table {
	margin: auto;
	border-collapse: separate;
	border-spacing: 10px 0;
}
</style>
<script type="text/javascript">
	function Check() {
		if (Form.keyword.value.length < 1) {
			alert("검색어를 입력하세요.");
			Form.keyword.focus();
			return false;
		}
	}
</script>
</head>
<body>
<table><tr>
	<td align="left"><h2><b>Re-Auc!</b></h2></td>
	<td align="center">
		<form Name="Form" action="Product/Listboard.jsp" method="post" target="rightFrame" OnSubmit="return Check()">
		<table><tr>
			<td><input type="text" name="keyword" placeholder="검색하기..." style="width:400px; height:30px; font-size:25px;"></td>
			<td><input type="submit" value="검색" style="width:100px; height:40px; font-size:25px"></td>
		</tr></table>
		</form>
	</td>
</tr></table>
</body>
</html>