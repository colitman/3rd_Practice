<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<c:import url="/meta.html"/>
<title>Lab 8 - Regions</title>
</head>
<body>

<div id="header">
	<c:import url="/header.html"/>
</div><hr>
<h1>All Regions</h1>
<div id="content">
	<div id="paramsCurrent">
		<form class="editCountry" action="action?code=editCountry&id=000000" method="POST">
			<span class="paramTitle">Name: </span>Имя страны<br>
			<span class="paramTitle">Language: </span>Язык страны<br>
			<span class="paramTitle">Capital: </span>Столица страны<br>
			<span class="paramTitle">Population: </span>Население страны<br>
			<span class="paramTitle">Timezone: </span>Таймзона страны<br>
			<input type="submit" value="Edit">
		</form>
	</div>
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
						<c:param name="code" value="showAllCityInRegion" />
						<c:param name="parent_id" value="${item.ID}" />
					</c:url>
					<tr>
						<td class="thin"><input type="checkbox"></td>
						<td><a class="generated-data" href="${url}">${item.name}</a></td>
						<td>Population: ${item.population}, Square: ${item.square}</td>					
					</tr>
				</c:forEach>
			</table>
		</div>

		<div class="addNew" id="addNewRegion">
			<form id="newRegion" action="action?code=newRegion" method="POST">
				<table class="noborder">
					<tr>
						<td>Name:</td>
						<td>
							<input name="name" type="text" />
						</td>
					</tr>
					<tr>
						<td>Population:</td>
						<td>
							<input name="popu" type="text" />
						</td>
					</tr>
					<tr>
						<td>Square:</td>
						<td>
							<input name="sq" type="text" />
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="Add new region" type="submit" />
						</td>
					</tr>
				</table>
			</form>		
		</div>
	</div>
</div>

<hr style="clear: both;"><div id="footer">
	<c:import url="/footer.html"/>
</div>

</body>
</html>