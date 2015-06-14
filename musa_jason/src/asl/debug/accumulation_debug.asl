
//{ include("core/accumulation.asl") }

/**
 * [davide]
 * 
 * DEBUG PLAN for +!filter_capabilities_that_create_a_new_world_in_accumulation
 */
+!debug_filter_capabilities_that_create_a_new_world_in_accumulation
	<-
		IN	= [commitment(printer,print,0),commitment(printer,decide,10)];
		Acc	= accumulation(world([]),par_world([msg],[property(printed,[msg])]),a);
		
		!filter_capabilities_that_create_a_new_world_in_accumulation(IN,Acc,OutCapabilities);
		.print("Out cap: ",OutCapabilities);
	.
	
/**
 * [davide]
 * DEBUG PLAN for check_if_goal_pack_is_satisfied_in_accumulation
 */
+!debug_check_if_goal_pack_is_satisfied_in_accumulation
	<-
		SG = social_goal( condition(received(request)), condition(printed(bye)), system );
		AG_List = [ agent_goal( condition( two ) , condition(printed(again)), system )/*,
					agent_goal( condition( one ) , condition(printed(bye)), system )*/];
		
		Acc = accumulation(world([f(a)]), par_world([msg],[property(printed,[msg]), property(q,[p])]), a);
		
		!check_if_goal_pack_is_satisfied_in_accumulation(SG, AG_List, Acc, [assignment(msg,welcome)], GoalPackSatisfied, OutputAssignment);
		.print("Goal pack satisfied: ",GoalPackSatisfied);
		.print("Output assignment set: ",OutputAssignment);
		
	.
	
