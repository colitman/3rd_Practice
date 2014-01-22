<html>

<head>
	<title>Add University Page </title>
</head>

<body>
	<h1>Add University </h1><br>

	<form action="action?code=AddUniversity" method="post">
		<label for="name">Name : </label>
			<input type="text" name="name"><br>
		<label for="departs_count">Departaments count : </label>
			<input type="text" name="departs_count"><br>
		<label for="www">WWW : </label>
			<input type="text" name="www"><br>
		<label for="parent_id">ParentID : </label>
			<input type="text" name="parent_id"><br>
		<input type="submit" name="submit"><br>
	</form>

	<a href="action?code=ShowAllUniversity">back to list</a>
		
</body>

</html>