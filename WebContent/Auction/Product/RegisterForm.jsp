<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Register</title>
<style>
table {
	margin: auto;
	border-collapse: separate;
	border-spacing: 20px;
}
</style>


<SCRIPT language="JavaScript">
function Inputcheck() {     
   	if (formmem.title.value.length < 1) {     
       	alert("상품명을 입력해주세요");
      	formmem.title.focus(); 
        return false;
    }
    if (formmem.inst.value.length < 1) {   
       	alert("상품 상세 설명을 입력해주세요");
       	formmem.inst.focus(); 
      	return false;
    }
	if (formmem.price.value.length < 1 || isNaN(formmem.price.value) ) {   
      	alert("최소 입찰가를 입력해주세요");
       	formmem.price.focus();
       	return false;
    }
}
</SCRIPT>
</HEAD>

<body>
<div style="text-align:center;"><h1>Product Register</h1></div>
<hr height="4px" color="Black">
<form action="RegisterPass.jsp" name="formmem" method="post" OnSubmit="return Inputcheck()" Enctype="multipart/form-data">
<table>
			<tbody>
				<tr>
                    <td style="text-align:right;"><b>상품명</b></td>
         			<td><input type="text" name="title" value="" size="55"></td>
				</tr>
				<tr>
                    <td style="text-align:right;"><b>상품 상세 설명</b></td>
                    <td><textarea name="inst" cols="55" rows="5"></textarea></td>
				</tr>
				<tr>
                    <td style="text-align:right;"><b>이미지 파일</b></td>
                    <td><input type="file" name="img" value="" size="12"></td>
				</tr>
				<tr>
                    <td style="text-align:right;"><b>최소 입찰가</b></td>
                    <td><input type="text" name="price" value="" size="12"> P</td>
				</tr>
				<tr>
					<%
					java.util.Date now = new Date();
					//now.setDate(now.getDate() + 1);
					SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd");
					String nt = form.format(now);
					%>
					<td style="text-align:right;"><b>입찰 종료 날짜</b></td>
					<td><input type="date" size="25" name="date" min="<%=nt%>" value="<%=nt%>">&nbsp;&nbsp;&nbsp;
					    <input type="time" size="25" name="time" value="12:00"></td>
				</tr>
                <tr>
					<td style="text-align:right;"><b>거래 방법</b></td>
					<td><input type="radio" size="50" name="box" value="1">&nbsp;직접 거래&nbsp;&nbsp;&nbsp;<input type="radio" size="50" name="box" value="2">&nbsp;택배 거래</td>
				</tr>
			</tbody>
			<tfoot>
				<tr style="text-align: center;">
            		<td colspan="2"><br>
                      <input type="submit" value="등록">
				</tr>
			</tfoot>

</table>
</form>
</body>
</html>