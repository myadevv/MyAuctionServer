<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<style>
* { font-family: "Malgun Gothic", generic-family; }
body {
    background: repeating-linear-gradient(
        45deg,
        #fdfdfd,
        #fdfdfd 10px,
        #ffffff 10px,
        #ffffff 20px
    );
}
hr { border: dotted 1; }
img { align: center; }
table { margin: 30px 5%; }
table table { margin: 10px 10px; }
tr { margin: 15px 5px; }
td.title { font-size: 22px; }
a, a:visited { color: black; text-decoration: none;  }
a:hover { color: red; }

#s { text-align:right; }
#s1 { text-align:center; }
#t { border-top : 2px solid; 
	 border-bottom : 1px solid;
	 border-collapse: collapse; 
	}
#productSet { border-bottom : 1px solid; }

#menu {	width: 100%;
		height: 30px;
		padding: 5px 0 0 0;
		list-style: none;  
		background: black;
		border: 100px;
	  }
#menu li { float: left;
		   padding: 0 0 5px 0;
		   position: relative;
		 }
#menu a { float: left;
		  height: 30px;
		  padding: 0 90px;
		  color: white;
		  text-decoration: none;
		}
#menu li a:hover { color:red; }
#menu li:hover ul { display: block; }
#menu ul { list-style: none;
		   padding: 0;    
		   display: none;
		   position: absolute;
		   top: 25px;
		   background-color: RGB( 255, 0, 0);
		   border-radius: none;
		 }
#menu ul li { display: block;
            }
#menu ul a { padding: 5px;
			 width: 1200px;
			 color: black;
		   }
#menu ul a:hover { background: green; }
</style>

<script type="text/javascript">
function remindTime(end, cnt) {
    var nt = new Date(); //현재시간을 구한다. 
  
    var et = new Date(end); // 종료시간만 가져온다.
    
    sec = parseInt(et - nt) / 1000;
    if (sec < 0) {
    	cnt.innerHTML = "(입찰 마감)";
    	return;
    }
    
    min = parseInt(sec / 60);
    sec = parseInt(sec % 60);
    
    hour = parseInt(min / 60);
    min = parseInt(min % 60);
    
    if (hour < 10) hour = "0" + hour;
    if (min < 10) min = "0" + min; 
    if (sec < 10) sec = "0" + sec;
    
    cnt.innerHTML = "(앞으로 " + hour + ":" + min + ":" + sec + ")";
}
</script>
</head>

<body>
<%
String keywordType = request.getParameter("AuctionSearchKeywordType");
String keyword = request.getParameter("AuctionSearchKeyword");
String pageNum = request.getParameter("AuctionPageNum");
String orderType = request.getParameter("AuctionOrderType");

if (pageNum == null) { // 처음 이 페이지 방문시 페이지번호 초기화 
	pageNum = "1";
}

int listSize = 10;
int currentPage = Integer.parseInt(pageNum); // 현재 열람한 페이지 번호
int startRow = (currentPage - 1) * listSize + 1; // 현재 페이지의 시작 레코드 번호
int endRow = currentPage * listSize; //  현재 페이지의 마지막 페이지 번호
int lastRow = 0; // 전체 레코드의 순번
int i = 0;

Class.forName("com.mysql.jdbc.Driver");

String url = "jdbc:mysql://localhost:3306/myAuction?serverTimezone=Asia/Seoul";
Connection conn = DriverManager.getConnection(url, "root", "Ki9^Ra6^");
Statement stmt = conn.createStatement();
String strSQL;

ResultSet rs = null;
java.util.Date now = new java.util.Date();
SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd");
if (keywordType == null || keyword == null) {
	strSQL = "SELECT count(*) FROM productList WHERE endDate > CURRENT_TIMESTAMP";
}
else {
	strSQL = "SELECT count(*) FROM productList WHERE " + keywordType + " like '%" + keyword + "%'"
	       + "AND endDate > CURRENT_TIMESTAMP";
}

rs = stmt.executeQuery(strSQL);
rs.next();
lastRow = rs.getInt(1);
rs.close();

