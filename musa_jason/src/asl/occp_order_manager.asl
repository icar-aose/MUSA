{ include( "role/department_employee_activity.asl" ) }
{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }
{ include( "search/select_filter_capabilities.asl" ) }

agent_capability(deliver_billing)[type(parametric)].
capability_parameters(deliver_billing, [billingFilename, theRecipient, orderId, recipientEmail]).
capability_precondition(deliver_billing, condition(true) ).
capability_postcondition(deliver_billing, par_condition([billingFilename, theRecipient, orderId, recipientEmail], property(billing_delivered,[billingFilename, theRecipient, orderId, recipientEmail])) ).
capability_cost(deliver_billing,0).
capability_evolution(deliver_billing,[add( billing_delivered(billingFilename, theRecipient, orderId, recipientEmail) )]).


agent_capability(upload_billing_to_google_drive)[type(parametric)].
capability_parameters(upload_billing_to_google_drive, [user_id,user_email,billingFilename]).
capability_precondition(upload_billing_to_google_drive, condition(true) ).
capability_postcondition(upload_billing_to_google_drive, par_condition([user_id,user_email,billingFilename],property(billing_uploaded_to_gdrive,[user_id,user_email,billingFilename])) ).
capability_cost(upload_billing_to_google_drive,0).
capability_evolution(upload_billing_to_google_drive,[add( billing_uploaded_to_gdrive(user_id,user_email,billingFilename) ),add( billing_uploaded(user_id) )]).




//#################################################################
//inserire capability che condivide link di file caricato su gdrive
//#################################################################











agent_capability(upload_billing_to_dropbox)[type(parametric)].
capability_parameters(upload_billing_to_dropbox, [user_id,the_access_token,billingFilename]).
capability_precondition(upload_billing_to_dropbox, condition(true) ).
capability_postcondition(upload_billing_to_dropbox, par_condition([user_id,the_access_token,billingFilename],property(billing_uploaded_to_dropbox,[user_id,the_access_token,billingFilename])) ).
capability_cost(upload_billing_to_dropbox,0).
capability_evolution(upload_billing_to_dropbox,[add( billing_uploaded_to_dropbox(user_id,the_access_token,billingFilename) ), add( billing_uploaded(user_id) )]).

agent_capability(fulfill_order)[type(parametric)].
capability_parameters(fulfill_order, [order_id,user_id]).
capability_precondition(fulfill_order, condition(true) ).
capability_postcondition(fulfill_order, par_condition([order_id,user_id],property(fulfill_order,[order_id,user_id])) ).
capability_cost(fulfill_order,0).
capability_evolution(fulfill_order,[add( fulfill_order(order_id,user_id) )]).

//---------------------------------------------------------------------------

//agent_capability(notifica_calendario)[type(parametric)].
//capability_parameters(notifica_calendario, [event_name, description]).
//capability_precondition(notifica_calendario, condition(true) ).
//capability_postcondition(notifica_calendario, par_condition([event_name, description], property(notifica_nel_calendario,[event_name, description])) ).
//capability_cost(notifica_calendario,0).
//capability_evolution(notifica_calendario,[add( notifica_nel_calendario(event_name, description) )]).

agent_capability(notifica_calendario)[type(simple)].
capability_parameters(notifica_calendario, []).
capability_precondition(notifica_calendario, condition(true) ).
capability_postcondition(notifica_calendario, condition(done(notificato_in_calendario)) ).
capability_cost(notifica_calendario,0).
capability_evolution(notifica_calendario,[add( done(notificato_in_calendario) )]).





//!awake.

+!awake
	<-
		!awake_as_employee;
	.

//+!prepare(notifica_calendario, Context, Assignment) <- true .
//+!terminate(notifica_calendario, Context, Assignment) <- true.
//+!action(notifica_calendario, Context, Assignment) 
//	<- 
//		
//		!get_variable_value(Assignment, Context, event_name, EventName);
//		!get_variable_value(Assignment, Context, description, Description);
//		
//		occp.action.insertGoogleCalendarEvent(EventName, Description);
//		
//		
//		!register_statement( notifica_nel_calendario(event_name, location, description, event_date), Context );
//	.

+!prepare(notifica_calendario, Context) 
	<- 
		true
	.
+!terminate(notifica_calendario, Context) <- true.
+!action(notifica_calendario, Context) 
	<- 
