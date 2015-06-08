/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: plans for testing goal fulfillement during state exploration
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * 
 *
 * TODOs:
 * 
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/

/**
 * Esempio di SG:
 * social_goal( condition(  received_emergency_notification(location, worker_operator) ), 
 * 				condition( done(secure_artworks) ), 
 * 				[firefighter,system] ) [pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])]
 */
 
//{ include("core/goal_annotation.asl") }  
 
 
+!debug_build_goal_pack
	<-
		+social_goal( condition(  received_emergency_notification(location, worker_operator) ), condition( done(secure_artworks) ), [firefighter,system] )[goalfused(process0),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])];
		+agent_goal( condition( received_emergency_notification(location, worker_operator) ), condition( move(worker_operator, location) ), [firefighter]) [goal(g0),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])];
		+agent_goal( condition( and([done(secure_injured), done(assess_explosion_hazard), done(assess_fire_hazard)])), condition( done(evacuation) ), [firefighter])[goal(g4),pack(p1),parlist([])];
		+agent_goal( condition( and([move(worker_operator, location), injured(person)]) ), condition( done(secure_injured) ), [firefighter])[goal(g1),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])];
		+agent_goal( condition( move(worker_operator, location)), condition( done(assess_explosion_hazard) ), [firefighter])[goal(g2),pack(p1),parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])];
		+agent_goal( condition( move(worker_operator, location)), condition( done(assess_fire_hazard) ), [firefighter])[goal(g3),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])];
		
		+agent_goal( condition( done(evacuation)), condition( done(delimit_dangerous_area) ), [firefighter])[goalfused(g5),pack(p1),parlist([])];
		+agent_goal( condition( done(delimit_dangerous_area)), condition( done(prepare_medical_area) ), [firefighter])[goal(g6),pack(p1),parlist([])];
		+agent_goal( condition( done(prepare_medical_area)), condition( done(fire_extinguished) ), [firefighter])[goal(g7),pack(p1),parlist([])];
		+agent_goal( condition( done(fire_extinguished)), condition( done(secure_artworks)), [firefighter])[goal(g8),pack(p1),parlist([])];
		
		!build_goal_pack(p1,OutPack);
		
		.print("Output goal pack:\n",OutPack);
	.

+!build_goal_pack(SGName,Pack)
	<-
		?social_goal(STC,SFS,As)[goal(SG_ID),pack(SGName),parlist(SGpar)];
		SG=social_goal(STC,SFS,As)[goal(SG_ID),pack(SGName),parlist(SGpar)];
		
		.findall(MT,agent_metric(MT)[pack(SGName)],Metrics);
		.findall(agent_goal(TC1,FS1,A1), agent_goal(TC1,FS1,A1), AgentGoals);		
		
		!assign_annotations(AgentGoals,AgentGoalsWannotations);
		Pack=pack(SG,AgentGoalsWannotations,[],Metrics);
	.
//QUESTO È NUOVO
-!build_goal_pack(SGName,Pack)
	<-
		?social_goal(STC,SFS,As)[goalfused(SG_ID),pack(SGName),parlist(SGpar)];
		SG=social_goal(STC,SFS,As)[goalfused(SG_ID),pack(SGName),parlist(SGpar)];
		
		.findall(MT,agent_metric(MT)[pack(SGName)],Metrics);
		.findall(agent_goal(TC1,FS1,A1),agent_goal(TC1,FS1,A1),			AgentGoals);		
		
		!assign_annotations(AgentGoals,AgentGoalsWannotations);
		Pack=pack(SG,AgentGoalsWannotations,[],Metrics);
	.


	
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:	AgentGoals = []
	<-	AgentGoalsWannotations = [];
	.
	
