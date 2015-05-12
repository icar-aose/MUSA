{ include( "search/search_with_accumulation.asl" ) }
{ include( "search/conditions.asl" ) }
{ include( "search/system_goals.asl" ) }
{ include( "search/system_norms_metrics.asl" ) }
{ include( "search/agent_capabilities.asl" ) }
{ include( "search/utilities.asl" ) }


+!initialize_search(WI,Pack,OutSolutions)
	<-
		makeArtifact("stack","st.Stack",[],ArtifactID);
		
		//.println("WI: ",WI);
		.println("INITIALIZE SEARCH");
		
		Pack=pack(Social, GoalList, Norms, Metrics);
		.println("SG: ",Social);
		for ( .member(X,GoalList) ) {
			.println("Goal: ",X);
		}
		.println("Norms: ",Norms);
		.println("Metrics: ",Metrics);
		
		
		?search_max_depth(MaxDepth);
		?search_number_of_solutions(MaxSolution);
		
		!select_capabilities([WI],CPSet);
		!unroll_capabilities_to_update_stack_and_score(CPSet,item(cs([]),evo([WI]),0),Pack,MaxDepth);
		
		InitSolutions=[];
		
		.println("START SEARCH");
		
		!search(InitSolutions,MaxSolution,Pack,MaxDepth,0,OutSolutions);
		
		.println("END SEARCH");
		
		disposeArtifact(ArtifactID);
	.

+!search(InSolutions,MaxSolution,Pack,MaxDepth,Steps,OutSolutions)
	<-
		stackSize(Size);
		?search_number_of_steps(Max);
		
		if (Size>0 & Steps<Max ) {
			pickItem( Item );
			Item=item(cs(CS),evo(Evo),Score);
			
			!get_last_element_from_list(Evo,Wk);
			
			Pack=pack(Social,AgentGoalList,Norms,Metrics);
			!check_if_goal_pack_is_satisfied_in_evolution(Social,AgentGoalList,Evo,GoalPackSatisfied);
			
			if (GoalPackSatisfied=true) {
				if (.empty(InSolutions)) {
					-+first_solution(Steps);
				}
				NewSolutions = [ Item | InSolutions ];
				.length(NewSolutions,SolSize);
				.println("new solution! at step ",Steps,"  number of solutions: ",SolSize);
				
				if (MaxSolution > 1) {
					!search(NewSolutions,MaxSolution-1,Pack,MaxDepth,Steps+1,OutSolutions);
				
				} else {
					-+total_step(Steps);
					OutSolutions = NewSolutions;
				}
			
			} else {
				.length(CS,Len); 
				
				if (Len <= MaxDepth) {
					!select_capabilities(Evo,CPSet);
					
					!update_statistics(Len,CPSet,Size);
					
					/* 
					if (Steps/10 = math.floor(Steps/10)) {
						.length(CPSet,CPLen);
						!unroll_agent_goals_to_count_how_many_satisfied_in_evolution(AgentGoalList,Evo,NumberSatisfiedGoals);					
						.println("LOG: step ", Steps,": score (",Score,") depth {",Len,"} satisfied [",NumberSatisfiedGoals,"] branch=",CPLen," Stack Size:",Size);
					}*/
					!unroll_capabilities_to_update_stack_and_score(CPSet,Item,Pack,MaxDepth);	
				}
				
				!search(InSolutions,MaxSolution,Pack,MaxDepth,Steps+1,OutSolutions);
			}
		} else {
			OutSolutions = InSolutions;
		}
	.


+!update_statistics(Depth,CPSet,Size)
	<-
		?depth(PrevDepth);
		if (Depth > PrevDepth) { 
			-+depth(Depth);
		}
		
		.length(CPSet,Branch);
		?branch(BranchList);
		NewBranchList = [ Branch | BranchList];
		-+branch(NewBranchList);
		
		?size(SizeList);
		NewSizeList = [ Size | SizeList];
		-+size(NewSizeList);
		
	.


