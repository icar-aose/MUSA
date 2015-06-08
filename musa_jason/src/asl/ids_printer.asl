/**************************/
// RESPONSIBILITIES:
// get QUOTE request from customer
// notify result to customer
/* Last Modifies:
 * 
 * Todo:
 * 	- spostare !find_parameter_by_name 
 * Bugs:  
 * 
 */
/**************************/

{ include( "role/department_employee_activity.asl" ) }
{ include( "role/project_manager_activity.asl" ) }
{ include( "peer/capability_lifecycle.asl" ) }
{ include( "peer/common_context.asl" ) }
{ include( "peer/simulation.asl" ) }

{ include( "core/accumulation.asl" ) }

 
//PRINT 
agent_capability(print)[type(parametric)].
capability_parameters(print, [msg]).
capability_precondition(print, condition( true ) ).
capability_postcondition(print, par_condition( [msg], property(printed,[msg])    ) ).
//capability_postcondition(print, condition( printed(msg) ) )[parlist([ par(msg,string) ])].
capability_cost(print,0).
capability_evolution(print,[add(printed(msg))]).

//DECIDE
agent_capability(decide)[capa[type(simple),type(dsadsa)]].
capability_precondition(decide, condition( true ) ).
capability_postcondition(decide, condition( or([f(uno),f(due)]) ) ).	//NOTA: i predicati dentro l'or sono posti come atomi: "a", non funge. Il problema sta nella normalizzazione che richiede predicati e non atomi
capability_cost(decide,0).
capability_evolution(decide,[add( f(uno) ),add( f(due) )]).

!awake.

+!awake
	<-
	true
	//.print("hello!");
	
	//!debug_check_if_goal_pack_is_satisfied_in_accumulation;
	//!debug_filter_capabilities_that_create_a_new_world_in_accumulation;
/*
	!orchestrate_search_in_solution_space(
			accumulation( world([received(request)]), par_world([],[]), assignment_list([])), 			//Wi
			pack(																	//Pack
				social_goal(condition(received(request)), condition(printed(bye)),system),
		[
			agent_goal(condition(or([received(msg),printed(retry)])),condition( printed(welcome) ),system)[parlist( [par(welcome,"ciao")] )],								//printed #1
			agent_goal(condition( printed(welcome)), condition( or([f(uno),f(due)]) ),system),							//decide
			agent_goal(condition(f(due)),condition( printed(retry) ),system)[parlist( [par(retry,"retry")] )],										//printed #2	
			agent_goal(condition(f(uno)),condition( printed(bye)),system)[parlist( [par(bye,"bye")] )]											//printed #3
		]
		,[]
		,[]
	),
			[],			//Members
			OutSolutions
		);*/
		
		/*
		 * social_goal( condition(received(request)), condition(printed(bye)), system )[ pack(p1) ]
agent_goal( condition( or( [received(request)), printed(again)]) , condition(printed(welcome)), system )[ pack(p1),parlist([par(welcome,”ciao”)]) ]
agent_goal( condition( printed(welcome) , condition( or([one,two])), system )[ pack(p1) ]
agent_goal( condition( two ) , condition(printed(again)), system )[ pack(p1),parlist([par(again,”ciao di nuovo”)]) ]
agent_goal( condition( one ) , condition(printed(bye)), system )[ pack(p1),parlist([par(bye,”addio”)]) ]
		 */
		 
		!orchestrate_search_in_solution_space(
			accumulation( world([received(request)]), par_world([],[]), assignment_list([])), 			//Wi
			pack(
				social_goal( condition(received(request)), condition(printed(bye)), system )[parlist([par(bye,"byee")])],
			[
				agent_goal( condition( or( [received(request), printed(again)])) , condition(printed(welcome)), system )[ parlist([par(welcome,"ciao")]) ],
				agent_goal( condition( printed(welcome) ) , condition( or([f(one), f(two)]) ), system ),
				agent_goal(condition(f(two)),condition( printed(again) ),system)[parlist( [par(again,"retry")] )],										//printed #2	
				agent_goal(condition(f(one)),condition(printed(bye)),system)[parlist( [par(bye,"bye")] )]
			]
			,[]
			,[]
		),
			[],			//Members
			OutSolutions
		);
		 
		
	//.println(OutSolutions); 
	.


+!prepare(print, Context) 
	<-
		true
	.
	
+!action(print, Context) 
	<-
	.println("PRINT ACTION");
	.

+!terminate(print, Context)
	<-
		!register_statement( printed(msg), Context);
	.
	
	
//decide
+!prepare(decide, Context) 
	<-
		true
	.
	
+!action(decide, Context) 
	<-
		//uno o due?
		.random(N);
		if (N<0.5) {
			!register_statement( uno , Context);
		} else {
			!register_statement( due , Context);
		}
	.

+!terminate(decide, Context)
	<-
		true
	.	