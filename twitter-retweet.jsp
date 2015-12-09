<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%
	String login_id = (String)session.getAttribute("key");
	String tweet_id = request.getParameter("tweeter");
	String tweeter_first = request.getParameter("username"); //username
	
	String tweet_cont = "";
	java.sql.Connection con = null;
   String username = "pclark";
   String password = "onefishtwofish";
   String fullname = "";
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow

    con = DriverManager.getConnection(url, username, password); //mysql id &  pwd
	java.sql.Statement stmt = con.createStatement();
    
    java.sql.ResultSet rs = stmt.executeQuery("SELECT tweet FROM tweet_t WHERE tweet_id =" + tweet_id);


	while(rs.next())
	{
		tweet_cont = rs.getString(1);
	}
	
	java.sql.PreparedStatement retweet = con.prepareStatement("INSERT INTO tweet_t (login_id, tweet_date, tweet) VALUES (?, NOW(), ?)");
	retweet.setString(1, login_id);
	retweet.setString(2, "RT from @" + tweeter_first + ": " + tweet_cont);
	retweet.executeUpdate();

	String tweeter_new = "";
	
	java.sql.ResultSet getTweetID = stmt.executeQuery("SELECT MAX(tweet_id) FROM tweet_t");
	
	while(getTweetID.next())
	{
		tweeter_new = getTweetID.getString(1);
	}
	
	java.sql.ResultSet hash_locate = stmt.executeQuery("SELECT hash_id FROM hash_tweet_t WHERE tweet_id =" + tweet_id);

	String hash_id = "";

	while(hash_locate.next())
	{
		hash_id = hash_locate.getString(1);
	}
	
	java.sql.PreparedStatement hash_insert = con.prepareStatement("INSERT INTO hash_tweet_t (tweet_id, hash_id) VALUES (?, ?)");
	hash_insert.setString(1, tweeter_new);
	hash_insert.setString(2, hash_id);
	hash_insert.executeUpdate();
		
	
	String redir_url = "twitter-home.jsp";
	response.sendRedirect(redir_url);

	
%>