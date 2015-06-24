/**************************
 * @Author: Luca Sabatucci, Davide Guastella
 * Description: project manager role activities
 * 
 * Last Modifies:  
 * 
 *
 * TODO: 
 *	
 * Bugs:  
 * 
 *
 **************************/

{ include("core/goal.asl") }


/*
 * For debug purpose use existing project name and department name.
 */
+!create_project(DepartmentName,ProjectName)
	<-	
		
		Context = project_context(DepartmentName,ProjectName);
		.delete("_dept",DepartmentName,SocialGoalName);
		.term2string(SocialGoal,SocialGoalName);

		.println("organizing for event ",ProjectName);
		!build_goal_pack(SocialGoal,Pack);
		!organize_solution(Context,Pack);
	.
//-!create_project(DepartmentName, ProjectName)
//	<-
//		.println("Cannot create project (Dpt name: ",DepartmentName," Project name: ",ProjectName,")");
//		occp.logger.action.fatal("Cannot create project (Dpt name: ",DepartmentName," Project name: ",ProjectName,")");
//		?frequency_long_perception_loop(Delay);
//		.wait(Delay);
//		!!create_project(DepartmentName,ProjectName);
//	.



/**
 * [davide]
 * 
 * Retrieve from the database the previously blacklisted capability 
 * referred to the given context. For each blacklisted capability found,
 * a belief is added into the dpt manager knowledge base.
 */
+!read_blacklist_from_database(Context)
	<-
		Context 	= project_context(Department , Project);
		getBlacklistedCapabilitySet(Project);
	.
	
/**
 * 
 * This plan is triggered when an employee agent tell the project manager that 
 * one of its capabilities is failed. The project manager, when receive this message,
 * add the involved capability into the blacklist. Also, the project manager keep
 * in its knowledge base the predicate capability_error(...) that will cause a
 * replanning of the project. 
 */ 
+capability_failure(Capability, Agent, Context)
	<-
		?blacklist_enabled(BlacklistEnabled);
		
		+capability_error(Context);
		
		if(BlacklistEnabled)
		{
			insertOrUpdateCapabilityIntoBlacklist(Capability, Agent);	
			getBlacklistedCapabilityTimestamp(Capability, Agent, TSstr);
			.term2string(TS,TSstr);

			.print("[BLACKLIST] Capability [",Capability,"] Added/Updated in blacklist @",TS);
			.send(Agent, tell, capability_blacklist(Me, Capability, TS));
		}
		.abolish( capability_failure(Capability, Agent, Context) );
	.
	
+!organize_solution(Context, Pack)
	<-
		?blacklist_enabled(BlacklistEnabled);
//		action.clearContext;
		occp.logger.action.info("Organizing solution. Context: ",Context);
		getEmployees(DptMembers);

		.my_name(Me);
		.delete(Me,DptMembers,Members);
		!build_current_state_of_world(Context,WI);
		!retrieve_assignment_from_context(Context, AssignmentList);		//????
		
		Accumulation_state = accumulation(WI, par_world([],[]), assignment_list(AssignmentList));
		
		if(BlacklistEnabled)	
		{
			!read_blacklist_from_database(Context);
				
			//Keep the timestamp of when the solution planning is starting  
			getDatabaseSystemCurrentTimeStamp(NowStr);
			.term2string(Now,NowStr);
			+orchestration_start_at(Now);
			
			.abolish( blacklist_access(_) );
			+blacklist_access(0);
		}
		
		!orchestrate_search_in_solution_space(Accumulation_state,Pack,Members,[TheSolution|_]);
		//TODO per adesso assumiamo che la orchestrate_search restituisca la migliore soluzione
		
//		?blacklist_access(BA);
//		.print("######################\nblacklist accesses: ",BA,"\n######################");
		
		if(BlacklistEnabled)	
		{
			
			-orchestration_start_at(Now);
		}
		
		Context = project_context(DepartmentName,ProjectName);
		
		if(	TheSolution \== no_solution)
		{			
			Pack = pack(SG, AG_list, _, _); 
			
			//Unroll the found solution to set the assignment values to these in the context
			!unroll_solution_to_set_goal_param_values_into_assignment([TheSolution], AG_list, Context, [TheSolutionWithAssignment|_]);
			
			//Update the project in the database
			TheSolutionWithAssignment = item(cs(CS), Accumulation, ag(AG), HeadScore);
			.term2string(CS,CSString);
			updateProject(ProjectName, Me, CSString, "current");

			.print("Soluzione finale: ",TheSolutionWithAssignment);
			
			//Start the social commitment
//			occp.logger.action.info("Activating social commitment");
			.print("Activating social commitment");
			!activate_social_commitment(Context,Pack,TheSolutionWithAssignment);
//			occp.logger.action.info("Activating project monitoring");
			
			.print("Activating project monitoring");
			!activate_project_monitoring(Context,Pack,TheSolutionWithAssignment);
//			occp.logger.action.info("Activating goal state monitoring");
			.print("Activating goal state monitoring");	
			!activate_goal_state_monitoring(Context, Pack);
		}
		else
		{
			occp.logger.action.warn("No solution found. Waiting...");
			.print("NO SOLUTION. Idle...");
			?frequency_long_perception_loop(Delay);
			.wait(Delay);
			!!organize_solution(Context, Pack);
		}
	.		
	


