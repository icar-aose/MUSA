/******************************************************************************
 * @Author: 
 *  - Luca Sabatucci 
 * 	- Davide Guastella
 * 
 * Description: plans for collaborative space exploration with 
 * Accumulation state of the world
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * 	- (15/2/23) in filter_capabilities_that_triggers_on_accumulation, modified the var name that contains the logic formula truth percent
 *
 * TODOs:
 * - condition_to_world_statement must handle NEG predicates.
 * - get_goal_TC e get_goal_FS devono gestire i goal con annotazioni
 * 
 * - [IMPORTANTE] inserire dei piani !get_capability_postcondition e !get_capability_precondition che gestiscano i casi in cui le capability non 
 *   siano trovate. 
 * - manca EVO in !ask_for_tasks_that_address_final_state
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/

{ include( "core/conditions.asl" ) }
{ include( "search/goals_addressing_in_evolution.asl" ) }
{ include( "search/system_norms_metrics.asl" ) }
{ include( "search/select_filter_capabilities.asl" ) }
{ include( "search/utilities.asl" ) }

{ include( "core/accumulation.asl" ) }
{ include( "core/goal.asl" ) }
{ include( "core/task.asl" ) }
{ include( "core/blacklist.asl" ) }

/**
 * [davide]
 * 
 * Given an item list I, return the item with the higher score within the list I.
 * 
 */
+!get_item_with_higher_score(ItemList, BestItem, BestScore)
	:
		ItemList 	= [Head|Tail] &
		Head 		= item(_,_,_,Score)
	<-
		!get_item_with_higher_score(Tail, BestItemRec, BestScoreRec);
		
		if(BestScoreRec >= Score)
		{
			BestItem 	= [BestItemRec];
			BestScore 	= BestScoreRec;
		}
		else
		{
			BestItem 	= [Head];
			BestScore 	= Score;
		}
	.

+!get_item_with_higher_score(ItemList, BestItem, BestScore)
	:
		ItemList = []
	<-
		BestScore 	= -1;
		BestItem 	= [];
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for !search_for_item_that_satisfy_goal_conditions
 */
+!debug_search_for_item_that_satisfy_goal_conditions
	<-
		AG_items = [item(cs([task(condition(or([received(request),printed(again)])),condition(printed(welcome)),[add(f(due)),add(f(uno)),add(printed(msg))],cs([commitment(printer,print,1),commitment(printer,decide,1)]),[assignment(msg,welcome)],norms([]))]),accumulation(world([received(request)]),par_world([msg],[property(f,[due]),property(f,[uno]),property(printed,[msg])]),assignment_list([])),ag([]),0.09530107160810088),
					item(cs([task(condition(or([received(request),printed(again)])),condition(printed(welcome)),[add(printed(msg))],cs([commitment(printer,print,1)]),[assignment(msg,welcome)],norms([]))]),accumulation(world([received(request)]),par_world([msg],[property(printed,[msg])]),assignment_list([])),ag([]),0.11812322182992825)];
	
		GoalTC = condition(or([received(request),printed(again)]));
		GoalFS = condition(printed(welcome));
		
		!search_for_item_that_satisfy_goal_conditions(AG_items, GoalTC, GoalFS, ItemList);
		.print("Items: ",ItemList);	
	.

/**
 * [davide]
 * 
 * Search for the items that satisty the given trigger/final condition.
 * 
 * ##NOTE##
 * 
 * Every input item is assumed to contains only one task within its commitment set
 */
+!search_for_item_that_satisfy_goal_conditions(AG_items, GoalTC, GoalFS, ItemList)
	:
		AG_items 	= [Head|Tail] 						&
		Head 		= item(cs([Task|_]),_,_,_) 			&
		Task		= task(TaskTC, TaskFS,_,_,_,_)		&
		TaskTC 		= GoalTC &	TaskFS = GoalFS 
	<-
		!search_for_item_that_satisfy_goal_conditions(Tail, GoalTC, GoalFS, ItemListRec);
		.concat(ItemListRec, [Head], ItemList);
	.

+!search_for_item_that_satisfy_goal_conditions(AG_items, GoalTC, GoalFS, ItemList)
	:
		AG_items 	= [Head|Tail] 						&
		Head 		= item(cs([Task|_]),Acc,_,Score) 	&
		Task		= task(TaskTC, TaskFS,_,_,_,_)		&
		(TaskTC 	\== GoalTC | TaskFS \== GoalFS)	
	<-
		!search_for_item_that_satisfy_goal_conditions(Tail, GoalTC, GoalFS, ItemList);
	.

+!search_for_item_that_satisfy_goal_conditions(AG_items, GoalTC, GoalFS, ItemList)
	:	AG_items 	= []
	<-	ItemList 	= []
	.
	
/**
 * [davide]
 * 
 * This plan assembles the final solution by taking the items with the higher score that
 * satisfy the input goal pack. It starts by taking, for each goal, the best item. Then,
 * the task set from the found items are extracted and merged togheter with the task/commitment
 * set of the social goal solution item into a new commitment set (SolTask).
 */	
+!assemble_final_solution_pack(SG_items, AG_items, GoalList, OutSolution)
	:
		SG_items 	= [Head|_]  						&
		Head 		= item(cs(CS),Acc,ag(Ag),Score) 	& 
		CS 			= [Task|_] 							& 
		Task		= task(TaskTC, TaskFS, SGevo, cs(SG_CS), SG_assignment, SG_Norms)
	<-
		!get_best_item_solution_for_goals(AG_items, GoalList, AG_items_filtered);
		!extract_tasks_from_item_set(AG_items_filtered, TaskSet);						//Unroll the solution to obtain the task set
		!unroll_solution_to_get_commitment_set(TaskSet, AGCommitmentSet);				//Unroll the task set to obtain the commitment set
		!unroll_solution_to_get_commitment_set(SG_CS, SGCommitmentSet);					//Unroll the solution commitment set
		
		.difference(SGCommitmentSet,AGCommitmentSet,RemainingCommitmentSet);			
		.concat(RemainingCommitmentSet, TaskSet, OutCS);
		
		SolTask 	= task(TaskTC, TaskFS,SGevo,cs(OutCS),SG_assignment,SG_Norms);
		OutSolution = item(cs([SolTask]),Acc,ag(Ag),Score);
	.
+!assemble_final_solution_pack(SG_items, AG_items, GoalList, OutSolution)
	:
		SG_items = []  						
	<-
		.print("[WARNING] solutions not found...\n");
		
		?frequency_very_long_perception_loop(Delay);
		
	
		
		.wait(Delay);
	.
	
