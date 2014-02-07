<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<c:import url="/meta.html"/>
<title>Lab 8 - Universities</title>
</head>
<body>

<div id="header">
	<c:import url="/header.html"/>
</div><hr>
<h1>All Universities</h1>
<div id="content">
	<div id="toolbar">
		<c:import url="/toolbar.html"/>
	</div>
	<div id="main-info">
		<div id="children-list">
			<table class="normal">
				<tr>
					<th class="thin">v</th><th>Name</th><th>Description</th>
				</tr>
				<c:forEach var="item" items="${data}">
					<c:url var="url" value="action">
						<c:param name="code" value="showOneCountry" />
						<c:param name="parent_id" value="${item.ID}" />
					</c:url>
					<tr>
						<td class="thin"><input type="checkbox"></td>
						<td><a class="generated-data" href="${url}">${item.name}</a></td>
						<td>Departaments count: ${item.departamentsCount}, WWW: ${item.WWW}</td>					
					</tr>
				</c:forEach>
			</table>
		</div>

		<div id="params">
		</div>
	</div>
</div>

<hr><div id="footer">
	<c:import url="/footer.html"/>
</div>

</body>
</html>