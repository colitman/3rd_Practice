<html>

<head>
	<title> Show One University </title>
</head>

<body>
	<h1>University</h1>
	<%	ApplicationContext context = new FileSystemXmlApplicationContext("res/beans.xml");
		Gateway<University> gateway = (Gateway) context.getBean("oracleGateway");
		int id = Integer.valueOf(request.getParameter("id"));
		University university = gateway.get(id);
	%>
		Name : <%= university.getName() %><br>
		Departaments count :<%= university.getDepartamentsCount() %><br>
		WWW : <%= university.getWWW() %><br>
		ParentID :<%= university.getParentID() %><br>
	
		<a href="action?code=ShowAllUniversity">back to list</a>
</body>

</html>