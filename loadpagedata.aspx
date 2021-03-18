<% @Page Language="C#" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="System.Linq" %>

<%
    var contentId = Request.QueryString["id"];
    var providerName = Request.QueryString["providerName"];
	if (string.IsNullOrWhiteSpace(contentId))
    {
		%>
		<div>
			Please specify the content id using query parameter "id" like this: loadpagedata.aspx?id=148
		</div>
		<%
		return;
    }
	IContentLoader contentLoader = ServiceLocator.Current.GetInstance<IContentLoader>();
	var content = contentLoader.Get<IContent>(new ContentReference(int.Parse(contentId), string.IsNullOrEmpty(providerName) ? null : providerName));
%>
<html>
	<style>
		h3{
		display: inline;
		}
	</style>
	<body>
		<h1>Properties of '<%=content.Name%>' page</h1>
		<div>
		<%
			foreach (var property in content.Property.OrderBy(x => x.Name))
			{%>
				<div>
					<h3><%=property.Name%></h3>&nbsp;<span><%=property.Value%></span>
				</div>
			<%}
		%>
		</div>
	</body>
</html>