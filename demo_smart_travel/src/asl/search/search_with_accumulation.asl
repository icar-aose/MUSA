+!initialize_search_with_accumulation(WI,Pack,OutSolutions)
	<-
		makeArtifact("stack","st.Stack",[]);
		
		.println("WI: ",WI);
		.println("INITIALIZE STACK");
		
		?search_max_depth(MaxDepth);
		?search_number_of_solutions(MaxSolution);
		
		!select_hypotetical_capabilities(WI,CPSet);
		.println(CPSet);
		!unroll_capabilities_to_update_stack_and_score_on_accumulation(CPSet,item(cs([]),evo([WI]),0),Pack,MaxDepth);
		
		InitSolutions=[];
		
		.println("START SEARCH");
		!search_with_accumulation(InitSolutions,MaxSolution,Pack,MaxDepth,0,OutSolutions);
		.println("END SEARCH");
	.


+!search_with_accumulation(InSolutions,MaxSolution,Pack,MaxDepth,Steps,OutSolutions)
	<-
		stackSize(Size);
		?search_number_of_steps(Max);
		
		if (Size>0 & Steps<Max ) {
			pickItem( Item );
			Item=item(cs(CS),evo([Accumulation]),Score);
			//.println(Steps,": (",CS,") ",Accumulation);
			
			Pack=pack(Social,AgentGoalList,Norms,Metrics);
			!check_if_goal_pack_is_satisfied_in_accumulation(Social,AgentGoalList,Accumulation,GoalPackSatisfied);
			
			if (GoalPackSatisfied=true) {
				
				!add_item_to_solution(InSolutions,Item,NewSolutions);
				
				.length(NewSolutions,SolSize);
				.println("new solution! at step ",Steps,"  number of solutions: ",SolSize);
				
				if (MaxSolution > 1) {
					!search_with_accumulation(NewSolutions,MaxSolution-1,Pack,MaxDepth,Steps+1,OutSolutions);
				
				} else {
					OutSolutions = NewSolutions;
				}
			
			} else {
				.length(CS,Len); 
				
				if (Len <= MaxDepth) {
					!select_hypotetical_capabilities(Accumulation,CPSet);
					
					if (Steps/10 = math.floor(Steps/10)) {
						.length(CPSet,CPLen);
						.println(Steps,": (",Score,") {",Len,"} ",Accumulation," b=",CPLen," Stack:",Size);
					}
					
					!unroll_capabilities_to_update_stack_and_score_on_accumulation(CPSet,Item,Pack,MaxDepth);	
				}
				
				!search_with_accumulation(InSolutions,MaxSolution,Pack,MaxDepth,Steps+1,OutSolutions);
			}
		} else {
			OutSolutions = InSolutions;
		}
	.

+!add_item_to_solution(InSolutions,Item,NewSolutions)
	<-
		!unroll_solutions_to_check_new_solution(InSolutions, Item, New);		
		
		if (New=true) {
			NewSolutions = [ Item | InSolutions ];
			//.println("FOUND new solution ",Item," against ",InSolutions);
		}	else {
			NewSolutions = InSolutions;
			//.println("FOUND existing solution ",Item," against ",InSolutions);
		}	
	.

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
		if (HeadBool=false) {
			!unroll_solutions_to_check_new_solution(Tail, Item, Bool)
		} else {
			Bool=false;
		}
	.


+!compare_solutions(Item1,Item2,EqBool)
	<-
		Item1=item(cs(CS1),_,_);
		Item2=item(cs(CS2),_,_);
		
		!unroll_sequence_to_extract_capability_list(CS1,CPList1);
		!unroll_sequence_to_extract_capability_list(CS2,CPList2);
		
		
		.union(CPList1,CPList2,Union);
		.intersection(CPList1,CPList2,Inters);
		.difference(Union,Inters,Diff);
		
		if ( .empty( Diff ) ) { EqBool=true } else { EqBool = false }		
		
		//.println("comparing ",CPList1," with ",CPList2," = ",EqBool);
	.

+!unroll_sequence_to_extract_capability_list(CS,CPList)
	:
		CS=[]
	<-
		CPList=[];
	.
+!unroll_sequence_to_extract_capability_list(CS,CPList)
	:
		CS=[ Head | Tail ]
	<-
		Head = cap(Capability,Percent);
		
		!unroll_sequence_to_extract_capability_list(Tail,TailCPList);
		CPList = [ Capability | TailCPList ];
	.

		
//Item=item(cs(CS),evo([Accumulation]),Score);
	
