+!unroll_norms_to_evaluate_state(Norms,CS,Evo,NormCompliance)
	:
		Norms=[]
	<-
		NormCompliance=true
	.
+!unroll_norms_to_evaluate_state(Norms,CS,Evo,NormCompliance)
	:
		Norms=[ Head | Tail ]
	<-
		!norm(Head,CS,Evo,HeadComp);
		if (HeadComp==true) {
			!unroll_norms_to_evaluate_state(Tail,CS,Evo,NormCompliance);
		} else {
			//.println("violated ",Head);
			NormCompliance=false;
		}
	.


+!unroll_agent_goals_to_check_maintain_norm(AgentGoalList,Evo,NormMaintain)
	:
		AgentGoalList=[]
	<-
		NormMaintain=true;
	.
+!unroll_agent_goals_to_check_maintain_norm(AgentGoalList,Evo,NormMaintain)
	:
		AgentGoalList=[ Head | Tail ]
	&	Head = agent_goal(_,FS,_,GoalType)
	&	GoalType = maintain
	<-
		
		//.println("evaluating:",Head);
		
		.length(Evo,Cardinality);
		.reverse(Evo,RevEvo);
		RevEvo = [ Wk | Tail2 ];
		Tail2 = [ Wprev | Tail3 ];
		!test_goal_maintain(FS,Cardinality,Wprev,Wk,Bool);
		if (Bool=true) {
			!unroll_agent_goals_to_check_maintain_norm(Tail,Evo,NormMaintain)
		} else {
			NormMaintain = false;
		}
		
	.
+!unroll_agent_goals_to_check_maintain_norm(AgentGoalList,Evo,NormMaintain)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		!unroll_agent_goals_to_check_maintain_norm(Tail,Evo,NormMaintain)
	.
+!debug_unroll_agent_goals_to_check_maintain_norm <- !unroll_agent_goals_to_check_maintain_norm(
	[agent_goal(condition(true),condition(visited(palermo,2)),system)],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([being_at(palermo),visited(palermo,2),it_is(dt(2014,2,16,8,30,00))]),
		world([being_at(palermo),visited(palermo,3),it_is(dt(2014,2,16,8,30,00))])
	],
	NormMaintain
); .println(NormMaintain).
+!debug_unroll_agent_goals_to_check_maintain_norm_2 <- !unroll_agent_goals_to_check_maintain_norm(
	[agent_goal(condition(true),condition(visited(palermo,2)),system)],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([being_at(palermo),visited(palermo,2),it_is(dt(2014,2,16,8,30,00))]),
		world([being_at(palermo),visited(palermo,3),it_is(dt(2014,2,16,8,30,00))])
	],
	NormMaintain
); .println(NormMaintain).

