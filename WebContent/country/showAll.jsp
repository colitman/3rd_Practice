<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<c:import url="/meta.html"/>
<title>Lab 8 - Countries</title>
</head>
<body>

<div id="header">
	<c:import url="/header.html"/>
</div><hr>
<h1>All Countries</h1>
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
						<c:param name="code" value="showAllRegionInCountry" />
						<c:param name="parent_id" value="${item.ID}" />
					</c:url>
					<tr>
						<td class="thin"><input type="checkbox" id="${item.ID}" class="personalCheckbox"></td>
						<td><a class="generated-data" href="${url}">${item.name}</a></td>
						<td>Language : ${item.language}, Capital: ${item.capital}, Population: ${item.population}, Timezone: ${item.timezone}</td>					
					</tr>
				</c:forEach>
			</table>
		</div>

		<div class="addNew popUpWrapper" id="addNewCountry newItemPopup">
			<div class="popUpContent">
				<form id="newCountry" action="action?code=addCountry" method="POST">
					<table class="noborder">
						<tr>
							<td>Name:</td>
							<td>
								<input name="name" type="text" />
							</td>
						</tr>
						<tr>
							<td>Language:</td>
							<td>
								<input name="language" type="text" />
							</td>
						</tr>
						<tr>
							<td>Capital:</td>
							<td>
								<input name="capital" type="text" />
							</td>
						</tr>
						<tr>
							<td>Population:</td>
							<td>
								<input name="population" type="text" />
							</td>
						</tr>
						<tr>
							<td>Timezone:</td>
							<td>
								<input name="timezone" type="text" />
							</td>
						</tr>
						<tr>
							<td><input value="Add" type="submit" /></td>
							<td>
								<button onclick="javascript:hidePopUp()">Cancel</button>
							</td>
						</tr>
					</table>
				</form>		
			</div>
		</div>
	</div>
</div>

<hr style="clear: both;"><div id="footer">
	<c:import url="/footer.html"/>
</div>

</body>
</html>