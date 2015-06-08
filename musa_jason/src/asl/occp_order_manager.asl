{ include( "role/department_employee_activity.asl" ) }
{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }
{ include( "search/select_filter_capabilities.asl" ) }

agent_capability(deliver_billing)[type(parametric)].
capability_parameters(deliver_billing, [billing_data, recipient, order_id, recipient_email]).
capability_precondition(deliver_billing, condition(true) ).
capability_postcondition(deliver_billing, par_condition([billing_data, recipient, order_id, recipient_email], property(billing_delivered,[billing_data, recipient, order_id, recipient_email])) ).
capability_cost(deliver_billing,0).
capability_evolution(deliver_billing,[add( billing_delivered(billing_data, recipient, order_id, recipient_email) )]).

agent_capability(upload_billing_to_user_cloud)[type(parametric)].
capability_parameters(upload_billing_to_user_cloud, [user_id]).
capability_precondition(upload_billing_to_user_cloud, condition(true) ).
capability_postcondition(upload_billing_to_user_cloud, condition(billing_uploaded(user_id)) ).
capability_cost(upload_billing_to_user_cloud,0).
//capability_evolution(upload_billing_to_user_cloud,[add( done(billing_uploaded) )]).
capability_evolution(upload_billing_to_user_cloud,[add( billing_uploaded(user_id) )]).

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
		
		!get_variable_value(Assignment, order_id, Order_id);
		!get_variable_value(Assignment, recipient, User_id);
		!get_variable_value(Assignment, recipient_email, User_email);
		
		occp.logger.action.info("[deliver_billing] Delivering billing to user ",User_id);
		
		if(Order_id 	\== unbound 	& 
		   User_id 		\== unbound 	& 
		   User_email 	\== unbound)
	    {
	   		occp.action.sendBilling(Order_id, User_id, User_email);
	   		occp.logger.action.info("[deliver_billing] Billing for user ",User_id," related to order ",Order_id," sent to email address ",User_email);
	    }
	    else
	    {
	    	occp.logger.action.error("[deliver_billing] Billing for user ",User_id," related to order ",Order_id," CAN NOT BE SENT to email address ",User_email);
	    }
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
		!get_variable_value(Assignment, user_id, User_id);
		occp.logger.action.info("[upload_billing_to_user_cloud] Uploading billing to user (",User_id,")cloud ");
		
		occp.action.upload_billing_to_cloud("/tmp/billing.pdf", true, User_id);
				
		occp.logger.action.info("[upload_billing_to_user_cloud] Billing has been succesfully uploaded to user cloud");
	.

+!terminate(upload_billing_to_user_cloud, Context, Assignment) 
	<- 
		!register_statement(billing_uploaded(user),Context); 
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
		
		
		!get_variable_value(Assignment, order_id, Order_id);
		!get_variable_value(Assignment, user_id, User_id);
		
		if(Order_id 	\== unbound 	& 
		   User_id 		\== unbound)
	    {
	    	occp.logger.action.info("[fulfill_order] Fulfilling order ",Order_id);
			occp.action.fulfillOrder(Order_id);
			occp.logger.action.info("[fulfill_order] order ",Order_id," fulfilled");
			.print("------------------>Order ID: ",Order_id, " fulfilled");	
	    }
	    else
    	{
    		occp.logger.action.warn("[fulfill_order] Variables unbounded (order_id: ",Order_id,", user_id: ",User_id,")");		
    	}
	.

+!terminate(fulfill_order, Context, Assignment) 
	<- 
		!register_statement(fulfill_order(order,user),Context); 
	.
