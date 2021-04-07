<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ import Namespace="EPiServer.Core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
      <title>GetChildren</title>
    </head>
    <body>
        <%
        var contentLoader = EPiServer.ServiceLocation.ServiceLocator.Current.GetInstance<EPiServer.IContentLoader>();

		var contentId = Request.QueryString["id"];
		var providerName = Request.QueryString["providerName"];		
		if (string.IsNullOrWhiteSpace(contentId))
		{
			%>
			<div>
				Please specify the content id using query parameter "id" like this: getchildren.aspx?id=148
			</div>
			<%
			return;
		}
		
		var contentReference = new ContentReference(int.Parse(contentId), providerName);		
		if (providerName == Mediachase.Commerce.Catalog.ReferenceConverter.CatalogProviderKey)
		{
			var children = contentLoader.GetChildren<EPiServer.Commerce.Catalog.ContentTypes.CatalogContentBase>(contentReference, new LoaderOptions{ LanguageLoaderOption.MasterLanguage() });
			foreach (var child in children)
			{%>
				<div>
				<%: child.ContentLink.ID %>: <%: child.Name  %>
				</div>
			<%}
		}
		else
		{
			var children = contentLoader.GetChildren<PageData>(contentReference, new LoaderOptions{ LanguageLoaderOption.MasterLanguage() });
			foreach (var child in children)
			{%>
				<div>
				<%: child.ContentLink.ID %>: <%: child.Name  %>
				</div>
			<%}		
		}

        %>  
    </body>
</html>
