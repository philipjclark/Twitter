<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<!doctype html>
<html lang="en">
<head>

<%
	String msg = request.getParameter("msg");
	try{
		if(!msg.equals("fail")){
	 	%>
	 		<script>
	 			window.alert("Tweet contains greater than 140 characters: please try again");
	 		</script>
	 	<%
		}
	}
	catch(Exception e){
		//out.println(e); 
	}
%>

<% 

 //  String login_id = request.getParameter("login_id");
	String login_id = (String)session.getAttribute("key");
      
   int totaltweets = 0;
   int followers = 0;
   int following = 0;
   int finalnumtweets = 0;
   
   if(login_id == null)
   {
   response.sendRedirect("twitter-signin.jsp");
   }

   java.sql.Connection con = null;
   String username = "pclark";
   String password = "onefishtwofish";
   String fullname = "";
   int total_users = 0;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow

    con = DriverManager.getConnection(url, username, password); //mysql id &  pwd
	java.sql.Statement stmt = con.createStatement();

   	String getusername = "SELECT username FROM login_t WHERE login_id =" + login_id;
	String tweetnum_q = "SELECT COUNT(a.tweet) AS 'Tweets' FROM tweet_t a, login_t b WHERE a.login_id = b.login_id AND b.login_id =" + session.getAttribute("key");
	String follower_q = "SELECT COUNT(*)-1 AS 'Followers' FROM following_t a, login_t b WHERE a.following_id = b.login_id AND b.login_id =" + session.getAttribute("key");
	String following_q = "SELECT COUNT(*)-1 AS 'Following' FROM following_t a, login_t b WHERE a.follower_id = b.login_id AND b.login_id =" + session.getAttribute("key");
	String tweetlisting_q = "SELECT a.tweet, a.login_id, a.tweet_date,a.tweet_id, c.fullname, c.username FROM tweet_t a, following_t b, login_t c WHERE a.login_id = b.following_id AND b.follower_id = c.login_id AND c.login_id =" + session.getAttribute("key") + " ORDER BY a.tweet_date DESC;";
	String getfullname_q = "SELECT fullname FROM login_t WHERE login_id =" + session.getAttribute("key");
	String user_count = "SELECT COUNT(*) FROM login_t";
	java.sql.ResultSet usercount_rs = stmt.executeQuery(user_count);  
   while(usercount_rs.next())
   {
	total_users = usercount_rs.getInt(1);
   }  

	java.sql.ResultSet fullname_rs = stmt.executeQuery(getfullname_q);  
   while(fullname_rs.next())
   {
	fullname = fullname_rs.getString(1);
   }  
	
	 java.sql.ResultSet username_rs = stmt.executeQuery(getusername);  
   while(username_rs.next())
   {
	username = username_rs.getString(1);
   }  
   
java.sql.ResultSet tweetnum_rs = stmt.executeQuery(tweetnum_q);
   while(tweetnum_rs.next())
   {
   	finalnumtweets = tweetnum_rs.getInt(1);
   }
   
   java.sql.ResultSet follower_rs = stmt.executeQuery(follower_q);
   while(follower_rs.next())
   {
   	followers = follower_rs.getInt(1);
   }
   
   java.sql.ResultSet following_rs = stmt.executeQuery(following_q);
   while(following_rs.next())
   {
   	following = following_rs.getInt(1);
   }
   
   HashMap<String, String> fullnames = new HashMap<String, String>();
HashMap<String, String> usernames = new HashMap<String, String>();
  
  String tweet_info_q = "SELECT login_id, login_t.fullname, login_t.username from login_t;";
  java.sql.ResultSet info_rs = stmt.executeQuery(tweet_info_q);
   while(info_rs.next())
   {
         fullnames.put(info_rs.getString(1), info_rs.getString(2));
    	 usernames.put(info_rs.getString(1), info_rs.getString(3));
   }
     
 //  String tweet_info_q = "SELECT login_t.fullname, login_t.username from login_t
   

   java.sql.ResultSet gettweet_rs = stmt.executeQuery(tweetlisting_q);
   

	%>
	
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <meta name="description" content="">
    <meta name="author" content="">
    <style type="text/css">
    	body {
    		padding-top: 60px;
    		padding-bottom: 40px;
    	}
    	.sidebar-nav {
    		padding: 9px 0;
    	}
    </style>    
    <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
