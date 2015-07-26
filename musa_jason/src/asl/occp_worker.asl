{ include( "role/department_employee_activity.asl" ) }
{ include( "role/department_manager_activity.asl") }
{ include( "role/project_manager_activity.asl" ) }
{ include( "peer/capability_lifecycle.asl" ) }
{ include( "peer/common_context.asl" ) }
{ include( "core/accumulation.asl" ) }
{ include( "role/department_head_activity.asl" ) }
{ include( "peer/act_as_server.asl" ) }
{ include( "search/collaborative_search_with_accumulation.asl" ) }

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
capability_precondition(place_order, par_condition([order_id,user_id], property(received_order,[order_id,user_id])) ).
capability_postcondition(place_order, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
capability_cost(place_order,[10,4]). 
capability_evolution(place_order,[add( order_placed(order_id,user_id) )]).


//##################MONITOR - TODO
//agent_capability(monitor_place_order)[type(monitor)].
//capability_observed(place_order).
//on_capability_cost_change(monitor_place_order, plan_name).
//on_capability_failure(monitor_place_order, compensate_plan).
//on_capability_resource_change(monitor_place_order, plan_name).
//
//capability_parameters(monitor_place_order, [order_id,user_id]).
//capability_precondition(monitor_place_order, condition(true) ).
//capability_postcondition(monitor_place_order, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
//capability_cost(monitor_place_order,[10,4]). 
//capability_evolution(monitor_place_order,[add( order_placed(order_id,user_id) )]).
//##################

//agent_capability(place_order_alternative)[type(parametric)].
//capability_parameters(place_order_alternative, [order_id,user_id]).
//capability_precondition(place_order_alternative, condition(true) ).
//capability_postcondition(place_order_alternative, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
//capability_cost(place_order_alternative,[12,3]).
//capability_evolution(place_order_alternative,[add( order_placed(order_id,user_id) )]). 
//
//agent_capability(place_order_alternative2)[type(parametric)].
//capability_parameters(place_order_alternative2, [order_id,user_id]).
//capability_precondition(place_order_alternative2, condition(true) ).
//capability_postcondition(place_order_alternative2, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
//capability_cost(place_order_alternative2,[12,3,6]).
//capability_evolution(place_order_alternative2,[add( order_placed(order_id,user_id) )]). 

//---------------------------

agent_capability(set_user_data)[type(parametric)].
capability_parameters(set_user_data, [user_id,user_email]).
capability_precondition(set_user_data, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
capability_postcondition(set_user_data, par_condition([user_id,user_email], property(set_user_data,[user_id,user_email])) ).
capability_cost(set_user_data,[0]).
capability_evolution(set_user_data,[add( set_user_data(user_id,user_email) )]). 

agent_capability(set_user_data_step1)[type(parametric)].
capability_parameters(set_user_data_step1, [user_id,user_email]).
capability_precondition(set_user_data_step1, condition(true) ).
capability_postcondition(set_user_data_step1, par_condition([user_id,user_email], property(set_user_data_step1,[user_id,user_email])) ).
capability_cost(set_user_data_step1,[0]).
capability_evolution(set_user_data_step1,[add( set_user_data_step1(user_id,user_email) )]). 

agent_capability(set_user_data_step2)[type(parametric)].
capability_parameters(set_user_data_step2, [user_id,user_email]).
capability_precondition(set_user_data_step2, par_condition([user_id,user_email], property(set_user_data_step1,[user_id,user_email])) ).
capability_postcondition(set_user_data_step2, par_condition([user_id,user_email], property(set_user_data,[user_id,user_email])) ).
capability_cost(set_user_data_step2,[0]).
capability_evolution(set_user_data_step2,[add( set_user_data(user_id,user_email) )]). 


agent_capability(check_order_feasibility)[type(parametric)].
capability_parameters(check_order_feasibility, [order_id]).
capability_precondition(check_order_feasibility, par_condition([user_id,user_email], property(set_user_data,[user_id,user_email])) ).
capability_postcondition(check_order_feasibility, par_condition([order_id], property(order_checked,[order_id])) ).
capability_cost(check_order_feasibility,[0]).
capability_evolution(check_order_feasibility,[add( order_checked(order_id) )]).

agent_capability(complete_transaction)[type(simple)].
capability_parameters(complete_transaction, []).
capability_precondition(complete_transaction, condition(true) ).
capability_postcondition(complete_transaction, condition( done(complete_transaction) ) ).
capability_cost(complete_transaction,[0]).
capability_evolution(complete_transaction,[add( done(complete_transaction) )]).

+!awake
	<-
		!awake_as_employee;
	.

/**
 * Register the capability receive_order
 */
+!register_page(receive_order, Context)
	<-
		!standard_register_HTTP_page(receive_order, "Receive order ", Context );
	.

//set_user_data_step1------------------------
+!prepare(set_user_data_step1, Context, Assignment).
+!action(set_user_data_step1, Context, Assignment) 
	<- 
		!register_statement(set_user_data_step1(user,email),Context);
	.
+!terminate(set_user_data_step1, Context, Assignment).

//set_user_data_step2------------------------
+!prepare(set_user_data_step2, Context, Assignment).
+!action(set_user_data_step2, Context, Assignment) 
	<- 		
		!register_statement(set_user_data(user,email),Context);
	.
+!terminate(set_user_data_step2, Context, Assignment).

//receive_order------------------------
+!prepare(receive_order, Context, Assignment).
+!action(receive_order, Context, Assignment) 
	<- 		
		!register_statement(received_order(order,user),Context); 
	.
+!terminate(receive_order, Context, Assignment).

//-------------------------------------
//place_order--------------------------	
+!prepare(place_order, Context, Assignment).
+!action(place_order, Context, Assignment)  	: fail(place_order).	
+!action(place_order, Context, Assignment) 
	<- 
		!get_variable_value(Assignment, Context, order_id, Order_id);
		!get_variable_value(Assignment, Context, user_id, User_id);
		
		if(Order_id 	\== unbound 	& 
		   User_id 		\== unbound)
	    {
	    	occp.logger.action.info("[place_order] Registerind order ",Order_id);
//	    	occp.action.registerOrder(Order_id, User_id);
			occp.logger.action.info("[place_order] Order ",Order_id," registered");
	    }
	    else
    	{
    		occp.logger.action.warn("Variables unbounded (order_id: ",Order_id,", user_id: ",User_id,")");		
    	}

    	!register_statement(order_placed(order,user), Context);
	.

+!terminate(place_order, Context, Assignment).

//-------------------------------------
//place_order_alternative--------------

 +!prepare(place_order_alternative, Context, Assignment).
+!action(place_order_alternative, Context, Assignment)  	: fail(place_order_alternative) <- true.
+!action(place_order_alternative, Context, Assignment) 
	<- 
		!register_statement(order_placed(order,user), Context);
	.
+!terminate(place_order_alternative, Context, Assignment).

//-------------------------------------
//place_order_alternative2--------------
+!prepare(place_order_alternative2, Context, Assignment).
+!action(place_order_alternative2, Context, Assignment)  : fail(place_order).
+!action(place_order_alternative2, Context, Assignment) 
	<- 
		!register_statement(order_placed(order,user), Context);
	.
+!terminate(place_order_alternative2, Context, Assignment).
//-------------------------------------

//set_user_data------------------------
+!prepare(set_user_data, Context, Assignment).
+!action(set_user_data, Context, Assignment) : fail(set_user_data).
+!action(set_user_data, Context, Assignment) 
	<- 
		!register_statement(set_user_data(user,email),Context);
	.
+!terminate(set_user_data, Context, Assignment).

//-------------------------------------
//check_order_feasibility--------------
+!prepare(check_order_feasibility, Context, Assignment).
+!action(check_order_feasibility, Context, Assignment) 
	<- 
//		.random(X);
//		if(X>=0.5)	{!register_statement(order_status(accepted), Context);}
//		else		{!register_statement(order_status(refused), Context);}

		!register_statement(order_status(accepted), Context);
		!register_statement(order_checked(order), Context);
	.
+!terminate(check_order_feasibility, Context, Assignment).
	
//-------------------------------------
//complete_transaction-----------------
+!prepare(complete_transaction, Context). 
+!action(complete_transaction, Context) 
	<- 
		!register_statement(done(complete_transaction),Context);
	.
+!terminate(complete_transaction, Context).