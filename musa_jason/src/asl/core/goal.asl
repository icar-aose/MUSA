/******************************************************************************
 * @Author: 
 * 	- Davide Guastella
 * 
 * Description: plans for goals
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

//DA RIMUOVERE
+!get_goal(Goal, TC, FS, ParList)
	<-
		!get_goal_TC([Goal],[TC|_]);
		!get_goal_FS([Goal],[FS|_]);
		!get_goal_Pars([Goal],ParList);
	.
//----


+!get_goal_Identifier(GoalsList, IDOut)
	:
		GoalsList = [Goal|Tail] &	
	   (Goal = agent_goal(_,_,_)[goal(ID),_] 					| Goal = social_goal(_,_,_)[goal(ID),_] 			|	
		Goal = agent_goal(_,_,_,_)[goal(ID),_] 					| Goal = social_goal(_,_,_,_)[goal(ID),_]			|
		Goal = agent_goal(_,_,_)[goal(ID),_,_] 					| Goal = social_goal(_,_,_)[goal(ID),_,_] 			|	
		Goal = agent_goal(_,_,_,_)[goal(ID),_,_] 				| Goal = social_goal(_,_,_,_)[goal(ID),_,_])
	<-
		!get_goal_Identifier(Tail, IDOutRec);
		.concat(ID, IDOutRec, IDOut);
	.
+!get_goal_Identifier(GoalsList, IDOut)
	<-	IDOut = []
	.

/**
 * [davide]
 * 
 * DEBUG PLAN FOR +!get_goal_pars_from_task
 */
+!debug_get_goal_pars_from_task
	<-
		GoalList = [agent_goal( condition(done(billing_uploaded)), condition(done(fulfill_order)), system )[goal(g5),pack(p4),parlist([])],
					agent_goal( condition(and([done(order_checked), order_status(refused)])), condition(notify_order_unfeasibility(message)), system )[goal(g6),pack(p4),parlist([par(message,"ORDER_REFUSED")])]];
		
		TC = condition(and([done(order_checked), order_status(refused)]));
		FS = condition(notify_order_unfeasibility(message));
		
		!get_goal_pars_from_task(TC, FS, GoalList, OutGoal, ParList);
		.print("OutGoal: ",OutGoal);
		.print("ParList: ",ParList);
	.

/**
 * [davide]
 * 
 * Return the parameters of a goal whose conditions match the given TC and FS.
 */
+!get_goal_pars_from_task(TC, FS, GoalList, OutGoal, ParList)
	:
		GoalList = [Head|Tail]		
	<-
		!get_goal_TC([Head],[GoalTC|_]);
		!get_goal_FS([Head],[GoalFS|_]);
	
		if(TC=GoalTC & FS=GoalFS)
		{
			!get_goal_Pars([Head],ParList);	
			OutGoal = Head;
		}
		else
		{
			!get_goal_pars_from_task(TC, FS, Tail, OutGoal, ParList);
		}
	.
+!get_goal_pars_from_task(TaskTC, TaskFS, GoalList, OutGoal, ParList)
	:	GoalList 	= []
	<-	ParList 	= [];
	.

+!get_goal_Pars(GoalsList, ParsOut)
	:
		GoalsList = [Goal|Tail] &
		(Goal = agent_goal(_,_,_)[parlist(Pars)] 								| Goal = social_goal(_,_,_)[parlist(Pars)] 								|
		 Goal = agent_goal(_,_,_,_)[parlist(Pars)] 								| Goal = social_goal(_,_,_,_)[parlist(Pars)] 							|
		 Goal = agent_goal(_,_,_)[pack(Pack),parlist(Pars)] 					| Goal = social_goal(_,_,_)[pack(Pack),parlist(Pars)] 					|
		 Goal = agent_goal(_,_,_,_)[pack(Pack),parlist(Pars)] 					| Goal = social_goal(_,_,_,_)[pack(Pack),parlist(Pars)]					|
		 Goal = agent_goal(_,_,_)[goal(G),pack(Pack),parlist(Pars)] 			| Goal = social_goal(_,_,_)[goal(G),pack(Pack),parlist(Pars)] 			|
		 Goal = agent_goal(_,_,_,_)[goal(G),pack(Pack),parlist(Pars)] 			| Goal = social_goal(_,_,_,_)[goal(G),pack(Pack),parlist(Pars)]			|
		 Goal = agent_goal(_,_,_)[goalfused(G),pack(Pack),parlist(Pars)] 		| Goal = social_goal(_,_,_)[goalfused(G),pack(Pack),parlist(Pars)] 		|
		 Goal = agent_goal(_,_,_,_)[goalfused(G),pack(Pack),parlist(Pars)] 		| Goal = social_goal(_,_,_,_)[goalfused(G),pack(Pack),parlist(Pars)])
	<-
		!get_goal_Pars(Tail, Pars_rec);
		.concat(Pars, Pars_rec, ParsOut);
	.
