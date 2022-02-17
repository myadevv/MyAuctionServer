<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

<script type="text/javascript">
     function Inputcheck()    {     
         if (formmem.id.value.length < 1) {     
        	 alert("회원 아이디를 채워주세요");
         	formmem.id.focus(); 
            return false; 	}

         if (formmem.pass.value.length < 1) {   
        	 alert("비밀번호를 입력해주세요");
        	formmem.pass.focus(); 
        	return false;   	}
			
		if (formmem.name.value.length < 1) {   
			alert("이름을 입력해주세요");
        	formmem.pass.focus(); 
        	return false;   	}
    
	    if (formmem.num.value.length < 1) {   
	    	alert("연락처를 입력해주세요");
        	formmem.pass.focus(); 
        	return false;   	}
			
		if (formmem.address.value.length < 1) {   
			alert("주소를 입력해주세요");
        	formmem.pass.focus(); 
        	return false;   	}
	 }
</script>
</head>
<body>
      <div style="text-align:center;">
	  <h1>Member Register</h1>
	  </div>
	  <hr width="75%" color="Black"><br>
	  <form action="RegisterPass.jsp" name="formmem" method="post" onSubmit="return Inputcheck()">
	  <table>
			<tbody>
				<tr>
                    <td style="text-align:right;"><b>회원 아이디</b></td>
         			<td><input type="text" name="id" value="" size="12"></td>
				</tr>
				<tr>
                    <td style="text-align:right;"><b>비밀번호</b></td>
                    <td><input type="password" name="pass" value="" size="12"></td>
				</tr>
				<tr>	
                    <td style="text-align:right;"><b>이름</b></td>
                    <td><input type="text" name="name" value="" size="12"></td>
				</tr>
				<tr>
                    <td style="text-align:right;"><b>연락처</b></td>
                    <td><input type="text" name="num0" value="010" size="3" maxlength="3"> - 
                        <input type="text" name="num1" size="4" maxlength="4"> - 
                        <input type="text" name="num2" size="4" maxlength="4"></td>
				</tr>
				<tr>
					<td style="text-align:right;"><b>주소</b></td>
					<td><input type="text" size="50" name="address"></td>
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