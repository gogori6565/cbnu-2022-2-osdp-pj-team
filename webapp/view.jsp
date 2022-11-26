<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="reply.Reply" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale"="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>충북대 소프트웨어학과 과목별 게시판</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		
		int bbsID = 0;
		if(request.getParameter("bbsID")!=null){ //매개변수로 넘어온 bbsID가 존재한다면
			bbsID = Integer.parseInt(request.getParameter("bbsID")); //현재 파일 변수 bbsID에 bbsID 넣어주기
		}
		if(bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'"); 
			script.println("</script>");
		}
		//코드 4줄의 import bbs.Bbs 덕에 쓸 수 있는 
		Bbs bbs = new BbsDAO().getBbs(bbsID); //유효한 글이라면 Bbs라는 인스턴스 안에 내용 담기
	%>
  <nav class="navbar navbar-default">
  	<div class="navbar-header">
  		<button type="button" class="navbar-toggle collapsed"
  			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
  			aria-expanded="false">
  			<span class="icon-bar"></span>
  			<span class="icon-bar"></span>
  			<span class="icon-bar"></span>
  		</button>
  		<a class="navbar-brand" href="main.jsp">충북대 소프트웨어학과 과목별 게시판</a>
  	</div>
  	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  		<ul class="nav navbar-nav">
  			<li><a href="main.jsp">메인</a></li>
  			<li class="active"><a href="bbs.jsp">게시판</a></li>
  		</ul>
  		<%
  			if(userID == null){ //로그인이 되어있지 않다면
  		%>
  		<ul class="nav navbar-nav navbar-right">
  			<li class="dropdown">
  				<a href="#" class="dropdown-toggle"
  					data-toggle="dropdown" role="button" aria-haspopup="true"
  					aria-expanded="false">접속하기<span class="caret"></span></a>
  				<ul class="dropdown-menu">
  					<li><a href="login.jsp">로그인</a></li>
  					<li><a href="join.jsp">회원가입</a></li>
  				</ul>
  			</li>
  		</ul>
  		<%
  			} else{ //로그인이 되어있다면
		%>
		<ul class="nav navbar-nav navbar-right">
  			<li class="dropdown">
  				<a href="#" class="dropdown-toggle"
  					data-toggle="dropdown" role="button" aria-haspopup="true"
  					aria-expanded="false">회원관리<span class="caret"></span></a>
  				<ul class="dropdown-menu">
  					<li><a href="logoutAction.jsp">로그아웃</a></li>
  				</ul>
  			</li>
  		</ul>
  		<%		
  			}
  		%>
  	</div>
  </nav>
  <div class="container">
  	<div class="row">
  		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
  			<thead>
  				<tr>
  					<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 보기 양식</th>
  				</tr>
  			</thead>
  			<tbody>
  				<tr>
  					<td style="width: 20%;">글 제목</td>
  					<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
  				</tr>
  				<tr>
  					<td>작성자</td>
  					<td colspan="2"><%= bbs.getUserID() %></td>
  				</tr>
  				<tr>
  					<td>작성일자</td>
  					<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시 " + bbs.getBbsDate().substring(14, 16) + "분" %></td>
  				</tr>
  				<tr>
  					<td>내용</td>
  					<td colspan="2" style="height: 300px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
  				</tr>
  			</tbody>
  		</table>
  		<a href="bbs.jsp" class="btn btn-primary">목록</a>
  		<%
  		 	if(userID != null && userID.equals(bbs.getUserID())){ //글 사용자가 해당 글의 작성자와 동일하다면
  			
  		 		//update.jsp에 해당글의 ID를 가져갈 수 있게 함 (아래 코드 설명)
  		%>
  				<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
  				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
  		<% 
  		 }
  		%>
  		<div style="height:30px;"></div>
  		<div class="container">
            <div class="row">
               <form method="post" action="submitAction.jsp?bbsID=<%=bbsID%>">
                  <table class="table table-bordered"
                     style="text-align: center; border: 1px solid #dddddd">
                     <tbody>
                        <tr>
                           <td align="left"  bgcolor="LightSteelBlue"><%=userID%></td>
                        </tr>
                        <tr>
                           <td><input style="display: inline-block; width: 90%;" type="text" class="form-control"
                              placeholder="댓글 쓰기" name="replyContent" maxlength="300">
                              <input style="display: inline-block" type="submit" class="btn btn-success pull-right" value="댓글 쓰기">
                           </td>
                              
                        </tr>
                     </tbody>
                  </table>
               </form>
            </div>
         </div>
  		<div class="container">
            <div class="row">
               <table class="table table-striped"
                  style="text-align: center; border: 1px solid #dddddd">
                  <tbody>

                     <tr>
                        <%
                           ReplyDAO replyDAO = new ReplyDAO();
                           ArrayList<Reply> list = replyDAO.getList(bbsID);
                           for (int i = 0; i < list.size(); i++) {
                        %>
                        <div class="container">
                           <div class="row">
                              <table class="table table-striped"
                                 style="text-align: center; border: 1px solid #dddddd">
                                 <tbody>
                                    <tr>
                                       <td align="left" style="width:100%;"><%=list.get(i).getUserID()%></td>   
                                    </tr>
                                    <tr>
                                       <td align="left"><%=list.get(i).getReplyContent()%></td>
                                       <td align="right"><a
                                          onclick="return confirm('정말로 삭제하시겠습니까?')"
                                          href="replyDeleteAction.jsp?bbsID=<%=bbsID%>&replyID=<%=list.get(i).getReplyID()%>"
                                          class="btn btn-danger">삭제</a></td>
                                    </tr>
                                 </tbody>
                              </table>
                           </div>
                        </div>
                        <%
                           }
                        %>
                     </tr>
               </table>
            </div>
         </div>
         <br>
      </div>
   </div>
  	</div>
  </div> 
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  <script src="js/bootstrap.js"></script>
</body>
</html>