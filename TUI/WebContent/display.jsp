<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script type="text/javascript">
$(function() {
	$("head").load("meta.html");
});
</script>
<title>Lab 8 - Countries</title>
</head>
<body>

<div id="header"></div><hr>
<h1>Title</h1>
<div id="content">
<%@page language="java" import="java.util.*, used.*" %>
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
				<%
					List<Entity> data = (List<Entity>)request.getAttribute("data");
					for(Entity d:data) {
				%>
				<tr>
					<td class="thin"><input type="checkbox"></td>
					<td><a class ="generated-data" href="show?list=children&parent=<%=d.getName()%>"><%=d.getName()%></a></td>
					<td>
						<%
							Map<String, String> params = d.getParams();
							Set<String> keys = params.keySet();
							for(String key:keys) {
						%>
						<%=key %>: <%=params.get(key) %>
						<%}%>			
					</td>
				</tr>
				<%}%>
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