//---------------------------------------------------------------------------------
//Orchestration plan
//---------------------------------------------------------------------------------
+!orchestrate_search_in_solution_space(InputAccumulation,Pack,Members,MergedSolutions)
	<-
		makeArtifact("stack","st.Stack",[],ArtifactId);	// Note: in a further version to create once and use many times, clearing at the end, and using a token for cuncurrent access
		.println("INITIALIZE STACK WITH ",Members);
		.print("Pack: ",Pack);
		?search_max_depth(MaxDepth);
		?search_number_of_solutions(MaxSolution);

		.println("START SEARCH");
		occp.logger.action.info("START SEARCH");		
		Pack = pack(SocialGoal, AG_list, _, _);
		
		!check_if_goal_pack_is_satisfied_in_accumulation(SocialGoal,AG_list,InputAccumulation,[],GoalPackSatisfied, _);
		if(GoalPackSatisfied=true)
		{
			.print("ENTIRE GOAL PACK ALREADY SATISFIED. ABORTING...");
			.succeed_goal( orchestrate_search_in_solution_space(_,_,_,[]) );

		}
		
		//Search solutions for agent goal set
		!search_solution_for_agent_goals(AG_list, InputAccumulation, MaxSolution, Members, MaxDepth, 1, InitSolutions);	//restituisce ITEMS
		
		//After searching for agent goal solutions, clear the stack for searching the solution for the social goal 
		clearStack;	
		
		//Get the goal trigger condition
		!get_goal_TC([SocialGoal],Sg_TC);
	
		//Convert the goal trigger condition to a list of world statement
		!condition_to_world_statement(Sg_TC, SG_Predicates);
		
		//Create a dummy accumulation state to use as a starting point for finding solutions for the current goal
		InputAccumulation = accumulation(world(WS), par_world(Vars,PWS), AssignmentList);
		.union(WS, SG_Predicates, DummyWS);
		
		Accumulation = accumulation(world(DummyWS),par_world(Vars,PWS),AssignmentList);
		
		!ask_for_hypotetical_capabilities(Members, Accumulation, TaskSet);
		Item = item( cs([]),
					 Accumulation,
					 ag([]),
					 0 );
		!unroll_capabilities_to_update_stack_and_score_on_accumulation(TaskSet,[], Item , Pack, MaxDepth, []);

		!orchestrate_search_with_accumulation(InitSolutions, MaxSolution, Pack, Members, MaxDepth, 1, OutSolutions);
		.print("Init solution: ",InitSolutions,"\n\n\n");
		
		occp.logger.action.info("END SEARCH");
		.println("END SEARCH");
		.println("Out solution: ",OutSolutions);
		
		/**
		 * ASSEMBLAMENTO DELLE SOLUZIONI FINALI (CIOE' SCELTA DELLA SOLUZIONE MIGLIORE).
		 * OMETTERE SOLO NEL CASO IN CUI SI VOGLIANO RESTITUIRE TUTTI GLI ITEM.
		 */
		Sg_TC = [SocialGoalTC|_];
		!get_goal_FS([SocialGoal],[Sg_FS|_]);
		!search_for_item_that_satisfy_goal_conditions(OutSolutions, SocialGoalTC, Sg_FS, SGitems);

		!assemble_final_solution_pack(SGitems, InitSolutions, AG_list, MergedSolution);
		.print("Best solution found: ",MergedSolution);
		 occp.logger.action.info("Best solution found: ",MergedSolution);
		 
		 MergedSolutions = [MergedSolution];
		 
		 
		 
		 disposeArtifact(ArtifactId);
	.

/**
 * [davide]
 * 
 * Do a local solution search for each agent goal within the input goal pack. This plan takes an agent goal list and for each one
 * it searches a solution (one or more) that addresses it.
 */
+!search_solution_for_agent_goals(AGList, InputAccumulation, MaxSolution, Members, MaxDepth, Steps, OutSolutions)
	:
		AGList = [Head|Tail]
	<-	
		//Convert the current agent goal to social goal
		!get_social_goal_from_agent_goal(Head, Sg);
		
		//Create a dummy goal pack which has the current agent goal as a social goal, and an empty agent goal list	
		Pack = pack(Sg,[],[],[]);
		
		!check_if_goal_pack_is_satisfied_in_accumulation(Sg,[],InputAccumulation,[],GoalPackSatisfied, OutAssignmentList);
		if(GoalPackSatisfied = true)
		{
			.term2string(Sg, SgStr);
			 occp.logger.action.warn("Goal already Satisfied");
			 occp.logger.action.warn(SgStr);
			
			.print("[WARNING] Goal satisfied: ",Sg);
			
			!search_solution_for_agent_goals(Tail, InputAccumulation, MaxSolution, Members, MaxDepth, Steps, OutSolRec);
			.concat([], OutSolRec, OutSolutions);
		}
		else
		{
			//Get the goal trigger condition
			!get_goal_TC([Sg],Sg_TC);
			
			//Convert the goal trigger condition to a list of world statement
			!condition_to_world_statement(Sg_TC, SG_Predicates);
			
			//Create a dummy accumulation state to use as a starting point for finding solutions for the current goal
			InputAccumulation = accumulation(world(WS), par_world(Vars,PWS), assignment_list(AssignmentList));
			
			.union(WS, SG_Predicates, DummyWS);
			Accumulation = accumulation(world(DummyWS),par_world(Vars,PWS),assignment_list(AssignmentList));
			
			//Clear the solution items stack
			clearStack;
			
			!ask_for_hypotetical_capabilities(Members, Accumulation, TaskSet);
			Item = item( cs([]),
						 Accumulation,
						 ag([]),
						 0 );
			
//			!unroll_solution_to_get_commitment_set(TaskSet, CommitmentSet);
//			!get_blacklisted_capability_list(CommitmentSet, BlacklistedCS);
//			.print("BlacklistedCS: ",BlacklistedCS);
//	 		.length(BlacklistedCS, BlacklistedCSCardinality);
//			
			!unroll_capabilities_to_update_stack_and_score_on_accumulation(TaskSet,[], Item , Pack, MaxDepth, []);
			!orchestrate_search_with_accumulation([],MaxSolution,Pack,Members,MaxDepth,Steps, OutSol);		
			
			//Now prepare the assignments
			.println("Solution for ",Sg,"\n->",OutSol);			
			occp.logger.action.info("Found a solution for ",Sg);
			
			!search_solution_for_agent_goals(Tail, InputAccumulation, MaxSolution, Members, MaxDepth, Steps, OutSolRec);
			.concat(OutSol, OutSolRec, OutSolutions);
		}
	.

+!search_solution_for_agent_goals(AGList, Accumulation, MaxSolution, Members, MaxDepth, Steps, OutSolutions)
	:	AGList 			= []
	<-	OutSolutions 	= [];
	.		

/**
 * Pianificazione
 */
