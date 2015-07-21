/**************************
 * @Author: Luca Sabatucci
 * Description:
 * 
 * Last Modifies:
 * 
 * TODOs:
 * 	- dovrei sostituire i vari test goal ?capability_evolution(..) con il piano !get_remote_capability_tx ??
 * 
 *
 * Bugs:  
 * 
 *
 **************************/

{ include("core/goal.asl") }
{ include("core/accumulation.asl") }
{ include("search/collaborative_search_with_accumulation.asl") }

{ include("search/goals_addressing_in_evolution.asl") }
{ include("peer/project_persistance.asl") }

/**
 * signal from Organization artifact 
 */
+call_for_manager(DptNameString,PackNameString)
	<-
		.term2string(DptName,DptNameString);
		.term2string(PackName,PackNameString);
		
		?boss(Boss);
		.send(Boss, achieve, set_musa_status(call_for_manager));
		
		!build_goal_pack(PackName,Pack);
		!check_if_I_am_able_to_manage_dpt( Pack, ManagerBool);
		
		//Initiate the logger for MUSA
		action.initiateLogger(DptNameString);
		.my_name(Me);
		
		if (ManagerBool) 
		{	
			.print("I'm able to manage dpt");
			applyAsDptManager(Me,PackName,Result);
			
			if (Result) 
			{
				occp.logger.action.info("Agent [",Me,"] is going to manage department",DptNameString);
				.print("I'm going to manage department for pack ",Pack);
				!manage_department(Pack, department_context(DptNameString) );
			}			
		} 
		else 
		{
			.wait(100);
			occp.logger.action.info("Agent [",Me,"] is NOT able to manage department");
			.println("I am NOT able to manage ",DptName);
		}
	.


/**
 * Called from each agent. It checks if an agent has a capability which
 * execution generates a world state that will be used as start point for
 * searching solutions.
 */
+!check_if_I_am_able_to_manage_dpt( Pack, ResultBool)
	<-
		Pack=pack(SocialGoal,AgentGoals,Norms,Metrics);		
		!get_goal(SocialGoal, TC, FS, Parlist);
		
		TC = condition(StatementTC);
		//Search for a capability whose execution could generate a world state in which the TC of the social goal is satisfied. 
		//The owner of this capability can take the role of manager
		!check_if_I_am_able_to_monitor(TC,ManagerBool);
		
		//Do a second test on the capabilities that might be parametric 
		!get_assignment_from_par_list(Parlist,SGAssignment);
		!get_var_list_from_assignment_list(SGAssignment, SGVars);
		
		Acc = accumulation(world([]), par_world([],[]), assignment_list([]));
		!check_if_I_am_able_to_monitor(TC, Acc, Parlist, BoolPar);
		
		.eval(ResultBool,BoolPar|ManagerBool);
	.

+!check_if_I_am_able_to_manage_dpt( Pack, ManagerBool)
	<-	ManagerBool=false;
	.

+!check_if_I_am_able_to_monitor(Condition,Bool)
	:
		Condition = condition(LogicFormula)
	<-
		!check_if_I_am_able_to_monitor(LogicFormula,Bool);
	.
+!check_if_I_am_able_to_monitor(LogicFormula,Bool)
	:
		LogicFormula = and(Operands) | LogicFormula = or(Operands)
	<-
		!check_if_I_am_able_to_monitor_list(Operands,Bool);
	.
+!check_if_I_am_able_to_monitor(LogicFormula,Bool)
	:
		LogicFormula = neg(NegLogicFormula)
	<-
		Bool=true;
	.
+!check_if_I_am_able_to_monitor(LogicFormula,Bool)
	:
		LogicFormula = true | LogicFormula = false
	<-
		Bool=true;
	.
+!check_if_I_am_able_to_monitor(LogicFormula,Bool)
	<-
		.findall(Capability,agent_capability(Capability),CapList);
		!unroll_capability_to_check_if_I_am_able_to_monitor(CapList,LogicFormula,Bool);
	.

/**
 * [davide]
 * 
 * use this for testing parametric capability
 */
+!check_if_I_am_able_to_monitor(SocialGoalTC, DummyAccumulation, Parlist, Bool)
	<-
		.findall(Capability,agent_capability(Capability),CapList);		//Build a list containing the names of the avaible capabilities
		!unroll_capability_to_check_if_I_am_able_to_monitor(CapList, SocialGoalTC, DummyAccumulation, Parlist, Bool);
	.

+!check_if_I_am_able_to_monitor_list(Operands,Bool)
	:	Operands	= []
	<-	Bool		= true;
	.
+!check_if_I_am_able_to_monitor_list(Operands,Bool)
	:
		Operands=[ Head | Tail ]
	<-
		!check_if_I_am_able_to_monitor(Head,HeadBool);
		!check_if_I_am_able_to_monitor_list(Tail,TailBool);
		!logic_and(HeadBool,TailBool,Bool);
	.

+!unroll_capability_to_check_if_I_am_able_to_monitor(CapList,LogicFormula,Bool)
	:	CapList	= []
	<-	Bool	= false;
	.


/**
 * [davide]
 * 
 * Unroll the capabilities to check if an agent is able to assume the role of department manager. 
 */
+!unroll_capability_to_check_if_I_am_able_to_monitor(CapList,LogicFormula,Bool)
	:
		CapList=[ Head | Tail ]
	<-
		?capability_evolution(Head,EvolTx);
		!unroll_evolution_to_check_able_to_monitor(EvolTx,LogicFormula,HeadBool);
		
		if (HeadBool=true) 	{Bool = true;} 
		else 				{!unroll_capability_to_check_if_I_am_able_to_monitor(Tail,LogicFormula,Bool);}
	.
	
