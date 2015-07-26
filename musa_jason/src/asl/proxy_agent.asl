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
	: 	execution(deployment) 
	<- 
		!start_proxy_server;
	.
+!awake 
	: 	execution(standalone) 
	<- 
		!start_proxy_server;
	.
+!awake 
	: 	execution(test) 
	<- 
		?simulated_request_delay(Delay);
		.wait(Delay);
		!simulate_quote_request;
		
		
//		!start_proxy_server;
	.

/**
 * This event is triggered when a jason goal pack is remotely 
 * injected into MUSA system from the web GUI.
 */	
+remote_goal_pack_injected(Pack)
	<-
		?boss(BossAgent);
		.send(BossAgent, tell, injectJasonGoals(Pack));	
		
		.abolish(remote_goal_pack_injected);
	.

/*
 * SIMULATE USER INTERACTION SCENARIO
 */
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
		
		!forward(worker,"access_to_order",paramset(Session,User,[param(user_message,"Fallito"),param(userAccessToken,"poS0fEDTJ1AAAAAAAAAAPlo48ljrLSP-uRtjHE2zva9z3yY1rH9SsFkOXYwefliR"),param(idOrder,"0"),param(mailUser,"musa.customer.service@gmail.com"),param(idUser,"116")]),HTML1);
 	.
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
		!forward(worker,"access_to_order",paramset(Session,User,[param(user_message,"Fallito"),param(userAccessToken,"poS0fEDTJ1AAAAAAAAAAPlo48ljrLSP-uRtjHE2zva9z3yY1rH9SsFkOXYwefliR"),param(idOrder,"0"),param(mailUser,"musa.customer.service@gmail.com"),param(idUser,"116")]),HTML1);
	.		


/*
 * HTTP PROXY AS SERVER
 */
+!start_proxy_server 
	<-
		!create_or_use_proxy_server_artifact(Id1);
		focus(Id1);
		
		run_server;		/* proxy_server -> HTTPProxy artifact */
	.
	
	
+simulate_occp_request
	<-
		!simulate_occp_request;
		.abolish( simulate_occp_request );
	.

+update_database_configuration
	<-
		?boss(Boss);
		.send(Boss, achieve, updateLocalHost);
		
		.abolish(update_database_configuration);
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

+unsetCapabilityFailure(CapName)
	<-
		?boss(Boss);
		.send(Boss, tell, unsetCapabilityFailure(CapName));
		 
		.abolish( unsetCapabilityFailure(CapName) );
	.




/**
 * Forward a request to Agent
 */
+!forward(Agent,RequestPath,ParamSet,Reply)
	<-
		.print("[forward] sending ",request(RequestPath,ParamSet)," to ",Agent);
		.send( Agent, tell, request(RequestPath,ParamSet) );
//		.wait(1000);
//		.findall(HTML, response(RequestPath,ParamSet,HTML), List);
//		!evaluate_reply(List,Reply);
//		.abolish(html_response(RequestPath, ParamSet, _ ));
//		.abolish(response(RequestPath, ParamSet, _ ));
	.

+html_response(RequestPath,ParamSet, HTML)
	<-
		.println("RECEIVED RESPONSE ",HTML);
		+response(RequestPath,ParamSet, HTML);
	.

/**
 * [davide]
 * 
 * Inject a new capability implementation plans (that is, +!action, +!prepare and +!terminate plans).
 */
+inject_implementation_capability(Agent_owner, Prepare, Action, Terminate)
	<-
		.term2string(AgTerm, Agent_owner);
		.send(AgTerm, tell, inject_implementation_capability_plans(Prepare, Action, Terminate));
			
		.abolish( inject_implementation_capability(_,_,_,_) );
	.

/**
 * [davide]
 * 
 * Inject a new abstract capability
 */
+inject_abstract_capability(Agent_owner, Cap_name, Cap_type, Cap_params, Cap_pre, Cap_post, Cap_cost, Cap_evo)
	<-
		.term2string(AgTerm,Agent_owner);
		.term2string(CapTerm,Cap_name);
		.term2string(CapTypeTerm,Cap_type);
		.term2string(ParamsTerm,Cap_params);
		.term2string(CapPreTerm,Cap_pre);
		.term2string(CapPostTerm,Cap_post);
		.term2string(CapCostTerm,Cap_cost);
		.term2string(CapEvoTerm,Cap_evo);

		.send(AgTerm, tell, agent_capability(AgTerm,CapTerm)[type(CapTypeTerm)]);
		.send(AgTerm, tell, capability_parameters(CapTerm, ParamsTerm));
		.send(AgTerm, tell, capability_precondition(CapTerm, CapPreTerm));
		.send(AgTerm, tell, capability_postcondition(CapTerm, CapPostTerm));
		.send(AgTerm, tell, capability_cost(capTerm, CapCostTerm));
		.send(AgTerm, tell, capability_evolution(CapTerm, CapEvoTerm));
		
		.abolish( inject_abstract_capability(_,_,_,_,_,_,_,_) );
	.



+received_occp_billing_approval
	<-
		.send(order_manager, tell, billing_approved);
		.abolish( received_occp_billing_approval );
	.
	

//+!evaluate_reply([A],A).
//+!evaluate_reply([H|T],H).
//+!evaluate_reply([],"agent error").
