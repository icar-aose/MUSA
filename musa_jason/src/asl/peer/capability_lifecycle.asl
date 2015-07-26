/**************************
 * @Author: Luca Sabatucci
 * Description: social goal commitment and orchestration
 * 
 * Last Modifies:  
 * 
 *
 * TODOs:
 * 	
 * Bugs:  
 *
 *
 **************************/
	
/**
 * [davide]
 * 
 * nuovo piano. Contiene le pre/post condition del task a cui appartiene la capability data
 * in ingresso (Capability).
 * 
 * TODO vedi intestazione
 */
+!commit_to_goal_pack(Context,Pack,Capability,TaskPre,TaskPost,AssignmentList)
	<-
		Lifecycle = capability_lifecycle( Pack,Context,ready );
		
		.println(Capability, " is ready");		
		!!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList);
	.

+terminate_social_commitment(Context,Capability)
	<-
		.print("Terminating social commitment for capability ",Capability);
		.drop_intention( capability_achievement_lifecycle(Capability, capability_lifecycle( _,Context,_ ), _, _, _) );
		.abolish( terminate_social_commitment(Context,Capability) );
	.

+terminate_project(Context)
	<-
		Context = project_context(Department,Project);
		.abolish( statement(Department,Project,_) );
		.abolish( data_value(Department,Project,_,_) );
	.

+ping_for_project(Context)[source(Manager)]
	<-
		.my_name(Me);
		.send(Manager,tell,reply_to_ping_for_project(Me,Context));
		.abolish( ping_for_project(Context) );
	.


/* 
 * [davide]
 * 
 * Check the validity of a capability. This is useful to check if
 * a capability can be activated. This plan checks if the pre/post 
 * conditions are verified in the context, then, if they are verified, 
 * check the action validity, that is, a check on the timestamp of the
 * conditions.
 */
+!check_capability_precondition_in_context(Capability,Context,AssignmentList,Validity)
	:
		Lifecycle = capability_lifecycle( Pack,Context,ready )
	<-
		.my_name(Me);
		!get_remote_capability_precondition( commitment(Me, Capability, _), PreCondition );
		!check_condition_true_in_context(Capability, PreCondition, Context, AssignmentList, PreBool);

		//Is the pre-condition is satisfied, proceed checking the post-condition
		if (PreBool)
		{			
			!get_remote_capability_postcondition(commitment(Me, Capability, _), PostCondition);
			!check_condition_true_in_context(Capability, PostCondition, Context, AssignmentList, PostBool);
		} 
		else {PostBool=false;}
		
		if (PreBool==true & PostBool==false) 	{Validity=true;}
		if (PreBool==true & PostBool==true) 	{!check_action_validity(Capability,Context,Validity);}
		if (PreBool==false) 					{Validity=false;}
	.
	
/* 
 * [davide]
 * 
 * Check the validity of a task or a capability. This is useful to check if
 * a capability/task can be activated. This plan checks if the pre/post 
 * conditions are verified in the context, then, if they are, check
 * the action validity, that is, a check on the timestamp of the
 * conditions.
 */
+!check_task_conditions_in_context(PreCondition, PostCondition, Context, AssignmentList, Validity)
	:
		Lifecycle = capability_lifecycle( Pack,Context,ready )
	<-
		!check_condition_true_in_context(_, PreCondition, Context, AssignmentList, PreBool);
				
		//Is the pre-condition is satisfied, proceed checking the post-condition
		if (PreBool==true) 					{!check_condition_true_in_context(_, PostCondition, Context, AssignmentList, PostBool);}//{!check_condition_true_in_context(PostCondition, Context, PostBool);} 
		else 								{PostBool=false;}
		
		if (PreBool==true & PostBool==false) 	{Validity=true;}
		if (PreBool==true & PostBool==true) 	{!check_action_validity(PreCondition,PostCondition,Context,Validity);}
		if (PreBool==false) 					{Validity=false;}
	.
	
/* 
 * [davide]
 * 
 * Check if the parameters of a capability are contained within the context. That is,
 * Validity is unified with true if all the parameters of the capability are contained 
 * within the context.
 */
