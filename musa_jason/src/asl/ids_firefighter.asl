{ include( "role/department_employee_activity.asl" ) }
{ include( "role/department_manager_activity.asl") }
{ include( "role/project_manager_activity.asl" ) }
{ include( "peer/capability_lifecycle.asl" ) }
{ include( "peer/common_context.asl" ) }
{ include( "peer/simulation.asl" ) }

{ include( "core/accumulation.asl" ) }
{ include( "role/department_head_activity.asl" ) }


{ include("debug/accumulation_debug.asl") }

/* dummy capability used for simulation purpose */
/*agent_capability(wait_emergency)[type(simple)].
capability_precondition(wait_emergency, condition(true) ).
capability_postcondition(wait_emergency, condition( received_emergency_notification(location, worker_operator)) ).
capability_cost(wait_emergency,0).
capability_evolution(wait_emergency,[add( received_emergency_notification(location, worker_operator) )]).
*/

agent_capability(wait_emergency)[type(simple)].
capability_parameters(wait_emergency, [location, worker_operator]).
capability_precondition(wait_emergency, condition(true) ).
capability_postcondition(wait_emergency, par_condition([location, worker_operator], property(received_emergency_notification,[location, worker_operator])) ).
capability_cost(wait_emergency,0).
capability_evolution(wait_emergency,[add( received_emergency_notification(location, worker_operator) )]). 

/*agent_capability(wait_emergency)[type(parametric)].
capability_parameters(wait_emergency, [location]).
capability_precondition(wait_emergency, condition(true) ).
capability_postcondition(wait_emergency, par_condition([location], property(received_emergency_notification,[location])) ).
capability_cost(wait_emergency,0).
capability_evolution(wait_emergency,[add( received_emergency_notification(location) )]).
*/



agent_capability(move)[type(parametric)].
capability_parameters(move, [emergency_location, worker]).
capability_precondition(move, condition(true) ).
capability_postcondition(move, par_condition( [worker, emergency_location], property(move, [worker,emergency_location]) ) ).
capability_cost(move,0).
capability_evolution(move,[add( move(worker, emergency_location) )]).


/*agent_capability(move)[type(parametric)].
capability_parameters(move, [emergency_location]).
capability_precondition(move, condition(true) ).
capability_postcondition(move, par_condition( [emergency_location], property(move, [firefighter,emergency_location]) ) ).
capability_cost(move,0).
capability_evolution(move,[add( move(firefighter, emergency_location) )]).
*/
/*agent_capability(secureInjured)[type(simple)].
capability_parameters(secureInjured, []).
capability_precondition(secureInjured, condition(true) ).
capability_postcondition(secureInjured, condition(done(secure_injured)) ).
capability_cost(secureInjured,0).
capability_evolution(secureInjured,[add( done(secure_injured) )]).*/


agent_capability(assessExplosionHazard)[type(simple)].
capability_parameters(assessExplosionHazard, []).
capability_precondition(assessExplosionHazard, condition(true)).
capability_postcondition(assessExplosionHazard, par_condition( [worker, emergency_location], [property(move, [worker,emergency_location]), property(done,[assess_explosion_hazard])] ) ).
capability_cost(assessExplosionHazard,0).
capability_evolution(assessExplosionHazard,[add( done(assess_explosion_hazard) )]).


agent_capability(assessFireHazard)[type(simple)].
capability_parameters(assessFireHazard, []).
capability_precondition(assessFireHazard, condition(true)).
capability_postcondition(assessFireHazard, condition(done(assess_fire_hazard)) ).
capability_cost(assessFireHazard,0).
capability_evolution(assessFireHazard,[add( done(assess_fire_hazard) )]).


agent_capability(assessEvacuation)[type(simple)].
capability_parameters(assessEvacuation, []).
capability_precondition(assessEvacuation, condition(true)).
capability_postcondition(assessEvacuation, condition(done(evacuation)) ).
capability_cost(assessEvacuation,0).
capability_evolution(assessEvacuation,[add( done(evacuation) )]). 

!awake.