/**
 * [davide]
 * 
 * DEBUG PLANS FOR +!unroll_solution_to_set_goal_param_values_into_assignment
 */
+!debug_unroll_solution_to_set_goal_param_values_into_assignment_1
	<-
		CS=[item(cs([task(condition(or([order_deleted(order),done(fulfill_order)])),condition(done(complete_transaction)),[add(done(complete_transaction)),add(order_deleted(order_id))],cs([commitment(worker,complete_transaction,1),commitment(failure_handler,delete_order,1)]),[assignment(order_id,order)],norms([]))]),accumulation(world([done(complete_transaction),done(fulfill_order),order_deleted(order),received_order(order,user)]),par_world([order_id],[property(order_deleted,[order_id])]),assignment_list([assignment(order_id,order)])),ag([]),0.09530107160810088),item(cs([task(condition(or([order_deleted(order),done(fulfill_order)])),condition(done(complete_transaction)),[add(done(complete_transaction))],cs([commitment(worker,complete_transaction,1)]),[],norms([]))]),accumulation(world([done(complete_transaction),done(fulfill_order),order_deleted(order),received_order(order,user)]),par_world([],[]),assignment_list([])),ag([]),0.11812322182992825)];
		GoalList=[social_goal(condition(or([order_deleted(order),done(fulfill_order)])),condition(done(complete_transaction)),system)[goal(g8),pack(p4),parlist([par(order,12345)])]];
		
		!unroll_solution_to_set_goal_param_values_into_assignment(CS, GoalList, OutCS);
		.print("[test 1] OutCS: ",OutCS);
	.	
+!debug_unroll_solution_to_set_goal_param_values_into_assignment_2
	<-
		CS=[item(cs([task(condition(order_placed(order,user)),condition(set_user_data(user,email)),[add(order_deleted(order_id)),add(set_user_data(user_id,user_email))],cs([commitment(worker,set_user_data,1),commitment(failure_handler,delete_order,1)]),[assignment(user_email,email),assignment(user_id,user)],norms([]))]),accumulation(world([order_placed(order,user),received_order(order,user)]),par_world([order_id,user_email,user_id],[property(order_deleted,[order_id]),property(set_user_data,[user_id,user_email])]),assignment_list([])),ag([]),0.09530107160810088),item(cs([task(condition(order_placed(order,user)),condition(set_user_data(user,email)),[add(set_user_data(user_id,user_email))],cs([commitment(worker,set_user_data,1)]),[assignment(user_email,email),assignment(user_id,user)],norms([]))]),accumulation(world([order_placed(order,user),received_order(order,user)]),par_world([user_email,user_id],[property(set_user_data,[user_id,user_email])]),assignment_list([])),ag([]),0.11812322182992825)];
		GoalList=[social_goal(condition(order_placed(order,user)),condition(set_user_data(user,email)),system)[goal(g1),pack(p4),parlist([par(user,185),par(email,"davide.guastella90_AT_gmail.com")])]];
		
		!unroll_solution_to_set_goal_param_values_into_assignment(CS, GoalList, OutCS);
		.print("[test 2] OutCS: ",OutCS);
	.

