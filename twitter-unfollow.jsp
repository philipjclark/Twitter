<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%
	String login_id = (String)session.getAttribute("key");
	String following_id = request.getParameter("check_id");
		
	java.sql.Connection con = null;
   String username = "pclark";
   String password = "onefishtwofish";
   String fullname = "";
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow
    con = DriverManager.getConnection(url, username, password); //mysql id &  pwd

	try {
	int status = 0;

    java.sql.PreparedStatement unfollow = con.prepareStatement("DELETE FROM following_t WHERE following_id = ? && follower_id = ?"); 
      unfollow.setString (1, following_id);
	  unfollow.setString (2, login_id);
    status = unfollow.executeUpdate();
	
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