+!check_capability_parameters_in_context(Capability,Context,ParentTaskAssignments,Validity)
	:
		.list(ParentTaskAssignments) &
		Lifecycle = capability_lifecycle( Pack,Context,ready )
	<-
		?capability_parameters(Capability, CapabilityParametersList);
		!check_if_every_capability_parameter_has_an_assignment(CapabilityParametersList, ParentTaskAssignments, Validity);
	.
+!check_capability_parameters_in_context(Capability,Context,ParentTaskAssignments,Validity)
	<-
		Validity = true;
	.
+!debug_check_if_every_capability_parameter_has_an_assignment
	<-
		CapParams 		= [emergency_location,worker];
		TaskAssignment 	= [assignment(emergency_location,location),assignment(worker,worker_operator)];
		
		!check_if_every_capability_parameter_has_an_assignment(CapParams, TaskAssignment, Validity);
		.print("Validity: ",Validity);
	.

/**
 * [davide]
 * 
 * Check if exists an assignment for every parameter within the CapabilityParameters term list.
 */
+!check_if_every_capability_parameter_has_an_assignment(CapabilityParameters, TaskAssignment, Validity)
	:
		CapabilityParameters = [Head|Tail]
	<-
		!check_if_every_capability_parameter_has_an_assignment(Tail, TaskAssignment, ValidityRec);
		if( .member(assignment(Head,_), TaskAssignment) )	{	CurrentValidity = true;	}
		else												{	CurrentValidity = false; }
		.eval(Validity, CurrentValidity & ValidityRec);
	.
+!check_if_every_capability_parameter_has_an_assignment(CapabilityParameters, TaskAssignment, Validity)
	:	CapabilityParameters 	= []
	<-	Validity 				= true;
	.
-!check_capability_parameters_in_context(Capability,Context,ParentTaskAssignments,Validity)
	<-
		.print("Failed to execute plan check_capability_parameters_in_context.....");
		Validity = true;
	.

/*
 * Capability life cycle plans. These plans checks if pre condition and parameters are valid.
 * If true, change the capability state from ready to active state. 
 */
 
//********************************
//		READY STATE
//********************************
+!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,  AssignmentList)
	:
		Lifecycle = capability_lifecycle( Pack,Context,ready )
	<-
		?track_capability_status(TS);
		if(TS){set_capability_status(Capability, ready);}
		occp.action.setOCCPcapabilityStatus(Capability, ready);
		
		
		
		
		.my_name(Me);
		!get_remote_capability_precondition(commitment(Me,Capability,_), PreCondition);
		!check_task_conditions_in_context(TaskPre, TaskPost, Context, AssignmentList, ValidityTaskPre);
		
		!check_capability_precondition_in_context(Capability, Context, AssignmentList, ValidityPre);
		
		.eval(Validity, ValidityPre & ValidityTaskPre /*[TODO] & NormValidity*/);
		if(Validity)
		{
			!check_capability_parameters_in_context(Capability,Context,AssignmentList, ValidityPar);
			if (ValidityPar)
			{	
				NewLifecycle = capability_lifecycle( Pack, Context, active );					//Change from ready to active state and start a new life cycle
				!!capability_achievement_lifecycle(Capability,NewLifecycle, TaskPre,TaskPost,AssignmentList);
				.println(Capability, " is active");
			} 
		}
		else 
		{
			?frequency_perception_loop(Delay);
			.wait(Delay);
			
			!!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList);
		}		
	.
//********************************
//		ACTIVE STATE
//********************************
+!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList)
	:
		Lifecycle = capability_lifecycle( Pack,Context,active )
	<-
		?track_capability_status(TS);
		if(TS){set_capability_status(Capability, active);}
		occp.action.setOCCPcapabilityStatus(Capability, active);
		
		
		.print("Invoking capability [",Capability,"]");
		
		.my_name(Me);
		!check_if_capability_is_of_type(commitment(Me,Capability,_), parametric, IsParametric);
		
		if(IsParametric)				{!invoke_project_capability(Capability, Context, AssignmentList);}
		else							{!invoke_project_capability(Capability, Context);}
		
		NewLifecycle = capability_lifecycle( Pack,Context,wait );

		?frequency_perception_loop(Delay);
		.wait(Delay);

		!!capability_achievement_lifecycle(Capability,NewLifecycle, TaskPre,TaskPost,AssignmentList);
		.println(Capability, " is wait");
	.
