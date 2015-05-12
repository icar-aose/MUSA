+!build_goal_pack(SGName,Pack)
	<-
		?social_goal(STC,SFS,As)[pack(SGName)];
		.findall(agent_goal(TC1,FS1,A1),agent_goal(TC1,FS1,A1)[pack(SGName)],AgentGoals1);
		.findall(agent_goal(TC2,FS2,A2,T),agent_goal(TC2,FS2,A2,T)[pack(SGName)],AgentGoals2);
		.findall(MT,agent_metric(MT)[pack(SGName)],Metrics);
		.concat(AgentGoals1,AgentGoals2,AgentGoals);
		
		Pack=pack(social_goal(STC,SFS,As),AgentGoals,[],Metrics);
	.


+!test_goal_maintain(FinalState,Cardinality,Wprev,Wk,Bool)
	:
		Cardinality > 1
	<-	
			!test_condition(FinalState,Wprev,GoalWasSatisfied);
			
			if (GoalWasSatisfied=true) {
				!test_condition(FinalState,Wk,GoalIsStillSatisfied);
				
				Bool = GoalIsStillSatisfied;

			} else {
				Bool = true;
			}
	.
+!test_goal_maintain(FinalState,Cardinality,Wprev,Wk,Bool)
	<-	
		Bool = true
	.


+!check_if_goal_pack_is_satisfied_in_evolution(Social,AgentGoalList,Evo,GoalPackSatisfied)
	<-
		!check_if_social_goal_is_satisfied_in_evolution(Social,Evo,SocialGoalSatisfied);
		if (SocialGoalSatisfied=true) {
			!unroll_agent_goals_to_check_if_satisfied_in_evolution(AgentGoalList,Evo,AgentGoalsSatisfied);
			GoalPackSatisfied = AgentGoalsSatisfied;

		} else {
			GoalPackSatisfied = false;
		}
	.
/* OK */
+!debug_check_if_goal_pack_is_satisfied_in_evolution <- !check_if_goal_pack_is_satisfied_in_evolution(
	social_goal(condition(and([s1,s4])),condition(and([s2,s6])),[system,luca]),
	[agent_goal(condition(and([s1,s7])),condition(and([s1,s5])),system), agent_goal(condition(s5),condition(and([s2,s6])),system)],
	[world([s1,s4,s7]),world([s1,s5,s8]),world([s2,s6,s9])],
	GoalPackSatisfied
); .println(GoalPackSatisfied); .
	


+!check_if_social_goal_is_satisfied_in_evolution(Social,Evo,SocialGoalSatisfied)
	<-
		Evo = [ WI | Tail1 ];
		!get_last_element_from_list(Evo,Wk);
		
		!check_if_goal_is_satisfied(Social,WI,Wk,SocialGoalSatisfied);
	.
+!debug_check_if_social_goal_is_satisfied_in_evolution <- !check_if_social_goal_is_satisfied_in_evolution(
	social_goal(condition(and([s1,or([s2,s4])])),condition(and([s2,s6])),[system,luca]),
	[world([s1,s4,s7]),world([s1,s5,s8]),world([s2,s6,s9])],
	GoalSatisfied
); .println(GoalSatisfied); .
+!debug_check_if_social_goal_is_satisfied_in_evolution_1 <- !check_if_social_goal_is_satisfied_in_evolution(
	social_goal(
			condition(being_at(palermo)),
			par_condition([datetime],
				and([being_at(catania),property(it_is,[datetime]),data_is(datetime,date(2014,2,22))])
			),[system,luca]
		),
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,0))]),
		world([being_at(catania),cost(384.55),it_is(dt(2014,2,22,9,57,0)),visited(agrigento,1),visited(catania,0.5),visited(palermo,2),visited(siracusa,1)])
	],
	SocialGoalSatisfied
); .println(SocialGoalSatisfied);.


+!unroll_agent_goals_to_check_if_satisfied_in_evolution(AgentGoalList,Evo,AgentGoalsSatisfied)
	:
		AgentGoalList=[]
	<-
		AgentGoalsSatisfied=true;
	.
+!unroll_agent_goals_to_check_if_satisfied_in_evolution(AgentGoalList,Evo,AgentGoalsSatisfied)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		!test_conditions_in_evolution(Head,Evo,HeadSatisfied);
		
		if (HeadSatisfied=true) {
			!unroll_agent_goals_to_check_if_satisfied_in_evolution(Tail,Evo,AgentGoalsSatisfied);
		
		} else {
			AgentGoalsSatisfied=false;
		}
	.



+!unroll_agent_goals_to_count_how_many_satisfied_in_evolution(AgentGoalList,Evo,Count)
	:
		AgentGoalList=[]
	<-
		Count=0;
	.
+!unroll_agent_goals_to_count_how_many_satisfied_in_evolution(AgentGoalList,Evo,Count)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		!test_conditions_in_evolution(Head,Evo,HeadSatisfied);
		
		!unroll_agent_goals_to_count_how_many_satisfied_in_evolution(Tail,Evo,TailCount);

		if (HeadSatisfied=true) {
			Count = TailCount+1;
		} else {
			Count = TailCount;
		}
	.




