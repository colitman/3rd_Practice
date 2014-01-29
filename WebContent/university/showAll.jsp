<html>

<head>
	<title> Show All Page </title>
</head>

<body>
	<h1>All Universities</h1><br>
	<%@ page import = "org.springframework.context.*" %>
	<%@ page import = "org.springframework.context.support.*" %>
	<%@ page import = "org.springframework.beans.factory.*" %>
	<%@ page import = "hibernate.dao.*" %>
	<%@ page import = "hibernate.logic.*" %>
	<%@ page import = "java.util.Collection" %>
	<% 	boolean flag = Boolean.valueOf(request.getParameter("success"));
		//ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/hibernate.cfg.xml");
		//Gateway<University> gateway = (Gateway) context.getBean("oracleGateway");
		Collection<University> universities = new OracleGateway<University>().getAll();
		if (flag) {
	%>
		<color="green">Your request was success denied</color><br>
	<%  }
	%>
	<ul>	
	<% 	for (University university : universities) {  %>
	
		<li>
		<% 	String href = "action?code=ShowOneUniversity&id=" + university.getID();
			String name = university.getName();
		%>
		<a href=<%= href %>><%= name %></a>	
	
		</li>
	  
	<%	
		}  
	%>

	</ul>	

</body>

</html>