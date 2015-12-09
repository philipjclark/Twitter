<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%
	String login_id = (String)session.getAttribute("key");
	String following_id = request.getParameter("check_id");
		
	String tweet_cont = "";
	java.sql.Connection con = null;
   String username = "pclark";
   String password = "onefishtwofish";
   String fullname = "";
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow

	int status = 0;
	try {
    con = DriverManager.getConnection(url, username, password); //mysql id &  pwd
	java.sql.Statement stmt = con.createStatement();
    
    java.sql.PreparedStatement follow = con.prepareStatement("INSERT INTO following_t VALUES (?, ?)");

	follow.setString(1, login_id);
	follow.setString(2, following_id);
	status = follow.executeUpdate();
	
	if(status > 0)
	{
	String redir_url = "twitter-home.jsp";
	response.sendRedirect(redir_url);
	}
	
	}
	
	catch (Exception e) {
         out.println(e);
      }
	
%>