<html>

<head>
	<title> Show All Page </title>
</head>

<body>
	<h1>All Universities</h1><br>
	<% 	boolean flag = Boolean.valueOf(request.getParameter("success"));
		ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		Gateway<University> gateway = (Gateway) context.getBean("oracleGateway");
		Collection<University> universities = gateway.getAll();
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