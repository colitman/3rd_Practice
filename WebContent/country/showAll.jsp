<html>

<head>
	<title> Show All Page </title>
</head>

<body>
	<h1>All Countries</h1><br>
	<%@ page import = "org.springframework.context.*" %>
	<%@ page import = "org.springframework.context.support.*" %>
	<%@ page import = "org.springframework.beans.factory.*" %>
	<%@ page import = "hibernate.dao.*" %>
	<%@ page import = "hibernate.logic.*" %>
	<%@ page import = "java.util.Collection" %>
	<% 	boolean flag = Boolean.valueOf(request.getParameter("success"));
		//ApplicationContext context = new FileSystemXmlApplicationContext("C:/Workspace/LAB3/Mego_Portal_XD/res/hibernate.cfg.xml");
		//Gateway<Country> gateway = (Gateway) context.getBean("oracleGateway");
		Collection<Country> countries = new OracleGateway<Country>().getAll();
		if (flag) {
	%>
		<color="green">Your request was success denied</color><br>
	<%  }
	%>
	<ul>	
	<% 	for (Country country : countries) {  %>
	
		<li>
		<% 	String href = "action?code=showOneCountry&id=" + country.getID();
			String name = country.getName();
		%>
		<a href=<%= href %>><%= name %></a>	
	
		</li>
	  
	<%	
		}  
	%>

	</ul>	

</body>

</html>