/******************************************************************************
 * @Author: 
 * 	- Davide Guastella
 * 
 * Description: plans for taks
 * 
 *
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 *
 * TODOs:
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/


/**
 * [davide]
 * 
 * DEBUG PLAN for +!build_task_list_from_solution_set(CPSet, TaskList)
 */
+!debug_build_task_list_from_commitment_set
	<-
		CPSet = [ commitment(user_device,print_on_screen,0), commitment(printer,check_printer,0) ];
  							 
  		.print("CPSet: ",CPSet);		
		!build_task_list_from_commitment_set(CPSet, TaskList);
		.print("TaskList: ",TaskList);					 
	.

/**
 * [davide]
 * 
 * This plan creates for each capability in the input list a task containing themselves.
 */
+!build_task_list_from_commitment_set(CPSet, TaskList)
	:
		CPSet 	= [Head|Tail] &
		Head 	= commitment(Me, Capability, HeadPercent)
	<-
		!build_task_list_from_commitment_set(Tail, TaskListRec);
		!create_new_task([],[],[],[Head],[],[],Task);
		.union(TaskListRec,[Task],TaskList);
	.
	
+!build_task_list_from_commitment_set(CPSet, TaskList)
	:	CPSet 		= []
	<-	TaskList 	= [];
	.




/**
 * [davide]
 * 
 * Create a new task.
 * 
 * TC 	-> task trigger condition
 * FS 	-> task final state
 * Evo 	-> evolution plans
 * CS	-> commitment list
 * NormList -> norm list
 * T 	-> output task predicate
 * 
 * output example:
 * 	task( condition(one), condition(printed(bye)), cs([commitment(user device,print on screen,0)]), [assign(msg,”addio”)], norms([]) )
 */	
+!create_new_task(TC,FS,Evo,CS,AssignmentList,NormList,T)
	<-
		T = task(TC, FS, Evo, cs(CS), AssignmentList, norms(NormList));
	.	

/**
 * [davide]
 * 
 * Retrieve the commitment set from a stack item
 */
+!get_commitment_from_stack_item(StackItem,CS)
	:
		StackItem = item(cs(CS),_,_,_) | 
		StackItem = item(task(_,_,_,cs(CS),_,_),_,_,_,_)
	.

+!debug_get_best_item_solution_for_goals
	<-
		Items = [item(cs([task(condition(received_emergency_notification(location,worker_operator)),condition(move(worker_operator,location)),[add(done(evacuation)),add(move(worker,emergency_location))],cs([commitment(firefighter,move,1),commitment(firefighter,assessEvacuation,1)]),[assignment(emergency_location,location),assignment(worker,worker_operator)],norms([]))]),accumulation(world([received_emergency_notification(location,worker_operator),injured(person)]),par_world([worker,emergency_location],[property(done,[evacuation]),property(move,[worker,emergency_location])]),assignment_list([])),ag([]),0.09530107160810088),
				 item(cs([task(condition(received_emergency_notification(location,worker_operator)),condition(move(worker_operator,location)),[add(move(worker,emergency_location))],cs([commitment(firefighter,move,1)]),[assignment(emergency_location,location),assignment(worker,worker_operator)],norms([]))]),accumulation(world([received_emergency_notification(location,worker_operator),injured(person)]),par_world([worker,emergency_location],[property(move,[worker,emergency_location])]),assignment_list([])),ag([]),0.11812322182992825) ];
				 
		!get_best_item_solution_for_goals(Items, OutItems);
		.print("Out items: ",OutItems);
	.

/*
 * [davide]
 * 
 * This plan loop on the agent goals list, and for each goal G, given 
 * the task set TS that satisfy G, return a task t in TS which has the
 * higher score and satisfies G.
 */
+!get_best_item_solution_for_goals(AG_items, GoalList, OutItems)
	:	GoalList = []
	<-	OutItems = [];
	.
	
+!get_best_item_solution_for_goals(AG_items, GoalList, OutItems)
	:
		GoalList 	= [Head|Tail]
	<-
		//Recursive call
		!get_best_item_solution_for_goals(AG_items, Tail, OutItemsRec);
		
		!get_goal_TC([Head], [GoalTC|_]);		//Get the goal TC
		!get_goal_FS([Head], [GoalFS|_]);		//Get the goal FS
		
		//Search for items that satisfy the current item TC and FS
		!search_for_item_that_satisfy_goal_conditions(AG_items, GoalTC, GoalFS, OutItemsTmp);
		
		//Get the item with the higher score
		!get_item_with_higher_score(OutItemsTmp, BestItemForCurrentGoal, BestScore);
		
//		.print("Best item for ",Head,"\n",BestItemForCurrentGoal);
		
		//Add the found item into the output item list
		.union(BestItemForCurrentGoal, OutItemsRec, OutItems);
	.
	

/**
 * DEBUG PLAN for !extract_tasks_from_item_set
 */
