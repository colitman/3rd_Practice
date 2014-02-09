<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<c:import url="meta.html"/>
<title>Lab 8 - Start</title>
</head>
<body>

<div id="header">
	<c:import url="header.html"/>
</div><hr>

<div id="content">
	<h1 class="greeting">Welcome!</h1>
	<h2 class="greeting">Press the <span id="start">Start</span> button below to begin working.</h2>
	<div id="start-button-img">
		<a class="greeting" href="action?code=showAllCountry" >
			<img width="75px" height="75px" id="start-button" alt="Go-go-go!" src="http://fotki.ykt.ru/albums/userpics/2014/01-01/start_button.png">
		</a>
	</div>
	<h2 class="greeting">Good luck and may the Force be with you.</h2>
</div>

<hr><div id="footer">
	<c:import url="footer.html"/>
</div>

</body>
</html>