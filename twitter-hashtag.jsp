<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>



<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<!doctype html>
<html lang="en">
<head>


<% 

	String login_id = (String)session.getAttribute("key");

java.sql.Connection con = null;
   String username = "pclark";
   String password = "onefishtwofish";
   String fullname = "";
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow



    con = DriverManager.getConnection(url, username, password); //mysql id &  pwd
    
 java.sql.Statement stmt = con.createStatement();

    int totaltweets = 0;
   int followers = 0;
   int following = 0;
   int finalnumtweets = 0;
   
   String getusername = "SELECT username FROM login_t WHERE login_id =" + login_id;
	String tweetnum_q = "SELECT COUNT(a.tweet) AS 'Tweets' FROM tweet_t a, login_t b WHERE a.login_id = b.login_id AND b.login_id =" + login_id;
	String follower_q = "SELECT COUNT(*)-1 AS 'Followers' FROM following_t a, login_t b WHERE a.following_id = b.login_id AND b.login_id =" + login_id;
	String following_q = "SELECT COUNT(*)-1 AS 'Following' FROM following_t a, login_t b WHERE a.follower_id = b.login_id AND b.login_id =" + login_id;
	String tweetlisting_q = "SELECT a.tweet, a.login_id FROM tweet_t a, following_t b, login_t c WHERE a.login_id = b.following_id AND b.follower_id = c.login_id AND c.login_id =" + login_id + " ORDER BY a.tweet_date DESC;"; //"SELECT a.username, b.tweet FROM login_t a INNER JOIN tweet_t b ON a.login_id = b.login_id INNER JOIN following_t c ON c.follower_id = " + login_id +" AND c.following_id = b.login_id;";
	String getfullname_q = "SELECT fullname FROM login_t WHERE login_id =" + login_id;

	java.sql.ResultSet fullname_rs = stmt.executeQuery(getfullname_q);  
   while(fullname_rs.next())
   {
	fullname = fullname_rs.getString(1);
   }  
	
	 java.sql.Statement stmt2 = con.createStatement();

	 java.sql.ResultSet username_rs = stmt2.executeQuery(getusername);  
   while(username_rs.next())
   {
	username = username_rs.getString(1);
   }  
   
    java.sql.Statement stmt3 = con.createStatement();

java.sql.ResultSet tweetnum_rs = stmt3.executeQuery(tweetnum_q);
   while(tweetnum_rs.next())
   {
   	finalnumtweets = tweetnum_rs.getInt(1);
   }
   
    java.sql.Statement stmt4 = con.createStatement();

   java.sql.ResultSet follower_rs = stmt4.executeQuery(follower_q);
   while(follower_rs.next())
   {
   	followers = follower_rs.getInt(1);
   }
   
    java.sql.Statement stmt5 = con.createStatement();

   java.sql.ResultSet following_rs = stmt5.executeQuery(following_q);
   while(following_rs.next())
   {
   	following = following_rs.getInt(1);
   }
   
   
	String hash_tag = request.getParameter("hashtag");
	
    String hashid_select = "SELECT hash_id FROM hash_t where hash_tag = '" + hash_tag + "'";
    
  //      out.println(hash_tag);

    int hash_id = 0;
  
 java.sql.Statement stmt_hash = con.createStatement();

	java.sql.ResultSet hashfind_rs = stmt_hash.executeQuery(hashid_select);
    
    while(hashfind_rs.next()) {
        hash_id = hashfind_rs.getInt(1);
              }        
	
  //  out.println(tweet_id);
	
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
                            <% String redirect_home = "<a href=twitter-home.jsp>" + fullname + "</a>";  %>      

                                <b class="fullname"><strong><%=redirect_home%></strong></b>
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
                    
                </div>
                <div class="module other-side-content">
                    <div class="content"
                        <p>Some other content here</p>
                    </div>
                </div>
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
                    	String timestamp = "";
                    	String tweeting_login_id = "";
                    	String tweet_id = "";
       
       		java.sql.Statement stmt_tweet = con.createStatement();

       String get_tweet = "SELECT login_t.fullname, tweet_t.tweet, tweet_t.tweet_date, tweet_t.login_id, hash_tweet_t.tweet_id FROM tweet_t, login_t, hash_tweet_t WHERE login_t.login_id = tweet_t.login_id AND tweet_t.tweet_id = hash_tweet_t.tweet_id AND hash_tweet_t.hash_id=" + hash_id + " GROUP BY tweet_t.tweet_id";
             
java.sql.ResultSet tweets_result = stmt_tweet.executeQuery(get_tweet);
    

                    	while (tweets_result.next()) //loop through tweet ids, for each tweet id get the tweet
                    	{
                    	
                    		tweeter = tweets_result.getString(1); //tweeting user
    						tweet_cont = tweets_result.getString(2);
    						timestamp = tweets_result.getString(3);
    						tweeting_login_id = tweets_result.getString(4);
    						tweet_id = tweets_result.getString(5);
					%>
                        <!-- start tweet -->
      	
      				
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <small class="time">
                                            <a href="#" class="tweet-timestamp" title="10:15am - 16 Nov 12">
                                                <span class="_timestamp"><%=timestamp%></span>
                                            </a>
                                        </small>
                                        <a class="account-group">
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                            <strong class="fullname"><%=tweeter%></strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b><%=username%></b>
                                            </span>
                                        </a>
                                    </div>
                                    <p class="js-tweet-text">
                                	<%
                                	String[] words = tweet_cont.split(" "); 
                                    
                                    for(int j = 0; j < words.length; j++)
                                    {
                                    	//out.println(" w: " + words[j]); 
                                    	if(words[j].substring(0,1).equals("#")) {
                                    	    int hashexist_id = 0;
                                    	    String hash_cont = words[j].substring(1, words[j].length());
                                    	    //out.println(hash_tag); 
                                    	    String hash_link = "SELECT hash_id FROM hash_t where hash_tag = '" + hash_cont + "'";
                                    	    //out.println(hash_link); 
                                    	    java.sql.Statement hashstmt = con.createStatement();
                                    	    java.sql.ResultSet hashlocate_rs = hashstmt.executeQuery(hash_link);
                                    	    while(hashfind_rs.next()) {
                                    	    	hashexist_id = hashlocate_rs.getInt(1);
                                    	    } 
                                    	    %> 
                                    	    <a href ="twitter-hashtag.jsp?hashtag=<%=hash_cont%>"> <%=words[j]%> </a><%=" "%> 
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