+!debug_extract_tasks_from_item_set
	<-
		Items = [item(cs([task(condition(or([received(request),printed(again)])),condition(printed(welcome)),[add(f(due)),add(f(uno)),add(printed(msg))],cs([commitment(printer,print,1),commitment(printer,decide,1)]),[assignment(msg,welcome)],norms([]))]),accumulation(world([received(request)]),par_world([msg],[property(f,[due]),property(f,[uno]),property(printed,[msg])]),assignment_list([])),ag([]),0.09530107160810088),
				 item(cs([task(condition(or([received(request),printed(again)])),condition(printed(welcome)),[add(printed(msg))],cs([commitment(printer,print,1)]),[assignment(msg,welcome)],norms([]))]),accumulation(world([received(request)]),par_world([msg],[property(printed,[msg])]),assignment_list([])),ag([]),0.11812322182992825)];
	
		!extract_tasks_from_item_set(Items, TaskSet);
		.print("Output task set: ",TaskSet);		
	.

/**
 * [davide]
 * 
 * Given an item list, return a list containing all the task contained within every item in the input list.
 */
+!extract_tasks_from_item_set(Items, TaskSet)
	:
		Items 	= [Head|Tail] 				&
		Head 	= item(CS,Acc,_,Score) 		&
		CS 		= cs([Task|_])
	<-
		!extract_tasks_from_item_set(Tail, TaskSetRec);
		.concat(TaskSetRec,[Task],TaskSet);
	.
	
+!extract_tasks_from_item_set(Items, TaskSet)
	:	Items 	= []
	<-	TaskSet = []
	.
	
/**
 * [davide]
 * 
 * For each task in CS, check if one or more assignment can be added into it. That is, this plan loops
 * on each commitment within the input task, then checks if the corresponding capability parameter(s)
 * match with an assignment in the input assignment list. If an assignment for the capability parameter
 * exists, then it can be added to the task assignment list.
 * 
 * This plan return a list of task where the assignment have been added.
 */
+!set_assignment_for_task_set(CS,AssignmentList,OutTaskSet)
	:
		CS 		= [Head|Tail] &
		Head 	= task(TC,FS,Evo,cs(TaskCommitmentSet),TaskAssignment,_)
	<-
		!set_assignment_for_task_set(Tail,AssignmentList,OutTaskSetRec);									//Recursive call
		!get_assignment_for_commitment_set(TaskCommitmentSet, AssignmentList, OutTaskAssignment);			//Retrieve the assignment for the current task commitment set
		!create_new_task(TC,FS,Evo,TaskCommitmentSet,OutTaskAssignment,[],NewTask);	//TODO Norme qui		//Assemble the task
		.union([NewTask], OutTaskSetRec, OutTaskSet);														//Unify the task into the output task list
	.
+!set_assignment_for_task_set(CS,AssignmentList,OutAssignmentList)
	:	CS 					= []
	<-	OutAssignmentList	= []
	.


/**
 * [davide]
 * 
 * Filter an assignment list by returning only those assignment which has
 */
+!get_assignment_for_commitment_set(CS,AssignmentList,OutAssignmentList)
	:
		CS 		= [Head|Tail]	&
		Head 	= commitment(AgName,CapName,_)
	<-
		!get_assignment_for_commitment_set(Tail,AssignmentList,OutAssignmentListRec);	//recursive call
		
		!find_assignment_for_commitment(Head, AssignmentList, OutAssignment);		//find an assignment for CapName parameter(s)
		.union(OutAssignment, OutAssignmentListRec, OutAssignmentList);
	.

+!get_assignment_for_commitment_set(CS,AssignmentList,OutAssignmentList)
	:	CS 					= []
	<-	OutAssignmentList 	= []
	.

/**
 * [davide]
 * 
 * Unroll the input solution items and assemble, for each one, a task containing all the commitments 
 * contained within the item.
 */
 +!unroll_solutions_to_get_task_set(Items, SocialGoalTC, SocialGoalFS, Assignment, OutTask)
	:	Items 		= []
	<-	OutTask 	= []
	.
+!unroll_solutions_to_get_task_set(Items, TaskTC, TaskFS, Assignment, OutTask)
	:
		Items 	= [Head|Tail]	&
		Head 	= item(cs(CS),_,_,_)
	<-
		!unroll_solutions_to_get_task_set(Tail, TaskTC, TaskFS, Assignment, OutTaskRec);			//recursive call
		!unroll_solution_to_get_commitment_set(Head,CommitmentSet);									//Retrieve the commitment from the item
		!unroll_capabilities_to_get_evolution_plans(CommitmentSet, Evo);							//retrieve the evolution plan		
		!create_new_task(TaskTC, TaskFS, Evo, CommitmentSet, Assignment, [], T);					//TODO NORME QUI?
		.concat([T],OutTaskRec, OutTask);
	.	
	
/**
 * [davide]
 * 
 * Unroll a task set and build two lists containing the TC and FS of each task.
 */
+!unroll_task_set_to_get_condition_list(CS, TClist, FSlist)
	:
		CS 		= [Head|Tail]	&
		Head 	= task(TC,FS,_,_,_,_)
	<-
		!unroll_task_set_to_get_condition_list(Tail, TClistRec, FSlistRec);
		.union([TC], TClistRec, TClist);
		.union([FS], FSlistRec, FSlist);
	.
+!unroll_task_set_to_get_condition_list(CS, TClist, FSlist)
	:	CS 		= []
	<-	TClist 	= [];
		FSlist 	= [];
	.	
		