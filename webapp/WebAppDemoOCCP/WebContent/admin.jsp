
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page session="true"   %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/styleDemoOCCP.css" type="text/css"/>
<title>PAGINA DI AMMINISTRAZIONE</title>
<s:head />
</head>

<body>
<s:include value="/pages/top.jsp"></s:include>
<%--    <s:form action="addUtente"> --%>

<%--    <s:textfield name="nome" label="Nome"/> --%>
<%--    <s:textfield name="cognome" label="Cognome"/> --%>
<%--    <s:textfield name="email" label="Email"/> --%>
<%--    <s:textfield name="telefono" label="Telefono"/> --%>
<%--     <s:textfield name="partitaIVA" label="PartitaIVA"/> --%>
<%--    <s:submit/> --%>
<!--    <hr/> -->
  
<%--    </s:form> --%>


<s:div  cssClass="center">
<s:form  cssClass="center" action="" >
   PAGINA DI AMMINISTRAZIONE
   
   <br>
     <s:submit name="modifyUserData" title="modifyUserData" value="Modifica Dati Personali" action="modifyUserData" align="center"/> 
     <s:submit name="logoutUtente" title="logoutUtente" value="Logout" action="logoutUtente" align="center"/> 
  
   <br>
    <table class="altrowstable" id="alternatecolor" align="center">
      <tr>
      	
      	 <td>Elimina</td>
<!--          <td>Id</td> -->
         <td>Denominazione</td>
         <td>Descrizione</td>
         <td>Quantità diponibile</td>
         <td>Prezzo</td>
         <td>Tipologia</td>
        
         
      </tr>
     
       <s:iterator value="prodottiToModify">	
     	<tr>

		<td><input type="button" /></td>
<%-- 			<td><s:submit value='<s:property value="id"/>' action="deleteProdottoInOrdine">ELINIMA</s:submit></td> --%>
	
	
<!-- 	<td><input type="text" name="id" value=<s:property value="id" /> /></td> -->
	<td><input type="text" name="denominazione" value=<s:property value="denominazione"/> /></td>
	<td><input type="text" name="descrizione" value=<s:property value="descrizione"/> /></td>
	<td><input type="text" name="disponibilita" value=<s:property value="disponibilita"/> /></td>
	<td><input type="text" name="prezzo" value=<s:property value="prezzo"/> /></td>
	<td><input type="text" name="tipologia" value=<s:property value="tipologia"/> /></td>
	
<%--      	 	<td><s:textfield value="id" key="id"/></td> --%>
<%--             <td><s:textfield value="denominazione" key="denominazione"/></td> --%>
<%--             <td><s:textfield value="descrizione" key="descrizione"/></td> --%>
<%--             <td><s:textfield value="quantita_diponibile" key="quantita_diponibile"/></td> --%>
<%--           	<td><s:textfield value="prezzo" key="prezzo"/></td> --%>
<%--           	<td><s:textfield value="tipologia" key="tipologia"/></td> --%>
          	
      </s:iterator>	
       </table>
       <br>
       <br>
      <s:submit value="Accetta Modifiche" action="modifyProducts" align="center"/> 
      <br>
       <br>
      </s:form>
      
    <s:form action="listProdotti">
   
    <table class="altrowstable" id="alternatecolor" align="center">
      <tr>
      	
      	 <td>Seleziona</td>
         <td>Id</td>
         <td>Denominazione</td>
         <td>Descrizione</td>
         <td>Quantità diponibile</td>
         <td>Prezzo</td>
         <td>Tipologia</td>
         
      </tr>
      <s:iterator value="prodotti">	
     	<tr>
     	 <td>
<%--      	 <s:checkbox name="prodottoSelezionato" fieldValue=<s:property value='id'/> label="select" class="checkbokStruts"/> --%>
            <input type="checkbox" name="prodottoSelezionato" value=<s:property value="id"/> /> select
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
  	 <s:submit name="Modifica prodotti " title="Aggiungi prodotti all'ordine" value="Modifica Prodotti" action="addProdottiToModify" align="center"> </s:submit>  
   <br>
<%--     <s:submit name="Show All Products" title="Show All Products" value="Mostra tutti i Prodotti" action="listProdottiModify" align="center"> </s:submit> --%>
    </s:form>
    </s:div>
<%--      <s:submit name="modifyUserData" title="modifyUserData" value="Modifica Dati Personali" action="modifyUserData" align="center"/>  --%>
<!--   <a href="datiPersonali.jsp">MODIFICA DATI PERSONALI</a>  -->
<s:include value="/pages/up.jsp"></s:include>
</body>

</html>