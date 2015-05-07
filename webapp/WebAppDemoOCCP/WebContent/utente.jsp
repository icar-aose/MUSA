
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page session="true"   %>
<jsp:useBean id="utente" class="cnr.icar.db.hibernate.Utente"  scope="session" /> 
<jsp:useBean id="utenteDAO" class="cnr.icar.db.hibernate.UtenteDAO"  scope="session" /> 
<%-- <jsp:setProperty name="utente" property="infocloud" value=""/> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/styleDemoOCCP.css" type="text/css"/>
<head>  
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">  
<title>NUOVO UTENTE</title>  

 </head>  
<body>
<s:include value="/pages/top.jsp"></s:include>
 <s:include value="/pages/menu.jsp"></s:include> 

<%--  <s:div  cssClass="menu"> --%>
<%--  <s:form   action="" >   --%>
<%-- <s:submit  name="nuovoOrdine" title="nuovo ordine" value="Nuovo Ordine" action="ordineSubmit" />  --%>
<%-- <s:submit  value="Riepilogo Ordini" action="riepilogoOrdine"/>  --%>
<%-- <s:submit  name="modifyUserData" title="modifyUserData" value="Modifica Dati Personali" action="modifyUserData" />  --%>
<%-- <s:submit name="logoutUtente" title="logoutUtente" value="Logout" action="logoutUtente" />  --%>
<%-- </s:form>  --%>
<%--  </s:div> --%>
<s:div  cssClass="center">
<%-- <s:action name="updateInfoCloudAction"  /> --%>
<%--   <s:elseif test="%{#parameters.code}"> --%>
<!-- 	pippo -->
	
		
<%-- 	</s:elseif> --%>
<%-- 	<s:else> --%>
<!--  		 plutos -->
<%-- 	</s:else> --%>
<%-- 	<s:property value="#session.cloudInfo" /> --%>
<s:form  cssClass="center" action="modifyUserData" >  

<p align="center">FORM DATI UTENTE<p>
  	<s:textfield name="nome" label="Nome" />  
    <s:textfield name="cognome" label="Cognome" />  
    <s:textfield name="email" label="Email" />  
    <s:textfield name="partitaIVA" label="PartitaIVA" />  
   	<s:textfield name="telefono" label="Telefono" />  
    <s:textfield name="infocloud" label="Infocloud" />  
    <s:textfield name="username" label="User Name" />  
    <s:password name="password" label="Password"  showPassword="true" />  
<%--     <s:label for="amministratore">Amministratore</s:label> --%>
    <s:checkbox name="amministratore" value="amministratore" label="Amministratore" fieldValue="true" ></s:checkbox>
    <s:if test='<s:property value="#session.cloudInfo" />'>
<!--    You have a cloud property setted  -->

     <s:checkbox name="cloudInfo" value="true" label="Informazioni Cloud Inserite" fieldValue="true" ></s:checkbox>
    
  </s:if>
 <s:else>
<!--    No info Cloud  for User -->
</s:else>
     <% 
   // String access_token = request.getParameter("code");
   //  out.println("access_token "+ access_token);
     
//      if(access_token!=null){
//  	 out.println(" UTENTE SESSION ID--_>");%>

<%-- <s:property value="#session.idCliente" />  --%>


<%--     	 <%  --%>
    
<!-- //     	 //inserire il dato nel database -->
<!-- //     	utente= utenteDAO.getUtenteById(Integer.parseInt(session.getAttribute("idCliente").toString())); -->
<!-- //     	out.println(" UTENTE ID IF--_>"+utente.getId()); -->
<!-- //     	  utente.setInfocloud(access_token); -->
<!-- //     	  utenteDAO.updateUtente(utente); -->
<!-- //     	 out.println("InfoCLUD UTENTE IN IF--_>"+utente.getInfocloud()); -->
    	 
<%--      %> --%>
<%--      <s:checkbox name="servizioCloud" value="servizioCloud" label="Servizio Cloud Attivo" fieldValue="true" ></s:checkbox> --%>
<%--     <%  --%>
<!-- //      } -->
<!-- //      else{ -->
   
<!-- //     	 out.println("InfoCLUD UTENTE IN ELSE--_>"+utente.getInfocloud()); -->
<%--      %> --%>
<%--      <s:checkbox name="servizioCloud" value="servizioCloud" label="Servizio Cloud Attivo"  ></s:checkbox> --%>
<%--     <%  --%>
<!-- //     } -->
<!--      if( session.getAttribute("idCliente") !=null){ -->
<!--     %> -->
<%--     <s:submit action="Registrati"  align="center"  value="Invia Dati"/>  --%>
<%-- <%--    	<s:submit action="Registrati"   value="Registrati" align="center"/>  --%>
<%-- <%}else{ %> --%>
  <s:submit action="updateUserData"  align="center"  value="Aggiorna"/> 
<%-- <%} %> --%>
</s:form>  
<!--   <a href="https://www.dropbox.com/1/oauth2/authorize?client_id=bpg9o57qlu9w0j0&response_type=code&redirect_uri=http://localhost:8080/LoginStruts2/utente.jsp">CONNETTI SERVIZIO CLOUD</a> -->
  <br>
   <br>
   <div id="cloudLink">
  <a href="https://www.dropbox.com/1/oauth2/authorize?client_id=bpg9o57qlu9w0j0&response_type=code&redirect_uri=https://194.119.214.121:8080/WebAppDemoOCCP/utente.jsp">CLOUD LINK</a>
  </div>
   <br>
   <br>
  </s:div>
  
  
 
<!--     <table class="altrowstable" id="alternatecolor" align="center"> -->
<!--       <tr> -->
      	
<!--          <td>Nome</td> -->
<!--          <td>Cognome</td> -->
<!--          <td>Email</td> -->
<!--          <td>Telefono</td> -->
<!--          <td>PartitaIVA</td> -->
<!--          <td>Username</td> -->
<!--          <td>Password</td> -->
<!--       </tr> -->
<%--       <s:iterator value="utenti">	 --%>
<!--          <tr> -->
<%--             <td><s:property value="nome"/></td> --%>
<%--             <td><s:property value="cognome"/></td> --%>
<%--             <td><s:property value="email"/></td> --%>
<%--             <td><s:property value="telefono"/></td> --%>
<%--           	<td><s:property value="partitaIVA"/></td> --%>
<%--           	 <td><s:property value="username"/></td> --%>
<%--           	<td><s:property value="password"/></td> --%>
<!--            </tr> -->
<%--       </s:iterator>	 --%>
<!--    </table> -->
<s:include value="/pages/up.jsp"></s:include>
</body>
</html>