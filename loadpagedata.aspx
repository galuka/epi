<% @Page Language="C#" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="System.Linq" %>

<%
    var contentId = Request.QueryString["id"];
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
	PageData pageData = contentLoader.Get<PageData>(new ContentReference(int.Parse(contentId)));
	string name = pageData.Name;
	DateTime changed = pageData.Changed;
	DateTime saved = pageData.Saved;
	DateTime? published = pageData.StartPublish;
%>
<html>
	<style>
		h3{
		display: inline;
		}
	</style>
	<body>
		<h1>Properties of '<%=pageData.Name%>' page</h1>
		<div>
		<%
			foreach (var property in pageData.Property.OrderBy(x => x.Name))
			{%>
				<div>
					<h3><%=property.Name%></h3>&nbsp;<span><%=property.Value%></span>
				</div>
			<%}
		%>
		</div>
	</body>
</html>