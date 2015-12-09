<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%


	String login_id = request.getParameter("login_id");
	String tweet_id = request.getParameter("tweeter");

		java.sql.Connection con = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
   	 String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow
        String username = "pclark";
        String password = "onefishtwofish";
        
        con = DriverManager.getConnection(url, username, password);      //connect to database

 try {
 	int status = 0;

     java.sql.PreparedStatement hash_del = con.prepareStatement("DELETE FROM hash_tweet_t WHERE tweet_id = ?"); 
    hash_del.setString (1, tweet_id);
    status = hash_del.executeUpdate();
	java.sql.PreparedStatement delete_tweet = con.prepareStatement("DELETE from tweet_t WHERE tweet_id = ?");
	delete_tweet.setString(1, tweet_id);
	status = delete_tweet.executeUpdate();
	//out.println(login_id); 
	//out.println(tweet_id); 


	String redirurl = "twitter-home.jsp?login_id=" + login_id; 
	response.sendRedirect(redirurl);
	
	}
		
		catch (Exception e) {
         out.println(e);
      }
	
%>