<html>

<head>
	<title> Show One Country </title>
</head>

<body>
	<h1>Country</h1>
	<%@ page import = "hibernate.logic.Country" %>
	<%	
		Country country = (Country) request.getSession().getAttribute("country");
	%>
		Name : <%= country.getName() %><br>
		Language :<%= country.getLanguage() %><br>
		Capital : <%= country.getCapital() %><br>
		Population :<%= country.getPopulation() %><br>
		Timezone :<%= country.getTimezone() %><br>
	
		<a href="action?code=showAllCountry">back to list</a>
</body>

</html>