+!awake
	<-
		.print("Hello!");

		/*Pack = pack(agent_goal( condition( and([done(secure_injured), done(assess_explosion_hazard), done(assess_fire_hazard)])), condition( done(evacuation) ), [firefighter])[goal(g4),pack(p1),parlist([])],
				    [],[],[]
		);
		
		
		Pack=pack(social_goal( condition(  received_emergency_notification(location, worker_operator) ), condition( done(secure_artworks) ), [firefighter,system] )[goal(g),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])]
			,
			[	
			agent_goal( condition( received_emergency_notification(location, worker_operator) ), condition( move(worker_operator, location) ), [firefighter]) [goal(g),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])],
			agent_goal( condition( and([move(worker_operator, location), injured(person)]) ), condition( done(secure_injured) ), [firefighter])[goal(g),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])],
			agent_goal( condition( move(worker_operator, location)), condition( done(assess_explosion_hazard) ), [firefighter])[goal(g),pack(p1),parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])],
			agent_goal( condition( move(worker_operator, location)), condition( done(assess_fire_hazard) ), [firefighter])[goal(g),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])],
			agent_goal( condition( and([done(secure_injured), done(assess_explosion_hazard), done(assess_fire_hazard)])), condition( done(evacuation) ), [firefighter])[goal(g),pack(p1),parlist([])],
			agent_goal( condition( done(evacuation)), condition( done(delimit_dangerous_area) ), [firefighter])[goal(g),pack(p1),parlist([])],
			agent_goal( condition( done(delimit_dangerous_area)), condition( done(prepare_medical_area) ), [firefighter])[goal(g),pack(p1),parlist([])],
			agent_goal( condition( done(prepare_medical_area)), condition( done(fire_extinguished) ), [firefighter])[goal(g),pack(p1),parlist([])],
			agent_goal( condition( done(fire_extinguished)), condition( done(secure_artworks) ), [firefighter])[goal(g),pack(p1),parlist([])]
			]
			,
			[],
			[]);
*/
		/*!orchestrate_search_in_solution_space(
			accumulation( world([ received_emergency_notification(location, worker_operator), injured(person)]), par_world([],[]), assignment_list([])),
			Pack,
			[], //Members
			OutSolutions
		);*/
		//!debug_get_goal_parameter_list;
//		!awake_as_employee;
//		!debug_get_goal_pars_from_task;
//!debug_set_assignment_for_new_solution;


	!debug_unroll_solution_to_set_goal_param_values_into_assignment_2;
		//!debug_check_if_par_condition_addresses_accumulation_6;
		
		
		
		
//		!unroll_condition_formulae;
	.
	


//-----------------------------------------------------------

+!debug_unroll_par_to_get_final_assignment_1
	<-
		A 	= assignment(var,value);
		Par	= [par(value,value1),par(value1,value2)];
		
		!unroll_par_to_get_final_assignment(A, Par, OutAssignment);
		.print("Final assignment: ",OutAssignment);		
	.
+!debug_unroll_par_to_get_final_assignment_2
	<-
		A 	= assignment(emergency_location,location);
		Par	= [par(location,"palermo")];
		
		!unroll_par_to_get_final_assignment(A, Par, OutAssignment);
		.print("Final assignment: ",OutAssignment);		
	.	
+!debug_unroll_par_to_get_final_assignment_3
	<-
		A 	= assignment(var,value);
		Par	= [];
		
		!unroll_par_to_get_final_assignment(A, Par, OutAssignment);
		.print("Final assignment: ",OutAssignment);		
	.
+!debug_unroll_par_to_get_final_assignment_4
	<-
		A 	= [assignment(var,value),assignment(worker_operator,operator1)];
		Par	= [par(value,value1),par(value1,value2),par(operator1,firefighter),par(firefighter,firefighter_1)];
		
		!unroll_par_to_get_final_assignment(A, Par, OutAssignment);
		.print("Final assignment: ",OutAssignment);		
	.	
/**
 * [davide]
 * 
 *  Return a list of assignment which value has been substitued with the actual value in
 * 	goal parlist corresponding parameter.
 */
+!unroll_par_to_get_final_assignment(AssignmentList, GoalParlist, OutAssignment)
	:
		AssignmentList = [Head|Tail]
	<-
		!unroll_par_to_get_final_assignment(Head, GoalParlist, OutAssignmentCurrent);
		!unroll_par_to_get_final_assignment(Tail, GoalParlist, OutAssignmentRec);
		.concat([OutAssignmentCurrent],OutAssignmentRec,OutAssignment);
	.
