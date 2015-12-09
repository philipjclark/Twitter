<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%

	String tweet = request.getParameter("text");
	String login_id = (String)session.getAttribute("key");
	String redirectURL = "";
	String tweet_id = "";
	
	java.sql.Connection con = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow
    String username = "pclark";
    String password = "onefishtwofish";
	con = DriverManager.getConnection(url, username, password); //connect to database
			
 try {
 	tweet = tweet.replace("<", "&lt;").replace(">", "&gt;");

java.sql.Statement statement = con.createStatement();

java.sql.Statement hash_statement = con.createStatement();


if(tweet.length() > 0 && tweet.length() < 141)
{
		
	java.sql.PreparedStatement create_tweet = con.prepareStatement("INSERT INTO tweet_t (login_id, tweet_date, tweet) values (" + login_id + ",NOW(),?)");
	
	create_tweet.setString(1, tweet);
	int status = 0;
	status = create_tweet.executeUpdate();
	int counter = 0;
	String[] text = tweet.split(" "); 
	for(int i = 0; i < text.length; i ++){
		if(text[i].charAt(0) == '#'){
			
			String hash_tag = text[i].substring(1);
			String check_tag = "SELECT hash_tag from hash_t WHERE hash_tag = '" + hash_tag + "';" ;
			java.sql.Statement hStatement = con.createStatement(); 
			java.sql.ResultSet results = hStatement.executeQuery(check_tag); 
			
			while(results.next())
			{
			counter = counter +1;
			}
			
			if(counter == 0)
			{
			//	out.println("inserted"); 
				java.sql.PreparedStatement create_hash = con.prepareStatement("INSERT INTO hash_t (hash_tag) values (?)");
				create_hash.setString(1, hash_tag);
				status = create_hash.executeUpdate();
			}
			
			String hashid_query = "SELECT hash_id FROM hash_t WHERE hash_tag ='" + hash_tag + "';";
			java.sql.Statement hashid_statement = con.createStatement();
			java.sql.ResultSet result_set = hashid_statement.executeQuery(hashid_query); 
			int tag_num = 0; 
			while(result_set.next()){
				tag_num = Integer.parseInt(result_set.getString(1)); 
			}
			
			String tweetid_query = "SELECT MAX(tweet_id) FROM tweet_t";
			java.sql.Statement tweetid_statement = con.createStatement();
			java.sql.ResultSet tweet_result = tweetid_statement.executeQuery(tweetid_query); 
			int tweet_hash_num = 0;
			while(tweet_result.next())
			{
			tweet_hash_num = Integer.parseInt(tweet_result.getString(1)); 
			}
						
			 java.sql.PreparedStatement insert_rel = con.prepareStatement("INSERT INTO hash_tweet_t (hash_id, tweet_id) VALUES (?, ?)"); 
			 insert_rel.setString(1, Integer.toString(tag_num)); 
			 insert_rel.setString(2, Integer.toString(tweet_hash_num)); 
			 status = insert_rel.executeUpdate(); 
		}
	}
	
	
		redirectURL = "twitter-home.jsp"; 
		response.sendRedirect(redirectURL);
		
}
else
	{
	redirectURL = "twitter-home.jsp?msg=tweet-fail"; 
		response.sendRedirect(redirectURL);
	}
		
}
		
		catch (Exception e) {
         out.println(e);
      }



%>