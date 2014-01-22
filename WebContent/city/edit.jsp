<html>

<head>
	<title>Edit City Page </title>
</head>

<body>
	<h1>Edit City </h1><br>
	
	<form action="action?code=AddCity" method="post">
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
	
	<a href="action?code=ShowAllCity">back to list</a>

</body>

</html>