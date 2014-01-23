<html>

<head>
	<title>Error </title>
</head>

<body>
	<h1>Error</h1><hr>
	<div color=ff0000>
	Some thing go wrong...
	<? 
		String message = request.getParameter("message");
		if (message != null) {
	?>
	Message : <?= message>
	</div>
	<?
		}
	?>
	<a href="action?code=homepage">go to homepage</a>
</body>

</html>