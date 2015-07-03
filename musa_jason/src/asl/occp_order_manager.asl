{ include( "role/department_employee_activity.asl" ) }
{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }
{ include( "search/select_filter_capabilities.asl" ) }

agent_capability(deliver_billing)[type(parametric)].
capability_parameters(deliver_billing, [billingData, theRecipient, orderId, recipientEmail]).
capability_precondition(deliver_billing, condition(true) ).
capability_postcondition(deliver_billing, par_condition([billingData, theRecipient, orderId, recipientEmail], property(billing_delivered,[billingData, theRecipient, orderId, recipientEmail])) ).
capability_cost(deliver_billing,0).
capability_evolution(deliver_billing,[add( billing_delivered(billingData, theRecipient, orderId, recipientEmail) )]).

agent_capability(upload_billing_to_user_cloud)[type(parametric)].
capability_parameters(upload_billing_to_user_cloud, [user_id]).
capability_precondition(upload_billing_to_user_cloud, condition(true) ).
capability_postcondition(upload_billing_to_user_cloud, par_condition([user_id], property(billing_uploaded,[user_id]))).//  condition(billing_uploaded(user_id)) ).
capability_cost(upload_billing_to_user_cloud,0).
capability_evolution(upload_billing_to_user_cloud,[add( billing_uploaded(user_id) )]).

//---------------------------------------------------

//agent_capability(upload_billing_to_dropbox)[type(parametric)].
//capability_parameters(upload_billing_to_dropbox, [user_id,the_access_token]).
//capability_precondition(upload_billing_to_dropbox, condition(true) ).
//capability_postcondition(upload_billing_to_dropbox, condition(billing_uploaded_to_dropbox(user_id,the_access_token)) ).
//capability_cost(upload_billing_to_dropbox,0).
//capability_evolution(upload_billing_to_dropbox,[add( billing_uploaded_to_dropbox(user_id,the_access_token) )]).
//
//agent_capability(upload_billing_to_google_drive)[type(parametric)].
//capability_parameters(upload_billing_to_google_drive, [user_id,user_email]).
//capability_precondition(upload_billing_to_google_drive, condition(true) ).
//capability_postcondition(upload_billing_to_google_drive, condition(billing_uploaded_to_gdrive(user_id,user_email)) ).
//capability_cost(upload_billing_to_google_drive,0).
//capability_evolution(upload_billing_to_google_drive,[add( billing_uploaded_to_gdrive(user_id,user_email) )]).

//---------------------------------------------------

agent_capability(fulfill_order)[type(parametric)].
capability_parameters(fulfill_order, [order_id,user_id]).
capability_precondition(fulfill_order, condition(true) ).
capability_postcondition(fulfill_order, par_condition([order_id,user_id],property(fulfill_order,[order_id,user_id])) ).
capability_cost(fulfill_order,0).
capability_evolution(fulfill_order,[add( fulfill_order(order_id,user_id) )]).

!awake.

+!awake
	<-
		!awake_as_employee;
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
		
		!get_variable_value(Assignment, Context, order_id, Order_id);
		!get_variable_value(Assignment, Context, recipient, User_id);
		!get_variable_value(Assignment, Context, recipient_email, User_email);
		
//		occp.logger.action.info("[deliver_billing] Delivering billing to user ",User_id);
//		
		if(Order_id 	\== unbound 	& 
		   User_id 		\== unbound 	&
		   User_email 	\== unbound)
	    {
//	   		occp.action.sendBilling(Order_id, User_id, User_email);
			occp.action.tad.sendBillingTAD(User_email);
	   		occp.logger.action.info("[deliver_billing] Billing for user ",User_id," related to order ",Order_id," sent to email address ",User_email);
	    }
	    else
	    {
	    	occp.logger.action.error("[deliver_billing] Billing for user ",User_id," related to order ",Order_id," CAN NOT BE SENT to email address ",User_email);
	    }
	    .print("...-.-.-.-.-.-.-.-.-.-.-.--.-.-.-.-.-.-.- deliver_billing ACTION OK");
	.

+!terminate(deliver_billing, Context, Assignment) 
	<- 
		!register_statement(billing_delivered(billing,recipient_id,order,email), Context);
	.
//-------------------------------------
//upload_billing_to_user_cloud---------
 +!prepare(upload_billing_to_user_cloud, Context, Assignment) 
	<- 
		true 
	.

+!action(upload_billing_to_user_cloud, Context, Assignment) 
	<- 
		.print("..................................................(upload_billing_to_user_cloud) uploading billing to cloud.");
		!get_variable_value(Assignment, Context, user_id, User_id);
		occp.logger.action.info("[upload_billing_to_user_cloud] Uploading billing to user (",User_id,")cloud ");
		
//		occp.action.upload_billing_to_cloud("/tmp/billing.pdf", true, User_id);
		occp.action.tad.upload_billing_to_cloudTAD;
//		occp.logger.action.info("[upload_billing_to_user_cloud] Billing has been succesfully uploaded to user cloud");
		.print("...-.-.-.-.-.-.-.-.-.-.-.--.-.-.-.-.-.-.- upload_billing_to_user_cloud ACTION OK");
		
	.

+!terminate(upload_billing_to_user_cloud, Context, Assignment) 
	<- 
		 !register_statement(billing_uploaded(user),Context);
	.
//-------------------------------------
//upload_billing_to_dropbox---------
 +!prepare(upload_billing_to_dropbox, Context, Assignment) 
	<- 
		true 
	.

+!action(upload_billing_to_dropbox, Context, Assignment) 
	<-
		!get_variable_value(Assignment, Context, user_id, User_id);
		!get_variable_value(Assignment, Context, the_access_token, Access_Token);
//		occp.action.upload_file_to_dropbox("/tmp/billing.pdf", User_id, Access_Token);
		!register_statement(billing_uploaded_to_dropbox(user,access_token),Context);
	.

+!terminate(upload_billing_to_dropbox, Context, Assignment) 
	<- 
		true 
	.
//-------------------------------------
//upload_billing_to_google_drive-------
 +!prepare(upload_billing_to_google_drive, Context, Assignment) 
	<- 
		true 
	.

+!action(upload_billing_to_google_drive, Context, Assignment) 
	<- 
		!get_variable_value(Assignment, Context, user_id, User_id);
		!get_variable_value(Assignment, Context, user_email, Email);
//		occp.action.upload_file_to_googledrive("/tmp/billing.pdf", Email);
	
		!register_statement(billing_uploaded_to_gdrive(user,email),Context); 
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
//			occp.action.fulfillOrder(Order_id);
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