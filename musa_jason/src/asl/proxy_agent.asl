/**************************/
// RESPONSIBILITIES:
// 
/* Last Modifies:
 * 
 * Todo:
 * MODIFICARE l'INTERFACCIA CON TOMCAT ADEGUANDOLA ALLA SIMULAZIONE
 *
 * Bugs:  
 * 
*/
/**************************/

{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }

!awake.

/* Plans */

+!awake : execution(deployment) 
	<- 
		!start_proxy_server;
	.
+!awake : execution(test) 
	<- 
//		!start_proxy_server;
		.wait(9000);
		.print("---------------SIMULATING REQUEST---------------");
		!simulate_quote_request;
	.


/*
 * SIMULATE USER INTERACTION SCENARIO
 */
+!simulate_quote_request
	<-
		/* for testing purpose */
		
		.println("clear database");
		!create_or_use_database_artifact(Id1);
		focus(Id1);
//		clear;
		
		
		.println("start simulation");
		
		
		// user load page for send quote_request
		
		/*Session = "doc_management_dept";
		User = user("luca","customer");
		DocNumber = 100;*/
		
		//!forward(ids_customer,"request_doc_to_customer",paramset(Session,User,[]),HTML1);
		//.println(HTML1);
		//.wait(1000);

		/*.println("sending request_new_quote");
		!forward(ids_customer,"request_new_quote",paramset(Session,User,[param(doc,DocNumber)]),HTML2);
		.println(HTML2);*/

		/* 
		.wait(1500);
		.concat(Session,DocNumber,Project);
		getJob("customer_approval",ApproveAgent);
		.println("approval assigned to ",ApproveAgent);
		*/
		
		
		Session = "p4_dept";
		User = user("luca","occp_user");
		!forward(worker,"access_to_order",paramset(Session,User,[param(idOrder,1111),param(idUser,116)]),HTML1);
	.		


/*
 * HTTP PROXY AS SERVER
 */
+!start_proxy_server 
	<-
		!create_proxy_server_artifact(Id1);
		focus(Id1);
		
		!connect_proxy;
		occp.logger.action.info("[PROXY] proxy server ready. Running...");
		run_server;		/* proxy_server -> HTTPProxy artifact */
	.

+http_param(Id,Key,Value)  
	<- 
		.print("Key: ",Key," Value: ",Value);
		.term2string(KeyTerm,Key);
		
		+param(Id,KeyTerm,Value)
	.

/**
 * Plan triggered when receiving an http request from a client. The request is forwarded to a 
 * specified agent.
 */
+http_request(Id,Session,Agent,Service,UserName,Role)[artifact_name(_,"proxy_server")] 
	<-
		.term2string(AgentTerm,Agent);
		.println("receive HTTP request ",log(Id,Session,Agent,Service,UserName,Role));
		.findall( param(Key,Value), param(Id,Key,Value), Params );
 
		.abolish(param(Id,_,_));
		
		User = user(UserName,Role);
		
		!forward(Agent,Service,paramset(Session,User,Params),HTML);
		//id sessione + codice html es "OK"
		reply(Id,HTML);

		run_server;					/* proxy_server -> HTTPProxy artifact */
	.
-http_request(Id,Session,Agent,Service,User,Role)[artifact_name(_,"proxy_server")] 
	<-
		reply(Id,"500 error: something went wrong");	/* proxy_server -> HTTPProxy artifact */
		.abolish(param(Id,_,_));
		run_server;										/* proxy_server -> HTTPProxy artifact */
	.

+!forward(Agent,RequestPath,ParamSet,Reply)
	<-
		.print("[forward] sending ",request(RequestPath,ParamSet)," to ",Agent);
		.send( Agent, tell, request(RequestPath,ParamSet) );
		.wait(1000);
		.findall(HTML, response(RequestPath,ParamSet,HTML), List);
		!evaluate_reply(List,Reply);
		.abolish(html_response(RequestPath, ParamSet, _ ));
		.abolish(response(RequestPath, ParamSet, _ ));
		
		//TODO perchè questa attesa??
		.wait(50000);
	.

+html_response(RequestPath,ParamSet, HTML)
	<-
		.println("RECEIVED RESPONSE ",HTML);
		+response(RequestPath,ParamSet, HTML);
	.

+!evaluate_reply([A],A) : true <- true.
+!evaluate_reply([H|T],H) : true <- true.
+!evaluate_reply([],"agent error") : true <- true.


+!connect_proxy: true
  <- 
  	connect(A);
  	!test_connection(A);
  	.
+!test_connection("ok") : true <- true.
+!test_connection(A) : true
  	<- 
  		.wait(10);
     	!connect_proxy;
	.

