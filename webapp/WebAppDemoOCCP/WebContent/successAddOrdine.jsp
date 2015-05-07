<%@ page language="java" contentType="text/html; charset=ISO-8859-1"  
    pageEncoding="ISO-8859-1"%>  
<%@taglib uri="/struts-tags" prefix="s"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
<head>  

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">  
<link rel="stylesheet" href="css/styleDemoOCCP.css" type="text/css"/>
<title>login Successful</title>  
</head>  


<body>
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


<s:form  cssClass="centerTable" action="">
<%--   <s:submit cssClass= "menusubmit" name="modifyUserData" title="modifyUserData" value="Modifica Dati Personali" action="modifyUserData" />  --%>
<%--      <s:submit cssClass= "menusubmit" value="Riepilogo Ordini" action="riepilogoOrdine"/>  --%>
<%--    	 <s:submit cssClass= "menusubmit" name="logoutUtente" title="logoutUtente" value="Logout" action="logoutUtente" />  --%>
<!--      <br> -->
<!--         <br> -->
<!--            <br> -->
     <p align="center">  ORDINI INOLTRATI  <p>
 <table class="altrowstable" id="alternatecolor" align="center">
      <tr>
      	
      	 
         <th>ID_FATTURA</th>
         <th>IMPORTO </th>
         <th>DATA_EMISSIONE</th>
         <th>DATA_EVASIONE</th>
         <th>EVASO</th>
         <th>DETTAGLIO</th>
         
      </tr>
     
       <s:iterator value="ordiniByUser">	
     	<tr>

     	 	<td><s:property value="id_fattura"/></td>
            <td><s:property value="importo"/></td>
            <td><s:property value="data_emissione"/></td>
            <td><s:property value="data_evasione"/></td>
          
          	<td>
	          	<s:if test="%{#evaso=='0'}">
			 		NON EVASO
				</s:if>
          
		        <s:else>
		   			EVASO
				</s:else>
		          	
          	</td>
          	<td>
          	
          	<s:url value="dettaglioOrdine" var="urlTag">
          	 <s:param name="idOrdine" value="%{id_fattura}" />
          	</s:url>
          <s:a href="%{urlTag}">DETTAGLIO</s:a>
          	</td>
          	
           </tr>
      </s:iterator>	
      </table>
  <br>
        <br>
 </s:form>

 <s:include value="/pages/up.jsp"></s:include>
</body>  
</html>  