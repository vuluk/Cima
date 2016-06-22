<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.SWBComparator"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.ResourceSubType"%>

<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.semanticwb.portal.util.SWBPriorityComparator"%>

<%!     
    static List<Resource> ramdomSelect(List<Resource> collection, int number)
    {
        if (collection.size() <= number)
        {
            return collection;
        }
        List<Resource> select = new ArrayList<Resource>();
        Random r = new Random();
        for (int i = 0; i < number; i++)
        {
            int index = r.nextInt(collection.size());
            Resource value = collection.get(index);
            select.add(value);
            collection.remove(index);
        }
        return select;
    }

    String getString(String str)
    {
        if (str == null)
        {
            return "";
        }
        /*if (str.length() > 91)
         {
         str = str.substring(0, 91) + "...";
         }*/
        str = str.replace("'", "");
        return str;
    }
%>


<%
    User user = (User) request.getAttribute("user");
    String lang = user.getLanguage();
    WebPage topic = (WebPage) request.getAttribute("topic");
    if (topic == null){ return; }
    
    HashMap params = (HashMap) request.getAttribute("params");
    if (params == null){ return; }
    
    WebSite site = topic.getWebSite();
    if (site == null){ return; }
    
    String bannertype = (String) params.get("bannersubtype");
    if (bannertype == null){ return; }
    
    ResourceSubType stype = site.getResourceSubType(bannertype);
    if (stype == null){ return; }

    String titleFirst = null;
    String descriptionFist = null;
    String urlFist = null;
    Iterator<Resource> it = stype.listResources();
    
    TreeSet set = new TreeSet(new Comparator()
    {
        public int compare(java.lang.Object obj, java.lang.Object obj1)
        {
            Resource res1 = ((Resource) obj);
            Resource res2 = ((Resource) obj1);
            int index1 = 0;
            int index2 = 0;
            try
            {
                if (res1.getAttribute("index") != null && !res1.getAttribute("index").trim().equals(""))
                {
                    try
                    {
                        index1 = Integer.parseInt(res1.getAttribute("index"));

                    } catch (NumberFormatException nfe)
                    {
                    }
                }

                if (res2.getAttribute("index") != null && !res2.getAttribute("index").trim().equals(""))
                {
                    try
                    {
                        index2 = Integer.parseInt(res2.getAttribute("index"));

                    } catch (NumberFormatException nfe)
                    {
                    }
                }
            } catch (Throwable t)
            {
            }
            if (index1 > index2)
            {
                return 1;
            } else
            {
                return -1;
            }

        }
    });
    int i = 0;
    while (it.hasNext())
    {
        Resource res = it.next();
        if (res.evalFilterMap(topic) && res.isActive() && user.haveAccess(res) && res.getAttribute("img") != null && !res.getAttribute("img").toLowerCase().endsWith(".swf"))
        {
            set.add(res);
            i++;
            //if (i == 5)
            //  break;
        }
    }
    
    List<Resource> resources = new ArrayList<Resource>();
    resources.addAll(set);
    resources = ramdomSelect(resources, 7);
    Iterator<Resource> it2 = resources.iterator();
    int j = 0;
%>

<!-- Indicators -->
<ol class="carousel-indicators">            
<%    for (int k = 0; k < resources.size(); k++){
        if(k==0) { %>
              <li data-target="#image-slide" data-slide-to="<%=k%>" class="active"></li>
<%      } else {         %>              
              <li data-target="#image-slide" data-slide-to="<%=k%>"></li>
<%
        }
    }
    
%>
</ol>


<!-- Wrapper for slides -->
<div class="carousel-inner img-slide" role="listbox">
<%    
    while (it2.hasNext()){
        Resource res = it2.next();
        String title = res.getDisplayTitle(lang);
        String desc = getString(res.getDisplayDescription(lang));
        String alt = res.getAttribute("alt", "");
        String action = res.getAttribute("axn", "");
        String img = SWBPortal.getWebWorkPath() + res.getWorkPath() + "/" + res.getAttribute("img");
        String url = res.getAttribute("url");
        if(j==0) {
%>
    <div class="item active">
        <img src="<%=img%>" alt="<%=desc%>" />
        <div class="carousel-caption">
            <a href="<%=url%>" <%=action%> ><h3><%=desc%></h3></a>
          <p><%=alt%></p>
        </div>
    </div>        
<%        
        } else {
%>
    <div class="item">
        <img src="<%=img%>" alt="<%=desc%>" />
        <div class="carousel-caption">
          <a href="<%=url%>" <%=action%> ><h3><%=desc%></h3></a>
          <p><%=alt%></p>
        </div>        
    </div>
<%
        }
        j++;
    }

%>
</div>

