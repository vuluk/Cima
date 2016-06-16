<%@page import="java.util.Comparator"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.util.SWBPriorityComparator"%>
<%@page import="org.semanticwb.model.SWBComparator"%>
<%@page import="java.util.TreeSet"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.model.ResourceSubType"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%
    WebPage topic=(WebPage)request.getAttribute("topic");
    User user=(User)request.getAttribute("user");
    HashMap params=(HashMap)request.getAttribute("params");
    //out.println("topic:"+topic);
    //out.println("user"+user);
    //out.println("params"+params);

    String lang=user.getLanguage();
    WebSite site=topic.getWebSite();
    String bannertype=(String)params.get("bannersubtype");
    //out.println("bannertype:"+bannertype);

    ResourceSubType stype=site.getResourceSubType(bannertype);
    //out.println("stype"+stype);

    Iterator<Resource> it=stype.listResources();
    TreeSet set=new TreeSet(new Comparator()
    {
        public int compare(java.lang.Object obj, java.lang.Object obj1)
        {
            int x = ((Resource) obj).getRandPriority();
            int y = ((Resource) obj1).getRandPriority();

            //if(x==y)return 0;
            if (x > y)
                return -1;
            else
                return 1;
        }        
    });
    int i=0;
    while (it.hasNext())
    {
        Resource res = it.next();
        //out.println("res"+res);
        if(res.isActive() && user.haveAccess(res))
        {
            set.add(res);
            i++;
            if(i==5)break;
        }
    }
%>


         <div class="carousel-inner">
<%
    int num = 0;
    String resid = null;
    Iterator<Resource> it2=set.iterator();
    while (it2.hasNext())
    {
        num++;
        Resource res = it2.next();
        resid = res.getId();
        String url=res.getAttribute("url");
        //out.println("          <li class=\"TabbedPanelsTab\"><a href=\"#\" onclick=\"document.getElementById('"+resid+num+"').click();\"><span class=\"resaltado\">"+res.getDisplayTitle(lang)+"</span><br/>"+res.getDisplayDescription(lang)+"</a></li>");
        String img=SWBPortal.getWebWorkPath()+res.getWorkPath()+"/"+res.getAttribute("img");
        String alt=res.getAttribute("alt");
        String target="";
        if(res.getAttribute("target").equals("true")) target=" target=\"_new\"";


        out.println('<div class="item">');
        out.println('<a href="'+url+'"> <img class="img-responsive" '+target+' src="'+img+'" alt="'+alt+'"></a>');
        out.println(' <div class="carousel-caption"><h4><a href="'+url+'">'+res.getDisplayTitle(lang)+'</a></h4><p>'+res.getDisplayTitle(lang)+'</p></div>');
        out.println('</div>');
    }
%>
        </div>






  