+!debug_unroll_solution_to_set_goal_param_values_into_assignment_3
	<-	
	    CS = [item(cs([task(condition(and([received_order(order,user),true])),condition(done(complete_transaction)),[add(done(complete_transaction))],cs([task(condition(billing_delivered(billing,recipient_id,order,email)),condition(billing_uploaded(user)),[add(billing_uploaded(user_id))],cs([commitment(order_manager,upload_billing_to_user_cloud,1)]),[assignment(user_id,user)],norms([])),task(condition(set_user_data(user,email)),condition(order_checked(order)),[add(order_checked(order_id))],cs([commitment(worker,check_order_feasibility,1)]),[assignment(order_id,order)],norms([])),task(condition(received_order(order,user)),condition(order_placed(order,user)),[add(order_placed(order_id,user_id))],cs([commitment(worker,place_order,1)]),[assignment(order_id,order),assignment(user_id,user)],norms([])),task(condition(order_placed(order,user)),condition(set_user_data(user,email)),[add(set_user_data(user_id,user_email))],cs([commitment(worker,set_user_data,1)]),[assignment(user_email,email),assignment(user_id,user)],norms([])),task(condition(or([order_deleted(order),fulfill_order(order,user)])),condition(done(complete_transaction)),[add(done(complete_transaction))],cs([commitment(worker,complete_transaction,1)]),[],norms([])),task(condition(notify_order_unfeasibility(message)),condition(order_deleted(order)),[add(order_deleted(order_id))],cs([commitment(failure_handler,delete_order,1)]),[assignment(order_id,order)],norms([])),task(condition(billing_uploaded(user)),condition(fulfill_order(order,user)),[add(done(complete_transaction)),add(order_checked(order_id)),add(order_deleted(order_id)),add(fulfill_order(order_id,user_id))],cs([commitment(order_manager,fulfill_order,1),commitment(worker,complete_transaction,1),commitment(worker,check_order_feasibility,1),commitment(failure_handler,delete_order,1)]),[assignment(order_id,order),assignment(user_id,user)],norms([])),task(condition(and([order_checked(order),order_status(refused)])),condition(notify_order_unfeasibility(message)),[add(notify_order_unfeasibility(notification_message))],cs([commitment(failure_handler,notify_order_unfeasibility,1)]),[assignment(notification_message,message)],norms([])),task(condition(and([order_checked(order),order_status(accepted)])),condition(billing_delivered(billing,recipient_id,order,email)),[add(billing_delivered(billing_data,recipient,order_id,recipient_email))],cs([commitment(order_manager,deliver_billing,1)]),[assignment(billing_data,billing),assignment(order_id,order),assignment(recipient,recipient_id),assignment(recipient_email,email)],norms([]))]),[],norms([]))]),accumulation(world([true,done(complete_transaction),received_order(order,user)]),par_world([],[]),assignment_list([])),ag([agent_goal(condition(or([order_deleted(order),fulfill_order(order,user)])),condition(done(complete_transaction)),system)[goal(g8),pack(p4),parlist([])],agent_goal(condition(notify_order_unfeasibility(message)),condition(order_deleted(order)),system)[goal(g7),pack(p4),parlist([par(order,idOrder)])],agent_goal(condition(and([order_checked(order),order_status(refused)])),condition(notify_order_unfeasibility(message)),system)[goal(g6),pack(p4),parlist([par(message,user_message)])],agent_goal(condition(billing_uploaded(user)),condition(fulfill_order(order,user)),system)[goal(g5),pack(p4),parlist([par(order,idOrder),par(user,idUser)])],agent_goal(condition(billing_delivered(billing,recipient_id,order,email)),condition(billing_uploaded(user)),system)[goal(g4),pack(p4),parlist([par(user,idUser)])],agent_goal(condition(and([order_checked(order),order_status(accepted)])),condition(billing_delivered(billing,recipient_id,order,email)),system)[goal(g3),pack(p4),parlist([par(billing,"FATTURA_PDF"),par(order,idOrder),par(recipient_id,idUser),par(email,mailUser)])],agent_goal(condition(set_user_data(user,email)),condition(order_checked(order)),system)[goal(g2),pack(p4),parlist([par(order,idOrder),par(user,idUser),par(email,mailUser)])],agent_goal(condition(order_placed(order,user)),condition(set_user_data(user,email)),system)[goal(g1),pack(p4),parlist([par(order,idOrder),par(user,idUser),par(email,mailUser)])],agent_goal(condition(received_order(order,user)),condition(order_placed(order,user)),system)[goal(g0),pack(p4),parlist([par(order,idOrder),par(user,idUser)])]]),0.11812322182992825)];
		GoalList = [agent_goal(condition(or([order_deleted(order),fulfill_order(order,user)])),condition(done(complete_transaction)),system)[goal(g8),pack(p4),parlist([])],agent_goal(condition(notify_order_unfeasibility(message)),condition(order_deleted(order)),system)[goal(g7),pack(p4),parlist([par(order,idOrder)])],agent_goal(condition(and([order_checked(order),order_status(refused)])),condition(notify_order_unfeasibility(message)),system)[goal(g6),pack(p4),parlist([par(message,user_message)])],agent_goal(condition(billing_uploaded(user)),condition(fulfill_order(order,user)),system)[goal(g5),pack(p4),parlist([par(order,idOrder),par(user,idUser)])],agent_goal(condition(billing_delivered(billing,recipient_id,order,email)),condition(billing_uploaded(user)),system)[goal(g4),pack(p4),parlist([par(user,idUser)])],agent_goal(condition(and([order_checked(order),order_status(accepted)])),condition(billing_delivered(billing,recipient_id,order,email)),system)[goal(g3),pack(p4),parlist([par(billing,"FATTURA_PDF"),par(order,idOrder),par(recipient_id,idUser),par(email,mailUser)])],agent_goal(condition(set_user_data(user,email)),condition(order_checked(order)),system)[goal(g2),pack(p4),parlist([par(order,idOrder),par(user,idUser),par(email,mailUser)])],agent_goal(condition(order_placed(order,user)),condition(set_user_data(user,email)),system)[goal(g1),pack(p4),parlist([par(order,idOrder),par(user,idUser),par(email,mailUser)])],agent_goal(condition(received_order(order,user)),condition(order_placed(order,user)),system)[goal(g0),pack(p4),parlist([par(order,idOrder),par(user,idUser)])]];
		Department	= "p4_dept";
		Project		= "p4_dept20154416036";
		Context 	= project_context(Department , Project);
		
		
		+data_value(Department,Project,user_message,"Fallito");
		+data_value(Department,Project,idOrder,12409);
		+data_value(Department,Project,mailUser,usermail2);
		+data_value(Department,Project,idUser,199);
		
