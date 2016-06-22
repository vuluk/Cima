<%@page import="java.util.Comparator"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.util.SWBPriorityComparator"%>
<%@page import="org.semanticwb.model.SWBComparator"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.ResourceSubType"%>
<%@page import="org.semanticwb.model.WebSite"%><%!
    private final String pathimageOn = "/work/models/cima/css/SelOn.png";
    private final String pathimageOff = "/work/models/cima/css/selOff.png";

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

   // String cadenaNula = null;
	//System.out.println(cadenaNula.length());	//error
    User user = (User) request.getAttribute("user");
    String lang = user.getLanguage();
    WebPage topic = (WebPage) request.getAttribute("topic");
    if (topic == null)
    {
        return;
    }
    HashMap params = (HashMap) request.getAttribute("params");
    if (params == null)
    {
        return;
    }
    WebSite site = topic.getWebSite();
    if (site == null)
    {
        return;
    }
    String bannertype = (String) params.get("bannersubtype");
    if (bannertype == null)
    {
        return;
    }
    ResourceSubType stype = site.getResourceSubType(bannertype);
    if (stype == null)
    {
        return;
    }

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
    StringBuilder alts = new StringBuilder("var alts =[ ");
    StringBuilder descriptions = new StringBuilder("var descriptions =[ ");
    StringBuilder titles = new StringBuilder("var titles =[ ");
    StringBuilder images = new StringBuilder("var imageArray =[ ");
    StringBuilder urls = new StringBuilder("var urls =[ ");
    StringBuilder selectores = new StringBuilder("");
    String img_fist = null;
    String alt_fist = null;
    int j = -1;

    while (it2.hasNext())
    {
        j++;
        Resource res = it2.next();
        String title = res.getDisplayTitle(lang);
        if (titleFirst == null)
        {
            titleFirst = title;
        }
        
        String style = "";
        if (j == 0)
        {
            style = "style=\"background-image: url('" + pathimageOn + "');\"";
        } else
        {
            style = "";
        }
        selectores.append("<li><a id=\"selector_" + j + "\" " + style + " href=\"javascript:clickSelector(" + j + ")\" >" + "Tema " + (j + 1) + "</a></li>");
        titles.append("'");
        titles.append(title);
        titles.append("'");
        titles.append(",");
        String desc = getString(res.getDisplayDescription(lang));
        if (descriptionFist == null)
        {
            descriptionFist = desc;
        }
        descriptions.append("'");
        descriptions.append(desc);
        descriptions.append("'");
        descriptions.append(",");
        String alt = res.getAttribute("alt", "");
        if (alt_fist == null)
        {
            alt_fist = alt;
            if (alt_fist == null)
            {
                alt_fist="";
            }
        }
        String img = SWBPortal.getWebWorkPath() + res.getWorkPath() + "/" + res.getAttribute("img");
        res.incViews();
        String url = res.getAttribute("url");
        images.append("'");
        images.append(img);
        images.append("'");
        images.append(",");
        if (img_fist == null)
        {
            img_fist = img;
        }
        if (url == null)
        {
            url = "#";
        }

        if (urlFist == null)
        {
            urlFist = url;
        }
        urls.append("'");
        urls.append(url);
        urls.append("'");
        urls.append(",");

        alts.append("'");
        alts.append(alt);
        alts.append("'");
        alts.append(",");
    }
    if (img_fist == null)
    {
        img_fist = "#";
    }
    images.deleteCharAt(images.length() - 1);
    titles.deleteCharAt(titles.length() - 1);
    descriptions.deleteCharAt(descriptions.length() - 1);
    urls.deleteCharAt(urls.length() - 1);

    images.append("];");
    titles.append("];");
    alts.append("];");
    descriptions.append("];");
    urls.append("];");
%>