+!get_goal_Pars(GoalsList, ParsOut)
	:	GoalsList 	= []
	<-	ParsOut 	= []
	.
	
/**
 * [davide]
 * Retrieve the trigger condition from a agent/social goal.
 */	
+!get_goal_TC(GoalsList, TC_list)
	:	GoalsList 	= []
	<-	TC_list 	= [];
	.
+!get_goal_TC(GoalsList, TC_list)
	:
		GoalsList = [Goal|Tail] &
	   (Goal = agent_goal(TC,_,_) 											| Goal = social_goal(TC,_,_) 							| Goal = agent_goal(TC,_,_,_) 	| 
		Goal = agent_goal(TC,_,_)[parlist(_)] 								| Goal = social_goal(TC,_,_)[parlist(_)] 				| Goal = social_goal(TC,_,_,_) 	|
		Goal = agent_goal(TC,_,_,_)[parlist(_)] 							| Goal = social_goal(TC,_,_,_)[parlist(_)] 				|
		Goal = agent_goal(TC,_,_)[pack(Pack),parlist(_)] 					| Goal = social_goal(TC,_,_)[pack(Pack),parlist(_)] 	|
		Goal = agent_goal(TC,_,_,_)[pack(Pack),parlist(_)] 					| Goal = social_goal(TC,_,_,_)[pack(Pack),parlist(_)]	|
		Goal = agent_goal(TC,_,_)[goal(G),pack(Pack),parlist(_)] 			| Goal = social_goal(TC,_,_)[goal(G),pack(Pack),parlist(_)] 	|
		Goal = agent_goal(TC,_,_,_)[goal(G),pack(Pack),parlist(_)] 			| Goal = social_goal(TC,_,_,_)[goal(G),pack(Pack),parlist(_)]	|
		Goal = agent_goal(TC,_,_)[goalfused(G),pack(Pack),parlist(_)] 		| Goal = social_goal(TC,_,_)[goalfused(G),pack(Pack),parlist(_)] 	|
		Goal = agent_goal(TC,_,_,_)[goalfused(G),pack(Pack),parlist(_)] 	| Goal = social_goal(TC,_,_,_)[goalfused(G),pack(Pack),parlist(_)])
	<-
		!get_goal_TC(Tail, TC_rec);
		.concat([TC], TC_rec, TC_list);
	.

/**
 * [davide]
 * Retrieve the trigger condition from a agent or social goal.
 */	
+!get_goal_FS(GoalsList, FS_list)
	:	GoalsList 	= []
	<-	FS_list 	= [];
	.
+!get_goal_FS(GoalsList, FS_list)
	:
		GoalsList = [Goal|Tail] &
	   (Goal = agent_goal(_,FS,_) 											| Goal = social_goal(_,FS,_) 							| Goal = agent_goal(_,FS,_,_) 	| 
		Goal = agent_goal(_,FS,_)[parlist(_)] 								| Goal = social_goal(_,FS,_)[parlist(_)] 				| Goal = social_goal(_,FS,_,_) 	|
		Goal = agent_goal(_,FS,_,_)[parlist(_)] 							| Goal = social_goal(_,FS,_,_)[parlist(_)]				|
		Goal = agent_goal(_,FS,_)[_,pack(Pack),parlist(_)] 					| Goal = social_goal(_,FS,_)[pack(Pack),parlist(_)] 	|
		Goal = agent_goal(_,FS,_,_)[_,pack(Pack),parlist(_)] 				| Goal = social_goal(_,FS,_,_)[pack(Pack),parlist(_)]	|
		Goal = agent_goal(_,FS,_)[goal(G),pack(Pack),parlist(_)] 			| Goal = social_goal(_,FS,_)[goal(G),pack(Pack),parlist(_)] 	|
		Goal = agent_goal(_,FS,_,_)[goal(G),pack(Pack),parlist(_)] 			| Goal = social_goal(_,FS,_,_)[goal(G),pack(Pack),parlist(_)]	|
		Goal = agent_goal(_,FS,_)[goalfused(G),pack(Pack),parlist(_)] 		| Goal = social_goal(_,FS,_)[goalfused(G),pack(Pack),parlist(_)] 	|
		Goal = agent_goal(_,FS,_,_)[goalfused(G),pack(Pack),parlist(_)] 	| Goal = social_goal(_,FS,_,_)[goalfused(G),pack(Pack),parlist(_)])
	<-
		!get_goal_FS(Tail, FS_rec);
		.concat([FS], FS_rec, FS_list);
	.

