<html>

<head>
	<title> Show All Page </title>
</head>

<body>
	<h1>All Cities</h1><br>
	<% 	boolean flag = Boolean.valueOf(request.getParameter("success"));
		ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		Gateway<City> gateway = (Gateway) context.getBean("oracleGateway");
		Collection<City> cities = gateway.getAll();
		if (flag) {
	%>
		<color="green">Your request was success denied</color><br>
	<%  }
	%>
	<ul>	
	<% 	for (City city : cities) {  %>
	
		<li>
		<% 	String href = "action?code=ShowOneCity&id=" + region.getID();
			String name = region.getName();
		%>
		<a href=<%= href %>><%= name %></a>	
	
		</li>
	  
	<%	
		}  
	%>

	</ul>	

</body>

</html>