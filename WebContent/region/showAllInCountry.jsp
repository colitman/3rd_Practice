<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<c:import url="/meta.html"/>
<title>Lab 8 - Regions</title>
</head>
<body>

<div id="header">
	<c:import url="/header.html"/>
</div><hr>
<h1>All Regions</h1>
<div id="content">
    <div id="navPath">
        <a href="/WebPrototype/action?code=showAllCountry">Top</a> >
        <a href="/WebPrototype/action?code=showAllRegionInCountry&parent_id=${parent.ID}">${parent.name}</a>
    </div>
	<div id="paramsCurrent">
        <span class="paramTitle">Name: </span>${parent.name}<br>
        <span class="paramTitle">Language: </span>${parent.language}<br>
        <span class="paramTitle">Capital: </span>${parent.capital}<br>
        <span class="paramTitle">Population: </span>${parent.population}<br>
        <span class="paramTitle">Timezone: </span>${parent.timezone}<br>
	</div>
	<div id="toolbar">
		<c:import url="/toolbar.html"/>
	</div>
	<div id="main-info">
		<div id="children-list">
			<table class="normal">
				<tr>
					<th>Name</th><th>Description</th><th></th>
				</tr>
				<c:forEach var="item" items="${data}">
					<c:url var="url" value="action">
						<c:param name="code" value="showAllCityInRegion" />
						<c:param name="parent_id" value="${item.ID}" />
					</c:url>
					<tr>
						<td><a class="generated-data" href="${url}">${item.name}</a></td>
						<td>Population: ${item.population}, Square: ${item.square}</td>
						<td><a class="generated-data" href="action?code=removeRegion&id=${item.ID}&parent_id=${item.parentID}">delete</a></td>					
					</tr>
				</c:forEach>
			</table>
		</div>

		<div onclick="close_modal();" id="modal"></div><div id="modal_open"></div>
		<div class="addNew popUpWrapper" id="newItemPopup">
			<div class="popUpContent">
				<form id="newRegion" action="action?code=addRegion&parent_id=${parent.ID}" method="POST">
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
								<input name="population" type="text" />
							</td>
						</tr>
						<tr>
							<td>Square:</td>
							<td>
								<input name="square" type="text" />
							</td>
						</tr>
						<tr>
							<td>
								<a href="javascript:document.getElementById('newRegion').submit()">Add</a>
							</td>
							<td>
								<a href="javascript:close_modal()">Cancel</a>
							</td>
						</tr>
					</table>
				</form>		
			</div>
		</div>

		<div class="addNew popUpWrapper" id="editItemPopup">
			<div class="popUpContent">
				<form id="editCountry" action="action?code=modifyCountry&id=${parent.ID}" method="POST">
					<table class="noborder">
						<tr>
							<td>Name:</td>
							<td>
								<input name="name" type="text" value=${parent.name} />
							</td>
						</tr>
						<tr>
							<td>Language:</td>
							<td>
								<input name="language" type="text" value=${parent.language} />
							</td>
						</tr>
						<tr>
							<td>Capital:</td>
							<td>
								<input name="capital" type="text" value=${parent.capital} />
							</td>
						</tr>
						<tr>
							<td>Population:</td>
							<td>
								<input name="population" type="text" value=${parent.population} />
							</td>
						</tr>
						<tr>
							<td>Timezone:</td>
							<td>
								<input name="timezone" type="text" value=${parent.timezone} />
							</td>
						</tr>
						<tr>
							<td>
								<a href="javascript:document.getElementById('editCountry').submit()">Modify</a>
							</td>
							<td>
								<a href="javascript:close_modal()">Cancel</a>
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