//********************************
//		WAIT STATE
//********************************
+!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList)
	:
		Lifecycle = capability_lifecycle( Pack,Context,wait )
	&	done(Capability,Context)
	<-
		!retreat_project_capability(Capability, Context);
		
		?frequency_perception_loop(Delay);
		.wait(Delay);
		
		NewLifecycle = capability_lifecycle( Pack,Context,check );
		!!capability_achievement_lifecycle(Capability,NewLifecycle, TaskPre,TaskPost,AssignmentList);
		.println(Capability, " is check");
		-done(Capability,Context);
	.
+!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList)
	:
		Lifecycle = capability_lifecycle( Pack,Context,wait )
	&	error(Capability,Context)
	<-
		!retreat_project_capability(Capability, Context);
		
		?frequency_perception_loop(Delay);
		.wait(Delay);
		
		
		NewLifecycle = capability_lifecycle( Pack,Context,failure );
		!!capability_achievement_lifecycle(Capability,NewLifecycle, TaskPre,TaskPost,AssignmentList);
		-error(Capability,Context);
		.println(Capability, " is failure");
		
	.
+!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList)
	:
		Lifecycle = capability_lifecycle( Pack,Context,wait )
	<-
		?frequency_short_perception_loop(Delay);
		.wait(Delay);
		!!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList);
	.
+!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList)
	:
		Lifecycle = capability_lifecycle( Pack,Context,check )
	<-
		?track_capability_status(TS);
		if(TS){set_capability_status(Capability, check);}
	
		?frequency_perception_loop(Delay);
		.wait(Delay);
	
		?capability_postcondition(Capability, PostCondition );
		.my_name(Me);
		
		!check_condition_true_in_context(Capability, PostCondition, Context, AssignmentList, Bool);
		
		if (Bool) 
		{
			.println(Capability," was succesfully done");
			NewLifecycle = capability_lifecycle( Pack,Context,success );
			!!capability_achievement_lifecycle(Capability,NewLifecycle, TaskPre,TaskPost,AssignmentList);
		} 
		else 
		{
			.println(Capability," was not succesful");
			NewLifecycle = capability_lifecycle( Pack,Context,failure );
			!!capability_achievement_lifecycle(Capability,NewLifecycle, TaskPre,TaskPost,AssignmentList);
		}
	.
//********************************
//		SUCCESS STATE
//********************************
+!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList)
	:
		Lifecycle = capability_lifecycle( Pack,Context,success )
	<-
		?track_capability_status(TS);
		if(TS){set_capability_status(Capability, success);}
	
		occp.action.setOCCPcapabilityStatus(Capability, success);
	
	
		?frequency_long_perception_loop(Delay);
		.wait(Delay);
	
		//TODO DECREASE FAILURE RATE HERE
		//ANTONELLA START MODIFY
		//verifico se la capabiliy è in black list, 
		//se è cosi decremento richaiamo un operation che derementa il valore del campo failure_rate della tabella adw_blacklist
		//se tale valore diventa = la capbility deve essere rimossa dalla black list
		.my_name(Me);
		
		if(.desire(capability_blacklist(Me,Capability,_)))
		{
			updateFailureRate(Capability);
			//se l'operation ritorna false allora la capabiliy va rimossa dalla black list 
		}
		
		//ANTONELLA END MODIFY
		
		NewLifecycle = capability_lifecycle( Pack,Context,ready );
		!!capability_achievement_lifecycle(Capability,NewLifecycle, TaskPre, TaskPost,AssignmentList);
		.println(Capability, " is ready");
	.
