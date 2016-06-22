<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.ResourceSubType"%>

<%   
    WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
    WebPage wp = (WebPage) request.getAttribute("webpage");
    
    String wpName= wp.getTitle();
    String imgName= wp.getIconClass();
    
%>


<!-- Teaser START -->
<div class="section-teaser" style="background-image: url(/work/models/cima/plantillav2/img/teasers/<%=imgName%>); ">
    <div class="teaser-inner">
        <h2><%=wpName%></h2>
    </div>
</div>
<!-- Teaser END -->