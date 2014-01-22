<html>

<head>
	<title>Edit Region Page </title>
</head>

<body>
	<h1>Edit Region </h1><br>
	
	<form action="action?code=AddRegion" method="post">
		<label for="name">Name : </label>
			<input type="text" name="name"><br>
		<label for="population">Population : </label>
			<input type="text" name="population"><br>
		<label for="square">Square : </label>
			<input type="text" name="square"><br>
		<label for="parent_id">ParentID : </label>
			<input type="text" name="parent_id"><br>
		<input type="submit" name="submit"><br>
	</form>
	
	<a href="action?code=ShowAllRegion">back to list</a>

</body>

</html>