+!orchestrate_search_with_accumulation(InSolutions,MaxSolution,Pack,Members,MaxDepth,Steps,OutSolutions)
	<-
		?orchestrate_verbose(VB);
		stackSize(Size);
		?search_number_of_steps(Max);
				
		if (Size>0 & Steps<Max) 
		{
			pickItem( StackItem );																		//prendi un item dallo stack
			StackItem = item(_,Accumulation,ag(AddressedGoal), Score);			
			!get_commitment_from_stack_item(StackItem, CS);												//CS = item+task		
			
			if(VB=true){
			.print("[orchestrate_search_with_accumulation] STACK ITEM: ",StackItem,"\n");
			.print("[orchestrate_search_with_accumulation] Accumulation state: ",Accumulation);
			}
			Pack = pack(Social,AgentGoalList,Norms,Metrics);
			
			/* Verifica se Social è soddisfatto nello stato di accumulazione. Nella verifica possono essere trovati degli assignment (OutAssignmentList),
			   utilizzati in fase di verifica (vengono applicati allo stato di accumulazione prima di effettuare il test delle condition del goal). */
			   
			//Input assignment!!!!
			!check_if_goal_pack_is_satisfied_in_accumulation(Social,AgentGoalList,Accumulation,[],GoalPackSatisfied, OutAssignmentList);
			
			if(VB=true){.print("[orchestrate_search_with_accumulation] Found assignment ",OutAssignmentList,"for (social) goal ",Social);}
			
			if (GoalPackSatisfied=true) 
			{	
				//Concatenate Item and InSolutions into a new list
				!set_assignment_for_new_solution(StackItem, OutAssignmentList, OutTaskSet);
				
				ItemWithAssignment = item(cs(OutTaskSet),Accumulation,ag(AgentGoalList),Score);
				!add_item_to_solution(InSolutions, ItemWithAssignment, NewSolutions_tmp, NewSolutionFound);
				
				!get_goal_TC([Social], [TaskTC|_]);
				!get_goal_FS([Social], [TaskFS|_]);
				
				!unroll_solutions_to_get_task_set(NewSolutions_tmp, TaskTC, TaskFS, OutAssignmentList, NewSolutionTaskAndCS);				//assemblo il task
				
				NewSolutions = [item(cs(NewSolutionTaskAndCS),Accumulation,ag(AgentGoalList),Score)]; 
				
				if(VB=true){.print("[orchestrate_search_with_accumulation] Goal Pack satisfied. Found solution(s): ",NewSolutions,"\n\n")};
				.length(NewSolutionTaskAndCS, SolSize);
				
				if (MaxSolution-SolSize > 0) 	{!orchestrate_search_with_accumulation(NewSolutions_tmp,MaxSolution,Pack,Members,MaxDepth,Steps+1,OutSolutions);} 
				else 							{OutSolutions = NewSolutions_tmp;}		
			} 
			else 
			{				
				.length(CS,Len); 
				if (Len <= MaxDepth) 
				{
					!ask_for_hypotetical_capabilities(Members, Accumulation, TaskSet);
					
					//NOTE May the found capabilities be filtered here by the agent roles?
					
					if(VB=true){.print("[orchestrate_search_with_accumulation] FOUND TASK SET: ",TaskSet," DOVREBBE ANDARE CON ",OutAssignmentList);}
					
					//Update the stack by adding a new solution which contains the found task set 
					!unroll_capabilities_to_update_stack_and_score_on_accumulation(TaskSet, InSolutions, StackItem, Pack, MaxDepth, OutAssignmentList);	
				}
				!orchestrate_search_with_accumulation(InSolutions,MaxSolution,Pack,Members,MaxDepth,Steps+1,OutSolutions);
			}
		}
		else 
		{
			OutSolutions = InSolutions;			//Empty stack
		}
	.

	
+!debug_set_assignment_for_new_solution
	<-
		Item = item(cs([task(condition(or([received(request),printed(again)])),condition(printed(welcome)),
							 [add(f(due)),add(f(uno)),add(printed(msg))],cs([commitment(printer,print,1),commitment(printer,decide,1)]),[],norms([])
					  )]),
					  accumulation(world([received(request)]),par_world([msg],[property(f,[due]),property(f,[uno]),property(printed,[msg])]),assignment_list([])),
					  ag([]),
					  0.09530107160810088);
		
		!set_assignment_for_new_solution(Item,[assignment(msg,bye)],NewTaskSet);
		.println("Output task set: ",NewTaskSet);
		
	.

/*
 * Data una soluzione item(cs(CS),acc,ag,score) e una lista di assignment, scorro la lista di task/commitment in CS e verifico se nei predicati
 * presenti in essi esiste un termine per cui esiste un assignment. In caso di esito positivo nella ricerca, viene creato un nuovo task uguale
 * al precedente ma con l'assignment trovato nella corrispondente lista di assignment nel task.
 */
//AssignmentList è la lista di assignment trovati per la soluzione. Sono quelli da aggiungere al task in pratica
+!set_assignment_for_new_solution(StackItem,AssignmentList,OutTaskSet)
	:	
		StackItem = item(cs(CS),_,_,_)
	<-
		!set_assignment_for_task_set(CS,AssignmentList,OutTaskSet);
	.

+!unroll_capabilities_to_get_evolution_plans(CS,Evo)
	:	CS 	= []
	<-	Evo	= []
	.
	
+!unroll_capabilities_to_get_evolution_plans(Item,Evo)
	:
		Item = item(cs(CS),_,_,_)
	<-
		!unroll_solution_to_get_commitment_set(Item, CommitmentSet);
		!unroll_capabilities_to_get_evolution_plans(CommitmentSet,Evo);
	.
	
+!unroll_capabilities_to_get_evolution_plans(CS,Evo)
	:
		CS 		= [Head|Tail] &
		Head = task(_,_,_,cs(CommitmentSet),_,_)
	<-
		!unroll_capabilities_to_get_evolution_plans(CommitmentSet,Evo);
	.
+!unroll_capabilities_to_get_evolution_plans(CS,Evo)
	:
		CS 		= [Head|Tail] &
		Head 	= commitment(AgName, CapName, _) 
	<-
		!unroll_capabilities_to_get_evolution_plans(Tail,EvoRec);	//recursive call
		!get_remote_capability_tx(Head, EvoPlan);					//get the capability evo plan

		if(.list(EvoPlan))	{.union(EvoPlan,EvoRec,Evo);}
		else				{.union([EvoPlan],EvoRec,Evo);}
	.

+ask_for_capability_evolution_plan(CapName, EvoPlan)
	<-
		.my_name(Me);
		?capability_evolution(CapName, EvoPlan);
	.



/**
 * [luca]
 * 
 * Return a list containing the input solutions and a new item.
 */
+!add_item_to_solution(InSolutions, Item, NewSolutions, New)
	<-
		!unroll_solutions_to_check_new_solution(InSolutions, Item, New);
		if (New=true) 	{NewSolutions = [ Item | InSolutions ];}	
		else 			{NewSolutions = InSolutions;}	
	.

/**
 * [luca]
 * 
 * Check if an item is not contained within a solution set.(davide)
 */
+!unroll_solutions_to_check_new_solution(Solutions, Item, Bool)
	:
		Solutions=[]
	<-
		Bool=true
	.
+!unroll_solutions_to_check_new_solution(Solutions, Item, Bool)
	:
		Solutions=[ Head | Tail ]
	<-
		!compare_solutions(Head,Item,HeadBool);
		if (HeadBool=false) 	{!unroll_solutions_to_check_new_solution(Tail, Item, Bool)} 
		else 					{Bool=false;}
	.

