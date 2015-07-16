///**************************/
// RESPONSIBILITIES:
// 
/* Last Modifies:
 * 
 * Todo:
 * 
 * Bugs:  
 * 
*/
/**************************/

{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }


/* Plans */

+!awake 
	: 
		execution(deployment) 
	<- 
		!start_proxy_server;
	.
+!awake 
	: 
		execution(standalone) 
	<- 
		!start_proxy_server;
	.
+!awake 
	: 
		execution(test) 
	<- 
		?simulated_request_delay(Delay);
		.wait(Delay);
		!simulate_quote_request;
	.

/**
 * This event is triggered when a jason goal pack is remotely 
 * injected into MUSA system from the web GUI.
 */	
+remote_goal_pack_injected
	<-
		get_received_goals(RemoteGoalPack);
		?boss(BossAgent);
		.send(BossAgent, achieve, injectJasonPack(RemoteGoalPack));	
		
		.abolish(remote_goal_pack_injected);
	.

+!simulate_occp_request(ParamList)
	<-
		!create_or_use_database_artifact(Id1);
		focus(Id1);
		
		?clearDatabase(ClearDB);
		if(ClearDB)
		{
			clear;	
		}
		Session = "p4_dept";
		User = user("luca","occp_user");
		
		.print("~~~ simulating request ~~~");
		!forward(worker,"access_to_order",paramset(Session,User,ParamList),HTML1);
 	.

/*
 * SIMULATE USER INTERACTION SCENARIO
 */
 +!simulate_occp_request
	<-
		!create_or_use_database_artifact(Id1);
		focus(Id1);
		?clearDatabase(ClearDB);
		if(ClearDB)
		{
			clear;	
		}
		Session = "p4_dept";
		User = user("luca","occp_user");
		
		.wait(9000);
		!forward(worker,"access_to_order",paramset(Session,User,[param(user_message,"Fallito"),param(userAccessToken,"poS0fEDTJ1AAAAAAAAAAPlo48ljrLSP-uRtjHE2zva9z3yY1rH9SsFkOXYwefliR"),param(idOrder,"0"),param(mailUser,"musa.customer.service@gmail.com"),param(idUser,"116")]),HTML1);
	.
 
+!simulate_quote_request
	<-
		/* for testing purpose */
		!create_or_use_database_artifact(Id1);
		focus(Id1);
		
		?clearDatabase(ClearDB);
		if(ClearDB)
		{
			clear;	
		}		
		
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
//		!forward(worker,"access_to_order",paramset(Session,User,[param(idOrder,1111),param(idUser,116)]),HTML1);

		!forward(worker,"access_to_order",paramset(Session,User,[param(idOrder,1111),param(idUser,116),param(mailUser,"musa.customer.service@gmail.com"),param(user_message,"Fallito"),param(userAccessToken,"")]),HTML1);
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

+changed_database_configuration
	<-
		?boss(Boss);
		.send(Boss, achieve, updateLocalHost);
		
		.abolish(changed_database_configuration);
	.

+request_for_musa_status
	<-
		?boss(Boss);
		.send(Boss, askOne, musa_status(_), Reply);
		
		if (Reply \== false)
		{
			Reply = musa_status(Status)[source(Boss)];
			reply_with_musa_status(Status);
		}
		
		.abolish(request_for_musa_status);
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

/**
 * [davide]
 * 
 * Event triggered when the proxy agent receive a request of capability failure. The
 * request is forwarded to the boss agent.
 * 
 */
+submitCapabilityFailure(CapName)
	<-
		?boss(Boss);
		.send(Boss, tell, submitCapabilityFailure(CapName));
		.abolish( submitCapabilityFailure(CapName) );
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
//		.wait(50000);
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
