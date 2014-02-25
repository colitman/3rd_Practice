<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<c:import url="/meta.html"/>
<title>Lab 8 - Universities</title>
</head>
<body>

<div id="header">
	<c:import url="/header.html"/>
</div><hr>
<h1>All Universities</h1>
<div id="content">
	<div id="paramsCurrent">
        <span class="paramTitle">Name: </span>${parent.name}<br>
        <span class="paramTitle">Departaments count: </span>${parent.departamentsCount}<br>
        <span class="paramTitle">WWW: </span>${parent.WWW}<br>
	</div>
	<br><br><br><hr>
	<div id="toolbar">
		<c:import url="/toolbar.html"/>
	</div>
	
	<div onclick="close_modal();" id="modal"></div><div id="modal_open"></div>
	<div class="addNew popUpWrapper" id="editItemPopup">
			<div class="popUpContent">
				<form id="editUni" action="action?code=modifyUniversity&id=${parent.ID}&parent_id=${parent.parentID}" method="POST">
					<table class="noborder">
						<tr>
							<td>Name:</td>
							<td>
								<input name="name" type="text" value="${parent.name}" />
							</td>
						</tr>
						<tr>
							<td>Departaments count:</td>
							<td>
								<input name="departs_count" type="text" value="${parent.departamentsCount}" />
							</td>
						</tr>
						<tr>
							<td>WWW:</td>
							<td>
								<input name="www" type="text" value="${parent.WWW}" />
							</td>
						</tr>
						<tr>
							<td>
								<a href="javascript:document.getElementById('editUni').submit()">Modify</a>
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

<hr style="clear: both;"><div id="footer">
	<c:import url="/footer.html"/>
</div>

<script>
    document.getElementById("addNewButton").style.display = 'none';
</script>

</body>
</html>