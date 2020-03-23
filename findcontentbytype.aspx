<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ import Namespace="EPiServer.Core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
      <title>Content by type</title>
    </head>
    <body>
        <form id="form1" runat="server">
        <%
        var contentLoader = EPiServer.ServiceLocation.ServiceLocator.Current.GetInstance<EPiServer.IContentLoader>();
        var contentTypeRepository = EPiServer.ServiceLocation.ServiceLocator.Current.GetInstance<EPiServer.DataAbstraction.IContentTypeRepository>();
        var contentModelUsage = EPiServer.ServiceLocation.ServiceLocator.Current.GetInstance<EPiServer.Core.IContentModelUsage>();

        var contentTypeName = Request.QueryString["type"];
        var assemblyName = Request.QueryString["assembly"];
        if (string.IsNullOrWhiteSpace(contentTypeName) || string.IsNullOrWhiteSpace(assemblyName))
        {
            %>
            <div>
                Please specify the content type using query parameters "type" and "assembly" like this: findcontentbytype.aspx?type=MyProject.Models.Blocks.HomeBlock&assembly=MyProjects.Models
            </div>
            <%
            return;
        }
        var typeString = string.Format($"{contentTypeName}, {assemblyName}");
        var contentType = contentTypeRepository.Load(Type.GetType(typeString));
        var contentUsages = contentModelUsage.ListContentOfContentType(contentType);
        var contentReferences = contentUsages.Select(x => x.ContentLink.ToReferenceWithoutVersion()).Distinct().ToList();
        var instances = contentReferences.Select(contentReference => contentLoader.Get<IContent>(contentReference)).ToList();

        foreach (var instance in instances)
        {%>
            <div>
            <%: instance.ContentLink.ID %>: <%: instance.Name  %>
            </div>
        <%}
        %>  
        </form>
    </body>
</html>
