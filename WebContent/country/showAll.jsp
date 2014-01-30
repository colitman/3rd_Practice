<html>

<head>
	<title> Show All Page </title>
</head>

<body>
	<h1>All Countries</h1><br>
	<%@ page import = "java.util.Collection" %>
	<%@ page import = "hibernate.logic.Country" %>
	<% 	boolean flag = Boolean.valueOf(request.getParameter("success"));
		Collection<Country> countries = (Collection<Country>) request.getAttribute("countries");
		if (flag) {
	%>
		<color="green">Your request was success denied</color><br>
	<%  }
	%>
	<ul>	
	<% 	for (Country country : countries) {  %>
	
		<li>
		<% 	String href = "/action?code=showOneCountry&id=" + country.getID();
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