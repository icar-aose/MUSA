/**************************/
// RESPONSIBILITIES:
// get QUOTE request from customer
// notify result to customer
/* Last Modifies:
 * 
 * Todo:
 * 	- spostare !find_parameter_by_name 
 * Bugs:  
 * 
 */
/**************************/

{ include( "role/department_employee_activity.asl" ) }
{ include( "role/project_manager_activity.asl" ) }
{ include( "peer/capability_lifecycle.asl" ) }
{ include( "peer/common_context.asl" ) }
{ include( "peer/simulation.asl" ) }


/* receive_doc capability descriptions */
agent_capability(receive_doc)[type(simple),type(http_interaction)].
capability_precondition(receive_doc, condition( true ) ).
capability_postcondition(receive_doc, condition( message_in(doc,customer) ) ).
capability_cost(receive_doc,0).
capability_evolution(receive_doc,[add(message_in(doc,customer)), add( available(doc) ), add(unclassified(doc))]).
http_interface(receive_doc,request_page,"new_doc_page","customer_quote_interface").
http_interface(receive_doc,request_result,"new_quote_event","customer_quote_interface").
	

/* notify_doc capability descriptions */
agent_capability(notify_doc)[type(simple),type(service)].
capability_precondition(notify_doc, condition( approved(doc) ) )[ parlist([par(msg,string), par(msg_code,int)]) ].
capability_postcondition(notify_doc, condition( notified(doc,customer) ) ).
capability_cost(notify_doc,0).
capability_evolution(notify_doc,[add( notified(doc,customer) )]).

my_user(luca,customer).
my_user(mario,customer).

!awake.

/* Agent awakes */
+!awake 
	<- 
		.println("hello");

		!create_or_use_HTML_interface("customer_quote_interface","ids.artifact.HTMLCustomerInterface",Id);
		!awake_as_employee; 
	.


/* receive_doc capability implementations */
+!register_page(receive_doc, Context )
	<- 
		.println("register receive_doc");
		!standard_register_HTTP_page(receive_doc, "Add New Document ", Context );
	.
+!generate_html_request_page(receive_doc, Path, ParamSet, Context, ReturnHtml)
	<-
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams);
		.my_name(Me);
		generateQuoteRequest(ReturnHtml,Me,Session,UserName,UserRole,"new_quote_event");
	.	
+!action(receive_doc, Path, UserName, UserRole, HTTPParams, Context)
	:
		HTTPParams=[param(doc,DocId)]
	<-
		!register_data_value(doc,DocId,Context);
		// check if the received document is valid
		!register_statement( available(doc), Context);
		!register_statement( unclassified(doc), Context);
		!register_statement( message_in(doc,customer), Context);
	.
+!generate_html_result_page(receive_doc, Path, ParamSet, Context, ReturnHtml)
	<-
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams);
		.my_name(Me);
		generateQuoteReply(ReturnHtml,Me,Session,UserName,UserRole);
	.	
+!unregister_page(receive_doc, Context )
	<- 
		!standard_unregister_HTTP_page(receive_doc, Context );
	.


/* notify_doc capability implementations */
+!prepare(notify_doc, Context) 
	<-
		true
	.
	
+!action(notify_doc, Context) 
	<-
		!get_data_value_simulated(msg, Msg, Context);
		!get_data_value_simulated(msg_code, MsgCode, Context);
		
		.print("->msg: '",Msg,"'");
		.print("->msg_code: '",MsgCode,"'");
	.

+!terminate(notify_doc, Context)
	<-
		!register_statement( notified(doc,customer), Context);
	.