+!unroll_capabilities_to_update_stack_and_score_on_accumulation(CPSet,Item,Pack,MaxDepth) : CPSet=[] <- true .
+!unroll_capabilities_to_update_stack_and_score_on_accumulation(CPSet,Item,Pack,MaxDepth)
	:
		CPSet=[ Head | Tail ]
	&	Head = cap(Capability,Percent)
	&	Percent > 0
	<-
		Pack=pack(Social,AgentGoalList,Norms,Metrics);
		Item=item(cs(CSold),evo([Accumulation]),ScoreOld);

		!get_capability_tx(Head,TX);		
		
		!update_accumulation_world(Accumulation,TX,AccuNext);
		.concat(CSold,[Head],CSnew);		


		!score_sequence_on_accumulation(CSnew,AccuNext,Pack,MaxDepth,NewScore);	
		insertItem(cs(CSnew), evo([AccuNext]), NewScore);
		
		//.println("generated ",cs(CSnew), evo([AccuNext]), NewScore);

		!unroll_capabilities_to_update_stack_and_score_on_accumulation(Tail,Item,Pack,MaxDepth);			
	.
+!unroll_capabilities_to_update_stack_and_score_on_accumulation(CPSet,Item,Pack,MaxDepth)
	:
		CPSet=[ Head | Tail ]
	<-
		!unroll_capabilities_to_update_stack_and_score_on_accumulation(Tail,Item,Pack,MaxDepth);			
	.

+!score_sequence_on_accumulation(CS,Accumulation,Pack,CSmaxlen,Score)
	<-
		//.println("focus for scoring on ",CS);
		Pack=pack(Social,AgentGoalList,Norms,Metrics);
		
		!evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,SatisfiedPercent);
		
		//.println("NumberSatisfiedGoals ",NumberSatisfiedGoals);

		//!check_if_goal_is_satisfied_in_accumulation(Social,Accumulation,SocialGoalSatisfied);

		//.println("SocialGoalSatisfied ",SocialGoalSatisfied);

		
/* 		if (SocialGoalSatisfied=true) {
			NumberGoals=NumberSatisfiedGoals+1;
		} else {
			NumberGoals=NumberSatisfiedGoals;
		}
*/
		.length(CS,Cardinality);
		Score=(0.1+SatisfiedPercent)/(1 + math.log(Cardinality));
	.



+!unroll_agent_goals_to_count_how_many_satisfied_in_accumulation(AgentGoalList,Accumulation,Count)
	:
		AgentGoalList=[]
	<-
		Count=0;
	.
+!unroll_agent_goals_to_count_how_many_satisfied_in_accumulation(AgentGoalList,Accumulation,Count)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		!check_if_goal_is_satisfied_in_accumulation(Head,Accumulation,HeadSatisfied);
		
		!unroll_agent_goals_to_count_how_many_satisfied_in_accumulation(Tail,Accumulation,TailCount);

		if (HeadSatisfied=1) {
			Count = TailCount+1;
		} else {
			Count = TailCount;
		}
	.


+!evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,SatisfiedPercent)
	<-
		//.println(evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,SatisfiedPercent));
		!unroll_agent_goals_to_evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,SatisfiedPercentList);
		!calculate_average(SatisfiedPercentList,SatisfiedPercent);
	.
	
+!unroll_agent_goals_to_evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,SatisfiedPercentList)
	:
		AgentGoalList=[]
	<-
		SatisfiedPercentList=[];
	.
+!unroll_agent_goals_to_evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,SatisfiedPercentList)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		//.println("HEAD: ",Head);
		!check_if_goal_is_satisfied_in_accumulation(Head,Accumulation,HeadSatisfied);
		
		//.println("HeadSatisfied: ",HeadSatisfied);
		
		!unroll_agent_goals_to_evaluate_satisfaction_in_accumulation(Tail,Accumulation,TailSatisfiedPercentList);
		SatisfiedPercentList=[ HeadSatisfied | TailSatisfiedPercentList ];
	.



+!update_accumulation_world(World,PlanEvFunc,Wnext)
	:
		PlanEvFunc = []
	<-
		Wnext = World;
	.
+!update_accumulation_world(World,PlanEvFunc,Wnext)
	:
		PlanEvFunc = [ Head | Tail]
	<-
		!apply_accu_evolution_operator(Head,World,UpdatedWorld);
		
		!update_accumulation_world(UpdatedWorld,Tail,Wnext);
	.
+!apply_accu_evolution_operator(Operator,World,UpdatedWorld)
	:
		Operator = add(Statement)
	&	World = world(StatementSet)
	<-
		.union(StatementSet,[Statement],UpdatedStatementSet);
		UpdatedWorld = world(UpdatedStatementSet);
	.
