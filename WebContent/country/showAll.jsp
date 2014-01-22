<html>

<head>
	<title> Show All Page </title>
</head>

<body>
	<h1>All Countries</h1><br>
	<% 	boolean flag = Boolean.valueOf(request.getParameter("success"));
		ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		Gateway<Country> gateway = (Gateway) context.getBean("oracleGateway");
		Collection<Country> countries = gateway.getAll();
		if (flag) {
	%>
		<color="green">Your request was success denied</color><br>
	<%  }
	%>
	<ul>	
	<% 	for (Country country : countries) {  %>
	
		<li>
		<% 	String href = "action?code=ShowOneCountry&id=" + country.getID();
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