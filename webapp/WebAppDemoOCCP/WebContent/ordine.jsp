
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/styleDemoOCCP.css" type="text/css"/>
<script type="text/javascript" src="js/script.js"></script>
<title>Nuovo Ordine</title>
<s:head />
</head>

<body >
<s:include value="/pages/top.jsp"></s:include>
 <s:include value="/pages/menu.jsp"></s:include> 
<%--    <s:form action="addUtente"> --%>
  
<%--    <s:textfield name="nome" label="Nome"/> --%>
<%--    <s:textfield name="cognome" label="Cognome"/> --%>
<%--    <s:textfield name="email" label="Email"/> --%>
<%--    <s:textfield name="telefono" label="Telefono"/> --%>
<%--     <s:textfield name="partitaIVA" label="PartitaIVA"/> --%>
<%--    <s:submit/> --%>
<!--    <hr/> -->
  
<%--    </s:form> --%>
<%-- <s:div id="menu"> --%>
<%--  <s:submit cssClass= "menusubmit" name="modifyUserData" title="modifyUserData" value="Modifica Dati Personali" action="modifyUserData" align="center"/>  --%>
<%--  <s:submit cssClass= "menusubmit" name="logoutUtente" title="logoutUtente" value="Logout" action="logoutUtente" align="center"/>  --%>
<!--  <a href="/">Link3</a>  -->
<!--  <a href="/">Link 4</a>  -->
<%--  </s:div>  --%>

<s:div  cssClass="centerTable">
<s:form  cssClass="centerTable" action="">
<%-- <s:div cssClass="menu"> --%>
<%--      <s:submit cssClass= "menusubmit" name="modifyUserData" title="modifyUserData" value="Modifica Dati Personali" action="modifyUserData" />  --%>
<%--      <s:submit cssClass= "menusubmit" value="Riepilogo Ordini" action="riepilogoOrdine"/>  --%>
<%--    	 <s:submit cssClass= "menusubmit" name="logoutUtente" title="logoutUtente" value="Logout" action="logoutUtente" />  --%>
<%--   </s:div>  --%>
<br>
    <table class="altrowstable" id="alternatecolor" align="center">
      <tr>
      	
      	 <th>Elimina</th>
         <th>Id</th>
         <th>Denominazione</th>
         <th>Descrizione</th>
         <th>Quantità diponibile</th>
         <th>Prezzo</th>
         <th>Tipologia</th>
         <th>Quantità</th>
         
      </tr>
     
       <s:iterator value="prodottiInOrdine">	
     	<tr>

<!-- 		<td><input type="button" /></td> -->
<%-- 			<td><s:submit  cssClass="submitCss2" value="ELINIMA" action="deleteProdottoInOrdine"></s:submit></td> --%>
	<td><input type="checkbox" name="prodottoSelezionatoElimina" value=<s:property value="id"/> /> Elimina</td>
<!--      	 	<td><img src='img/delete.png' onclick='' width='20' height='20' /><td> -->
   
     	 	<td><s:property value="id"/></td>
            <td><s:property value="denominazione"/></td>
            <td><s:property value="descrizione"/></td>
            <td><s:property value="disponibilita"/></td>
          	<td><s:property value="prezzo"/></td>
          	<td><s:property value="tipologia"/></td>
          	<td>
          	 <input type="text" name="quantitaOrdinata" />
          	 </td>
           </tr>
      </s:iterator>	
       </table>
       <br>
       <br>
      <s:submit value="Conferma Ordine" action="addOrdine" align="center"/> 
        <s:submit name="Elimina prodotti dall'ordine" title="Elimina prodotti dall'ordine" value="Elimina prodotti dall'ordine" action="deleteProdottiInOrdine" align="center"> </s:submit>  
      <br>
       <br>
      </s:form>
      
    <s:form action="listProdotti">
   
    <table class="altrowstable" id="alternatecolor" align="center">
      <tr>
      	
      	 <th>Seleziona</th>
         <th>Id</th>
         <th>Denominazione</th>
         <th>Descrizione</th>
         <th>Quantità diponibile</th>
         <th>Prezzo</th>
         <th>Tipologia</th>
         
      </tr>
      <s:iterator value="prodotti">	
     	<tr>
     	 <td>
<%--      	 <s:checkbox name="prodottoSelezionato" fieldValue=<s:property value='id'/> label="select" class="checkbokStruts"/> --%>
            <input type="checkbox" name="prodottoSelezionato" value=<s:property value="id"/> />seleziona
        </td>
     	 	<td><s:property value="id"/></td>
            <td><s:property value="denominazione"/></td>
            <td><s:property value="descrizione"/></td>
            <td><s:property value="disponibilita"/></td>
          	<td><s:property value="prezzo"/></td>
          	<td><s:property value="tipologia"/></td>
           </tr>
      </s:iterator>	
   </table>
  <br>
  	 <s:submit name="Aggiungi prodotti all'ordine" title="Aggiungi prodotti all'ordine" value="Aggiungi prodotti all'ordine" action="addProdottiInOrdine" align="center"> </s:submit>  
  	
   <br>
<%--     <s:submit name="Show All Products" title="Show All Products" value="Mostra tutti i Prodotti" action="listProdotti" align="center"> </s:submit> --%>
   
    </s:form>
 </s:div>
 <s:include value="/pages/up.jsp"></s:include>
</body>

</html>