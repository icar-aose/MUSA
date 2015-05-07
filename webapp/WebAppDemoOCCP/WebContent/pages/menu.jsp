
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page session="true"   %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="table.css" type="text/css"/>
<head>  
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">  
<script type="text/javascript">

window.onload=function(){
	altRows('alternatecolor');
}
</script>
 </head>  
<body >  
 <s:div  cssClass="menu">
  <s:form  action="" >  
 

<s:submit cssClass="submitCss" name="ordineSubmit" title="nuovo ordine" value="Nuovo Ordine" action="ordineSubmit" /> 

<s:submit cssClass="submitCss" value="Riepilogo Ordini" action="riepilogoOrdine"/> 

<s:submit cssClass="submitCss" name="modifyUserData" title="modifyUserData" value="Modifica Dati Personali" action="modifyUserData" /> 

<s:submit cssClass="submitCss" name="logoutUtente" title="logoutUtente" value="Logout" action="logoutUtente" /> 


</s:form>
 </s:div>


 
<!--  <ul id="menuUL"> -->
<!--     <li class="active"><a href="ordini.jsp">Nuovo Ordine</a></li> -->
<!--     <li class="active"><a href="/">Riepilogo Ordini</a></li> -->
<!--     <li class="active"><a href="#">Modifica Dati Personali</a></li> -->

<!--     <li class="active"><a href="#">Logout</a></li> -->
<!-- </ul> -->

 <br>
  <br>
   <br>
    <br>
  <br>
</html>