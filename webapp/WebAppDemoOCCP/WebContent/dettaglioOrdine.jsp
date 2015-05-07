<%@ page language="java" contentType="text/html; charset=ISO-8859-1"  
    pageEncoding="ISO-8859-1"%>  
<%@taglib uri="/struts-tags" prefix="s"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
<head>  

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">  
<link rel="stylesheet" href="css/styleDemoOCCP.css" type="text/css"/>
<title>DETTAGLIO ORDINE</title>  
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

<div align="center">

 
  <br>
<s:form cssClass="centerTable" action="">
<%--  <s:submit cssClass= "menusubmit" name="modifyUserData" title="modifyUserData" value="Modifica Dati Personali" action="modifyUserData" />  --%>
<%--  <s:submit cssClass= "menusubmit" value="Riepilogo Ordini" action="riepilogoOrdine"/>  --%>
<%--  <s:submit cssClass= "menusubmit" name="logoutUtente" title="logoutUtente" value="Logout" action="logoutUtente" />  --%>
<!--      <br> -->
<!--         <br> -->
         <p align="center">   ELENCO DEI PRODOTTI PRESENTI NELL'ORDINE <p>
      <br>
 <table class="altrowstable" id="alternatecolor" align="center">
      <tr>
      	
      	 
         <th>ID_PRODOTTO</th>
         <th>DENOMINAZIONE </th>
         <th>DESCRIZIONE</th>
         <th>DISPONIBILITA'</th>
         <th>PREZZO</th>
         <th>TIPOLOGIA</th>
<!--          <td>INDICE'</td> -->
         <th>QUANTITA'</th>
         
      </tr>
     
       <s:iterator  status="prodottiInDettaglioOrdine" value="prodottiInDettaglioOrdine">	
     	<tr>

     	 	<td><s:property value="id"/></td>
            <td><s:property value="denominazione"/></td>
            <td><s:property value="descrizione"/></td>
            <td><s:property value="disponibilita"/></td>
          	<td><s:property value="prezzo"/></td>
          	<td><s:property value="tipologia"/></td>
<%--           <td><s:property value="%{#prodottiInDettaglioOrdine.index}"/></td> --%>
          	<td><s:property value="quantitaDettaglioOrdineList[	#prodottiInDettaglioOrdine.index]"/></td>
          	
           </tr>
      </s:iterator>	
      </table>
  <br>
        <br>
 </s:form>
 </div>
 <s:include value="/pages/up.jsp"></s:include>
</body>  
</html>  