//		occp.action.insertGoogleCalendarEvent;

		!register_statement( done(notificato_in_calendario), Context );
		
	.












//-------------------------------------
//deliver_billing----------------------
 +!prepare(deliver_billing, Context, Assignment) 
	<- 
		true 
	.

+!action(deliver_billing, Context, Assignment) 
	<- 
		.print("..................................................(deliver_billing) delivering billing.");
		.print("ASSIGNMENT FOR CAPABILITY ",deliver_billing," -------------------.-.-.-.-.-.-.-> ",Assignment);
		
		!get_variable_value(Assignment, Context, billingFilename, BillingFileName);
		!get_variable_value(Assignment, Context, orderId, Order_id);
		!get_variable_value(Assignment, Context, theRecipient, User_id);
		!get_variable_value(Assignment, Context, recipientEmail, User_email);
		
//		occp.action.tad.sendBillingTAD(BillingFileName, User_email);
   		occp.logger.action.info("[deliver_billing] Billing for user ",User_id," related to order ",Order_id," sent to email address ",User_email);
    
	    .print("...-.-.-.-.-.-.-.-.-.-.-.--.-.-.-.-.-.-.- deliver_billing ACTION OK");
	    
	    !register_statement(billing_delivered(billing,recipient_id,order,email), Context);
	.

+!terminate(deliver_billing, Context, Assignment) 
	<- 
		true
	.
//-------------------------------------
//upload_billing_to_dropbox---------
+!prepare(upload_billing_to_dropbox, Context, Assignment) 	
	<- 
		true
	.
+!terminate(upload_billing_to_dropbox, Context, Assignment)	<- true .
+!action(upload_billing_to_dropbox, Context, Assignment) 
	<-
		.print("ASSIGNMENT FOR CAPABILITY ",upload_billing_to_dropbox," -------------------.-.-.-.-.-.-.-> ",Assignment);
	
		!get_variable_value(Assignment, Context, the_access_token, Access_Token);
		!get_variable_value(Assignment, Context, billingFilename, BillingFileName);
//		occp.action.upload_file_to_dropbox(BillingFileName, Access_Token);
		
		!register_statement(billing_uploaded_to_dropbox(user,accesstoken,billing), Context);
		!register_statement(billing_uploaded(user), Context);
	.


//-------------------------------------
//upload_billing_to_google_drive-------
 +!prepare(upload_billing_to_google_drive, Context, Assignment) 
	<- 
		true
	.
+!action(upload_billing_to_google_drive, Context, Assignment) 
	<-
	 	.print("ASSIGNMENT FOR CAPABILITY ",upload_billing_to_google_drive," -------------------.-.-.-.-.-.-.-> ",Assignment);

		!get_variable_value(Assignment, Context, user_email, Email);
		!get_variable_value(Assignment, Context, billingFilename, BillingFileName);

//		occp.action.upload_file_to_googledrive(BillingFileName, Email);
	
		!register_statement(billing_uploaded(user), Context);
		!register_statement(billing_uploaded_to_gdrive(user,email,billing),Context); 
	.

+!terminate(upload_billing_to_google_drive, Context, Assignment) 
	<- 
		true
	.
//-------------------------------------
//fulfill_order------------------------
 +!prepare(fulfill_order, Context, Assignment) 
	<- 
		true 
	.

+!action(fulfill_order, Context, Assignment) 
	<- 
		.print("..................................................(fulfill_order) fulfilling order.");
		
		!get_variable_value(Assignment, Context, order_id, Order_id);
		!get_variable_value(Assignment, Context, user_id, User_id);
		
		if(Order_id 	\== unbound 	& 
		   User_id 		\== unbound)
	    {
	    	occp.logger.action.info("[fulfill_order] Fulfilling order ",Order_id);
			occp.logger.action.info("[fulfill_order] order ",Order_id," fulfilled");
			.print("------------------>Order ID: ",Order_id, " fulfilled");	
	    }
	    else
    	{
    		occp.logger.action.warn("[fulfill_order] Variables unbounded (order_id: ",Order_id,", user_id: ",User_id,")");		
    	}
    	
    	!register_statement(fulfill_order(order,user),Context);
    	.print("...-.-.-.-.-.-.-.-.-.-.-.--.-.-.-.-.-.-.- fulfill_order ACTION OK");
	.

+!terminate(fulfill_order, Context, Assignment) 
	<- 
		true 
	.