<script type="text/javascript">
    <!--
    <%=images%>
    <%=titles%>
    <%=alts%>
    <%=descriptions%>
    <%=urls%>
    function changeBkPromoAccs(img, text, url, index,alt)
    {
        var element = document.getElementById('img_carrusel');
        var teasersKickertext = document.getElementById('teasersKickertext');
        var teasersKickerlnk = document.getElementById('teasersKickerlnk');
        //background-image: url("selOff.png");
        for (var i = 0; i <<%=i%>; i++)
        {
            var li = document.getElementById('selector_' + i);
            if (i === index)
            {
                li.style.backgroundImage = "url('<%=pathimageOn%>')";
            }
            else
            {
                li.style.backgroundImage = "url('<%=pathimageOff%>')";
            }
        }
        if (element)
        {
            //element.style.backgroundImage = "url('" + url + "')";
            //element.style.backgroundRepeat = 'no-repeat';
            element.src = img;
            element.alt=alt;
        }
        if (teasersKickertext)
        {
            teasersKickertext.innerHTML = text;
        }
        if (teasersKickerlnk)
        {
            teasersKickerlnk.href = url;
        }
    }

-->
</script>
<%
    String divName = "teasersHome";
    if (params.get("div") != null)
    {
        divName = params.get("div").toString();
    }
    String teasersKicker = "teasersKicker";
    if (params.get("kicker") != null)
    {
        teasersKicker = params.get("kicker").toString();
    }
%>
<div id="<%=divName%>">
    <%
        int w = 290;
        int h = 280;
        if (params.get("width") != null)
        {
            w = Integer.parseInt(params.get("width").toString());
        }
        if (params.get("height") != null)
        {
            h = Integer.parseInt(params.get("height").toString());
        }

    %>    
    <img id="img_carrusel" src="<%=img_fist%>" alt="<%=alt_fist%>" width="<%=w%>" height="<%=h%>" />
    <a href="javascript:back();" class="atras" >Tema anterior</a>
    <a href="javascript:next();" class="adelante" >Tema siguiente</a>
    <div align="center">
        <ul id="selector">
            <%=selectores%>
        </ul>
    </div>
    <div class="<%=teasersKicker%>">
        <div class="kickerTextBox">
            <p id="teasersKickertext"><%=descriptionFist%></p>
            <a id="teasersKickerlnk" href="<%=urlFist%>" class="leerMas" >leer más</a> </div>
    </div>
</div>


<script type="text/javascript">
<!--
    var currentIndex = 0;

    //var timerID = 0;

    function clickSelector(index)
    {
        //clearTimeout(timerID);
        currentIndex = index;
        var img = imageArray[currentIndex];
        var text = descriptions[currentIndex];
        var url = urls[currentIndex];
        var alt = alts[currentIndex];
        changeBkPromoAccs(img, text, url, currentIndex,alt);
        //timerID = setTimeout("fTimer()", 6000);
    }
    function next()
    {
        //clearTimeout(timerID);
        var index = currentIndex + 1;
        if (index ===<%=i%>)
        {
            index = 0;
        }
        if (index < 0)
        {
            index = <%=i%> - 1;
        }
        currentIndex = index;

        var img = imageArray[currentIndex];
        var text = descriptions[currentIndex];
        var url = urls[currentIndex];
        var alt = alts[currentIndex];
        //clearTimeout(timerID);
        changeBkPromoAccs(img, text, url, currentIndex,alt);
        //timerID = setTimeout("fTimer()", 6000);
    }
    function back()
    {
        //clearTimeout(timerID);
        var index = currentIndex - 1;
        if (index ===<%=i%>)
        {
            index = 0;
        }
        if (index < 0)
        {
            index = <%=i%> - 1;
        }
        currentIndex = index;
        var img = imageArray[currentIndex];
        var text = descriptions[currentIndex];
        var url = urls[currentIndex];
        var alt = alts[currentIndex];
        changeBkPromoAccs(img, text, url, currentIndex,alt);
        //timerID = setTimeout("fTimer()", 6000);
    }
    function fTimer() {

        var index = currentIndex + 1;
        if (index ===<%=i%>)
        {
            index = 0;
        }
        if (index >= 0 & index <<%=i%>)
        {
            currentIndex = index;
            //timerID = setTimeout("fTimer()", 6000);
            //TabbedPanels1.showPanel(index);            
        }
        var img = imageArray[currentIndex];
        var text = descriptions[currentIndex];
        var url = urls[currentIndex];
        var alt = alts[currentIndex];
        changeBkPromoAccs(img, text, url, currentIndex,alt);
    }
    //timerID = setTimeout("fTimer()", 6000);
    /*TabbedPanels1.onTabClick = function(e, tab)
     {
     clearTimeout(timerID);
     TabbedPanels1.showPanel(tab);
     return TabbedPanels1.cancelEvent(e);
     }*/
-->

</script>