+!test_conditions_in_evolution(Goal,Evo,GoalSatisfied)
	:
		Goal = agent_goal(TC,FS,_,maintain) | Goal = social_goal(TC,FS,_,maintain)
	<-
		!unroll_evolution_until_condition_true(Evo,TC,RemainingEvo,TCSatisfied);
		if (TCSatisfied = true) {
			!unroll_evolution_until_condition_true(RemainingEvo,FS,_,FSSatisfied);
			GoalSatisfied = FSSatisfied;
		} else {
			
			GoalSatisfied = false;
		}
	.
+!test_conditions_in_evolution(Goal,Evo,GoalSatisfied)
	:
		Goal = agent_goal(TC,FS,_) | Goal = social_goal(TC,FS,_) | Goal = agent_goal(TC,FS,_,achieve) | Goal = social_goal(TC,FS,_,achieve)
	<-
		!unroll_evolution_to_check_states_satisfy_goal(Evo,TC,FS,GoalSatisfied);
	.


/* OK */
+!debug_test_conditions_in_evolution <- !test_conditions_in_evolution(
	agent_goal(condition(and([s1,or([s2,s4])])),condition(and([s2,s6])),system),
	[world([s1,s4,s7]),world([s1,s5,s8]),world([s2,s6,s9])],
	GoalSatisfied
); .println(GoalSatisfied); .
+!debug_test_conditions_in_evolution_1 <- !test_conditions_in_evolution(
	agent_goal(condition(true),condition(visited(palermo,2)),system,maintain),
	[world([being_at(palermo)]),world([visited(palermo,1)]),world([visited(palermo,2)])],
	GoalSatisfied
); .println(GoalSatisfied); .
+!debug_test_conditions_in_evolution_2 <- !test_conditions_in_evolution(
	agent_goal(
		par_condition([datetime],and([property(it_is,[datetime]),data_is(datetime,date(2014,2,20))])),
		condition(being_at(siracusa)),
		system
	),
	[world([it_is(dt(2014,2,20,9,25,0))]),world([it_is(dt(2014,2,20,9,25,0)),being_at(siracusa)]),world([visited(palermo,2)])],
	GoalSatisfied
); .println(GoalSatisfied); .
+!debug_test_conditions_in_evolution_3 <- !test_conditions_in_evolution(
	agent_goal(
		par_condition([datetime],and([property(it_is,[datetime]),data_is(datetime,date(2014,2,20))])),
		condition(being_at(siracusa)),
		system
	),
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,0))]),
		world([being_at(trapani),cost(8),it_is(dt(2014,2,16,14,250,0))])
	],
	GoalSatisfied
); .println(GoalSatisfied); .


+!unroll_evolution_until_condition_true(Evo,CN,SatTail,Satisfied)
	:
		Evo=[]
	<-
		SatTail=[];
		Satisfied=false;
	.
+!unroll_evolution_until_condition_true(Evo,CN,SatTail,Satisfied)
	:
		Evo=[ Head | Tail ]
	<-
		!test_condition(CN,Head,CNSatisfied);
		
		if (CNSatisfied=true) {
			Satisfied = true;
			SatTail = Tail;

		} else {
			!unroll_evolution_until_condition_true(Tail,CN,SatTail,Satisfied)
		}
	.

+!unroll_evolution_to_check_states_satisfy_goal(Evo,TC,FS,Satisfied)
	:
		Evo=[]
	<-
		Satisfied=false;
	.
+!unroll_evolution_to_check_states_satisfy_goal(Evo,TC,FS,Satisfied)
	:
		Evo=[ Head | Tail ]
	<-
		//.println("checking ",Head);
		!test_condition(TC,Head,TCSatisfied);
		//.println("TC ",TCSatisfied);
		if (TCSatisfied=true) {
			!test_condition(FS,Head,HeadSatisfied);
			//.println("FS ",HeadSatisfied);
		} else {
			HeadSatisfied = false;
		}
		
		if (HeadSatisfied=true) {
			Satisfied = true;
		} else {
			!unroll_evolution_to_check_states_satisfy_goal(Tail,TC,FS,Satisfied);
		}
	.



+!check_if_goal_is_satisfied(Goal,WI,Wk,GoalSatisfied)
	:
		Goal = agent_goal(TC,FS,_) | Goal = social_goal(TC,FS,_) | Goal = agent_goal(TC,FS,_,_) | Goal = social_goal(TC,FS,_,_)
	<-
		//.println("testing ",TC);
		!test_condition(TC,WI,TCBool);
		if (TCBool=true) {
		//.println("testing ",FS);
			!test_condition(FS,Wk,GoalSatisfied);
		} else {
			GoalSatisfied = false;
		}
	.

/* OK */
+!debug_check_if_goal_is_satisfied <- !check_if_goal_is_satisfied(
	agent_goal(condition(and([s1,or([s2,s4])])),condition(and([s1,s5])),system),
	world([s1,s4,s7]),
	world([s1,s5,s6]),
	GoalSatisfied
); .println(GoalSatisfied); .