//		.print("ECCOMI");
		!unroll_solution_to_set_goal_param_values_into_assignment(CS, GoalList, Context, OutCS);
		
		.print("[test 3] InputCS: ",CS);
		.print("[test 3] OutCS: ",OutCS);
		
	.
/**
 * [davide]
 * 
 * Unroll a solution and find, for each task, an assignment set whose values are contained in goal parameter list or in context.  
 * 
 */
+!unroll_solution_to_set_goal_param_values_into_assignment(CS, GoalList, Context, OutCS)
	:
		CS 		= [Head|Tail]	&
		Head 	= item(cs(ItemCS),Accumulation,GoalSatisfied,Score)
	<-
		!unroll_solution_to_set_goal_param_values_into_assignment(Tail, GoalList, Context, OutCSTail);		
		!unroll_solution_to_set_goal_param_values_into_assignment(ItemCS, GoalList, Context, OutCSItem);
		
		NewItem = item(cs(OutCSItem),Accumulation,GoalSatisfied,Score);
		.union([NewItem],OutCSTail,OutCS);
	.
+!unroll_solution_to_set_goal_param_values_into_assignment(CS, GoalList, Context, OutCS)
	:
		CS 		= [Head|Tail]	&
		Head 	= task(TaskTC, TaskFS, TaskEvo, cs(TaskCS), TaskAssignment, TaskNorms)
	<-
		//Get the parameters from goal which has TaskTC/TaskFS as conditions
		!get_goal_pars_from_task(TaskTC, TaskFS, GoalList, OutGoal, ParList);
		
		//search for an assignment set, which values are correctly unified with those found in the goal's parlist or in the context (if found)
		!unroll_assignment_to_set_value_to_context_param(TaskAssignment, ParList, Context, OutAssignment);

		//Recursive calls
		!unroll_solution_to_set_goal_param_values_into_assignment(Tail, GoalList, Context, OutCSTail);
		!unroll_solution_to_set_goal_param_values_into_assignment(TaskCS, GoalList, Context, OutCSTask);

		//Build the new task
		NewTask = task(TaskTC, TaskFS, TaskEvo, cs(OutCSTask), OutAssignment, TaskNorms);
		.union(OutCSTail, [NewTask], OutCS);
	.
+!unroll_solution_to_set_goal_param_values_into_assignment(CS, GoalList, Context, OutCS)
	:
		CS 		= [Head|Tail]	&
		Head 	= commitment(_,_,_)
	<-
		!unroll_solution_to_set_goal_param_values_into_assignment(Tail, GoalList, Context, OutCSTail);
		.union([Head],OutCSTail,OutCS);
	.
+!unroll_solution_to_set_goal_param_values_into_assignment(CS, GoalList, Context, OutCS)
	:	CS 		= []
	<-	OutCS 	= []
	.
	