//********************************
//		FAILURE STATE
//********************************
+!capability_achievement_lifecycle(Capability,Lifecycle,TaskPre,TaskPost,AssignmentList)
	:
		Lifecycle = capability_lifecycle( Pack,Context,failure )
	<-
		?track_capability_status(TS);
		if(TS){set_capability_status(Capability, failed);}
		occp.action.setOCCPcapabilityStatus(Capability, failed);
		
		//Takes the exact time in which the capability has failed
		!numeric_timestamp(FailureTimestamp);

		//Communicate the capability failure to the dpt manager
		!communicate_failure(Capability, FailureTimestamp, Lifecycle);
	.

/**
 * Communicate the failure of a capability to the department manager.
 * This plan is executed when a capability fails its execution (in other
 * words, when its post-condition is not verified in context after its
 * execution)
 */
+!communicate_failure(Capability, FailureTimestamp, Lifecycle)
	<-
		Lifecycle 	= capability_lifecycle( Pack,Context,State );
		Context 	= project_context(Department , Project);
		getDptManager(Department,Manager);		
		.my_name(Me);
		
		.send(Manager,tell,capability_failure(Capability, Me, FailureTimestamp, Context));
	.

/**
 * Check if a condition is verified in context. This is used when a capability is in check
 * state and its par_condition must be verified in current world state to check if the 
 * capability has terminated correctly or not.
 */
+!check_condition_true_in_context(Capability, Condition, Context, AssignmentSet, Bool)
	<-
		!build_current_state_of_world(Context, World);
		
		UpdatedAccumulation = accumulation(World, par_world([],[]), assignment_list([]));		
		
		//Test the condition within the current world state
		if(not .empty(AssignmentSet))	
		{	
			!check_if_par_condition_addresses_accumulation(Condition, UpdatedAccumulation, [], [], _, Bool, _);
		}
		else							
		{
			!test_condition(Condition, UpdatedAccumulation, Bool);
		}
	.
//TODO da eliminare.....
+!check_condition_true_in_context(Condition, Context, Bool)
	<-
		!build_current_state_of_world(Context, World);
		World=world(WS);
		!test_condition(Condition, WS, Bool);
	.

/**
 * [luca]
 * 
 * This test determines if a capability can be executed by doing a test on
 * the timestamps of the pre/post conditions of the capability in the context.
 * 
 * NOTE: if this test is skipped, the execution of a set of capability could not
 * end while executing a solution. This may lead to a undesiderable behavior.
 */
+!check_action_validity(Capability,Context,Validity)
	<-
		?capability_precondition(Capability, PreCondition );
		?capability_postcondition(Capability, PostCondition );
		!get_condition_timestamp_in_context(PreCondition,Context,TSPre);
		!get_condition_timestamp_in_context(PostCondition,Context,TSPost);
		if ( earlier(TSPost,TSPre) ) 	{ Validity=true; } 
		else 							{ Validity=false; }
	.
+!check_action_validity(PreCondition,PostCondition,Context,Validity)
	<-
		!get_condition_timestamp_in_context(PreCondition,Context,TSPre);
		!get_condition_timestamp_in_context(PostCondition,Context,TSPost);
		if ( earlier(TSPost,TSPre) ) 	{ Validity=true; } 
		else 							{ Validity=false; }
	.

+!get_variable_value(VarList, Context, Var, Value)
	:
		VarList 	= [Head|Tail]					&
		Head 		= assignment(VarName,VarVal)	&
		VarName		= Var
	<-
		Value = VarVal;
	.
+!get_variable_value(VarList, Context, Var, Value)
	:
		VarList 	= [Head|Tail]					&
		Head 		= assignment(VarName,VarVal)	&
		VarName		\== Var
	<-
		!get_variable_value(Tail, Context, Var, Value)
	.
+!get_variable_value(VarList, Context, Var, Value)
	:	VarList = []
	<-	Value 	= unbound;
	.
+!get_variable_value(VarList, Context, Var, Value)
	<-
		//check in context
		!get_data_value(Var, DataValue, Context);	
		
		if(DataValue == null) 	{Value = unbound;}
		else 					{Value = DataValue;}
	.
