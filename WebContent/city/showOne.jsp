<html>

<head>
	<title> Show One City </title>
</head>

<body>
	<h1>City</h1>
	<%	ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		Gateway<City> gateway = (Gateway) context.getBean("oracleGateway");
		int id = Integer.valueOf(request.getParameter("id"));
		City city = gateway.get(id);
	%>
		Name : <%= city.getName() %><br>
		Population :<%= city.getPopulation() %><br>
		Square : <%= city.getSquare() %><br>
		ParentID :<%= city.getParentID() %><br>
	
		<a href="action?code=ShowAllCity">back to list</a>
</body>

</html>