+!debug_unroll_assignment_to_set_value_to_context_param
	<-
		Department	= "p4_dept";
		Project		= "p4_dept2015328213619";
		Context 	= project_context(Department , Project);
		
		!unroll_assignment_to_set_value_to_context_param([assignment(notification_message,messageaa)/*,assignment(messageaa,message) */], [par(message,message1),par(message1,"MM"),par(messageaa,par_message)], Context, OutAssignment);
		.print("OutAssignment: ",OutAssignment);
	.
/**
 * [davide]
 * 
 *  Return a list of assignment which value has been substitued with the actual value in
 * 	goals' parlist corresponding parameter.
 * 
 * ~~~~~~NOTE~~~~~~
 * 
 * Goals par list chain can be solved, but not assignment chains. For example, suppose we have
 * 
 * 		assignment(a,a_value)
 * and 
 * 		par list [par(a_value,a_value_inst1),par(a_value_inst1,a_value_inst2)]
 * 
 * the resulting assignment is assignment(a,a_value_inst2). Otherwise, if we have
 * 
 * 		[assignment(a,a_value),assignment(a_value,a_value1)]
 * and 
 * 		par list [par(a_value1,a_value_inst1)]
 * 
 * the chain of assignment is not resolved. In fact, the plan returns
 * 
 * 		[assignment(a,a_value),assignment(a_value1,a_value_inst1)]
 */
+!unroll_assignment_to_set_value_to_context_param(AssignmentList, GoalParlist, Context, OutAssignment)
	:
		AssignmentList = [Head|Tail]
	<-
		!unroll_assignment_to_set_value_to_context_param(Head, GoalParlist, Context, OutAssignmentCurrent);
		!unroll_assignment_to_set_value_to_context_param(Tail, GoalParlist, Context, OutAssignmentRec);
		.concat([OutAssignmentCurrent],OutAssignmentRec,OutAssignment);
	.
+!unroll_assignment_to_set_value_to_context_param(AssignmentList, GoalParlist, Context, OutAssignment)
	:	AssignmentList 	= []
	<-	OutAssignment 	= [];
	.
	
+!unroll_assignment_to_set_value_to_context_param(Assignment, GoalParlist, Context, OutAssignment)
	:
		Assignment 		= assignment(AssignmentVar, AssignmentVal)	&
		GoalParlist 	= [Head|Tail] 								
	<-
		if(.member(par(AssignmentVal,_), GoalParlist))
		{
			//Check if a parameter named [AssignmentVal] exists within the goal' parlist.
			!get_par_value(AssignmentVal, GoalParlist,ParValOut);
			
			//Check if a parameter named [AssignmentVal] exists within the context
			!check_data_value(ParValOut, Context, AssignmentInContext);

			if(ParValOut = no_value)	//no parameters found
			{
				OutAssignment = Assignment;
			}
			else
			{
				if(AssignmentInContext = true)
				{
					!get_data_value(ParValOut, ContextVal, Context);			//Retrieve the value of the variable [ParValOut] into the context
					OutAssignment = assignment(AssignmentVar,ContextVal);
				}
				else
				{
					!unroll_assignment_to_set_value_to_context_param(assignment(AssignmentVar, ParValOut), GoalParlist, Context, OutAssignment);
				}		
			}
		}
		else
		{
			OutAssignment = Assignment;
		}
	.
+!unroll_assignment_to_set_value_to_context_param(Assignment, GoalParlist, Context, OutAssignment)
	:	GoalParlist 	= []
	<-	OutAssignment 	= Assignment;
	.
	
	

/**
 * [davide]
 * 
 * Return the value of a parameter into a goal's parlist 
 */
+!get_par_value(ParName,ParList,ParValOut)
	:	
		ParList 	= [Head|Tail]							&
		Head 		= par(ParNameCurrent, ParVarl)			&
		ParName		\== ParNameCurrent
	<-
		!get_par_value(ParName,Tail,ParValOut);
	.	
+!get_par_value(ParName,ParList,ParValOut)
	:	
		ParList 	= [Head|Tail]						&
		Head 		= par(ParNameCurrent, ParVal)		&
		ParName		= ParNameCurrent 
	<-
		ParValOut	= ParVal;
	.
+!get_par_value(ParName,ParList,ParValOut)
	:	ParList 		= []
	<-	ParValOut		= no_value;
		ParNameCurrent 	= no_value;
	.	
+!get_par_value(ParName,ParList,ParValOut)
	<-	ParValOut		= no_value;
	.	

/*
 * [davide]
 * Activate monitoring for each goal in the given goal pack.
 */