+!debug_unroll_solution_to_get_commitment_set
	<-
		Item = item( cs([task([],[],[],cs([commitment(printer,decide,1)]),[],norms([])),task([],[],[],cs([commitment(printer,print,1)]),[],norms([]))]),
				     accumulation(world([received(request)]),par_world([msg],[property(f,[due]),property(f,[uno]),property(printed,[msg])]),assignment_list([])),
				     ag([]),
				     0.09530107160810088 );
				     
		!unroll_solution_to_get_commitment_set(Item, OutCS);
		.print("Out commitment set: ",OutCS);				 
	.
	
+!debug_unroll_solution_to_get_commitment_set_2
	<-
		Item = task([],[],[],cs([commitment(firefighter,move,1)]),[],norms([]));
		!unroll_solution_to_get_commitment_set([Item], OutCS);
		.print("OutCS: ",OutCS);
	.

+!unroll_solution_to_get_commitment_set(Item, OutCS)
	:
		(Item = [Head|Tail] & Head = item(cs(CS),Acc,Ag,Score)) |
		Item = item(cs(CS),Acc,Ag,Score)
	<-
		!unroll_solution_to_get_commitment_set(CS, OutCS);
	.
+!unroll_solution_to_get_commitment_set(Item, OutCS)
	:
		Item = [Head|Tail] 	& Head = task(_,_,_,cs(CS),_,_)
	<-
		!unroll_solution_to_get_commitment_set(Tail, OutCSTail);
		!unroll_solution_to_get_commitment_set(CS, OutCSRec);
		.concat(OutCSTail,OutCSRec,OutCS);
	.
+!unroll_solution_to_get_commitment_set(Item, OutCS)
	:
		Item = [Head|Tail] &
		Head = commitment(_,_,_)
	<-
		!unroll_solution_to_get_commitment_set(Tail, OutCSRec);
		.concat([Head],OutCSRec,OutCS);
	.	
+!unroll_solution_to_get_commitment_set(Item, OutCS)
	:
		Item = []
	<-
		OutCS=[];
	. 	


/*
 * [davide]
 * 
 * Confronta due soluzioni.
 */
+!compare_solutions(Item1,Item2,EqBool)
	:
		Item1=item(cs(CS1),_,_,_) & Item2=item(cs(CS2),_,_,_)
	<-
		!unroll_solution_to_get_commitment_set(Item1, CPList1);
		!unroll_solution_to_get_commitment_set(Item2, CPList2);
		!unroll_task_set_to_get_condition_list(CS1, TClist_1, FSlist_1);
		!unroll_task_set_to_get_condition_list(CS2, TClist_2, FSlist_2);
		
		.union(CPList1,CPList2,Union);
		.intersection(CPList1,CPList2,Inters);
		.difference(Union,Inters,Diff);
		
		.union(TClist_1,TClist_2,UnionTC);
		.intersection(TClist_1,TClist_2,IntersTC);
		.difference(UnionTC,IntersTC,DiffTC);
		
		.union(FSlist_1,FSlist_2,UnionFS);
		.intersection(FSlist_1,FSlist_2,IntersFS);
		.difference(UnionFS,IntersFS,DiffFS);
		
		if ( .empty( Diff ) ) 		{ EqCPBool=true } 	else { EqCPBool = false }
		if ( .empty( DiffTC ) ) 	{TCequal=true} 		else {TCequal=false}
		if ( .empty( DiffFS ) ) 	{FSequal=true} 		else {FSequal=false}
		
		.eval(EqBool,EqCPBool&TCequal&FSequal);
	.

+!compare_solutions(Item1,Item2,EqBool)
	:
		Item1=item(task(TC1,FS1,_,cs(CS1),_,_),_,_,_,_) &
		Item2=item(task(TC2,FS2,_,cs(CS2),_,_),_,_,_,_)
	<-
		?orchestrate_verbose(VB);
		
		!unroll_solution_to_get_commitment_set(Item1, CPList1);
		!unroll_solution_to_get_commitment_set(Item2, CPList2);
		.union(CPList1,CPList2,Union);
		.intersection(CPList1,CPList2,Inters);
		.difference(Union,Inters,Diff);
		
		TC1 = condition(TC1Pred);
		TC2 = condition(TC2Pred);
		.difference([TC1Pred],[TC2Pred],TCdiff);
		
		if(VB=true){.print("-------------------->TCDiff(",TC1,",",TC2,"):",TCdiff);}
		
		if ( .empty( Diff ) ) { EqBool=true } else { EqBool = false }		
	.
	
+!unroll_sequence_to_extract_capability_list(CS,CPList)
	:	CS=[]
	<-	CPList=[];
	.
+!unroll_sequence_to_extract_capability_list(CS,CPList)
	:
		CS=[ Head | Tail ]
	<-
		//Head = commitment (cap(Capability,Percent), Agent) ;
		Head = commitment (Agent,Capability,Percent);
		
		!unroll_sequence_to_extract_capability_list(Tail,TailCPList);
		CPList = [ couple(Capability,Agent) | TailCPList ];
	.


+!debug_unroll_capabilities_to_update_stack_and_score_on_accumulation
	<-
		CPSet = [commitment(firefighter,wait_emergency,0), commitment(firefighter,move,0)];
			
		Item = item(
					cs([ commitment(administrator,two_way_decide,0,[assign(path1,one),assign(path2,two)]) ])
				   );	
	.
/**
 * [luca]
 * 
 * TODO [...]
 * 
 * CPSet -> lista di commitment(Me, Capability, HeadPercent)
 * 
 */
+!unroll_capabilities_to_update_stack_and_score_on_accumulation(CPSet,InSolutions,Item,Pack,MaxDepth,AssignmentList) 
	: CPSet=[] 
	<- true .
//----------------------
//TODO INSERIRE LE NORME
//TODO IMPORTANTE: ELIMINARE RIDONDANZE..
//----------------------
/*
 * Questo piano viene chiamato quando un item non soddisfa una soluzione presa dallo stack (cioè StackItem non soddisfa il goal pack) 
 * e vengono trovate delle capability (CPSet) in forma di task che creano un nuovo stato di accumulazione.
 * 
 * -> i task generati, messi sullo stack, NON hanno assignment. Questi vengono trovati nel piano chiamante !orchestrate_search
 * 
 * IN PRATICA tolgo un item dallo stack e ci aggiungo un commitment, dunque rimetto il tutto in un nuovo item nello stack
 */
