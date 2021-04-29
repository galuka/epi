<% @Page Language="C#" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="EPiServer.Find.Cms" %>
<%@ Import Namespace="EPiServer.Find.Commerce" %>
<%@ Import Namespace="EPiServer.Web" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Diagnostics" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
      <title>Commerce Content Loading Measure</title>
    </head>
    <body>
		<script runat="server" type="text/C#">
			public IEnumerable<IEnumerable<TSource>> Batch<TSource>(IEnumerable<TSource> source, int size)
			{
				TSource[] sourceArray = null;
				int count = 0;
				foreach (TSource source1 in source)
				{
					if (sourceArray == null)
					{
						sourceArray = new TSource[size];
					}

					sourceArray[count++] = source1;
					if (count == size)
					{
						yield return sourceArray;
						sourceArray = null;
						count = 0;
					}
				}

				if (sourceArray != null && count > 0)
				{
					yield return sourceArray.Take(count);
				}
			}
		</script>
		<h1>Commerce Content Loading Measure</h1>
        <%
        var contentLoader = EPiServer.ServiceLocation.ServiceLocator.Current.GetInstance<EPiServer.IContentLoader>();
		var siteDefinitionResolver = ServiceLocator.Current.GetInstance<ISiteDefinitionResolver>();
        var commerceReindexInformation = ServiceLocator.Current.GetAllInstances<IReindexInformation>().Single(x => x is CommerceReIndexInformation);
		
		var maxThreads = Environment.ProcessorCount / 2 >= 1 ? Environment.ProcessorCount / 2 : 1;
		%>
		<h2>Max Threads for this environment: <%: maxThreads %> </h2>
		<%
		EPiServer.CacheManager.Clear();
		var batchSize = 1000;
		var batchCount = 5;
		var batchSizeParam = Request.QueryString["batchSize"];
		var batchCountParam = Request.QueryString["batchCount"];		
		if (!string.IsNullOrWhiteSpace(batchSizeParam))
		{	
			batchSize = int.Parse(batchSizeParam);
		}		
		if (!string.IsNullOrWhiteSpace(batchCountParam))
		{	
			batchCount = int.Parse(batchCountParam);
		}
		
		var index = 0;

		foreach (ReindexTarget reindexTarget in commerceReindexInformation.ReindexTargets)
		{
			var contentReferences = Batch(reindexTarget.ContentLinks, batchSize);

			foreach (IEnumerable<ContentReference> currentBatch in contentReferences)
			{
				List<ContentReference> contentReferenceList = new List<ContentReference>();
				foreach (ContentReference contentLink in currentBatch)
				{
					if (reindexTarget.SiteDefinition == null)
					{
						var byContent = siteDefinitionResolver.GetByContent(contentLink, false, false);
						if (byContent != null)
							continue;
					}

					contentReferenceList.Add(contentLink);
				}

				try
				{
					var watch = Stopwatch.StartNew();
					var contentList = new List<IContent>(contentLoader.GetItems(contentReferenceList, new LanguageSelector("en")));
					foreach (var item in contentList)
					{
						item.ToString();
					}

					watch.Stop();
					%>
						<div style="padding:5px;font-size: 1.3rem;">
						Loaded <%: contentReferenceList.Count %> items in <%: watch.ElapsedMilliseconds  %> milliseconds
						</div>
					<%
				}
				catch
				{
				}

				if (++index == batchCount)
				{
					break;
				}
			}
		}
        %>  
    </body>
</html>