+!get_variable_value(VarList, Context, Var, Value)
	<-	Value 	= unbound;
	.

+!get_condition_timestamp_in_context(Condition,Context,TimeStamp)
	:	/** [last modifies - davide - 2015-4-27] */
		Condition = par_condition(Variables,ParamLogicFormula)	
	<-
		!convert_parametric_to_simple_formula(ParamLogicFormula, Variables, [], LogicFormula);
		!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp);
	.	
+!get_condition_timestamp_in_context(Condition,AssignmentSet,Context,TimeStamp)
	:	/** [last modifies - davide - 2015-4-27] */
		Condition = par_condition(Variables,ParamLogicFormula)	
	<-
		!convert_parametric_to_simple_formula(ParamLogicFormula, Variables, AssignmentSet, LogicFormula);
		!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp);
	.	
+!get_condition_timestamp_in_context(Condition,Context,TimeStamp)
	:	
		Condition=condition(LogicFormula)	
	<-
		!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp);
	.	
+!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp)
	:
		LogicFormula = and(Operands)
	<-
		!get_logic_and_timestamp_in_context(Operands,Context,TimeStamp);
		//.println("AND: ",TimeStamp);
	.
+!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp)
	:
		LogicFormula = or(Operands)
	<-
		!get_logic_or_timestamp_in_context(Operands,Context,TimeStamp);
	.
+!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp)
	:
		LogicFormula = neg(NegLogicFormula)
	<-
		TimeStamp=no_timestamp;	// CONTROLLARE QUESTA AFFERMAZIONE
	.
+!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp)
	:
		LogicFormula = true | LogicFormula = false
	<-
		TimeStamp=no_timestamp;	// CONTROLLARE QUESTA AFFERMAZIONE
	.
+!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp)
	:
		statement(Department,Project,Statement)[ts(YYYY,MM,DD,HH,M,SS)]
	&	Context=project_context(Department,Project)	
	&	Statement = LogicFormula	
	<-
		TimeStamp=ts(YYYY,MM,DD,HH,M,SS);
	.
+!get_logic_formula_timestamp_in_context(LogicFormula,Context,TimeStamp)
	<-
		TimeStamp=no_timestamp;
	.

+!get_logic_and_timestamp_in_context(Operands,Context,TimeStamp)
	:
		Operands=[]
	<-
		TimeStamp=no_timestamp;
	.
+!get_logic_and_timestamp_in_context(Operands,Context,TimeStamp)
	:
		Operands=[ Head | Tail ]
	<-
		!get_logic_formula_timestamp_in_context(Head,Context,HeadTimeStamp);
		!get_logic_and_timestamp_in_context(Tail,Context,TailTimeStamp);

		!pick_most_recent( HeadTimeStamp,TailTimeStamp,TimeStamp );		
		//.println("between: ",HeadTimeStamp," and ",TailTimeStamp," -> ",TimeStamp);
	.
	
+!get_logic_or_timestamp_in_context(Operands,Context,TimeStamp)
	:
		Operands=[]
	<-
		TimeStamp=no_timestamp;
	.
+!get_logic_or_timestamp_in_context(Operands,Context,TimeStamp)
	:
		Operands=[ Head | Tail ]
	<-
		!get_logic_formula_timestamp_in_context(Head,Context,HeadTimeStamp);
		!get_logic_or_timestamp_in_context(Tail,Context,TailTimeStamp);

		!pick_most_recent( HeadTimeStamp,TailTimeStamp,TimeStamp );		
		//.println("between: ",HeadTimeStamp," or ",TailTimeStamp," -> ",TimeStamp);
	.


/* a system goal is a bridge when it is the first goal of a workflow and it must be activated before the workflow instantiation */
system_goal_is_a_bridge(SystemGoal,SocialGoal)
	:-
		triggering_condition(SystemGoal,SystemTC)
	&	triggering_condition(SocialGoal,SocialTC)
	&	equal_condition(SystemTC,SocialTC)
	.

/**
 * 
 * INUTILIZZATI
 * 
 */
