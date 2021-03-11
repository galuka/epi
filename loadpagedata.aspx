<% @Page Language="C#" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>

<%
	IContentLoader contentLoader = ServiceLocator.Current.GetInstance<IContentLoader>();
	PageData pageData = contentLoader.Get<PageData>(new ContentReference(131893));
	string name = pageData.Name;
	DateTime changed = pageData.Changed;
	DateTime saved = pageData.Saved;
	DateTime? published = pageData.StartPublish;
%>

<html>
	<h1>Test page</h1>
	<div>
		<h3> Page name: </h3><span><%=name%></span>
		<h3> Changed: </h3><span><%=changed%></span>
		<h3> Saved: </h3><span><%=saved%></span>
		<h3> Published: </h3><span><%=published%></span>
	</div>
</html>