+!unroll_capabilities_to_update_stack_and_score_on_accumulation(CPSet,InSolutions,StackItem,Pack,MaxDepth,AssignmentList)
	:
		CPSet 	= [Head|Tail] &
		Head 	= task(TC, FS, TaskEvo, cs(CS), _, norms(Norms))			//I task set trovati mediante il piano !ask_for_hypotetical_capabilities non contengono assignment		
	<-
		?orchestrate_verbose(VB);
		Pack 			= pack(Social,AgentGoals,Norms,Metrics);
		StackItem		= item(_, Accumulation, ag(AddressedItemGoal), ScoreOld);
		Accumulation 	= accumulation(_,_,assignment_list(OldAssignment));
		
		!get_commitment_from_stack_item(StackItem, CSold);								//Retrieve the commitment list from the stack item			
		!unroll_solution_to_get_commitment_set([Head], TaskCommitmentSet);				//Unroll the item to get the commitment set
		!apply_accu_evolution_operator(TaskCommitmentSet, Accumulation, AccuNext);		//apply the evolution plans related to the commitments
		
		if(VB=true){	.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] ITEM: ",StackItem);
						.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] accumulation state: ",Accumulation);
						.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] STACK ITEM CAPABILITIES: ",CSold);
						.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] NEW ACCUMULATION STATE:",AccuNext);}
		
		//Merge the old and the new commitment set. The old commitment set is not related to the input solutions.
		.union(CSold, CS, CSnew);							 
		
		//Get the list of satisfied goals in AccuNext (in which all the necessary substitutions have been made).
		!unroll_agent_goals_to_get_addressed_goals(AgentGoals,AccuNext,OldAssignment,AddressedGoal, _);		
 		!score_sequence_on_accumulation(CSnew, InSolutions, AccuNext, Pack, AddressedGoal, MaxDepth, OldAssignment, NewScore);	//Measure the zz
 		
		if(VB=true)
		{
			.print("------> NEW SCORE (score(CS)) ------> ",NewScore);	
			.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation]Old assignment list: ",OldAssignment);
			.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation]New assignment list: ",AssignmentList,"\n\n");
		}
		
		//Concatenate old and new assignment sets
		.union(OldAssignment, AssignmentList, NewAssignment);
		if(VB=true){.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] NEW ACCUMULATION STATE: ",AccuNext);}
		AccuNext 	= accumulation(AccunextW, AccunextPW, _);
		
		!unroll_capabilities_to_get_evolution_plans(CSnew, TaskEvoPlans);				//Unroll the commitment set to get their evolution plans
 		!unroll_solution_to_get_commitment_set(CSnew, TaskCS);							//Unroll the task to get the inner commitment set
	   	!get_goal_TC([Social], [TaskTC|_]);					
		!get_goal_FS([Social], [TaskFS|_]);
	   	!create_new_task(TaskTC,TaskFS,TaskEvoPlans,TaskCS,NewAssignment,[],NewTask);	//Create a new task
		insertItem(cs([NewTask]),														//Put the new task into the solution stack
				   accumulation(AccunextW, AccunextPW, assignment_list(NewAssignment)), 
				   ag(AddressedGoal), 
				   NewScore);
		
		!unroll_capabilities_to_update_stack_and_score_on_accumulation(Tail,InSolutions,StackItem,Pack,MaxDepth, AssignmentList);		//Recursive call	
	.	
	
/*
 * E' utile?
 */
+!unroll_capabilities_to_update_stack_and_score_on_accumulation(CPSet,InSolutions,Item,Pack,MaxDepth,AssignmentList)
	:
		CPSet=[ Head | Tail ]									
	&	Head = commitment(Me, Capability, HeadPercent)		//Capability da aggiungere
	&	HeadPercent > 0
	<-
		?orchestrate_verbose(VB);
		Pack 			= pack(Social,AgentGoalList,Norms,Metrics);
		Item 			= item(cs(CSold), Accumulation, ag(AddressedItemGoal), ScoreOld);
		Accumulation 	= accumulation(_,_,assignment_list(OldAssignment));	
		
		if(VB=true){.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] ITEM: ",Item);
					.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] accumulation state: ",Accumulation);
					.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] CURRENT CAPABILITY: ",Capability);}		
		
		//Get the capability evolution plan and apply it to the accumulation state
		!apply_accu_evolution_operator([Head], Accumulation, AccuNext);		
		
		if(VB=true){.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] EVO PLAN: ",Evo_Plan);
					.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] NEW ACCUMULATION STATE:",AccuNext);}
		
		//Merge the input commitment with the old commitment set 
		.union(CSold,[Head],CSnew);

		//Get the list of satisfied goals in AccuNext (in which all the necessary substitutions have been made). 
		!unroll_agent_goals_to_get_addressed_goals(AddressedItemGoal,AccuNext,OldAssignment,AddressedGoal, _);
		!score_sequence_on_accumulation(CSnew,InSolutions,AccuNext,Pack,AddressedGoal,MaxDepth,OldAssignment, NewScore);
		if(VB=true)
		{
			.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] Old assignment list: ",OldAssignment);
			.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] New assignment list: ",AssignmentList,"\n\n");
			.print("[unroll_capabilities_to_update_stack_and_score_on_accumulation] NEW ACCUMULATION STATE: ",AccuNext);
		}
		
		.union(OldAssignment, AssignmentList, NewAssignment);																				//Concatenate old and new assignment sets
		AccuNext = accumulation(AccunextW, AccunextPW, _);																					//Get W and PW from the new accumulation state
		insertItem(cs(CSnew), accumulation(AccunextW, AccunextPW, assignment_list(NewAssignment)), ag(AddressedGoal), NewScore);			//Insert the new item into the stack		
		!unroll_capabilities_to_update_stack_and_score_on_accumulation(Tail,InSolutions,Item,Pack,MaxDepth, AssignmentList);							//Recursive call on next capability			
	.
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------

+!debug_unroll_agent_goals_to_get_addressed_goals
	<-
		AGlist = [	agent_goal( condition( or( [received(request), printed(again)])) , condition(printed(welcome)), system )[ parlist([par(welcome,"ciao")]) ],
					agent_goal( condition( printed(welcome) ) , condition( or([f(one), f(two)])), system )];
					
		Accumulation = accumulation( world([received(request)]), par_world([],[]), assignment_list([]));
		
		!unroll_agent_goals_to_get_addressed_goals(AGlist,Accumulation,[],AddressedGoalList, AddressedGoalAssignment);
		.print("Addressed goals: ",AddressedGoalList);
	.

/** 
 *  [davide]
 *  Build a list of solutions AddressedGoalList, containing the addressed goals contained 
 *  into AgentGoalList. 
 */
+!unroll_agent_goals_to_get_addressed_goals(AgentGoalList,Accumulation,InputAssignment,AddressedGoalList, AddressedGoalAssignment)
	:
		AgentGoalList=[]
	<-
		AddressedGoalList=[];
		AddressedGoalAssignment=[];
	.
/** 
 *  [davide]OutCS
 * 
 *  Build a list of solutions AddressedGoalList, containing the goals satisfied in accumulation. 
 */
+!unroll_agent_goals_to_get_addressed_goals(AgentGoalList,Accumulation,InputAssignment,AddressedGoalList, AddressedGoalAssignment)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		?orchestrate_verbose(VB);
		!unroll_agent_goals_to_get_addressed_goals(Tail,Accumulation,InputAssignment,TailAddressedGoalList,AssignmentRec);
		!check_if_goal_is_satisfied_in_accumulation(Head,Accumulation,InputAssignment,_,HeadSatisfied,Assignment);			
		
		.concat(Assignment,AssignmentRec, AddressedGoalAssignment);
		
		if(HeadSatisfied=true)										//if current goal has been addressed
		{
			if(VB=true)
			{
				.print("[unroll_agent_goals_to_get_addressed_goals] Head (satisfied): ",Head);
				.print("[unroll_agent_goals_to_get_addressed_goals] Tail: ",Tail);	
			}
			.union([Head], TailAddressedGoalList, AddressedGoalList);
		}
		else
		{
			.concat([],TailAddressedGoalList, AddressedGoalList);
		}
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for calculate_solutions_cardinality
 */
