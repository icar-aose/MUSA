{ include( "role/department_employee_activity.asl" ) }

/* Initial beliefs and rules */
//soap_ip("123.45.234.29","webservice").

/* classify_doc capability descriptions */
agent_capability(classify_doc)[type(simple),type(service)].
capability_precondition(classify_doc, condition( and( [available(doc),unclassified(doc)] ) ) ).
capability_postcondition(classify_doc, condition( classified(doc) ) ).
capability_cost(classify_doc,0).
capability_evolution(classify_doc,[add( classified(doc) ),remove( unclassified(doc) )]).


/* Initial goals */

!awake.

/* Plans */

+!awake : true 
	<- 
		.println("hello");
		!awake_as_employee; 
	.
+!debug_awake 
	<- 
		!debug_employee; 
	.

/* classify_doc capability implementations */
+!prepare(classify_doc, Context) 
	<-
		.println(prepare_classify_doc);
		//true
	.
+!action(classify_doc, Context) 
	<-
		//!get_data(doc,Doc,TimeStamp,Context);
	
		!get_data_value(doc,Doc,Context);
	
		// classify_doc
		.println("doc: ",Doc,", classified!");
		!register_statement( classified(doc), Context);
	.
+!terminate(classify_doc, Context)
	<-
		.println(terminate_classify_doc);
		//true
	.




