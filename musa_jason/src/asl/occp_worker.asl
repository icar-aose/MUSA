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




//capability_blacklist(worker, receive_order).
//capability_blacklist(worker, place_order).




agent_capability(receive_order)[type(parametric)].	
capability_parameters(receive_order, [order_id,user_id]).
capability_precondition(receive_order, condition(true) ).
capability_postcondition(receive_order, par_condition([order_id,user_id], property(received_order,[order_id,user_id])) ).
capability_cost(receive_order,[0]).
capability_evolution(receive_order,[add( received_order(order_id,user_id) )]).

//PROVA
capability_failure(receive_order, 0).








//---------------------------
agent_capability(place_order)[type(parametric)].
capability_parameters(place_order, [order_id,user_id]).
capability_precondition(place_order, condition(true) ).
capability_postcondition(place_order, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
capability_cost(place_order,[10,4]).
capability_evolution(place_order,[add( order_placed(order_id,user_id) )]).

capability_failure(place_order, 0).

agent_capability(place_order_alternative)[type(parametric)].
capability_parameters(place_order_alternative, [order_id,user_id]).
capability_precondition(place_order_alternative, condition(true) ).
capability_postcondition(place_order_alternative, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
capability_cost(place_order_alternative,[12,3]).
capability_evolution(place_order_alternative,[add( order_placed(order_id,user_id) )]). 

//agent_capability(place_order_alternative2)[type(parametric)].
//capability_parameters(place_order_alternative2, [order_id,user_id]).
//capability_precondition(place_order_alternative2, condition(true) ).
//capability_postcondition(place_order_alternative2, par_condition([order_id,user_id], property(order_placed,[order_id,user_id])) ).
//capability_cost(place_order_alternative2,[12,3,6]).
//capability_evolution(place_order_alternative2,[add( order_placed(order_id,user_id) )]). 
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



+!debug_filter_capabilities_that_offer_same_service
	<-
		.my_name(Me);
		CS = [commitment(Me,receive_order,_),commitment(Me,place_order,_), commitment(Me,place_order_alternative,_), commitment(Me,place_order_alternative2,_)];
		
		!filter_capabilities_that_offer_same_service(CS, CS, OutCS);
		.print("CS: ",CS);
		.print("OutCS: ",OutCS);
	.

+!debug_filter_capabilities_that_offer_same_service_2
	<-
		.my_name(Me);
		WholeCS = [commitment(Me,receive_order,_),commitment(Me,place_order,_), commitment(Me,place_order_alternative,_), commitment(Me,place_order_alternative2,_)];
		CS = commitment(Me,place_order,_);
		
		!filter_capabilities_that_offer_same_service(CS, WholeCS, BestCommitment, _);
		.print("BestCommitment: ",BestCommitment);
	.
	
+!debug_filter_capabilities_that_offer_same_service_3
	<-
		.my_name(Me);
		WholeCS = [commitment(Me,receive_order,_),commitment(Me,place_order,_), commitment(Me,place_order_alternative,_), commitment(Me,place_order_alternative2,_)];
		CS = commitment(Me,receive_order,_);
		
		!filter_capabilities_that_offer_same_service(CS, WholeCS, BestCommitment, _);
		.print("BestCommitment: ",BestCommitment);
	.
	

/**
 * [davide]
 * 
 * Filter a capability set by removing those capabilities which have an higher cost
 * compared to other capabilities that are not blacklisted and offer the same service. 
 * 
 * CS is a commitment list
 * 
 * NOTE CS is assumed to contain only non blacklisted commitment
 */
+!filter_capabilities_that_offer_same_service(Commitment, TheWholeCS, BestCommitment, BestCommitmentScore)
	:
		Commitment = commitment(Agent, CapName, HeadPercent)
	<-
		!get_remote_capability_precondition(Commitment, PRE);												//Get the precondition of the current capability
		!get_remote_capability_postcondition(Commitment, POST);											//Get the postcondition of the current capability
		
		!capability_set_difference(TheWholeCS, [Commitment], CSWithoutHead);
		!find_capability_set_that_offer_service(CSWithoutHead, PRE, POST, CSequal);					//Find a capability set that offer the same service as the current capability
		!select_best_capability(CSequal, BestCommitment, BestCommitmentScore);						//Find, within the previously created list (ThisCS), the best capability in term of cost.  
		
		.print("Current Capability: ",Commitment);
		.print("CS equivalent: ",CSequal);
		.print("Best equivalent commitment: ",BestCommitment," score: ",BestCommitmentScore);
	. 
 
 
+!filter_capabilities_that_offer_same_service(CS, TheWholeCS, OutCS)
	:
		CS = [Head|Tail]
	<-
		if(not .member(Head,TheWholeCS))
		{
			!filter_capabilities_that_offer_same_service(Tail, TheWholeCS, OutCS);
		}
		else
		{
			!get_remote_capability_precondition(Head, PRE);												//Get the precondition of the current capability
			!get_remote_capability_postcondition(Head, POST);											//Get the postcondition of the current capability
			
			.difference(TheWholeCS,[Head],RemainingCS);													//Get the difference between the whole CS and the current capability
			!find_capability_set_that_offer_service(RemainingCS, PRE, POST, CSequal);					//Find a capability set that offer the same service as the current capability
			
			
			//in realtà l'unione andrebbe fatta
			//SOLO se Head non è blacklisted. Quindi qui ci andrebbe un bel controllo tipo if(blacklisted(Head)) {...}
			.union([Head],CSequal,ThisCS);																//Create a list containing the capabilities that offer the same service of the current capability (Head)

			!capability_set_difference(CSequal, [Head], CSequalWithoutHead);


			//!select_best_capability(CSequal, BestCommitment, BestCommitmentScore);						//Find, within the previously created list (ThisCS), the best capability in term of cost.  
			!select_best_capability(CSequalWithoutHead, BestCommitment, BestCommitmentScore);
			
			.print("Current Capability: ",Head);
			.print("CS equivalent: ",CSequal);
			.print("CS equivalent w.out head: ",CSequalWithoutHead);
			//in CSequale mi ritrovo Head
			
			
//			.print("ThisCS (Head+CS equivalent): ",ThisCS);
			.print("Best equivalent commitment: ",BestCommitment," score: ",BestCommitmentScore);
			
			
//			.print("\nWhole CS: ",TheWholeCS);
//			.print("\nThis CS: ",ThisCS);
				
			//.difference(TheWholeCS,ThisCS,WholeCSWithOutCurrentCS);
			!capability_set_difference(TheWholeCS, ThisCS, WholeCSWithOutCurrentCS);
			
			.print("WholeCSWithOutCurrentCS: ",WholeCSWithOutCurrentCS);								//Remove the best capability from the main CS
			.print("\n\n");
			
			!filter_capabilities_that_offer_same_service(Tail, WholeCSWithOutCurrentCS, OutCSRec);		//recursive call
			
			
			if(BestCommitmentScore < 9999)
			{
				.union([BestCommitment], OutCSRec, OutCS);
			}
			else	
			{
				.union([Head], OutCSRec, OutCS);
			}

		}
	.
	
+!filter_capabilities_that_offer_same_service(CS, TheWholeCS, OutCS)
	:	CS 		= []
	<-	OutCS 	= []
	.


+!capability_set_difference(SetA, SetB, SetOut)
	:
		SetA = [Head|Tail] &
		.list(SetB)
	<-
		!capability_set_difference(Tail, SetB, SetOutRec);
		
		if(not .member(Head, SetB))
		{
			.concat(SetOutRec, [Head], SetOut);
		}
		else
		{
			.concat(SetOutRec, [], SetOut);
		}
	.

+!capability_set_difference(SetA, SetB, SetOut)
	:	SetA 	= []
	<-	SetOut 	= [];
	.


/**
 * DEBUG
 */
+!debug_find_capability_set_that_offer_service
	<-
		.my_name(Me);
		CS = [commitment(Me,receive_order,_),commitment(Me,place_order,_), commitment(Me,place_order_alternative,_), commitment(Me,place_order_alternative2,_)];
		
		PRE 	= condition(true);
		POST 	= par_condition([order_id,user_id], property(order_placed,[order_id,user_id]));
		
		
		!find_capability_set_that_offer_service(CS, PRE, POST, OutCS);
		.print("CS: ",CS);
		.print("OutCS: ",OutCS);
	.

/**
 * [davide]
 * 
 * OK
 */
+!find_capability_set_that_offer_service(CS, PreCondition, PostCondition, OutCS)
	:
		CS = [Head|Tail]
	<-
		!find_capability_set_that_offer_service(Tail, PreCondition, PostCondition, OutCSRec);
		
		!get_remote_capability_precondition(Head, PRE);
		!get_remote_capability_postcondition(Head, POST);		
		
		if(PreCondition == PRE & PostCondition == POST)
		{
			.union([Head], OutCSRec, OutCS);
		}
		else
		{
			.union([], OutCSRec, OutCS);	
		}
	.	
+!find_capability_set_that_offer_service(CS, PreCondition, PostCondition, OutCS)
	:	CS 		= []
	<-	OutCS	= []	
	.	
	
/**
 * DEBUG
 */
+!debug_select_best_capability
	<-
		.my_name(Me);
		CS = [commitment(Me,place_order,_), commitment(Me,place_order_alternative,_)];
		
		!select_best_capability(CS, BestCommitment, BestCommitmentScore);
		
		.print("BestCommitment: ",BestCommitment);
		.print("BestCommitmentScore: ",BestCommitmentScore);
	.
	
/**
 * [davide]
 * 
 * CS -> commitment set
 */
+!select_best_capability(CS, BestCommitment, BestCommitmentScore)
	:
		CS = [Head|Tail]
	<-
		!get_remote_capability_cost(Head, HeadCostList);
		
		// ~~~~~~~ FUNZIONE DI COSTO SULLA LISTA ~~~~~~~
		action.evaluateCapabilityCost(HeadCostList, HeadCost);
		
		!select_best_capability(Tail, BestCommitmentRec, BestCommitmentScoreRec);
		
		if(HeadCost < BestCommitmentScoreRec)
		{
			BestCommitmentScore = HeadCost;
			BestCommitment		= Head;
		}
		else
		{
			BestCommitmentScore = BestCommitmentScoreRec;
			BestCommitment		= BestCommitmentRec;
		}
	.
	
+!select_best_capability(CS, BestCommitment, BestCommitmentScore)
	:
		CS = []
	<-
		BestCommitmentScore = 9999;
	.
	
	
	
	
	
	
	
	
	
	
	
//--------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------


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
		Context=department_context(DptName);
		!timestamp(TimeStamp);
		.concat(DptName,TimeStamp,ProjectName);	
		NewContext = project_context(DptName,ProjectName);
		addProject(ProjectName,DptName,"","","null");	// this goes here to allow data registration in the capability body
		+manager_of(DptName,ProjectName,[]);		
		
		!!create_project(DptName,ProjectName);		// in project_manager_activity.asl 

		.print("Project created");
		
		
		//!register_statement(received_order(order,user),Context);
		
		//ONLY FOR DEBUG (LOCAL INSTANCE)
		!register_statement(received_order(order,user),NewContext);
	.
//-------------------------------------
//place_order--------------------------
 +!prepare(place_order, Context, Assignment) 
	<- 
		true 
	.

+!action(place_order, Context, Assignment) 
	<- 
		.print("..................................................(place_order) placing order...");

//		!get_variable_value(Assignment, order_id, Order_id);
//		!get_variable_value(Assignment, user_id, User_id);
//		
//		if(Order_id 	\== unbound 	& 
//		   User_id 		\== unbound)
//	    {
//	    	occp.logger.action.info("[place_order] Registerind order ",Order_id);
//	    	occp.action.registerOrder(Order_id, User_id);
//			occp.logger.action.info("[place_order] Order ",Order_id," registered");
//	    }
//	    else
//    	{
//    		occp.logger.action.warn("Variables unbounded (order_id: ",Order_id,", user_id: ",User_id,")");		
//    	}
	.

+!terminate(place_order, Context, Assignment) 
	<- 
//		!register_statement(order_placed(order,user), Context);
true
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
	<- 
		true
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
		//!register_statement(set_user_data(user,email),Context);
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
		
		!get_variable_value(Assignment, order_id, Order_id);
		
		if(Order_id \== unbound)
	    {
	    	occp.action.checkOrderFeasibility(Order_id, Success);
		
			if(Success==true)
			{
				occp.logger.action.info("[check_order_feasibility] Order ",Order_id," is feasible.");
				!register_statement(order_status(accepted), Context);
			}
			else
			{
				occp.logger.action.info("[check_order_feasibility] Order ",Order_id," is NOT feasible.");
				!register_statement(order_status(refused), Context);
			}
	    }
	    else
	    {
	    	occp.logger.action.warn("[check_order_feasibility] Variable unbounded (order_id: ",Order_id,")");
	    	!register_statement(order_status(refused), Context);
	    }
	.

+!terminate(check_order_feasibility, Context, Assignment) 
	<- 
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


