<html>

<head>
	<title> Show All Page </title>
</head>

<body>
	
	<% 	Collection<University> univers = request.getParameter("universities"); %>

	<ul>	
	<% 	for (University university : univers) {  %>
	
		<li>

		<%= university.getName(); %>	
	
		</li>
	  
	<%	
		}  
	%>

	</ul>	

</body>

</html>