+!activate_goal_state_monitoring(Context, Pack)
	<-
		Context = project_context(Department , Project);			//context
		Pack 	= pack(SocialGoal, GoalList, Norms, Metrics);		//goal pack
		
		for ( .member(Goal, GoalList) )								//for each goal in goal pack
		{
			GoalLifeCycle = goal_lifecycle( Context, ready );		
			!!check_goal_lifecycle(Goal, GoalLifeCycle);
		}
	.

/*
 * [davide]
 * 
 * Goal monitoring plan (Ready state).
 */
+!check_goal_lifecycle(Goal, GoalLifeCycle)
	:
		GoalLifeCycle = goal_lifecycle( Context, ready ) 
	<-
		!get_goal_TC([Goal], [TS|_]);
		!get_goal_Pars([Goal], 	Pars);
		
		!check_condition_true_in_context(TS, Context, TSBool);				//Check precondition
		if(TSBool=true)
		{
			.wait(3000);													//Wait...
			NewGoalLifeCycle = goal_lifecycle( Context, active );			//Go from ready to active state
			!!check_goal_lifecycle(Goal, NewGoalLifeCycle);					
		}
		else
		{
//			.print("TSBool for ",Goal," is not verified. Waiting...");
			.wait(3000);													//Wait...
			!!check_goal_lifecycle(Goal, GoalLifeCycle);
		}
	.

/*
 * [davide]
 * Goal monitoring plan (Active state).
 */
+!check_goal_lifecycle(Goal, GoalLifeCycle)
	:
		GoalLifeCycle = goal_lifecycle( Context, active ) 
	<-
		!get_goal_TC([Goal], [TC|_]);										//Get the goal's trigger condition
		!get_goal_FS([Goal], [FS|_]);										//Get the goal's final state
		!check_condition_true_in_context(FS, Context, FSBool);				//Check precondition
		
		if(FSBool = true)
		{
			.wait(3000);													//Wait...
			occp.logger.action.info("Goal ",Goal," is ADDRESSED");	
			NewGoalLifeCycle = goal_lifecycle( Context, addressed );		//Go from active to addressed state
			!!check_goal_lifecycle(Goal, NewGoalLifeCycle);					
			//TODO remove parameters from context
		}
		else
		{
			.wait(3000);													//Wait...
			!!check_goal_lifecycle(Goal, GoalLifeCycle);
		}
	.

/*
 * [davide]
 * Goal monitoring plan (Addressed state).
 */
+!check_goal_lifecycle(Goal, GoalLifeCycle)
	:
		GoalLifeCycle = goal_lifecycle( Context, addressed ) &
		Context = project_context(Department , Project) 
	<-
		!get_goal_TC([Goal], 	[TC|_]);
		!get_goal_FS([Goal], 	[FS|_]);
		!get_goal_Pars([Goal], 	Pars);
		
		FS = condition(T);
		!get_condition_timestamp_in_context(TC,Context,TCPre);
		!get_condition_timestamp_in_context(FS,Context,FSPost);
		
		if ( earlier(TCPre,FSPost) ) 
		{
			.wait(3000);
			NewGoalLifeCycle = goal_lifecycle( Context, ready );			//Go from active to addressed state
			!!check_goal_lifecycle(Goal, NewGoalLifeCycle);
			
		} 
		else 
		{
			.wait(3000);
			!!check_goal_lifecycle(Goal, GoalLifeCycle);
		}
	.

+!activate_project_monitoring(Context,Pack,Solution)
	<-
		Context = project_context(Department , Project);
		Pack 	= pack(SocialGoal,GoalList,Norms,Metrics);
		
		!get_goal_TC([SocialGoal], 	[TC|_]);
		!get_goal_FS([SocialGoal], 	[FS|_]);
		
		Lifecycle = capability_lifecycle( Pack,Context,Solution,running );
		!!project_lifecycle(Project,Lifecycle);
		!!team_monitoring(Solution,Context);
	.
+!project_lifecycle(Project,Lifecycle)
	:
		Lifecycle = capability_lifecycle( Pack,Context,Solution,running )
	&	( capability_error(Context) | ping_error(Context) )
	<-
		Pack = pack(SocialGoal,GoalList,Norms,Metrics);
		NewLifecycle = capability_lifecycle( Pack,Context,Solution,replanning );
		
		!!project_lifecycle(Project,NewLifecycle);
		
		-capability_error(Context);
		-ping_error(Context);
	.		