+!commit_to_system_goal(SystemGoal,SocialGoal,project_context(DepartmentName,ProjectName)) 
	: 
		system_goal_is_a_bridge(SystemGoal,SocialGoal) 
	<- 
		true
	.
+!commit_to_system_goal(SystemGoal,SocialGoal,Context)
	:
		Context = project_context(DepartmentName,ProjectName)
	&	not project(ProjectName,DepartmentName,_,_)
	<- 
		?frequency_term_update(Delay);
		.wait(Delay);
		!!commit_to_system_goal(SystemGoal,SocialGoal,Context);
	.

+!commit_to_system_goal(SystemGoal,SocialGoal,Context) 
	<- 
		.println("committing to ",SystemGoal," in ",SocialGoal);
		
		Lifecycle = goal_lifecycle(SystemGoal, ready );
		
		!achievement_lifecycle(SystemGoal,Lifecycle,Context,run);
	.

+!drop_system_goal_commitment(Context)
	<-		
		.drop_intention(achievement_lifecycle(_,_,Context,_));
	.


/* ACTION-PERCEPTION LOOP */
+!achievement_lifecycle(SystemGoal,Lifecycle,Context,ExcutionContext)
	:
		 ExcutionContext = pause
	<-
		?frequency_perception_loop(Delay);
		.wait(Delay);
		!achievement_lifecycle(SystemGoal,Lifecycle,Context,ExcutionContext);
	.
+!achievement_lifecycle(SystemGoal,Lifecycle,Context,ExcutionContext)
	:
		 ExcutionContext = drop
	<-
		.drop_intention(achievement_lifecycle(_,_,Context,_));
	.
/* system goal is ready: do perception for triggering condition */
+!achievement_lifecycle(SystemGoal,Lifecycle,Context,run) 
	: 
		Lifecycle = goal_lifecycle(SystemGoal, ready )
	&	triggering_condition(SystemGoal,TC)
	<- 
		!verify_triggering_condition_catched(TC,Context,VerifyResult,CatchedTimeStamp);		/* perception_activity.asl */
		
		!check_TC_perception_result(loop(SystemGoal,Lifecycle,Context),VerifyResult,CatchedTimeStamp);
	.
/* perception catched: execute capacity */
+!achievement_lifecycle(SystemGoal,Lifecycle,Context,run) 
	:
		Lifecycle = goal_lifecycle(SystemGoal, active, Capacity )
	<-
		!invoke_project_capacity(Capacity,Context);

		UpdatedLifecycle = goal_lifecycle(SystemGoal, capacity_attempted, Capacity );
		!!achievement_lifecycle(SystemGoal,UpdatedLifecycle,Context,run);
	.
/* capacity is terminated: do verify final state */
+!achievement_lifecycle(SystemGoal,Lifecycle,Context,run) 
	:
		Lifecycle = goal_lifecycle(SystemGoal, capacity_attempted, Capacity )
	&	done(Capacity,Context)	
	&	final_state(SystemGoal,FS)
	<-
		.abolish(done(Capacity,Context));
		
		?frequency_perception_loop(Delay);
		.wait(Delay);
		
		!verify_final_state_addressed(FS,Context,VerifyResult,CatchedTimeStamp);		/* perception_activity.asl */
		!check_FS_perception_result(loop(SystemGoal,Lifecycle,Context),VerifyResult,CatchedTimeStamp);		
	.
/* capacity is not yet terminated: wait */
+!achievement_lifecycle(SystemGoal,Lifecycle,Context,run) 
	:
		Lifecycle = goal_lifecycle(SystemGoal, capacity_attempted, Capacity )
	<-
		?frequency_perception_loop(Delay);
		.wait(Delay);
		!!achievement_lifecycle(SystemGoal,Lifecycle,Context,run);
	.
/* capacity terminated badly: TODO */
+!achievement_lifecycle(SystemGoal,Lifecycle,Context,run) 
	:
		Lifecycle = goal_lifecycle(SystemGoal, failure )
	<-
		//TO DO: HANDLING ERROR IN FINAL STATE
		?frequency_perception_loop(Delay);
		.wait(Delay);
		!!achievement_lifecycle(SystemGoal,Lifecycle,Context,run);
	.
