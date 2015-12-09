<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<html>
	<body>

<%
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	String username = request.getParameter("name");
	String redirurl = "";
	String login_id = "";

	int status = 0;

	java.sql.Connection con = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    String url = "jdbc:mysql://localhost:3306/pclark";   //your db ex) ljadow
    String login_user = "pclark";
    String pwd = "onefishtwofish";
	con = DriverManager.getConnection(url, login_user, pwd); //connect to database

	java.sql.Statement stmt = con.createStatement();	
	
 try {
 boolean copy_one = false;
 String check_copy_user = "SELECT username FROM login_t; "; 
 
    java.sql.ResultSet check_rs = stmt.executeQuery(check_copy_user);  
    String uname = ""; 
   while(check_rs.next())
   {
	uname += check_rs.getString(1) + " "; 
   }  
   if(uname.contains(username)){
   		copy_one = true; 
   }

 
 if(password.length() > 6 && email.contains("@") && (copy_one == false) && !(name==null) && !(email==null) && !(password==null) && !(username==null) && !(name=="") && !(email=="") && !(password=="") && !(username==""))
{
        java.sql.PreparedStatement insert = con.prepareStatement("INSERT INTO login_t (fullname, email, password, username) values (?,?,?,?)");

	java.sql.PreparedStatement self_following = con.prepareStatement("INSERT INTO following_t values (?, ?)");

        insert.setString (1, name);
        insert.setString (2, email);
        insert.setString (3, password);
        insert.setString(4, username);
        status = insert.executeUpdate();
      
        
        java.sql.ResultSet rs = stmt.executeQuery("SELECT MAX(login_id) from login_t");
         
        while(rs.next())
        {
         	login_id = rs.getString(1);
        }

	self_following.setString(1, login_id);
	self_following.setString(2, login_id);

	status = self_following.executeUpdate();
        
}
	if(status > 0)	{
		session.setAttribute("key", login_id);
		redirurl = "twitter-home.jsp"; 
		response.sendRedirect(redirurl);
	
	}
	else
	{
	if(password.length() < 4)
	{
	redirurl = "twitter-signin.jsp?msg=password-too-short"; 
		response.sendRedirect(redirurl);
	}
	else{
		redirurl = "twitter-signin.jsp?msg=signup_fail"; 
		response.sendRedirect(redirurl);
		}
	}
	}
		catch (Exception e) {
         out.println(e);
      }
		

%>