+!unroll_par_to_get_final_assignment(AssignmentList, GoalParlist, OutAssignment)
	:	AssignmentList 	= []
	<-	OutAssignment 	= [];
	.
	
+!unroll_par_to_get_final_assignment(Assignment, GoalParlist, OutAssignment)
	:
		Assignment 		= assignment(AssignmentVar, AssignmentVal)	&
		GoalParlist 	= [Head|Tail] 								
	<-
		if(.member(par(AssignmentVal,_), GoalParlist))
		{
			!get_par_value(AssignmentVal,GoalParlist,ParValOut);
			if(ParValOut = no_value)
			{
				OutAssignment = Assignment;
			}
			else
			{
				!unroll_par_to_get_final_assignment(assignment(AssignmentVar, ParValOut), GoalParlist, OutAssignment);
			}
		}
		else
		{
			OutAssignment = Assignment;
		}
	.
+!unroll_par_to_get_final_assignment(Assignment, GoalParlist, OutAssignment)
	:	GoalParlist = []
	<-	OutAssignment = Assignment;
	.	
	

/**
 * [davide]
 * 
 * Return the value of a parameter into a goal's parlist 
 */
+!get_par_value(ParName,ParList,ParValOut)
	:	
		ParList 	= [Head|Tail]						&
		Head 		= par(ParNameCurrent, _)			&
		ParName		\== ParNameCurrent
	<-
		!get_par_value(ParName,Tail,ParValOut);
	.	
+!get_par_value(ParName,ParList,ParValOut)
	:	
		ParList 	= [Head|Tail]						&
		Head 		= par(ParNameCurrent, ParVal)		&
		ParName		= ParNameCurrent 
	<-
		ParValOut	= ParVal;
	.
+!get_par_value(ParName,ParList,ParValOut)
	:	ParList 	= []
	<-	ParValOut	= no_value;
	.	
+!get_par_value(ParName,ParList,ParValOut)
	<-	ParValOut	= no_value;
	.	
	
	
//-----------------------------------------------------------
	
	
	
	
	

+!prepare(wait_emergency, Context) <- true .
+!prepare(move, Context) 					<- 	.print("Preparing capability ",move); .
+!prepare(assessExplosionHazard, Context) 	<- 	.print("Preparing capability ",assessExplosionHazard); .
+!prepare(assessFireHazard, Context) 		<- 	.print("Preparing capability ",assessFireHazard); .
+!prepare(assessEvacuation, Context)		<-	.print("Preparing capability ",assessEvacuation); .

+!action(move,Context) 
	<- 					
		.print("--->ACTION FOR CAPABILITY ",move);

		!register_statement(move(worker_operator, location),Context);
		!register_statement(injured(person),Context);
	.
	
+!action(assessExplosionHazard,Context) 
	<- 	
		.print("--->ACTION FOR CAPABILITY ",assessExplosionHazard);
		!register_statement(done(assess_explosion_hazard), Context);
	.
+!action(assessFireHazard,Context) 
	<- 		
		.print("--->ACTION FOR CAPABILITY ",assessFireHazard);
		!register_statement(done(assess_fire_hazard),Context);
		
	.
+!action(assessEvacuation,Context) 
	<- 		
		.print("--->ACTION FOR CAPABILITY ",assessEvacuation);
		!register_statement(done(evacuation),Context);
	.
+!action(wait_emergency, Context)
	<-
		Context=department_context(DptName);
		
		!timestamp(TimeStamp);
		.concat(DptName,TimeStamp,ProjectName);	
		NewContext = project_context(DptName,ProjectName);
		addProject(ProjectName,DptName,"","","null");	// this goes here to allow data registration in the capability body
		
		+manager_of(DptName,ProjectName,[]);		

		!register_statement( received_emergency_notification(location, worker_operator), NewContext);

		!!create_project(DptName,ProjectName);		// in project_manager_activity.asl 			
	.

+!terminate(print, Context)
	<-
		!register_statement( printed(msg), Context);
	.	
+!terminate(move,Context) <- true.
+!terminate(assessExplosionHazard,Context) <- true.
+!terminate(assessFireHazard,Context) <- true.
+!terminate(assessEvacuation,Context) <- true.
+!terminate(wait_emergency,Context) <- true.