</head>
<body class="user-style-theme1">
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
                <i class="nav-home"></i> <a href="#" class="brand">!Twitter</a>
				<div class="nav-collapse collapse">
					<p class="navbar-text pull-right">Logged in as <a href="#" class="navbar-link"><%=fullname%></a>
					</p>
					<ul class="nav">
						<li><a href="twitter-usersdisplay.jsp">See Who's On Twitter</a></li>

					</ul>
					<ul class="nav">
						<li><a href="twitter-signin.jsp">Logout</a></li>

					</ul>
					
				</div><!--/ .nav-collapse -->
			</div>
		</div>
	</div>

    <div class="container wrap">
        <div class="row">

               <!-- left column -->
            <div class="span4" id="secondary">
                <div class="module mini-profile">
                    <div class="content">
                    
                        <div class="account-group">
                            <a href="#">
                                <img class="avatar size32" src="images/pirate_normal.jpg" alt="Gordy">
                                <b class="fullname"><strong><%=fullname%></strong></b>
                               <small class="metadata">View my profile page</small>
                            </a>
                        </div>
                    </div>
                    <div class="js-mini-profile-stats-container">
                        <ul class="stats">
                            <li><a href="twitter-display_tweets.jsp"><strong><%=finalnumtweets%></strong>Tweets</a></li>
                            <li><a href="twitter-following.jsp"><strong><%=following%></strong>Following</a></li>
                            <li><a href="twitter-followers.jsp"><strong><%=followers%></strong>Followers</a></li>
                         </ul>
                    </div>
                    <form class="navbar-form navbar-left" action="insert-tweet.jsp" method="get">
        					<div class="form-group">
								<textarea class="tweet-box" name="text" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile"></textarea>
        					</div>
							<input type="submit" class="btn btn-small btn-primary" maxlength="140" value="tweet">
							<input type="hidden" class="tweet-box" name="login_id" maxlength="140" value="<%=login_id%>" id="tweet-box-mini-home-profile">
      				</form>
                </div>
               </ul>
               
            </div>

            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title">Tweets</h2>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            4 new Tweets
                        </div>
                    </div>

                    <!-- all tweets -->
                    <div class="stream home-stream">
                    
                    <%
                    	String tweet_cont = "";
                    	String tweeter = "";
                    	String tweeter_fullname = "";

                    	while (gettweet_rs.next())
                    	{
                    String tweeter_username = usernames.get(gettweet_rs.getString(2));

                    String tweet_date = gettweet_rs.getString(3);
                    
			/*	String tweeter_info = "SELECT login_t.fullname, login_t.username FROM login_t WHERE login_id = " + gettweet_rs.getString(4);
                java.sql.ResultSet info_rs = stmt.executeQuery(tweeter_info);  

				while (info_rs.next()){
					tweeter_fullname = info_rs.getString(1);
					tweeter_username = info_rs.getString(2);
					}*/
 				  
					%>
                        <!-- start tweet -->
      				
      				
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <small class="time">
                                            <a href="#" class="tweet-timestamp" title="10:15am - 16 Nov 12">
                                                <span class="_timestamp"><%=tweet_date%></span>
                                            </a>
                                            <% if(gettweet_rs.getString(2).equalsIgnoreCase(login_id)) {%>
											<a href="twitter-delete.jsp?login_id=<%=gettweet_rs.getString(2)%>&tweeter=<%=gettweet_rs.getString(4)%>" class="btn btn-small" role="button"><font color="black">Delete</font> </a>
											<% } %> 
                                         </a>
                                            <% if(!gettweet_rs.getString(2).equalsIgnoreCase(login_id)) {%>
											<a href="twitter-retweet.jsp?login_id=<%=login_id%>&tweeter=<%=gettweet_rs.getString(4)%>&username=<%=gettweet_rs.getString(5)%>" class="btn btn-small" role="button"><font color="black">Retweet</font> </a>
											<% } %> 
                                        </small>

                                        <a class="account-group">
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                             <% 
                                             String redirect_profile = "<a href=twitter-home.jsp?login_id=" + gettweet_rs.getString(2) + ">" + fullnames.get(gettweet_rs.getString(2)) + "</a>";  %>      
                               				 <b class="fullname"><strong><%=fullnames.get(gettweet_rs.getString(2))%></strong></b>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b><%=tweeter_username%></b>
                                            </span>
                                        </a>

                                    </div>
                                    <p class="js-tweet-text">
                                	<%
                                	tweet_cont = gettweet_rs.getString(1);
    								tweeter = gettweet_rs.getString(2);
                                    String[] words = tweet_cont.split(" "); 
                                    
                                    for(int j = 0; j < words.length; j++)
                                    {
                                    	//out.println(" w: " + words[j]); 
                                    	if(words[j].substring(0,1).equals("#")) {
                                    	    int hashexist_id = 0;
                                    	    String hash_tag = words[j].substring(1, words[j].length());
                                    	    //out.println(hash_tag); 
                                    	    String hash_link = "SELECT hash_id FROM hash_t where hash_tag = '" + hash_tag + "'";
                                    	    //out.println(hash_link); 
                                    	    java.sql.Statement hashstmt = con.createStatement();
                                    	    java.sql.ResultSet hashfind_rs = hashstmt.executeQuery(hash_link);
                                    	    while(hashfind_rs.next()) {
                                    	    	hashexist_id = hashfind_rs.getInt(1);
                                    	    } 
                                    	    %> 
                                    	    <a href ="twitter-hashtag.jsp?hashtag=<%=hash_tag%>"> <%=words[j]%> </a><%=" "%> 
                                    	    <%
                                    	}
                                    	else {
                                    	    out.println(words[j] + " "); 
                                    	}
                                    }
									%>
									
                                    </p>
                                </div>
                            </a>
                                <div class="expanded-content js-tweet-details-dropdown"></div>
                            </div>
                        </div><!-- end tweet -->
                       <%  
                      }
%>
                    </div>
                    <div class="stream-footer"></div>
                    <div class="hidden-replies-container"></div>
                    <div class="stream-autoplay-marker"></div>
                </div>
                </div>
               
            </div>
        </div>
    </div>
     <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>
