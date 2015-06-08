/**************************/
// RESPONSIBILITIES:
// let quote supervisor approve/reject or set as incomplete a quote
/* Last Modifies:
 * 
 * Todo:
 * 
 * 1) (common) recover belief-base and clear dangerous predicates
 *
 * Bugs:  
 * 
*/
/**************************/

{ include( "role/department_employee_activity.asl" ) }


/* supervise_doc capability descriptions */
agent_capability(supervise_doc)[type(simple),type(http_interaction)].
capability_precondition(supervise_doc, condition( and( [available(doc,attachment),refined(doc)] ) ) ).
capability_postcondition(supervise_doc, condition( or( [approved(doc),rejected(doc),incomplete(doc)] ) ) ).
capability_cost(supervise_doc,0).
capability_evolution(supervise_doc,[add( approved(doc) ),add( rejected(doc) ),add( incomplete(doc) )]).

http_interface(supervise_doc,request_page,"access_to_supervise_doc","manager_quote_interface").
http_interface(supervise_doc,request_result,"accept_doc_event","manager_quote_interface").
http_interface(supervise_doc,request_result,"reject_doc_event","manager_quote_interface").
http_interface(supervise_doc,request_result,"torevise_doc_event","manager_quote_interface").



!debug_awake.

//!awake.

+!debug_awake 
	<- 
		!create_or_use_HTML_interface("manager_quote_interface","ids.artifact.HTMLSupervisorInterface",Id);
		!debug_employee; 
	.


/* supervise_doc capability implementations */
+!register_page(supervise_doc, Context )
	<- 
		!get_data_value(doc,Doc,Context);
		.concat("Supervise Document ",Doc,ServiceDescription);
		!standard_register_HTTP_page(supervise_doc, ServiceDescription, Context );
	.
+!generate_html_request_page(supervise_doc, Path, ParamSet, Context, ReturnHtml)
	:
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams)
	<-
		Context = project_context(Department,Session);
		!get_data_value(doc,Doc,Context);
		.my_name(Me);
		generatePageQuoteSupervisor(ReturnHtml,Me,UserName,UserRole,Session,Doc,"accept_doc_event","reject_doc_event","torevise_doc_event");
	.	
+!action(supervise_doc, "accept_doc_event", UserName, UserRole, HTTPParams, Context)
	<-
		!register_statement( approved(doc), Context);
	.
+!action(supervise_doc, "reject_doc_event", UserName, UserRole, HTTPParams, Context)
	<-
		!register_statement( rejected(doc), Context);
	.
+!action(supervise_doc, "torevise_doc_event", UserName, UserRole, HTTPParams, Context)
	<-
		!register_statement( incomplete(doc), Context);
	.
+!generate_html_result_page(supervise_doc, Path, ParamSet, Context, ReturnHtml)
	<-
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams);
		.my_name(Me);
		generatePageWorkNotification(ReturnHtml,Me,Session,UserName,UserRole);
	.	
+!unregister_page(supervise_doc, Context )
	<- 
		!standard_unregister_HTTP_page(supervise_doc, Context );
	.



/* Plans */

+!awake : true 
	<- 
		.println("hello");
		
		!create_or_use_HTML_interface("manager_quote_interface","ids.artifact.HTMLSupervisorInterface",Id);
		
		!awake_as_employee; 
	.