+!debug_calculate_solutions_cardinality
	<-
		Input =[item(cs([task(condition(or([received(request),printed(again)])),condition(printed(welcome)),[add(f(due)),add(f(uno)),add(printed(msg))],cs([commitment(printer,print,1),commitment(printer,decide,1)]),[],norms([]))]),accumulation(world([received(request)]),par_world([msg],[property(f,[due]),property(f,[uno]),property(printed,[msg])]),assignment_list([])),ag([]),0.09530107160810088),
				item(cs([task(condition(received(request)),condition(printed(bye)),[add(printed(msg))],cs([commitment(printer,print,1)]),[],norms([]))]),accumulation(world([received(request)]),par_world([msg],[property(printed,[msg])]),assignment_list([])),ag([agent_goal(condition(or([received(request),printed(again)])),condition(printed(welcome)),system)[parlist([par(welcome,"ciao")])]]),0.11812322182992825)];
		!calculate_solutions_cardinality(Input, Out);
		.print("Input Solution: ",Input);
		.print("\nSolution cardinality: ",Out); // unifica Out con 2
	.


/**
 * [davide]
 * 
 * Prendo il numero di commitment/task all'interno di tutte le soluzioni in ingresso.
 * 
 */
 +!calculate_solutions_cardinality(Insolutions, OutCardinality)
	:	Insolutions 	= []
	<-	OutCardinality 	= 0;
	.
+!calculate_solutions_cardinality(Insolutions, OutCardinality)
	:
		Insolutions 	= [Head|Tail] &
		Head 			= item(cs(CS),_,_,_)
	<-
		!calculate_solutions_cardinality(Tail, OutCardinalityRec);		
		.length(CS, CurrentSolutionCardinality);
		OutCardinality = CurrentSolutionCardinality + OutCardinalityRec;
	.
	
/**
 * TODO [ottimizzare] cambia evaluate_satisfaction in modo da utilizzare addressedgoal piuttosto che ricalcolarselo
 * 
 * QUI VIENE CALCOLATO LO SCORE score(CS) (Lecture 2, slide 25)
 */
+!score_sequence_on_accumulation(CS,InSolutions,Accumulation,Pack,AddressedGoal,CSmaxlen,InputAssignment,Score)
	<-
		?orchestrate_verbose(VB);
		?blacklist_enabled(BlacklistEnabled);
		
		if(VB=true)
		{
			.println("[score_sequence_on_accumulation] focus for scoring on ",CS);
			.println("[score_sequence_on_accumulation] AddressedGoal: ",AddressedGoal);
		}
		Pack=pack(Social,AgentGoalList,Norms,Metrics);
		
		//Evaluate goal pack satisfaction score in accumulation
		!evaluate_satisfaction_in_accumulation(AgentGoalList, Accumulation, InputAssignment, SatisfiedPercent);								//Evaluate the satisfaction of the agent goals
		!check_if_goal_is_satisfied_in_accumulation(Social, Accumulation, InputAssignment, SGSatPercent, SGSatisfied, SGAssignmentList);	//Evaluate the satisfaction of the social goal
		!calculate_solutions_cardinality(InSolutions, InputSolutionCardinality);
		
		InputSolutionScore = InputSolutionCardinality*0.5;
		.length(CS, CSCardinality);		//Calculate the cardinality of the solution

 		if(BlacklistEnabled)	
 		{
 			!unroll_solution_to_get_commitment_set(CS, CommitmentSet);
			!unroll_solution_to_get_commitment_set(InSolutions, InSolutionCommitmentSet);		
			.union(InSolutionCommitmentSet, CommitmentSet, OverallCS);
 			!get_blacklisted_capability_list(OverallCS, BlacklistedCS);
 			!score_blacklisted_CS(BlacklistedCS,BlacklistScore);
 		}
		else 					
		{
			BlacklistScore = 0;
		}

		if(SGSatisfied=true)		{	Cardinality = CSCardinality+1; 	}
		else						{	Cardinality = CSCardinality;	}
		
		GoalScore = (0.1+SatisfiedPercent)/(1 + BlacklistScore + math.log(Cardinality+InputSolutionScore));
		
		.length(Metrics,MSize);
		!unroll_metrics_on_accumulation_to_calculate_domain_score(Metrics,1/MSize,CS,Accumulation,DomainScore);
		
		Score = (2*GoalScore)+DomainScore;
		if(VB=true){.println("[score_sequence_on_accumulation] Score: ",Score);}
	.


+!unroll_metrics_on_accumulation_to_calculate_domain_score(Metrics,Weight,CS,Accumulation,DomainScore)
	:
		Metrics=[]
	<-
		DomainScore=0;
	.
+!unroll_metrics_on_accumulation_to_calculate_domain_score(Metrics,Weight,CS,Accumulation,DomainScore)
	:
		Metrics=[ Head | Tail ]
	<-
		!metric(Head,CS,Accumulation,HeadScore);
		!unroll_metrics_on_accumulation_to_calculate_domain_score(Tail,Weight,CS,Accumulation,TailScore);
		DomainScore = (Weight*HeadScore) + TailScore;
	.

/**
 * [davide]
 * 
 * Update an accumulation state by applying the given evolution plans.
 * This plan takes an accumulation state, for example
 * 
 * accumulation(world(..),par_world([...],[property(f,[x])],assignment_list(...)))
 * 
 * and apply the evolution plans from the capability set CS to get AccumulationNext.
 */
+!update_accumulation(Accumulation, PlanEvFunc, AccumulationNext)
	:	PlanEvFunc = []
	<-  AccumulationNext = Accumulation;
	.
+!update_accumulation(Accumulation,PlanEvFunc,AccumulationNext)
	:
		PlanEvFunc = [ Head | Tail]
	<-
		!apply_accu_evolution_operator(Capability, Head,Accumulation,UpdatedAccumulation);
		!update_accumulation(UpdatedAccumulation,Tail,AccumulationNext);
	.
	
/**
 * [davide]
 * 
 * DEBUG PLAN for !apply_accu_evolution_operator(Operator,Accumulation,UpdatedAccumulation)
 */
+!debug_apply_accu_evolution_operator_1
	<-
		Operator 		= add(f(msg));
		Accumulation 	= accumulation(world([]), par_world([],[]), []);
		Capability = boh;
		!apply_accu_evolution_operator(Capability, Operator,Accumulation,UpdatedAccumulation);
		.print("Updated acc: ",UpdatedAccumulation);
	.	
	
+!debug_apply_accu_evolution_operator_2
	<-
		.print("---Test case 2---");
		Operator 		= add( move(worker, emergency_location) );
		Accumulation 	= accumulation(world([]), par_world([],[]), assignment_list([]));
		Capability = move;
		!apply_accu_evolution_operator(move, Operator,Accumulation,UpdatedAccumulation);
		.print("Updated acc: ",UpdatedAccumulation);
	.