+!achievement_lifecycle(SystemGoal,Lifecycle,Context,_) <-true.




+!check_TC_perception_result(Loop,Result,CatchedTimeStamp) 
	:
		Result = true
	<- 
		Loop = loop(SystemGoal,Lifecycle,Context);
		?final_state(SystemGoal,FinalState);
		!bridge_system_to_capacity(FinalState,Capacity);

		!is_state_true(action(Capacity,success),ActionDoneResult,ActionDoneTime,Context);
		
		!check_action_notyetdone(Loop,Capacity,CatchedTimeStamp,ActionDoneTime);
	.
+!check_TC_perception_result(Loop,Result,_) 
	: 
		Result = false
	<- 
		?frequency_perception_loop(Delay);
		.wait(Delay);
		Loop = loop(SystemGoal,Lifecycle,Context);
		!!achievement_lifecycle(SystemGoal,Lifecycle,Context,run);
	.

+!check_action_notyetdone(Loop,Capacity,CatchedTimeStamp,ActionDoneTime)
	:
		(
			ActionDoneTime=no_timestamp		
		|	earlier(ActionDoneTime,CatchedTimeStamp)		
		)
	<-
		Loop = loop(SystemGoal,Lifecycle,Context);
		UpdatedLifecycle = goal_lifecycle(SystemGoal, active, Capacity );
		
		!!achievement_lifecycle(SystemGoal,UpdatedLifecycle,Context,run); 
		
	.
+!check_action_notyetdone(Loop, Capacity, CatchedTimeStamp, ActionDoneTime) 
	<- 
		?frequency_perception_loop(Delay);
		.wait(Delay);
		Loop = loop(SystemGoal,Lifecycle,Context);
		!!achievement_lifecycle(SystemGoal,Lifecycle,Context,run);
	.

+!check_FS_perception_result(Loop,true,CatchedTimeStamp)
	<- 
		Loop = loop(SystemGoal,Lifecycle,Context);
		Lifecycle = goal_lifecycle(SystemGoal, capacity_attempted, Capacity );
		
		!is_state_true(action(Capacity,success),ActionDoneResult,ActionDoneTime,Context);

		!retreat_project_capacity(Capacity,Context);
		!register_state(action(Capacity,success),Context);
		
		UpdatedLifecycle = goal_lifecycle(SystemGoal, ready );
		
		?frequency_perception_loop(Delay);
		.wait(Delay);
		!!achievement_lifecycle(SystemGoal,UpdatedLifecycle,Context,run);
	.
+!check_FS_perception_result(Loop,false,_) : true 
	<- 
		Loop = loop(SystemGoal,Lifecycle,Context);
		Lifecycle = goal_lifecycle(SystemGoal, capacity_attempted, Capacity );
		
		// FAILURE
		!retreat_project_capacity(Capacity,Context);
		!register_state(action(Capacity,failure),Context);
		
		UpdatedLifecycle = goal_lifecycle(SystemGoal, failure );
		?frequency_perception_loop(Delay);
		.wait(Delay);
		!!achievement_lifecycle(SystemGoal,UpdatedLifecycle,Context,run);
	.

+!bridge_system_to_capacity(FinalState,Capacity)
	<- 
		!list_of_dependencies(FinalState,DepList);
		
		!pick_capacity_for(DepList,Capacity);	// UPGRADE: WHAT IF WHEN MORE CAPACITY MATCH A FINAL STATE
	.

capacity_match_with_outdeplist(Capacity,DepList)
	:-
		DepList = [H]
	&	plan_output(Capacity, H )
	.
capacity_match_with_outdeplist(Capacity,DepList)
	:-
		DepList = [H | T]
	&	plan_output(Capacity, H )
	&   capacity_match_with_outdeplist(Capacity,T)
	.

+!pick_capacity_for(DepList,Capacity)
	: 
		capacity_match_with_outdeplist(Capacity,DepList)
	<-
		true
	.
+!pick_capacity_for(DepList,no_capacity) <- true.
