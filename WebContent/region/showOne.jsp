<html>

<head>
	<title> Show One Region </title>
</head>

<body>
	<h1>Region</h1>
	<%	ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		Gateway<Region> gateway = (Gateway) context.getBean("oracleGateway");
		int id = Integer.valueOf(request.getParameter("id"));
		Region region = gateway.get(id);
	%>
		Name : <%= region.getName() %><br>
		Population :<%= region.getPopulation() %><br>
		Square : <%= region.getSquare() %><br>
		ParentID :<%= region.getParentID() %><br>
	
		<a href="action?code=ShowAllRegion">back to list</a>
</body>

</html>