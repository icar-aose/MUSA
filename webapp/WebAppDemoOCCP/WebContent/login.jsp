
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page session="true"   %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/styleDemoOCCP.css" type="text/css"/>
<head>  
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">  
<title>Login Page</title>  
<s:include value="/pages/top.jsp"></s:include>
 </head>  
<body >  



<s:div  cssClass="center">
<br>
<br>
<s:form  cssClass="center" action="LoginAction" >  
    <s:textfield name="userName" label="User Name" />  
    <s:password name="password" label="Password" />  
    <s:submit action="Login"  align="center"  value="Login"/> 
<%--    	<s:submit action="Registrati"   value="Registrati" align="center"/>  --%>

</s:form>  

 <a href="utente.jsp">Registrati</a> 
 <br>
 <br>
 
  </s:div>
   <s:include value="/pages/up.jsp"></s:include>
</body>  
</html>