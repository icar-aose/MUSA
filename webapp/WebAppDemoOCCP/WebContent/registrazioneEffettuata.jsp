
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/styleDemoOCCP.css" type="text/css"/>
<script type="text/javascript" src="tableStyle.js"></script>
<title>Nuovo Utente Page</title>  

 </head>  
<body >
<s:include value="/pages/top.jsp"></s:include>
<s:include value="/pages/menu.jsp"></s:include>
<s:div  align="center">

<!--    ATTIVARE IL LINK SOLO SE ESISTE utente in sessione -->
<!--   <a href="ordine.jsp">AGGIUNGI UN NUOVO ORDINE</a> -->
<%--    <s:submit value="Nuovo Ordine" align="center" action="newOrdine"/> --%>
   
   </s:div>
   <br>
   <br>
    <table class="altrowstable" id="alternatecolor" align="center">
      <tr>
      	
         <th>Nome</th>
         <th>Cognome</th>
         <th>Email</th>
         <th>Telefono</th>
         <th>PartitaIVA</th>
         <th>Username</th>
         <th>Password</th>
      </tr>
      <s:iterator value="utenti">	
         <tr>
            <td><s:property value="nome"/></td>
            <td><s:property value="cognome"/></td>
            <td><s:property value="email"/></td>
            <td><s:property value="telefono"/></td>
          	<td><s:property value="partitaIVA"/></td>
          	 <td><s:property value="username"/></td>
          	<td><s:property value="password"/></td>
           </tr>
      </s:iterator>	
   </table>
   <s:include value="/pages/up.jsp"></s:include>
</body>
</html>