+!debug_apply_accu_evolution_operator_3
	<-
		.my_name(Me);
		CS = [commitment(Me,move,_),commitment(Me,wait_emergency,_)];
		Accumulation 	= accumulation(world([]), par_world([],[]), assignment_list([]));
		!apply_accu_evolution_operator(CS,Accumulation,UpdatedAccumulation);
		.print("Updated acc: ",UpdatedAccumulation);
	.
	

/**
 * [luca]
 * 
 * Apply an ADD operator (contained in an evolution plan) to a world
 * statement set. 
 * 
 * l'insieme di statement è dato dall'unione tra PWS e i predicati di world(..)
 * normalizzati. Dunque una lista di par_condition
 */
 //nuovo
 
//CS: lista di commitment
 +!apply_accu_evolution_operator(CS,Accumulation,UpdatedAccumulation)
	:
		CS=[Head|Tail] & 
		Head=task(_, _, _, cs(TaskCS), _, _)
	<-
		!apply_accu_evolution_operator(TaskCS,Accumulation,UpdatedAccumulation);	
	.
 +!apply_accu_evolution_operator(CS,Accumulation,UpdatedAccumulation)
	:
		CS=[Head|Tail] & 
		Head=commitment(Agent, Cap, HeadPercent)
	<-
		!get_remote_capability_tx(Head,[PLAN_EVO|_]);
		!apply_accu_evolution_operator(Head, PLAN_EVO,Accumulation,UpdatedAccumulationCurrent);
		!apply_accu_evolution_operator(Tail,UpdatedAccumulationCurrent,UpdatedAccumulation);	
	.
+!apply_accu_evolution_operator(CS,Accumulation,UpdatedAccumulation)
	:	CS=[]
	<-	UpdatedAccumulation=Accumulation;
	.
+!apply_accu_evolution_operator(Capability, Operator,Accumulation,UpdatedAccumulation)
	:
		Operator 		= add(Statement)																&
		Accumulation 	= accumulation(world(WS),par_world(Vars,PWS),assignment_list(AssignmentSet))
	<-	
		if(not .empty(WS))
		{
			!normalize_world_statement(WS, NormalizedWorldStatement);				//normalize the world statements (p(a) -> property(a,[f]))
		}
		!normalize_world_statement([Statement], NormalizedStatement_List);			//normalize the operator's statement	
		
		Capability = commitment(Ag,CapName,_);										//Get the capability terms
		!get_remote_capability_pars(Capability,ParamsList);							//Get the capability parameters name list
		NormalizedStatement_List = [Head|_];									
		Head = property(F,Terms);
		.intersection(ParamsList,Terms,EffectiveParams);							//Get the effective variabiles to be added in Vars
		
		//Build the new accumulation statement
		if(not .empty(EffectiveParams))
		{
			//The capability is parametric, add the evolution plan's predicates to par_world
			.union(PWS, [Head], NewPWSStatementSet);
			.union(Vars, EffectiveParams, NewVarList);
			UpdatedAccumulation = accumulation(world(WS), par_world(NewVarList, NewPWSStatementSet), assignment_list(AssignmentSet)); 
		}
		else
		{			
			!convert_parametric_to_simple_formula(Head,[],[],SimpleFormula);
			.union(WS, [SimpleFormula], NewWSStatementSet);
			UpdatedAccumulation = accumulation(world(NewWSStatementSet), par_world(Vars, PWS), assignment_list(AssignmentSet));
		}
	.
-!apply_accu_evolution_operator(Capability, Operator,Accumulation,UpdatedAccumulation)
	<-
		.print("[MUSA ERROR] Error executing plan +!apply_accu_evolution_operator.\nCap: ",Capability,"\nOperator: ",Operator,"\nAccumulation: ",Accumulation);
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for !check_if_property_contains_vars(..)
 */
+!debug_check_if_property_contains_vars
	<-
		!check_if_property_contains_vars([msg,a,b], [], Bool, VarList);
		.print("->",Bool);
		.print("->",VarList);
	.
	
/**
 * [davide]
 * 
 * Given a normalized statement, for example
 * 
 * property(a,[f,g])
 * 
 * and a list of parameters from a capability, check if the term 
 * list of a property contains variables. If it contains variables, then
 * unifies Bool with true and VarList with the variables. 
 */
+!check_if_property_contains_vars(NormalizedStatementTerms, ParamList, Bool, VarList)
	:
		NormalizedStatementTerms = [Head|Tail] &
		.member(Head, ParamList)
	<-
		!check_if_property_contains_vars(Tail, ParamList, BoolRec, VarListRec);
		
		.eval(Bool, BoolRec | true);
		.concat([Head],VarListRec,VarList);
	.
+!check_if_property_contains_vars(NormalizedStatementTerms, ParamList, Bool, VarList)
	:
		NormalizedStatementTerms = [Head|Tail] &
		not .member(Head, ParamList)
	<-
		!check_if_property_contains_vars(Tail, ParamList, Bool, VarList);
	.
+!check_if_property_contains_vars(NormalizedStatementTerms, ParamList, Bool, VarList)
	:
		NormalizedStatementTerms = []
	<-
		Bool = false;
		VarList = [];
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for !ask_for_hypotetical_capabilities(Members, Accumulation, CommitmentSet)
 */
+!debug_ask_for_hypotetical_capabilities
	<-
		!ask_for_hypotetical_capabilities([], accumulation( world([]), par_world([msg],[property(printed,[msg])]), a ), [], CS);
		.print("CS: ",CS);
	.

//TODO lista vuota Members solo per test
/* **forward strategy**  
 * 
 * search for capabilities with a PRE-COND that is true in Accumulation
 */
+!ask_for_hypotetical_capabilities(Members, Accumulation, TaskSet)
	<-
		?orchestrate_verbose(VB);
		?blacklist_enabled(BlacklistEnabled);
		
		!select_hypotetical_capabilities(Accumulation, LocalCommitmentSet);
		
		
		if(VB=true) {.println("[ask_for_hypotetical_capabilities]Accumulation state ",Accumulation);
					 .println("[ask_for_hypotetical_capabilities]LocalCommitmentSet:",LocalCommitmentSet);}
		
		if (.empty(Members)) 
		{
			CommitmentSet = LocalCommitmentSet;
		}
		else
		{
			//Ask for collaboration 
			!ask_for_collaborations(Members, contribute_to_solution(Accumulation), RemoteCommitmentSet);
			.concat(LocalCommitmentSet, RemoteCommitmentSet, CommitmentSet);
			
		}
		if(VB=true) {.println("[ask_for_hypotetical_capabilities]selected capabilities:",CommitmentSet);}


		if(BlacklistEnabled)
		{
			.my_name(Me);
			.findall(commitment(Me,Cap,TS), capability_blacklist(Me,Cap,TS), LocalBlacklistedCommitmentSet);
			
			if (.empty(Members))	
			{
				BlacklistedCS = LocalBlacklistedCommitmentSet
			}
			else					
			{
				!ask_for_collaborations(Members, blacklist_request, RemoteBlacklistedCommitmentSet);
				.union(LocalBlacklistedCommitmentSet, RemoteBlacklistedCommitmentSet, BlacklistedCS);
			}
			
			getDatabaseSystemCurrentTimeStamp(DBCurrentTimeStampStr);
			.term2string(DBCurrentTimeStamp,DBCurrentTimeStampStr);
			
			!update_capability_blacklist(BlacklistedCS, DBCurrentTimeStamp, Context);
		}
		
		//Costruisco lista di task
		!build_task_list_from_commitment_set(CommitmentSet, TaskSet);
	.