+!project_lifecycle(Project,Lifecycle)
	:
		Lifecycle = capability_lifecycle( Pack,Context,Solution,running )
	<-
		Pack = pack(SocialGoal,GoalList,Norms,Metrics);

		//Verifico la condition del social goal nel contesto
		!get_goal_TC([SocialGoal], 	[TC|_]);
		!get_goal_FS([SocialGoal], 	[FS|_]);
		
		!check_condition_true_in_context(FS, Context, FSBool); //LA DOVRO' USARE PER VERIFICARE LA TRIGGER CONDITION DEI GOAL
		
		if (FSBool==true) 
		{
			.println("[MUSA] Monitoring Social Goal: Terminating");
			NewLifecycle = capability_lifecycle( Pack,Context,Solution,terminating );
		} 
		else 
		{
			NewLifecycle = Lifecycle;
			?frequency_long_perception_loop(Delay);
			.wait(Delay);
		}
		!!project_lifecycle(Project,NewLifecycle);
	.		
+!project_lifecycle(Project,Lifecycle)
	:
		Lifecycle = capability_lifecycle( Pack,Context,Solution,terminating )
	<-
		.println("The project is correctly terminated");
		occp.logger.action.info("The project (",Project,") is correctly terminated");
		
		!suspend_social_commitment(SocialGoal,Solution,Context);
		!social_terminate_the_project(Context,Solution);
		
	.
+!project_lifecycle(Project,Lifecycle)
	:
		Lifecycle = capability_lifecycle( Pack,Context,Solution,replanning )
	<-
		Context = project_context(Department , Project);
		Pack = pack(SocialGoal,GoalList,Norms,Metrics);

		occp.logger.action.info("The project (",Project,") is going to be re-organizing");
		.println("The project is going to be re-organizing");
		!suspend_social_commitment(SocialGoal,Solution,Context);

		.print("---SOCIAL GOAL COMMITMENT SUSPENDED---");
		.wait(5000);

		//TODO ...other stuff?
		!organize_solution(Context,Pack);
	.


+!team_monitoring(Solution,Context)	
	:
		Context 	= project_context(Department, Project)				&
		Solution	= item(cs(CS), Accumulation, ag(SatisfiedAG), Score)
	<-
		!agent_monitoring(CS, CS, Context);	
	.	

+!agent_monitoring(CS,TheWholeCS,Context)
	:
		CS=[]
	<-
		!!agent_monitoring(TheWholeCS,TheWholeCS,Context);
	.
	
+!agent_monitoring(CS,TheWholeCS,Context)
	:
		CS		= [ Head | Tail ] &
		Head 	= task(TaskPre, TaskPost, TaskEvoPlans, cs(TaskCS), TaskAssignment, TaskNorms )		//TODO implementare norme
	<-
		!agent_monitoring(TaskCS,TheWholeCS,Context);	//richiamo sul commitment set del task
		!agent_monitoring(Tail,TheWholeCS,Context);		//richiamo sul resto della lista
	.	

+!agent_monitoring(CS,TheWholeCS,Context)
	:
		CS		= [ Head | Tail ] &
		Head 	= commitment(Agent,Capability,HeadPercent)
	<-
		.all_names(AllAgents);
		
		if (.member(Agent,AllAgents)) 
		{
			.send(Agent,tell, ping_for_project(Context) );
			?frequency_very_long_perception_loop(Delay);
			.wait(Delay);
			?reply_to_ping_for_project(Agent,Context);
			.abolish( reply_to_ping_for_project(Agent,Context) );
				
			!!agent_monitoring(Tail,TheWholeCS,Context);
		} 
		else 
		{
			unsubscribe(Agent);
			.println(Agent, " ping error");
			+ping_error(Context);
		}
	.
	
-!agent_monitoring(CS,TheWholeCS,Context)
	:
		CS		= [ Head | Tail ] &
		Head 	= task(TaskPre, TaskPost, TaskEvoPlans, cs(TaskCS), TaskAssignment, TaskNorms )
	<-
		!agent_monitoring(TaskCS,TheWholeCS,Context);
	.

-!agent_monitoring(CS,TheWholeCS,Context)
	:
		CS		= [ Head | Tail ] &
		Head 	= commitment(Agent,Capability,HeadPercent)
	<-	
		unsubscribe(Agent);
		+ping_error(Context);
	.

+!social_terminate_the_project(Context,Solution)	
	:
		Context 	= project_context(Department , Project) 	&
		Solution 	= item(cs(CS),Accumulation,ag(Ag),Score)
	<-
		closeProject(Project,"current");
		.all_names(AllAgents);
		
		!send_terminate_to_each_agent(CS,AllAgents);
		
		+terminate_project(Context);
		-manager_of(Department,Project,_);
	.	


+!send_terminate_to_each_agent(CS,AllAgents)
	:	CS = []
	<-	true
	.