/**
 * [davide]
 * 
 */
+!unroll_capability_to_check_if_I_am_able_to_monitor(CapList, SocialGoalTC, DummyAccumulation, Parlist,Bool)
	:
		CapList=[ Head | Tail ]
	<-
		?capability_evolution(Head,[EvolTx|_]);
		
		.my_name(Me);
		!apply_accu_evolution_operator([commitment(Me,Head,_)],DummyAccumulation,UpdatedAccumulation);
		
		!check_if_par_condition_addresses_accumulation(SocialGoalTC, UpdatedAccumulation, [], 				
													   Parlist, OutAssignmentTC, TC_Satisfied, 
													   PercentTC);									//Check if the social goal TC satisfied the dummy accumulation state
		
		if (TC_Satisfied=true) 		{Bool = true;} 
		else 						{!unroll_capability_to_check_if_I_am_able_to_monitor(Tail,SocialGoalTC, DummyAccumulation,Parlist,Bool);}
	.
+!unroll_capability_to_check_if_I_am_able_to_monitor(CapList, SocialGoalTC, DummyAccumulation, Parlist,Bool)
	:	CapList	= []
	<-	Bool 	= false;
	.

+!unroll_evolution_to_check_able_to_monitor(EvolTx,LogicFormula,Bool)
	:	EvolTx	= []
	<-	Bool	= false;
	.
+!unroll_evolution_to_check_able_to_monitor(EvolTx,LogicFormula,Bool)
	:
		EvolTx	= [ Head | Tail ]
	&	Head	= add(Predicate)
	<-
		if (Predicate=LogicFormula) {Bool=true;} 
		else 						{!unroll_evolution_to_check_able_to_monitor(Tail,LogicFormula,Bool);}	
	.
+!unroll_evolution_to_check_able_to_monitor(EvolTx,LogicFormula,Bool)
	:	EvolTx = [ Head | Tail ]
	<-	!unroll_evolution_to_check_able_to_monitor(Tail,LogicFormula,Bool);	
	.

+!manage_department(Pack, Context)
	<-
		Context = department_context(DptName);
		
		.println("I will manage ",DptName);
		.my_name(Me);
		addDepartment(DptName,Me);
		
		+manager_of(DptName);

		!recover_projects_from_database(Pack, Context);
		!!activate_dpt_monitor(Pack, Context);
	.
	
/**
 * Activate the trigger capability, that is, the capability that 
 * starts the project organization.
 */
+!activate_dpt_monitor(Pack, DptContext)
	:
		Pack = pack(SocialGoal,AgentGoals,Norms,Metrics) 	&
		(SocialGoal=social_goal(TC,FS,A) 					|
		 SocialGoal=social_goal(TC,FS,A)[_]					|
		 SocialGoal=social_goal(TC,FS,A)[_,_]				|
		 SocialGoal=social_goal(TC,FS,A)[_,_,_])
	<-
		.print("I'M GOING TO ACTIVATE DPT MONITORING. TC: ",TC);
		occp.logger.action.info("Activating department monitoring for ",DptContext);
		!get_goal_Pars([SocialGoal],Pars);
			
		.my_name(Me);
		.findall(commitment(Me,Capability,_), agent_capability(Capability), CS);	
		
		
		//QUI
		
		
		//assegna capability monitor
		
		
		
		
		
		
		
		
		!unroll_parametric_cap_set_to_activate_project(TC, Pars, CS, DptContext);
	.


/**
 * [davide]
 * 
 * DEBUG PLAN FOR +!unroll_parametric_cap_set_to_activate_project 
 */
+!debug_unroll_parametric_cap_set_to_activate_project
	<-
		TC 			= condition(received_order(order,user));
		GoalParams 	= [par(order,12345),par(user,185)];
		.my_name(Me);
		.findall(commitment(Me,Capability,_),agent_capability(Capability),CS);
		.print("CS: ",CS);
		
		//[REMEMBER] when using for debug, remove the !!activate_capability plan 
		//and the DptContext parameter.
		!unroll_parametric_cap_set_to_activate_project(TC, GoalParams, CS);
	.

/**
 * [davide]
 * 
 * Unroll the input capability set CapSet and activate those that represents
 * the trigger capabilities.
 */
+!unroll_parametric_cap_set_to_activate_project(TC, GoalParams, CapSet, DptContext)
	:
		CapSet 	= [Head|Tail]	&
		Head 	= commitment(_,CapabilityName,_)
	<-
		Acc = accumulation(world([]), par_world([],[]), assignment_list([]));			//create an empty accumulation state
		!apply_accu_evolution_operator([Head], Acc, UpdatedAccumulation);				//apply the current capability evolution plan to the empty accumulation state
		!check_if_par_condition_addresses_accumulation(TC, UpdatedAccumulation, [],		//check if the social goal TC is satisfied in the previously created Accumulation 				
													   GoalParams, OutAssignmentTC,  
													   TC_Satisfied, PercentTC);
		
		if(TC_Satisfied==true)
		{
			//If the trigger condition is satisfied, then the current capability is registered to the database.
			!!register_capability(CapabilityName, DptContext);			
		}
		
		!unroll_parametric_cap_set_to_activate_project(TC, GoalParams, Tail, DptContext);			//Recall the plan with the remaining capabilities.
	.
	
+!unroll_parametric_cap_set_to_activate_project(TC, GoalParams, CapSet, DptContext)
	:
		CapSet = []
	.
