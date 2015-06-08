/**************************/
// RESPONSIBILITIES:
// let quote worker to elaborate/fix document
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



/* elaborate_doc capability descriptions */
agent_capability(elaborate_doc)[type(simple),type(http_interaction)].
capability_precondition(elaborate_doc, condition( and( [available(doc),classified(doc)]) ) ).
capability_postcondition(elaborate_doc, condition( and( [refined(doc),available(doc,attachment)] ) ) ).
capability_cost(elaborate_doc,0).
capability_evolution(elaborate_doc,[add( refined(doc) ),add( available(doc,attachment) )]).

http_interface(elaborate_doc,request_page,"access_to_doc","worker_quote_interface").
http_interface(elaborate_doc,request_result,"change_doc_event","worker_quote_interface").



/* fix_doc capability descriptions */
agent_capability(fix_doc)[type(simple),type(http_interaction)].
capability_precondition(fix_doc, condition( and( [available(doc,attachment),incomplete(doc)] ) ) ).
capability_postcondition(fix_doc, condition( and( [refined(doc),fixed(doc)] ) ) ).
capability_cost(fix_doc,0).
capability_evolution(fix_doc,[add( refined(doc) ),add( fixed(doc) )]).

http_interface(fix_doc,request_page,"access_to_fixdoc","worker_quote_interface").
http_interface(fix_doc,request_result,"fix_doc_event","worker_quote_interface").






!debug_awake.

//!awake.

+!debug_awake 
	<- 
		!create_or_use_HTML_interface("worker_quote_interface","ids.artifact.HTMLWorkerInterface",Id);
		!debug_employee; 
	.




/* elaborate_doc capability implementations */
+!register_page(elaborate_doc, Context )
	<- 
		!get_data_value(doc,Doc,Context);
		.concat("Edit New Document ",Doc,ServiceDescription);
		!standard_register_HTTP_page(elaborate_doc, ServiceDescription, Context );
	.
/* 
+!generate_html_request_page(elaborate_doc, Path, ParamSet, Context, ReturnHtml)	//only for test purpose
	:
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams)
	&	( .my_name(filippo) )
	<-
		!get_data_value(doc,Doc,Context);
		.my_name(Me);
		generatePageQuoteWork(1,ReturnHtml,Me,UserName,UserRole,Session,Doc,"change_doc_event");
	.	*/
+!generate_html_request_page(elaborate_doc, Path, ParamSet, Context, ReturnHtml)
	:
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams)
	<-
		!get_data_value(doc,Doc,Context);
		.my_name(Me);
		generatePageQuoteWork(ReturnHtml,Me,UserName,UserRole,Session,Doc,"change_doc_event");
		//.println("request page is ",ReturnHtml);
	.	
+!action(elaborate_doc, Path, UserName, UserRole, HTTPParams, Context)
	:
		HTTPParams=[param(attachment,AttachId)]
	<-
		!register_data_value(attachment,AttachId,Context);
		// check if revision has been done
		!register_statement( refined(doc), Context);
		!register_statement( available(doc,attachment), Context);
	.
+!generate_html_result_page(elaborate_doc, Path, ParamSet, Context, ReturnHtml)
	<-
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams);
		.my_name(Me);
		generatePageWorkNotification(ReturnHtml,Me,Session,UserName,UserRole);
		//.println("reply page is ",ReturnHtml);
	.	
+!unregister_page(elaborate_doc, Context )
	<- 
		!standard_unregister_HTTP_page(elaborate_doc, Context );
	.





/* fix_doc capability implementations */
+!register_page(fix_doc, Context )
	<- 
		!get_data_value(doc,Doc,Context);
		.concat("Fix Document ",Doc,ServiceDescription);
		!standard_register_HTTP_page(fix_doc, ServiceDescription, Context );
	.
+!generate_html_request_page(fix_doc, Path, ParamSet, Context, ReturnHtml)
	:
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams)
	<-
		!get_data_value(doc,DocId,Context);
		!get_data_value(attachment,AttachId,Context);
		.my_name(Me);
		generatePageQuoteWorkFix(ReturnHtml,Me,UserName,UserRole,Session,DocId,AttachId,"fix_doc_event");
	.	
+!action(fix_doc, Path, UserName, UserRole, HTTPParams, Context)
	:
		HTTPParams=[param(attachment,AttachId)]
	<-
		!register_data_value(attachment,AttachId,Context);
		// check if revision has been done
		!register_statement( refined(doc), Context);
		!register_statement( fixed(doc), Context);
	.
+!generate_html_result_page(fix_doc, Path, ParamSet, Context, ReturnHtml)
	<-
		ParamSet = paramset(Session,user(UserName,UserRole),HTTPParams);
		.my_name(Me);
		generatePageWorkNotification(ReturnHtml,Me,Session,UserName,UserRole);
	.	
+!unregister_page(fix_doc, Context )
	<- 
		!standard_unregister_HTTP_page(fix_doc, Context );
	.



/* Plans */

+!awake : true 
	<- 
		.println("hello");
		
		!create_or_use_HTML_interface("worker_quote_interface","ids.artifact.HTMLWorkerInterface",Id);
		//!create_or_use_worker_interface(Id);
		
		!awake_as_employee; 
	.

	
@try_create_worker_interface[atomic]
+!create_or_use_worker_interface(Id) : true
	<-
		!create_worker_interface(Id);
	.
@otherwise_search_worker_interface[atomic]
-!create_or_use_worker_interface(Id) : true
	<-
		lookupArtifact("worker_quote_interface",Id);
		+using_artifact("worker_quote_interface",Id);
	.
+!create_worker_interface(Id) : true
	<-
		makeArtifact("worker_quote_interface","ids.artifact.HTMLWorkerInterface",[],Id);
		+using_artifact("worker_quote_interface",Id);
	.
	