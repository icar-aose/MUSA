/**************************
 * @Author: Davide Guastella
 * Description: Plans for handling goals annotation. Currently is unused.
 * 
 * Last Modifies:  
 *
 * TODO (davide):
 *
 * Bugs:  
 *
 **************************/
 
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS)
	<-
		?agent_goal(TC,FS)[goal(G),pack(P),parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS)[goal(G),pack(P),parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS)
	<-
		?agent_goal(TC,FS)[pack(P),parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS)[pack(P),parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS)
	<-
		?agent_goal(TC,FS)[goal(G),pack(P)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS)[goal(G),pack(P)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS)
	<-
		?agent_goal(TC,FS)[parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS)[parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS)
	<-
		?agent_goal(TC,FS)[goal(G)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS)[goal(G)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS)
	<-
		?agent_goal(TC,FS)[pack(P)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS)[pack(P)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A)
	<-
		?agent_goal(TC,FS,A)[goal(G),pack(P),parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A)[goal(G),pack(P),parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A)
	<-
		?agent_goal(TC,FS,A)[pack(P),parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A)[pack(P),parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A)
	<-
		?agent_goal(TC,FS,A)[goal(G),pack(P),parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A)[goal(G),pack(P),parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A)
	<-
		?agent_goal(TC,FS,A)[goal(G),pack(P)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A)[goal(G),pack(P)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A)
	<-
		?agent_goal(TC,FS,A)[parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A)[parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A)
	<-
		?agent_goal(TC,FS,A)[goal(G)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A)[goal(G)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A)
	<-
		?agent_goal(TC,FS,A)[pack(P)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A)[pack(P)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A,T)
	<-
		?agent_goal(TC,FS,A,T)[goal(G),pack(P),parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A,T)[goal(G),pack(P),parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A,T)
	<-
		?agent_goal(TC,FS,A,T)[pack(P),parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A,T)[pack(P),parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A,T)
	<-
		?agent_goal(TC,FS,A,T)[goal(G),pack(P),parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A,T)[goal(G),pack(P),parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A,T)
	<-
		?agent_goal(TC,FS,A,T)[goal(G),pack(P)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A,T)[goal(G),pack(P)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A,T)
	<-
		?agent_goal(TC,FS,A,T)[parlist(PAR)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A,T)[parlist(PAR)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A,T)
	<-
		?agent_goal(TC,FS,A,T)[goal(G)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A,T)[goal(G)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.
+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	:
		AgentGoals = [Head|Tail] &	Head = agent_goal(TC,FS,A,T)
	<-
		?agent_goal(TC,FS,A,T)[pack(P)];
		!assign_annotations(Tail,AgentGoalsWannotationsRec);
		.union([agent_goal(TC,FS,A,T)[pack(P)]], AgentGoalsWannotationsRec, AgentGoalsWannotations);
	.




+!assign_annotations(AgentGoals,AgentGoalsWannotations)
	<-
		AgentGoalsWannotations = [];
	.



