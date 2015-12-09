<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
	<body>
<%
	String email_user = request.getParameter("username_or_email");
	String email = "";
	String username = "";
	
	String password = request.getParameter("password");
	String redirurl = "";
	String login_id = "";
	
	String query = "";

	int status = 0;

			java.sql.Connection con = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
   	 String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow
        String login_name = "pclark";
        String pwd = "onefishtwofish";
        
        con = DriverManager.getConnection(url, login_name, pwd);      //connect to database
        java.sql.Statement stmt = con.createStatement();

 try {
 
 query = "SELECT login_id FROM login_t WHERE  email =" + "'" + email_user + "'" + " OR username =" + "'" + email_user + "'" + " AND password=" + "'" +  password + "'";
 	
	java.sql.ResultSet rs = stmt.executeQuery(query);

        while(rs.next())
        {
         login_id = rs.getString(1);
		status++;
        }
        
	if(status > 0)
	{
		session.setAttribute( "key", login_id);
		redirurl = "twitter-home.jsp"; 
		response.sendRedirect(redirurl);
	}
	else
	{
		redirurl = "twitter-signin.jsp?msg=login-fail"; 
		response.sendRedirect(redirurl);
	}
			}
		
		catch (Exception e) {
         out.println(e);
      }

%>
