<html>

<head>
	<title> Show One Country </title>
</head>

<body>
	<h1>Country</h1>
	<%	ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		Gateway<Country> gateway = (Gateway) context.getBean("oracleGateway");
		int id = Integer.valueOf(request.getParameter("id"));
		Country country = gateway.get(id);
	%>
		Name : <%= country.getName() %><br>
		Language :<%= country.getLanguage() %><br>
		Capital : <%= country.getCapital() %><br>
		Population :<%= country.getPopulation() %><br>
		Timezone :<%= country.getTimezone() %><br>
	
		<a href="action?code=ShowAllCountry">back to list</a>
</body>

</html>