+!send_terminate_to_each_agent(CS,AllAgents)
	:
		CS = cs(InnerCS)
	<-
		!send_terminate_to_each_agent(InnerCS,AllAgents)
	.
+!send_terminate_to_each_agent(CS,AllAgents)
	:
		CS 		= [Head|Tail] &
		Head 	= task(TaskPre, TaskPost, TaskEvoPlans, TaskCS, TaskAssignment, TaskNorms )
	<-
		!send_terminate_to_each_agent(TaskCS,AllAgents);
		!send_terminate_to_each_agent(Tail,AllAgents);
	.	
+!send_terminate_to_each_agent(CS,AllAgents)
	:
		CS 		= [Head|Tail] &
		Head 	= commitment(Agent, Capability, HeadPercent)
	<-
		if (.member(Agent,AllAgents)) 
		{
			.send(Agent,tell, terminate_project(Context) );
		}
	.

+!activate_social_commitment(Context,Pack,Solution)
	:
		Context 	= project_context(Department , Project)		&
		Pack 		= pack(SocialGoal,GoalList,Norms,Metrics)	&
		Solution 	= item(cs(CS), Accumulation, ag(SatisfiedAG), Score)
	<-
		.println("A solution has been found: ",Solution);
		!unroll_solution_to_inform_social_commitment_and_extract_members(CS,[],Context,Pack,Members);
		+manager_of(Department,Project,Members);
	.
+!activate_social_commitment(Context,Pack,no_solution)
	<-
		// cancel project
		.println("There is no solution for the project: deleting");
	.

/**
 * [davide]
 * 
 * Sostituisce il piano +!unroll_solution_to_inform_social_commitment_and_extract_members
 */
+!unroll_solution_to_inform_social_commitment_and_extract_members(CS,ParentCS,Context,Pack,Members)
	:
		CS 		= [Head|Tail] &
		Head 	= task(TaskPre, TaskPost, _, cs(TaskCS), _, _)
	<-
		!unroll_solution_to_inform_social_commitment_and_extract_members(Tail,	 ParentCS, 	Context,Pack,TailMembers);
		!unroll_solution_to_inform_social_commitment_and_extract_members(TaskCS, Head, 		Context,Pack,TaskMembers);
		.union(TailMembers,TaskMembers,Members);
	.
	
+!unroll_solution_to_inform_social_commitment_and_extract_members(CS,ParentCS,Context,Pack,Members)
	:
		CS 			= [Head|Tail] 								&
		ParentCS	= task(PRE,POST , _, _, AssignmentList, _)	&
		Head 		= commitment(Agent,Capability,HeadPercent)
	<-
		.send(Agent,tell,start_social_commitment(Context,Pack,Capability,PRE,POST,AssignmentList));
		
		!unroll_solution_to_inform_social_commitment_and_extract_members(Tail,ParentCS,Context,Pack,TailMembers);
		.union([Agent],TailMembers,Members);
		
	.

+!unroll_solution_to_inform_social_commitment_and_extract_members(CS,ParentCS,Context,Pack,Members)
	:	CS 		= []
	<-	Members	= []//Out = []
	.

+!suspend_social_commitment(SocialGoal,Solution,Context)
	:
		Context 	= project_context(Department , Project) 	&
		Solution 	= item(cs(CS),Accumulation,ag(AG),Score)	
	<- 
		.drop_intention( agent_monitoring(_,_,Context) );
		.all_names(AllAgents);
		!send_suspend_to_each_agent(CS, AllAgents);
	.
+!send_suspend_to_each_agent(CS,AllAgents)
	:	CS = []
	<-	true
	.
+!send_suspend_to_each_agent(CS,AllAgents)
	:
		CS = cs(InnerCS)
	<-
		!send_suspend_to_each_agent(InnerCS,AllAgents)
	.
+!send_suspend_to_each_agent(CS,AllAgents)
	:
		CS = [Head|Tail] &
		Head = task(TaskPre, TaskPost, TaskEvoPlans, TaskCS, TaskAssignment, TaskNorms )
	<-
		!send_suspend_to_each_agent(TaskCS,AllAgents);
		!send_suspend_to_each_agent(Tail,AllAgents);
	.	
+!send_suspend_to_each_agent(CS,AllAgents)
	:
		CS = [Head|Tail] &
		Head = commitment(Agent, Capability, HeadPercent)
	<-
		if (.member(Agent,AllAgents)) 
		{
			.send(Agent,tell,terminate_social_commitment(Context,Capability));
		}
	.




