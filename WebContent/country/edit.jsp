<html>

<head>
	<title>Edit Country Page </title>
</head>

<body>
	<h1>Edit Country </h1><br>
	
	<form action="action?code=ModifyCountry" method="post">
		<label for="name">Name : </label>
			<input type="text" name="name"><br>
		<label for="language">Language : </label>
			<input type="text" name="language"><br>
		<label for="capital">Capital : </label>
			<input type="text" name="capital"><br>
		<label for="population">Population : </label>
			<input type="text" name="population"><br>
		<label for="timezone">Timezone : </label>
			<input type="text" name="timezone"><br>
		<input type="submit" name="submit"><br>
	</form>
	
	<a href="action?code=ShowAllCountry">back to list</a>

</body>

</html>