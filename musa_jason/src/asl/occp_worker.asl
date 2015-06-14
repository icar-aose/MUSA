{ include( "role/department_employee_activity.asl" ) }
{ include( "role/department_manager_activity.asl") }
{ include( "role/project_manager_activity.asl" ) }
{ include( "peer/capability_lifecycle.asl" ) }
{ include( "peer/common_context.asl" ) }
{ include( "core/accumulation.asl" ) }
{ include( "role/department_head_activity.asl" ) }
{ include( "peer/act_as_server.asl" ) }
{ include( "search/collaborative_search_with_accumulation.asl" ) }


//fail(place_order).


http_interface(receive_order,request_result,"access_to_order","manager_quote_interface").

my_user(luca, occp_user).
my_user(mario, occp_user).

agent_capability(receive_order)[type(parametric)].	
capability_parameters(receive_order, [order_id,user_id]).
capability_precondition(receive_order, condition(true) ).
capability_postcondition(receive_order, par_condition([order_id,user_id], property(received_order,[order_id,user_id])) ).
capability_cost(receive_order,[0]).
capability_evolution(receive_order,[add( received_order(order_id,user_id) )]).


//---------------------------
agent_capability(place_order)[type(parametric)].
capability_parameters(place_order, [order_id,user_id]).
capability_precondition(place_order, condition(true) ).
//capability_postcondition(place_order, condition(order_placed(order, user)) ).
capability_postcondition(place_order, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
capability_cost(place_order,[10,4]).
//capability_evolution(place_order,[add( done(order_placed) )]). 
capability_evolution(place_order,[add( order_placed(order_id,user_id) )]).


agent_capability(place_order_alternative)[type(parametric)].
capability_parameters(place_order_alternative, [order_id,user_id]).
capability_precondition(place_order_alternative, condition(true) ).
capability_postcondition(place_order_alternative, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
capability_cost(place_order_alternative,[12,3]).
capability_evolution(place_order_alternative,[add( order_placed(order_id,user_id) )]). 

agent_capability(place_order_alternative2)[type(parametric)].
capability_parameters(place_order_alternative2, [order_id,user_id]).
capability_precondition(place_order_alternative2, condition(true) ).
capability_postcondition(place_order_alternative2, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
capability_cost(place_order_alternative2,[12,3,6]).
capability_evolution(place_order_alternative2,[add( order_placed(order_id,user_id) )]). 
 
//---------------------------



agent_capability(set_user_data)[type(parametric)].
capability_parameters(set_user_data, [user_id,user_email]).
capability_precondition(set_user_data, condition(true) ).
capability_postcondition(set_user_data, par_condition([user_id,user_email], property(set_user_data,[user_id,user_email])) ).
capability_cost(set_user_data,[0]).
capability_evolution(set_user_data,[add( set_user_data(user_id,user_email) )]). 

agent_capability(check_order_feasibility)[type(parametric)].
capability_parameters(check_order_feasibility, [order_id]).
capability_precondition(check_order_feasibility, condition(true) ).
capability_postcondition(check_order_feasibility, par_condition([order_id], property(order_checked,[order_id])) ).
capability_cost(check_order_feasibility,[0]).
capability_evolution(check_order_feasibility,[add( order_checked(order_id) )]).

agent_capability(complete_transaction)[type(simple)].
capability_parameters(complete_transaction, []).
capability_precondition(complete_transaction, condition(true) ).
capability_postcondition(complete_transaction, condition(done(complete_transaction)) ).
capability_cost(complete_transaction,[0]).
capability_evolution(complete_transaction,[add( done(complete_transaction) )]).

!awake.

+!awake
	<-
		!awake_as_employee;

//!debug_check_if_par_condition_addresses_accumulation_11;


//		!debug_test_parametric_condition;

//		!awake_as_head;
//		!create_or_use_database_artifact(DBId);
//		Department	= "p4_dept";
//		Project		= "p4_dept2015422101812";
//		Context 	= project_context(Department , Project);
//		.print("Context: ",Context);
//		Members 	= [worker];
//		+manager_of(Department, Project, Members);
//		//!register_data_value(par_message,messaggio_wella,Context);
//		
//		
//		!debug_unroll_solution_to_set_goal_param_values_into_assignment_3;
//		
//		!debug_update_capability_blacklist_expiration(Context);
	.

+!register_page(receive_order, Context)
	<-
		//Register the capability
		.print(".-.-.-.-.-> registering capability receive_order");
		!standard_register_HTTP_page(receive_order, "Receive order ", Context );
	.

//receive_order------------------------
 +!prepare(receive_order, Context, Assignment) 
	<- 
		true
	.

+!action(receive_order, Context, Assignment) 
	<- 
		.print("..................................................(receive_order) order received.");
	.

+!terminate(receive_order, Context, Assignment) 
	<- 
		!register_statement(received_order(order,user),Context);
	.
//-------------------------------------
//place_order--------------------------
 +!prepare(place_order, Context, Assignment) 
	<- 
		true
	.

//+!action(place_order, Context, Assignment) 
//	:
//		fail(place_order)
//	<- 
//		true
//	.		
+!action(place_order, Context, Assignment) 
	<- 
		.print("..................................................(place_order) placing order...");

		!get_variable_value(Assignment, order_id, Order_id);
		!get_variable_value(Assignment, user_id, User_id);
		
		if(Order_id 	\== unbound 	& 
		   User_id 		\== unbound)
	    {
	    	occp.logger.action.info("[place_order] Registerind order ",Order_id);
	    	occp.action.registerOrder(Order_id, User_id);
			occp.logger.action.info("[place_order] Order ",Order_id," registered");
	    }
	    else
    	{
    		occp.logger.action.warn("Variables unbounded (order_id: ",Order_id,", user_id: ",User_id,")");		
    	}

    	.print("[",place_order,"]ACTION TERMINATA CORRETTAMENTE");
	.

+!terminate(place_order, Context, Assignment)
	: 
		fail(place_order)
	<- 
		true
	.
+!terminate(place_order, Context, Assignment)
	<- 
		!register_statement(order_placed(order,user), Context);
	.

//-------------------------------------
//place_order_alternative--------------
 +!prepare(place_order_alternative, Context, Assignment) 
	<- 
	true
	.

+!action(place_order_alternative, Context, Assignment) 
	<- 
		.print("..................................................(place_order_alternative) placing order...");
	.
+!terminate(place_order_alternative, Context, Assignment)
	: 
		fail(place_order_alternative)
	<- 
		true
	.
+!terminate(place_order_alternative, Context, Assignment) 
	<- 
		!register_statement(order_placed(order,user), Context);
	.
//-------------------------------------
//place_order_alternative2--------------
 +!prepare(place_order_alternative2, Context, Assignment) 
	<- 
	true
	.

+!action(place_order_alternative2, Context, Assignment) 
	<- 
		.print("..................................................(place_order_alternative2) placing order...");
	.
+!terminate(place_order_alternative2, Context, Assignment)
	: 
		fail(place_order_alternative2)
	<- 
		true
	.
+!terminate(place_order_alternative2, Context, Assignment) 
	<- 
		!register_statement(order_placed(order,user), Context);
	.
//-------------------------------------


//set_user_data------------------------
 +!prepare(set_user_data, Context, Assignment) 
	<- 
		true 
	.

+!action(set_user_data, Context, Assignment) 
	<- 
		.print("..................................................(set_user_data) setting user data...");
		
		occp.logger.action.info("[set_user_data] Setting user data");
		
	.

+!terminate(set_user_data, Context, Assignment) 
	<- 
		!register_statement(set_user_data(user,email),Context);
	.
//-------------------------------------
//check_order_feasibility--------------
 +!prepare(check_order_feasibility, Context, Assignment) 
	<- 
		true 
	.

+!action(check_order_feasibility, Context, Assignment) 
	<- 
		.print("..................................................(check_order_feasibility) checking order feasibility...");
		occp.logger.action.info("[check_order_feasibility] Checking order feasibility");

//		!get_variable_value(Assignment, order_id, Order_id);
//		
//		if(Order_id \== unbound)
//	    {
//	    	occp.action.checkOrderFeasibility(Order_id, Success);
//		
//			if(Success==true)
//			{
//				occp.logger.action.info("[check_order_feasibility] Order ",Order_id," is feasible.");
//				!register_statement(order_status(accepted), Context);
//			}
//			else
//			{
//				occp.logger.action.info("[check_order_feasibility] Order ",Order_id," is NOT feasible.");
//				!register_statement(order_status(refused), Context);
//			}
//	    }
//	    else
//	    {
//	    	occp.logger.action.warn("[check_order_feasibility] Variable unbounded (order_id: ",Order_id,")");
//	    	!register_statement(order_status(refused), Context);
//	    }
	.

+!terminate(check_order_feasibility, Context, Assignment) 
	<- 
		!register_statement(order_status(refused), Context);
		!register_statement(order_checked(order), Context);
	.
	
//-------------------------------------
//complete_transaction-----------------
 +!prepare(complete_transaction, Context) 
	<- 
		true 
	.

+!action(complete_transaction, Context) 
	<- 
		.print("..................................................(complete_transaction) finishing transaction...");
		occp.logger.action.info("[complete_transaction] Completing transaction");
	.

+!terminate(complete_transaction, Context) 
	<- 
		!register_statement(done(complete_transaction),Context); 
	.