+!get_goal_Pack(GoalsList, PackOut)
	:
		GoalsList = [Goal|Tail] &
	   (Goal = agent_goal(_,_,_)[pack(Pack),parlist(_)] 					| Goal = social_goal(_,_,_)[pack(Pack),parlist(_)] 	|
		Goal = agent_goal(_,_,_,_)[pack(Pack),parlist(_)] 					| Goal = social_goal(_,_,_,_)[pack(Pack),parlist(_)]	|
		Goal = agent_goal(_,_,_)[goal(G),pack(Pack),parlist(_)] 			| Goal = social_goal(_,_,_)[goal(G),pack(Pack),parlist(_)] 	|
		Goal = agent_goal(_,_,_,_)[goal(G),pack(Pack),parlist(_)] 			| Goal = social_goal(_,_,_,_)[goal(G),pack(Pack),parlist(_)]	|
		Goal = agent_goal(TC,_,_)[goalfused(G),pack(Pack),parlist(_)] 		| Goal = social_goal(TC,_,_)[goalfused(G),pack(Pack),parlist(_)] 	|
		Goal = agent_goal(TC,_,_,_)[goalfused(G),pack(Pack),parlist(_)] 	| Goal = social_goal(TC,_,_,_)[goalfused(G),pack(Pack),parlist(_)])
	<-
		!get_goal_Pack(Tail, PackRec);
		.concat(Pack, PackRec, PackOut);
	.
+!get_goal_Pack(GoalsList, Pack)
	<-	Pack = []
	.


/**
 * [davide]
 * Plans for converting an agent goal to a social goal.
 */
 +!get_social_goal_from_agent_goal(Goal,SG)
	: 	Goal 	= agent_goal(TC,FS,Mem)[goal(G),pack(Pack),parlist(PL)]
	<-	SG 		= social_goal(TC,FS,Mem)[goal(G),pack(Pack),parlist(PL)];
	.
+!get_social_goal_from_agent_goal(Goal,SG)
	: 	Goal 	= agent_goal(TC,FS,Mem)[goalfused(G),pack(Pack),parlist(PL)]
	<-	SG 		= social_goal(TC,FS,Mem)[goalfused(G),pack(Pack),parlist(PL)];
	.
+!get_social_goal_from_agent_goal(Goal,SG)
	: 	Goal 	= agent_goal(TC,FS,Mem,T)[goal(G),pack(Pack),parlist(PL)]
	<-	SG 		= social_goal(TC,FS,Mem,T)[goal(G),pack(Pack),parlist(PL)];
	.
+!get_social_goal_from_agent_goal(Goal,SG)
	: 	Goal 	= agent_goal(TC,FS,Mem,T)[goalfused(G),pack(Pack),parlist(PL)]
	<-	SG 		= social_goal(TC,FS,Mem,T)[goalfused(G),pack(Pack),parlist(PL)];
	.

 +!get_agent_goal_from_social_goal(Goal,AG)
	: 	Goal 	= social_goal(TC,FS,Mem)[goal(G),pack(Pack),parlist(PL)]
	<-	AG 		= agent_goal(TC,FS,Mem)[goal(G),pack(Pack),parlist(PL)];
	.
+!get_agent_goal_from_social_goal(Goal,AG)
	: 	Goal 	= social_goal(TC,FS,Mem)[goalfused(G),pack(Pack),parlist(PL)]
	<-	AG 		= agent_goal(TC,FS,Mem)[goalfused(G),pack(Pack),parlist(PL)];
	.

+!get_agent_goal_from_social_goal(Goal,AG)
	: 	Goal 	= social_goal(TC,FS,Mem,T)[goal(G),pack(Pack),parlist(PL)]
	<-	AG 		= agent_goal(TC,FS,Mem,T)[goal(G),pack(Pack),parlist(PL)];
	.
+!get_agent_goal_from_social_goal(Goal,AG)
	: 	Goal 	= social_goal(TC,FS,Mem,T)[goalfused(G),pack(Pack),parlist(PL)]
	<-	AG 		= agent_goal(TC,FS,Mem,T)[goalfused(G),pack(Pack),parlist(PL)];
	. 
	
 /*
 * [davide]
 * 
 * Given a goal paramater list, i.e.
 * 
 * parlist([par(Var1,Val1), par(Var2,Val2), par(Var3,Val3)])
 * 
 * return the corresponding list of assignment, that is
 * 
 * [assignment(Var1,Val1), assignment(Var2,Val2), assignment(Var3,Val3)] 
 *  
 */
+!get_assignment_from_par_list(ParList, AssignmentList)
	:
		ParList = parlist(Pars) &
		(not .ground(Pars) | .empty(Pars)) 	
 	<-
 		AssignmentList = [];
 	.
+!get_assignment_from_par_list(ParList, AssignmentList)
	:	
		ParList = parlist(Pars)
 	<-	
 		!get_assignment_from_par_list(Pars, AssignmentList)
 	.
+!get_assignment_from_par_list(ParList, AssignmentList)
	:	
		ParList = [Head|Tail] 	&
		Head 	= par(Var,Val)
	<-	
		!get_assignment_from_par_list(Tail, AssignmentListRec);
		.union(AssignmentListRec,[assignment(Var,Val)],AssignmentList);
	.
+!get_assignment_from_par_list(ParList, AssignmentList)
	:	ParList = []
	<-	AssignmentList = []
	.
