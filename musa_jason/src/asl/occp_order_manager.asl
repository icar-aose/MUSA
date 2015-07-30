{ include( "role/department_employee_activity.asl" ) }
{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }
{ include( "search/select_filter_capabilities.asl" ) }

agent_capability(deliver_billing)[type(parametric)].
capability_parameters(deliver_billing, [billingFilename, theRecipient, orderId, recipientEmail]).
capability_precondition(deliver_billing, par_condition([order_id], [property(order_checked,[order_id]), property(order_status,[accepted])]) ).
capability_postcondition(deliver_billing, par_condition([billingFilename, theRecipient, orderId, recipientEmail], property(billing_delivered,[billingFilename, theRecipient, orderId, recipientEmail])) ).
capability_cost(deliver_billing,0).
capability_evolution(deliver_billing,[add( billing_delivered(billingFilename, theRecipient, orderId, recipientEmail) )]).

agent_capability(notify_gdrive_upload)[type(parametric)].
capability_parameters(notify_gdrive_upload, [user_id,user_email]).
capability_precondition(notify_gdrive_upload, par_condition([billingFilename, theRecipient, orderId, recipientEmail], property(billing_delivered,[billingFilename, theRecipient, orderId, recipientEmail])) ).
capability_postcondition(notify_gdrive_upload, par_condition([user_id,user_email], property(notified_gdrive_upload,[user_id,user_email])) ).
capability_cost(notify_gdrive_upload,[0]).
capability_evolution(notify_gdrive_upload,[add( notified_gdrive_upload(user_id,user_email) )]). 

agent_capability(upload_to_google_drive)[type(parametric)].
capability_parameters(upload_to_google_drive, [user_id,user_email,billingFilename]).
capability_precondition(upload_to_google_drive, par_condition([user_id,user_email], property(notified_gdrive_upload,[user_id,user_email])) ).
capability_postcondition(upload_to_google_drive, par_condition([user_id,user_email,billingFilename],property(billing_uploaded_to_gdrive,[user_id,user_email,billingFilename])) ).
capability_cost(upload_to_google_drive,[0]).
capability_evolution(upload_to_google_drive,[add( billing_uploaded_to_gdrive(user_id,user_email,billingFilename) ),add( billing_uploaded(user_id) )]).

agent_capability(upload_billing_to_dropbox)[type(parametric)].
capability_parameters(upload_billing_to_dropbox, [user_id,the_access_token,billingFilename]).
capability_precondition(upload_billing_to_dropbox, par_condition([billingFilename, theRecipient, orderId, recipientEmail], property(billing_delivered,[billingFilename, theRecipient, orderId, recipientEmail])) ).
capability_postcondition(upload_billing_to_dropbox, par_condition([user_id,the_access_token,billingFilename],property(billing_uploaded_to_dropbox,[user_id,the_access_token,billingFilename])) ).
capability_cost(upload_billing_to_dropbox,0).
capability_evolution(upload_billing_to_dropbox,[add( billing_uploaded_to_dropbox(user_id,the_access_token,billingFilename) ), add( billing_uploaded(user_id) )]).

agent_capability(fulfill_order)[type(parametric)].
capability_parameters(fulfill_order, [order_id,user_id]).
capability_precondition(fulfill_order, par_condition([user_id], property(billing_uploaded,[user_id])) ).
capability_postcondition(fulfill_order, par_condition([order_id,user_id],property(fulfill_order,[order_id,user_id])) ).
capability_cost(fulfill_order,0).
capability_evolution(fulfill_order,[add( fulfill_order(order_id,user_id) )]).

agent_capability(notifica_calendario)[type(simple)].
capability_parameters(notifica_calendario, []).
capability_precondition(notifica_calendario, condition(true) ).
capability_postcondition(notifica_calendario, condition(done(notificato_in_calendario)) ).
capability_cost(notifica_calendario,0).
capability_evolution(notifica_calendario,[add( done(notificato_in_calendario) )]).

+!awake
	<-
		!awake_as_employee;
	.

+!prepare(notifica_calendario, Context) .
+!action(notifica_calendario, Context) 
	<- 
		occp.action.insertGoogleCalendarEvent;
		!register_statement( done(notificato_in_calendario), Context );
	.