//Agent goal
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] & Head = agent_goal(TC,FS,A)
	<-
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		
		//?agent_goal(TC,FS,A)[GoalID,Pack,PL];
		//?agent_goal(TC,FS,A)[goal(GoalID),pack(Pack),parlist(PL)];
		//.concat([agent_goal(TC,FS,A)[goal(GoalID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		
		?agent_goal(TC,FS,A)[Identifier,pack(Pack),parlist(PL)];
		
		if(Identifier=goal(ID))
		{
			.concat([agent_goal(TC,FS,A)[goal(ID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		}
		else
		{
			?agent_goal(TC,FS,A)[goalfused(GFusedID),_,_];
			.concat([agent_goal(TC,FS,A)[goalfused(GFusedID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		}
		
	.
	
//Agent goal
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A,T)
	<-
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		
		//?agent_goal(TC,FS,A,T)[goal(GoalID),pack(Pack),parlist(PL)];
		//.concat([agent_goal(TC,FS,A,T)[goal(GoalID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		?agent_goal(TC,FS,A,T)[Identifier,pack(Pack),parlist(PL)];
		
		if(Identifier=goal(ID))
		{
			.concat([agent_goal(TC,FS,A,T)[goal(ID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		}
		else
		{
			?agent_goal(TC,FS,A,T)[goalfused(GFusedID),_,_];
			.concat([agent_goal(TC,FS,A,T)[goalfused(GFusedID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		}
		/*
		?agent_goal(TC,FS,A,T)[goal(GoalID),pack(Pack),parlist(PL)];
		
		//.findall(agent_goal(TC,FS,A,T)[Pack,Pars], agent_goal(TC,FS,A,T)[Pack,Pars], [G|_]);
		!deleteSourceAnnotation(agent_goal(TC,FS,A,T)[Pack,Pars],OutG);
		.concat([OutG],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		*/
	.
	
	
	
//Social goal
+!assign_annotations(AgentGoals,SocialGoalsWannotations)
	:
		AgentGoals = [Head|Tail] & Head = social_goal(TC,FS,A)
	<-	
		!assign_annotations(Tail,SocialGoalsWannotationsRec);
		//?social_goal(TC,FS,A)[goal(GoalID),pack(Pack),parlist(PL)];
		//.concat([social_goal(TC,FS,A)[goal(GoalID),pack(Pack),parlist(PL)]],SocialGoalsWannotationsRec,SocialGoalsWannotations);
		
		?social_goal(TC,FS,A)[Identifier,pack(Pack),parlist(PL)];
		
		if(Identifier=goal(ID))
		{
			.concat([social_goal(TC,FS,A)[goal(ID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		}
		else
		{
			?social_goal(TC,FS,A)[goalfused(GFusedID),_,_];
			.concat([social_goal(TC,FS,A)[goalfused(GFusedID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		}
		
		
		//.findall(social_goal(TC,FS,A)[Pack,Pars], social_goal(TC,FS,A)[Pack,Pars], [G|_]);
		//!deleteSourceAnnotation(social_goal(TC,FS,A)[Pack,Pars],OutG);
		//.concat([OutG],AgentGoalsWannotationsRec,AgentGoalsWannotations);
	.
	

//Social goal
+!assign_annotations(AgentGoals,SocialGoalsWannotations)
	:
		AgentGoals = [Head|Tail] & Head = social_goal(TC,FS,A,T)
	<-
		!assign_annotations(Tail,SocialGoalsWannotationsRec);
		//?social_goal(TC,FS,A,T)[goal(GoalID),pack(Pack),parlist(PL)];
		//.concat([social_goal(TC,FS,A,T)[goal(GoalID),pack(Pack),parlist(PL)]],SocialGoalsWannotationsRec,SocialGoalsWannotations);
		?social_goal(TC,FS,A,T)[Identifier,pack(Pack),parlist(PL)];
		
		if(Identifier=goal(ID))
		{
			.concat([social_goal(TC,FS,A,T)[goal(ID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		}
		else
		{
			?social_goal(TC,FS,A,T)[goalfused(GFusedID),_,_];
			.concat([social_goal(TC,FS,A,T)[goalfused(GFusedID),pack(Pack),parlist(PL)]],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		}
		/*!assign_annotations(Tail,AgentGoalsWannotationsRec);
		?social_goal(TC,FS,A,T)[GoalID,Pack,Pars];
		//.findall(social_goal(TC,FS,A,T)[Pack,Pars], social_goal(TC,FS,A,T)[Pack,Pars], [G|_]);
		!deleteSourceAnnotation(social_goal(TC,FS,A,T)[Pack,Pars],OutG);
		.print("fatto");
		.concat([OutG],AgentGoalsWannotationsRec,AgentGoalsWannotations);
		*/
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