+!debug_check_if_goal_is_satisfied_in_accumulation
	<-
		Accumulation = accumulation(world([f(a)]), par_world([msg,welcome],[property(printed,[msg]), property(q,[p])]), a);
		Condition = condition(printed(welcome));
		!check_if_goal_is_satisfied_in_accumulation(Condition, Accumulation, [], OutAssignment, Satisfied, SatisfiedBool, Percent);
		
		.print("Satisfied: ",Satisfied," Percent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
	
/**
 * [davide]
 * 
 * DEBUG PLAN for !assemble_par_condition_from_accumulation
 */
+!debug_assemble_par_condition_from_accumulation
	<-
		Accumulation = accumulation(world([p(x)]), par_world([n,a], [property(p,[x,a]), property(q,[n,m])  ]),[]  );
		!assemble_par_condition_from_accumulation(Accumulation, Pa);
		.print("Accumulation: ",Accumulation);
		.print("PA: ",Pa);	
	.
	
+!debug_unroll_nested_condition
	<-
		!unroll_nested_condition(a(b(f(g))), OutStatement);
		.print("OutStatement: ",OutStatement);
	.
	
/**
  * DEBUG PLANS FOR check_if_par_condition_addresses_accumulation plan.
  */
+!debug_check_if_par_condition_addresses_accumulation_1
	<-
		CN		=	condition( printed(ciao) );
		Acc		=	accumulation(world([received(doc)]), par_world([],[property(printed,[msg])]), []);
		
		!check_if_par_condition_addresses_accumulation(CN, Acc, [], OutAssignment, Bool);
		.print("OUTPUT:",OutAssignment);
		.print("Bool: ",Bool);
	.
+!debug_check_if_par_condition_addresses_accumulation_2
	<-
		CN = condition(or([received(msg),printed(retry)]));
		Acc		=	accumulation(world([received(doc)]), par_world([msg],[property(printed,[msg])]), []);
		
		!check_if_par_condition_addresses_accumulation(CN, Acc, [], OutAssignment, Bool, H);
		.print("OUTPUT:",OutAssignment);
		.print("Bool: ",Bool);
	.

+!debug_check_if_par_condition_addresses_accumulation_3
	<-
	
		Accumulation 	 = accumulation(world([received(msg)]),par_world([],[property(uno,[a]),property(due,[b])]),assignment_list([]));
		Condition		 = condition(or([received(msg),printed(retry)]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], OutAssignment, Satisfied, Percent);
		
		.print("Satisfied: ",Satisfied," Percent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.

+!debug_check_if_par_condition_addresses_accumulation_4
	<-
	
		Accumulation = accumulation(world([received(msg)]),par_world([],[property(uno,[a]),property(due,[b])]),assignment_list([]));
		Condition = condition(printed(welcome));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], OutAssignment, Satisfied, Percent);
		
		.print("Satisfied: ",Satisfied," Percent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
	
+!debug_check_if_par_condition_addresses_accumulation_5
	<-
		
		Accumulation = accumulation(world([done(secure_injured), done(assess_explosion_hazard), done(assess_fire_hazard)]),
									par_world([],[property(uno,[a]),property(due,[b])]),
									assignment_list([])
									);
		Condition = condition( and([done(secure_injured), done(assess_explosion_hazard), done(assess_fire_hazard)]) );
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		
		.print("Satisfied: ",Satisfied," Percent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
+!debug_check_if_par_condition_addresses_accumulation_6
	<-
		
		Accumulation = accumulation(world([injured(person),move(worker_operator,location),received_emergency_notification(location,worker_operator)]),par_world([],[property(done,[secure_injured])]),assignment_list([assignment(location,palermo),assignment(worker_operator,firefighter)]));
		Condition = condition(done(secure_injured));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		
		.print("Satisfied: ",Satisfied," Percent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
	
+!debug_check_if_par_condition_addresses_accumulation_7
	<-
		Accumulation 	= accumulation(world([injured(person),move(worker_operator,location),received_emergency_notification(location,worker_operator)]),par_world([],[property(done,[secure_injured])]),assignment_list([assignment(location,palermo),assignment(worker_operator,firefighter)]));
		Condition 		= condition(and([and([neg(done(assess_fire_hazard)),neg(done(activityFittizia))]),or([and([done(secure_injured),done(activityFittizia)]),and([done(secure_injured),done(assess_explosion_hazard),done(assess_fire_hazard)])])]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		
		.print("Satisfied: ",Satisfied," Percent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
	
	
+!debug_check_if_par_condition_addresses_accumulation_8
	<-
		Condition 		= par_condition([order_id,user_id], property(order_placed,[order_id,user_id]));
		Accumulation 	= accumulation(world([]),par_world([order,user],[property(order_placed,[order,user])]),assignment_list([]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		.print("Satisfied: ",Satisfied,"\nPercent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
+!debug_check_if_par_condition_addresses_accumulation_9
	<-
		Condition 		= condition(order_placed(order,user));
		Accumulation 	= accumulation(world([]),par_world([order,user],[property(order_placed,[order,user])]),assignment_list([]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		.print("Satisfied: ",Satisfied,"\nPercent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.	
+!debug_check_if_par_condition_addresses_accumulation_10
	<-
		Condition 		= condition(order_placed(order_id,user_id));
		Accumulation 	= accumulation(world([]),par_world([order,user],[property(order_placed,[order,user])]),assignment_list([]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		.print("Satisfied: ",Satisfied,"\nPercent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
+!debug_check_if_par_condition_addresses_accumulation_11//false
	<-
		Condition 		= condition(order_placed(order_id,user_id));
		Accumulation 	= accumulation(world([]),par_world([],[property(order_placed,[order,user])]),assignment_list([]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		.print("Satisfied: ",Satisfied,"\nPercent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.	
+!debug_check_if_par_condition_addresses_accumulation_12
	<-
		Condition 		= par_condition([order_id,user_id], property(order_placed,[order_id,user_id]));
		Accumulation 	= accumulation(world([]),par_world([],[property(order_placed,[order,user])]),assignment_list([]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		.print("Satisfied: ",Satisfied,"\nPercent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
+!debug_check_if_par_condition_addresses_accumulation_13
	<-
		Condition 		= par_condition([order_id,user_id], property(order_placed,[order_id,user_id]));
		Accumulation 	= accumulation(world([]),par_world([order,user],[property(order_placed,[order,user])]),assignment_list([]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		.print("Satisfied: ",Satisfied,"\nPercent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
+!debug_check_if_par_condition_addresses_accumulation_14 //false
	<-		
		Condition 		= par_condition([order_id,user_id], property(order_placed,[order_id,user_id]));
		Accumulation 	= accumulation(world([  condition(order_placed(order_id,user_id))  ]),par_world([],[]),assignment_list([]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		.print("Satisfied: ",Satisfied,"\nPercent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.		
+!debug_check_if_par_condition_addresses_accumulation_15
	<-		
		Condition 		= condition(order_placed(order_id,user_id));
		Accumulation 	= accumulation(world([  condition(order_placed(order_id,user_id))  ]),par_world([],[]),assignment_list([]));
		!check_if_par_condition_addresses_accumulation(Condition, Accumulation, [], [], OutAssignment, Satisfied, Percent);
		.print("Satisfied: ",Satisfied,"\nPercent: ",Percent);
		.print("Out assignment: ",OutAssignment);
	.
	
	
	

	





+!debug_filter_par_world_to_keep_only_parametric_condition
	<-
		PWS 		= [property(done,[secure_injured,a,g])];
		VarList		= [a];
		!filter_par_world_to_keep_only_parametric_condition(PWS,VarList,OutPWS,OutWS,OutVarList);
		.print("OutPWS: ",OutPWS);
		.print("OutWS: ",OutWS);
		.print("VarList: ",OutVarList);
	.
	
/**
 * [davide]
 * 
 * DEBUG PLAN for !apply_substitution_to_Accumulation(Acc ,AssignmentSet, AccNew)
 */
+!debug_apply_sobstitution_to_Accumulation
	<-
		Acc = accumulation(world([received(msg)]),par_world([msg],[property(printed,[msg]), property(f,[x])]),[]);
		Ass = [assignment(msg,welcome)];
		!apply_substitution_to_Accumulation(Acc , Ass, AccNew);
		.print("Acc: ",Acc);
		.print("Ass: ",Ass);
		.print("AccNew: ",AccNew);
	.
	
