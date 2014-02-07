<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script type="text/javascript">
$(function() {
	$("head").load("/WebPrototype/meta.html");
});
</script>
<title>Lab 8 - Countries</title>
</head>
<body>

<div id="header"></div><hr>
<h1>All Counties</h1>
<div id="content">
	<div id="toolbar">
		<script type="text/javascript">
			$("#toolbar").load("toolbar.html");
		</script>
	</div>
	<div id="main-info">
		<div id="children-list">
			<table class="normal">
				<tr>
					<th class="thin">v</th><th>Name</th><th>Description</th>
				</tr>
				<c:forEach var="item" items="${data}">
					<c:url var="url" value="action">
						<c:param name="code" value="showAllRegionInCountry" />
						<c:param name="parent_id" value="${item.ID}" />
					</c:url>
					<tr>
						<td class="thin"><input type="checkbox"></td>
						<td><a class="generated-data" href="${url}">${item.name}</a></td>
						<td>Language : ${item.language}, Capital: ${item.capital}, Population: ${item.population}, Timezone: ${item.timezone}</td>					
					</tr>
				</c:forEach>
			</table>
		</div>

		<div id="params">
		</div>
	</div>
</div>

<hr><div id="footer"></div>
<script type="text/javascript">
	$(function() {
		$("#header").load("header.html");
		$("#footer").load("footer.html");
	});
</script>

</body>
</html>