+!terminate(notifica_calendario, Context).
//-------------------------------------
//deliver_billing----------------------
+!prepare(deliver_billing, Context, Assignment).
+!action(deliver_billing, Context, Assignment) 
	<- 
		!get_variable_value(Assignment, Context, billingFilename, BillingFileName);
		!get_variable_value(Assignment, Context, orderId, Order_id);
		!get_variable_value(Assignment, Context, theRecipient, User_id);
		!get_variable_value(Assignment, Context, recipientEmail, User_email);
		
		occp.action.tad.sendBillingTAD(BillingFileName, User_email);
   	
	    !register_statement(billing_delivered(billing,recipient_id,order,email), Context);
	.

+!terminate(deliver_billing, Context, Assignment).
//-------------------------------------
//upload_billing_to_dropbox---------
+!action(upload_billing_to_dropbox, Context, Assignment)	: fail(upload_billing_to_dropbox).
+!prepare(upload_billing_to_dropbox, Context, Assignment) 	
	<- 
		true
	.
+!terminate(upload_billing_to_dropbox, Context, Assignment)	<- true .
+!action(upload_billing_to_dropbox, Context, Assignment) 
	<-
	
		!get_variable_value(Assignment, Context, the_access_token, Access_Token);
		!get_variable_value(Assignment, Context, billingFilename, BillingFileName);
		occp.action.upload_file_to_dropbox(BillingFileName, Access_Token);
		
		!register_statement(billing_uploaded_to_dropbox(user,accesstoken,billing), Context);
		!register_statement(billing_uploaded(user), Context);
	.	


//-------------------------------------
//upload_billing_to_google_drive-------
+!prepare(upload_billing_to_google_drive, Context, Assignment).
+!action(upload_billing_to_google_drive, Context, Assignment)	: fail(upload_billing_to_google_drive).
+!action(upload_billing_to_google_drive, Context, Assignment) 
	<-

		!get_variable_value(Assignment, Context, user_email, Email);
		!get_variable_value(Assignment, Context, billingFilename, BillingFileName);

		occp.action.upload_file_to_googledrive(BillingFileName, Email);
	
		!register_statement(billing_uploaded(user), Context);
		!register_statement(billing_uploaded_to_gdrive(user,email,billing),Context);
	.

+!terminate(upload_billing_to_google_drive, Context, Assignment).
//-------------------------------------
//fulfill_order------------------------
+!prepare(fulfill_order, Context, Assignment).
+!action(fulfill_order, Context, Assignment) 
	<- 
		!get_variable_value(Assignment, Context, order_id, Order_id);
		!get_variable_value(Assignment, Context, user_id, User_id);
		
		if(Order_id 	\== unbound 	& 
		   User_id 		\== unbound)
	    {
	    	//fulfill order
	    }
	    else
    	{
    		//vars unbounded		
    	}
    	
    	!register_statement(fulfill_order(order,user),Context);
    	
	.
+!terminate(fulfill_order, Context, Assignment).

//-------------------------------------
//notify_gdrive_upload-------
+!prepare(notify_gdrive_upload, Context, Assignment).
+!action(notify_gdrive_upload, Context, Assignment)	: fail(notify_gdrive_upload).
+!action(notify_gdrive_upload, Context, Assignment) 
	<-
		!get_variable_value(Assignment, Context, user_email, Email);
		
		.print("Email: ",Email);
		
		//occp.action.sendMail(Email,"~~~","Dear customer,\n\n the billing for your order has been upload to your Google Drive cloud storage.","MUSA");	
		!register_statement(notified_gdrive_upload(user_id,user_email), Context);
	.

+!terminate(notify_gdrive_upload, Context, Assignment) 
	<- 
		true
	.
	
//-------------------------------------
//upload_to_google_drive-------
+!prepare(upload_to_google_drive, Context, Assignment).
+!action(upload_to_google_drive, Context, Assignment)	: fail(upload_billing_to_google_drive).
+!action(upload_to_google_drive, Context, Assignment) 
	<-

		!get_variable_value(Assignment, Context, user_email, Email);
		!get_variable_value(Assignment, Context, billingFilename, BillingFileName);

		occp.action.upload_file_to_googledrive(BillingFileName, Email);
		!register_statement(billing_uploaded(user), Context);
		!register_statement(billing_uploaded_to_gdrive(user,email,billing),Context);
	.

+!terminate(upload_to_google_drive, Context, Assignment).