/**
 * [davide]
 * 
 * Failure goal for handling +capability_postcondition belief issues.
 */
-?capability_precondition(CAP,TC)
	<-
		.print("ERROR: failed to get TC for capability ",CAP);
	.
	
/**
 * [davide]
 * 
 * Failure goal for handling +capability_postcondition belief issues.
 */
-?capability_postcondition(CAP,FS)
	<-
		.print("ERROR: failed to get FS for capability ",CAP);
	.
	
/**
 * [davide]
 * 
 * Retrieve the TC for the capability Cap
 */
+!get_capability_PreCondition(Cap, TC)
	:
		Cap = commitment(_,CapName,_)
	<-
		?capability_precondition(CapName, FS);
	.
-!get_capability_PreCondition(Cap, FS)
	<-
		.print("Failed to get Capability '",Cap,"' pre condition.");
	.
/**
 * [davide]
 * 
 * Retrieve the FS for the capability Cap
 */	
+!get_capability_PostCondition(Cap, FS)
	:
		Cap = commitment(_,CapName,_)
	<-
		?capability_postcondition(CapName, FS);
	.
-!get_capability_PostCondition(Cap, FS)
	<-
		.print("Failed to get Capability '",Cap,"' post condition.");
	. 

 
+collaboration_request(Token,MaxCounter,Request)[source(Manager)]
	:
		Request=contribute_to_solution(Accumulation)
	<-
		?orchestrate_verbose(VB);
		if(VB=true){.println("[+collaboration_request]",collaboration_request(Token,MaxCounter,Request));}
		
		.abolish( collaboration_request(Token,MaxCounter,Request) );
		+max_time_for_collecting(Token,MaxCounter);
		!select_hypotetical_capabilities(Accumulation,CommitmentSet);
		
		.send(Manager,tell,collaboration_answer(Token,CommitmentSet));
		-max_time_for_collecting(Token,MaxCounter);
	.
	
+collaboration_request(Token,MaxCounter,Request)[source(Manager)]
	:
		Request=blacklist_request
	<-
		?orchestrate_verbose(VB);
		if(VB=true){.println("[+collaboration_request]",collaboration_request(Token,MaxCounter,Request));}
		
		.abolish( collaboration_request(Token,MaxCounter,Request) );
		+max_time_for_collecting(Token,MaxCounter);
		
		.my_name(Me);
		.findall(commitment(Me,Cap,TS), capability_blacklist(Me,Cap,TS), BlacklistCS);
		//!!!!
		
		.send(Manager,tell,collaboration_answer(Token,BlacklistCS));
		-max_time_for_collecting(Token,MaxCounter);
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for +!select_hypotetical_capabilities(Accumulation,CommitmentSet)
 */
+!debug_select_hypotetical_capabilities
	<-
		Acc = accumulation(world([]), par_world([],[]), a);
		!select_hypotetical_capabilities(Acc, CommitmentSet);
		
		.print("Commitment set: ",CommitmentSet);
		
	.
/**
 * []
 * 
 * Build a list containing all the capabilities, then filter them by:
 *  
 *  - selecting the capabilities that triggers on an accumulation state
 *  - selecting the capabilities that creates a new world state
 *  - [TODO] selecting the capabilities which parameters are valid
 *  - [TODO] selecting the capabilities that respect norms
 * 
 * poichè il piano viene richiamato per ogni goal G, allora, in realtà,
 * il piano dovrebbe restituire un singolo task contente i commitment che 
 * soddisfano il G.
 */
//[TODO] +!select_hypotetical_capabilities(Accumulation, CommitmentSet, NormList)
+!select_hypotetical_capabilities(Accumulation, CommitmentSet)
	<-
		.my_name(Me);
		
		//Build a list containing ALL the capabilities
		.findall(commitment(Me, Cap, HeadPercent), agent_capability(Cap)[type(simple)], AllSimpleCapabilities);				//Simple capabilities
		.findall(commitment(Me, Cap, HeadPercent), agent_capability(Cap)[type(parametric)], AllParCapabilities);			//Parametric capabilities
		
		//get the capabilities that have multiple types specified (only simple and parametric)
		.findall(commitment(Me, Cap, HeadPercent)[capability_types(CapabilityTypes)], agent_capability(Cap)[capability_types(CapabilityTypes)], AllCapabilityWithDifferentTypes);
		
		!filter_capability_with_multiple_types_specified(AllCapabilityWithDifferentTypes, OutFilteredCapabilities);
		
		/**
		 * TODO -> Può essere aggiunto qui un controllo o una azione sulle capability che hanno più tipi specificati
		 */
		
		.union(AllSimpleCapabilities, AllParCapabilities, AllCapabilities_tmp);													//ALLcapabilities
		.union(OutFilteredCapabilities, AllCapabilities_tmp, AllCapabilities);
		
		!filter_capabilities_that_triggers_on_accumulation(AllCapabilities, Accumulation, CapabilitiesThatTriggersAcc);
		!filter_capabilities_that_create_a_new_world_in_accumulation(CapabilitiesThatTriggersAcc, Accumulation, CommitmentSet);
	.

/**
 * [davide]
 * 
 * Filter the commitment list which have multiple types specified, returning the capabilities which have
 * type(simple) or type(parametric) specified.
 */
+!filter_capability_with_multiple_types_specified(CommitmentList, OutCapList)
	:
		CommitmentList 	= [Head|Tail]	&
		Head 			= commitment(Me, Cap, HeadPercent)[capability_types(CapabilityTypes)]
	<-
		!filter_capability_with_multiple_types_specified(Tail, OutCapListRec);
		
		if(.member(type(simple), CapabilityTypes) | .member(type(parametric), CapabilityTypes))
		{
			.concat([commitment(Me, Cap, HeadPercent)],OutCapListRec,OutCapList);
		}
		else
		{
			.concat([],OutCapListRec,OutCapList);
		}				
	.

+!filter_capability_with_multiple_types_specified(CommitmentList, OutCapList)
	:	CommitmentList 		= []
	<-	OutCapList 			= [];
	.

/**
 * Filter the input capabilities by selecting only those whose headPercent value is greater than 0
 */
+!concatene_capability_if_percent_not_zero(InCapabilities,Head,HeadPercent,OutCapabilities)
	:
		HeadPercent > 0
	&	Head=commitment(Me, Capability, HeadPercent)
	<-
		.my_name(Me);
		OutCapabilities = [ commitment(Me, Capability, HeadPercent) | InCapabilities ];
	.
+!concatene_capability_if_percent_not_zero(InCapabilities,Head,HeadPercent,OutCapabilities)
	<-
		OutCapabilities = InCapabilities;
	.