%>
<ul id="menu">
	<li>
		<a href="#">조회 순으로 보기</a>
	</li>
	<li>
		<a>가격 순으로 보기</a>
	</li>
	<li>
		<a>등록 순으로 보기</a>
	</li>
	<li>
	    <a>경매 종료 시간 순으로 보기</a>
	</li>
</ul>
<Table width=90% id="t">
<%
if (lastRow > 0) {
	if (keywordType == null || keyword == null) {
		strSQL = "SELECT * FROM productList WHERE endDate > CURRENT_TIMESTAMP "
			   + "AND registerNumber BETWEEN " + startRow + " and " + endRow + " ORDER BY registerNumber DESC";
		rs = stmt.executeQuery(strSQL);
	}
	else {
		strSQL = "SELECT * FROM productList WHERE " + keywordType + " like '%" + keyword + "%'"
			   + " AND endDate > CURRENT_TIMESTAMP ORDER BY registerNumber DESC";
		rs = stmt.executeQuery(strSQL);
	}
	for (i = 0; i < listSize; i++) {
		if (rs.next()) {
			int num = rs.getInt("registerNumber");
			String imageDir = rs.getString("defaultImage");
			String title = rs.getString("title");
			int price = rs.getInt("currentPoint");
			java.text.SimpleDateFormat transFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date startDate = new java.util.Date(rs.getTimestamp("registerDate").getTime());
			String start = transFormat.format(startDate);
			java.util.Date endDate = new java.util.Date(rs.getTimestamp("endDate").getTime());
			String end = transFormat.format(endDate);
			String name = rs.getString("sellerName");
			int hits = rs.getInt("hits");
		%>
		<tr id="productSet">
			<td id="s1" width="200px" height="200px">
				<a href="View.jsp?num=<%=num%>">
					<img src="../ImageStorage/<%= num %>/<%= imageDir %>" width="100%" height=auto>
				</a>
			</td>
			<td><table>
				<tr><td class="title"><b><a href="View.jsp?num=<%=num%>"><%= title %></a></b></td></tr>
				<tr><td>현재 가격 : <%= Integer.toString(price) %>P</td></tr>
				<tr><td>등록 날짜 : <%= start %> | 경매 종료 날짜 : <%= end %>
				    <font color="red"><b id="count<%= num %>">(앞으로 ??:??:??)</b></font></td> 
				</tr>
		        <tr><td>등록자명 : <%= name %> | 조회수 : <%= Integer.toString(hits) %> | 등록번호 : <%= num %></td></tr>
				</table>
			</td>
		</tr>
		<script>setInterval( function() { remindTime(<%= endDate.getTime() %>, count<%= num %>); }, 1000);</script>
<%
		}
		else break;
	}
	rs.close();
	stmt.close();
	conn.close();
%>
</table>
<div style="text-align:center;">
<%
	int setPage = 1; // 검색 수만큼의 하단 페이지 번호 생성 변수
	int lastPage = 0;
	if (lastRow % listSize == 0) // 전체 레코드 수가 5로 나누어 나머지 없는 경우
		lastPage = lastRow / listSize;
	else
		lastPage = lastRow / listSize + 1; // 나머지 있는 경우
	if (currentPage > 1) { //  현 페이지가 끝 페이지이면 “이전” 메뉴 출력
	%>
		<a href="Listboard.jsp?pageNum=<%=currentPage - 1%>">[이전]</a>
	<%
	}
	while (setPage <= lastPage) { // 현재 페이지가 처음/끝 아닌 중간 경우
	%>
		<a href="Listboard.jsp?pageNum=<%=setPage%>">[<%=setPage%>]</a>
	<%
		setPage = setPage + 1;
	}
	if (lastPage > currentPage) { //  현 페이지가 끝 페이지보다 적으면 “다음” 메뉴 생성
	%>
		<a href="Listboard.jsp?pageNum=<%=currentPage + 1%>">[다음]</a>
	<%
	}
}
%>
</div>
</body>
</html>