+!apply_accu_evolution_operator(Operator,StatementSet,UpdatedStatementSet)
	:
		Operator = add(Statement)
	<-
		.union(StatementSet,[Statement],UpdatedStatementSet);
	.
+!apply_accu_evolution_operator(Operator,World,UpdatedWorld)
	<-
		UpdatedWorld = World;
	.



+!select_hypotetical_capabilities(Accumulation,CPSet)
	<-
		
		.findall(cap(Cap),agent_capability(Cap)[type(simple)],AllSimpleCapabilities);
		!filter_capabilities_that_triggers_on_accumulation(AllSimpleCapabilities,Accumulation,WkSimpleCapabilities);
		!filter_capabilities_that_create_a_new_world_in_accumulation(WkSimpleCapabilities,Accumulation,SimpleCPSet);
		
		CPSet = SimpleCPSet;
	.



+!filter_capabilities_that_create_a_new_world_in_accumulation(InCapabilities,Accumulation,OutCapabilities)
	:
		InCapabilities=[]
	<-
		OutCapabilities=[]
	.
+!filter_capabilities_that_create_a_new_world_in_accumulation(InCapabilities,Accumulation,OutCapabilities)
	:
		InCapabilities=[ Head | Tail ]
	&	Head=cap(Capability,Percent)
	<-
		?capability_evolution(Capability,PLAN_EVO);
		!update_accumulation_world(Accumulation,PLAN_EVO,AccuNext);
		
		//.println("Accumulation: ",Accumulation);
		//.println("AccuNext: ",AccuNext);
		!check_worlds_equal(Accumulation,AccuNext,CompareBool);
		
		!filter_capabilities_that_create_a_new_world_in_accumulation(Tail,Accumulation,FilteredTail);
		
		if (CompareBool \== true) {
			OutCapabilities = [ Head | FilteredTail ];
		} else {
			OutCapabilities = FilteredTail
		}
	.



+!filter_capabilities_that_triggers_on_accumulation(InCapabilities,Accumulation,OutCapabilities)
	:
		InCapabilities=[]
	<-
		OutCapabilities=[]
	.
+!filter_capabilities_that_triggers_on_accumulation(InCapabilities,Accumulation,OutCapabilities)
	:
		InCapabilities=[ Head | Tail ]
	&	Head=cap(Capability)
	<-
		?capability_precondition(Capability,PRE);
		
		//.println("Capability: ",Capability);
		!elaborate_condition_truth_percent(PRE,Accumulation,HeadPercent);
		//.println("Pre: ",PRE," = ",HeadPercent);
		
		!filter_capabilities_that_triggers_on_accumulation(Tail,Accumulation,FilteredTail);
		!concatene_capability_if_percent_not_zero(FilteredTail,Head,HeadPercent,OutCapabilities);
	.
	
+!concatene_capability_if_percent_not_zero(InCapabilities,Head,HeadPercent,OutCapabilities)
	:
		HeadPercent > 0
	&	Head=cap(Capability)
	<-
		OutCapabilities = [ cap(Capability,HeadPercent) | InCapabilities ];
	.
+!concatene_capability_if_percent_not_zero(InCapabilities,Head,HeadPercent,OutCapabilities)
	<-
		OutCapabilities = InCapabilities;
	.
	




+!check_if_goal_pack_is_satisfied_in_accumulation(Social,AgentGoalList,Accumulation,GoalPackSatisfied)
	<-
		!check_if_goal_is_satisfied_in_accumulation(Social,Accumulation,SocialGoalSatisfied);
		//.println("social is ",SocialGoalSatisfied);
		
		
		if (SocialGoalSatisfied=1) {
			!unroll_agent_goals_to_check_if_satisfied_in_accumulation(AgentGoalList,Accumulation,AgentGoalsSatisfied);
			//.println("agents are ",SocialGoalSatisfied);
			GoalPackSatisfied = AgentGoalsSatisfied;

		} else {
			GoalPackSatisfied = false;
		}
	.

+!unroll_agent_goals_to_check_if_satisfied_in_accumulation(AgentGoalList,Accumulation,AgentGoalsSatisfied)
	:
		AgentGoalList=[]
	<-
		AgentGoalsSatisfied=true;
	.
+!unroll_agent_goals_to_check_if_satisfied_in_accumulation(AgentGoalList,Accumulation,AgentGoalsSatisfied)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		!check_if_goal_is_satisfied_in_accumulation(Head,Accumulation,HeadSatisfied);
		
		if (HeadSatisfied=1) {
			!unroll_agent_goals_to_check_if_satisfied_in_accumulation(Tail,Accumulation,AgentGoalsSatisfied);
		} else {
			AgentGoalsSatisfied=false;
		}
	.

