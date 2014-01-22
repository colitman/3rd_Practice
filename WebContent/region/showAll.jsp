<html>

<head>
	<title> Show All Page </title>
</head>

<body>
	<h1>All Regions</h1><br>
	<% 	boolean flag = Boolean.valueOf(request.getParameter("success"));
		ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		Gateway<Region> gateway = (Gateway) context.getBean("oracleGateway");
		Collection<Region> regions = gateway.getAll();
		if (flag) {
	%>
		<color="green">Your request was success denied</color><br>
	<%  }
	%>
	<ul>	
	<% 	for (Region region : regions) {  %>
	
		<li>
		<% 	String href = "action?code=ShowOneRegion&id=" + region.getID();
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