+!unroll_capabilities_to_update_stack_and_score(CPSet,Item,Pack,MaxDepth) : CPSet=[] <- true .
+!unroll_capabilities_to_update_stack_and_score(CPSet,Item,Pack,MaxDepth)
	:
		CPSet=[ Head | Tail ]
	<-
		Pack=pack(Social,AgentGoalList,Norms,Metrics);
		Item=item(cs(CSold),evo(EvoOld),ScoreOld);

		!get_capability_tx(Head,TX);		
		
		!get_last_element_from_list(EvoOld,Wk);
		!generate_new_world(Wk,TX,Wnext);

		.concat(CSold,[Head],CSnew);		
		.concat(EvoOld,[Wnext],EvoNew);
		
		!unroll_agent_goals_to_check_maintain_norm(AgentGoalList,EvoNew,NormMaintain);
		
		if (NormMaintain=true) {
			!unroll_norms_to_evaluate_state(Norms,CSnew,EvoNew,NormCompliance);
			
			if (NormCompliance=true) {
				!score_sequence(CSnew,EvoNew,Pack,MaxDepth,NewScore);
				
				//!log_capability(Head);
				//.println("generated: ",Wnext," with score ",NewScore);
				
				insertItem(cs(CSnew), evo(EvoNew), NewScore);
			}
		}
		
		/*
		if (NormMaintain=false) {
			.println("violated maintainance goal");
		}
		if (NormCompliance=false) {
			.println("norm compliance violated");
		}
		 */	
		!unroll_capabilities_to_update_stack_and_score(Tail,Item,Pack,MaxDepth);			
	.
/* OK */
+!debug_unroll_capabilities_to_update_stack_and_score <- !unroll_capabilities_to_update_stack_and_score(
	[flight,visit],
	[item(cs1,evo1,1),item(cs2,evo2,4),item(cs3,evo3,2)],
	item([taxi,train],[world([s0]),world([s2,s0]),world([s0,s1,s2])],3),
	social_goal(condition(and([s1,s4])),condition(and([s2,s6])),[system,luca]),
	[agent_goal(condition(and([s2,s0])),condition(and([s3,s4])),system), agent_goal(condition(s5),condition(and([s2,s6])),system)],
	20,
	NewStack
); .println(NewStack); .


+!score_sequence(CS,Evo,Pack,CSmaxlen,Score)
	<-
		Pack=pack(Social,AgentGoalList,Norms,Metrics);
		
		!unroll_agent_goals_to_count_how_many_satisfied_in_evolution(AgentGoalList,Evo,NumberSatisfiedGoals);
		!check_if_social_goal_is_satisfied_in_evolution(Social,Evo,SocialGoalSatisfied);
		
		if (SocialGoalSatisfied=true) {
			NumberGoals=NumberSatisfiedGoals+1;
		} else {
			NumberGoals=NumberSatisfiedGoals;
		}
		

		.length(CS,Cardinality);
		GoalScore=(0.1+NumberGoals)/(1 + math.log(Cardinality));
		
		//.println("");
		//.println("NumberGoals: ",NumberGoals," Cardinality: ",Cardinality);
		
		.length(Metrics,MSize);
		!unroll_metrics_to_calculate_domain_score(Metrics,1/MSize,CS,Evo,DomainScore);

		Score = (2*GoalScore)+DomainScore;
		
		//.println("GoalScore: ",NumberGoals," DomainScore: ",DomainScore," Score: ",Score);
		
	.
+!debug_score_sequence <- !score_sequence(
	[cap(visit),cap(visit),cap(hotel),cap(hotel),cap(train)],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([cost(70+70+12),being_at(cefalu),visited(palermo,2),it_is(dt(2014,2,18,10,30,00))])
	],
	pack(
		social_goal(condition(being_at(palermo)),condition(and([being_at(palermo),visited(palermo,2),visited(cefalu,1),it_is(dt(2014,2,19,15,00,00))])),[system,luca]),
		[
			agent_goal(condition(true),condition(visited(palermo,2)),system),
			agent_goal(condition(true),condition(visited(cefalu,1)),system)
		]
		,[]
		,[qos,cost]
	),
	CSmaxlen,
	Score
); .println(Score); .




+!unroll_metrics_to_calculate_domain_score(Metrics,Weight,CS,Evo,DomainScore)
	:
		Metrics=[]
	<-
		DomainScore=0;
	.
+!unroll_metrics_to_calculate_domain_score(Metrics,Weight,CS,Evo,DomainScore)
	:
		Metrics=[ Head | Tail ]
	<-
		!metric(Head,CS,Evo,HeadScore);
		!unroll_metrics_to_calculate_domain_score(Tail,Weight,CS,Evo,TailScore);
		DomainScore = (Weight*HeadScore) + TailScore;
	.