+!check_if_goal_is_satisfied_in_accumulation(Goal,Accu,Satisfied)
	:
		Goal = agent_goal(TC,FS,_) | Goal = social_goal(TC,FS,_) | Goal = agent_goal(TC,FS,_,_) | Goal = social_goal(TC,FS,_,_)
	<-
		//.println("testing goal ",Goal," on ",Accu);
		!elaborate_condition_truth_percent(TC,Accu,TCPercent);
		//.println("TC ",TC," is ",TCPercent);
		!elaborate_condition_truth_percent(FS,Accu,FSPercent);
		//.println("FS ",FS," is ",FSPercent);

		Satisfied = TCPercent * FSPercent;
		//.println("goals is ",Satisfied);
	.





+!elaborate_condition_truth_percent(Condition,World,Percent)
	:
		Condition = condition(LogicFormula)
	<-
		!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent);
	. 
+!elaborate_condition_truth_percent(Condition,World,Percent)
	:
		Condition = par_condition(Variables,ParamLogicFormula)
	<-
		!deduct_assignments_from_world(World,Condition,[],AssignmentSet,_);
		!elaborate_parametric_condition_truth_percent(Condition,AssignmentSet,World,Percent);
	. 
+!elaborate_parametric_condition_truth_percent(PCN,AssignmentSet,World,Percent)
	:
		PCN = par_condition(Variables,ParamLogicFormula)
	<-
		!unroll_variables_to_check_bound(Variables,AssignmentSet,BoundBool);
		if (BoundBool=true) {
			!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula);
			!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent);			
		} else {
			Percent = 0;
		}		
	. 
+!debug_truth_percent_1 
	<-
		!elaborate_condition_truth_percent(
			condition( and([s1,neg(s6),or([s5,s7]) ]) ),
			world([s1,s4,s7]),
			Percent
		);
		.println(Percent);
	.
+!debug_truth_percent_2 
	<-
		!elaborate_condition_truth_percent(
			condition( and([s1,neg(s6),or([s5,s7]) ]) ),
			world([s4,s7]),
			Percent
		);
		.println(Percent);
	.
+!debug_truth_percent_3 
	<-
		!elaborate_condition_truth_percent(
			condition( and([s1,neg(s6),or([s5,s7]) ]) ),
			world([s4,s6]),
			Percent
		);
		.println(Percent);
	.
+!debug_truth_percent_4 
	<-
		!elaborate_condition_truth_percent(
			condition( or( [ and( [available(doc),classified(doc)]), incomplete(doc)]) ),
			world([available(doc),classified(doc)]),
			Percent
		);
		.println(Percent);
	.


+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = and(Operands) | LogicFormula = or(Operands)
	<-
		//.println(LogicFormula,World,Percent);
		!elaborate_truth_percent_logic_and(Operands,World,PercentList);
		!calculate_average(PercentList,Percent);
	.
/* +!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = or(Operands)
	<-
		!elaborate_truth_percent_logic_or(Operands,World,PercentList);
		.max(PercentList,Percent);
	.*/
+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = neg(NegLogicFormula)
	<-
		!elaborate_logic_formula_truth_percent(NegLogicFormula,World,NegPercent);
		!invert_percent(NegPercent,Percent);
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = true
	<-
		Percent = 1;
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = false
	<-
		Percent = 0;
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = Statement
	&	World = world( StateOfWorld )
	&	.member(Statement,StateOfWorld)
	<-
		Percent = 1;
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,StateOfWorld,Percent)
	:
		LogicFormula = Statement
	&	.list(StateOfWorld)
	&	.member(Statement,StateOfWorld)	
	<-
		Percent = 1;
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,StateOfWorld,Percent)
	<-
		Percent = 0;
	.

+!elaborate_truth_percent_logic_and(Operands,World,PercentList)
	:
		Operands=[]
	<-
		PercentList = [];
	.
+!elaborate_truth_percent_logic_and(Operands,World,PercentList)
	:
		Operands=[ Head | Tail ]
	<-
		!elaborate_logic_formula_truth_percent(Head,World,HeadPercent);
		!elaborate_truth_percent_logic_and(Tail,World,TailPercentList);
		
		PercentList=[HeadPercent | TailPercentList];
	.
	
+!elaborate_truth_percent_logic_or(Operands,World,PercentList)
	:
		Operands=[]
	<-
		PercentList = [];
	.
+!elaborate_truth_percent_logic_or(Operands,World,PercentList)
	:
		Operands=[ Head | Tail ]
	<-
		!elaborate_logic_formula_truth_percent(Head,World,HeadPercent);
		!elaborate_truth_percent_logic_or(Tail,World,TailPercentList);
		
		PercentList=[HeadPercent | TailPercentList];
	.
		