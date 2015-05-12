+!get_remote_capability_tx(Commitment,TX)
	:
		Commitment = commitment( cap(Capability,HeadPercent), Agent )
	<-
		.send(Agent,askOne,capability_evolution(Capability,_),Reply);
		if (Reply \== false) {
			Reply = capability_evolution(Capability,TransferFunction)[source(Agent)];
		}
		TX = TransferFunction;
	.


+!get_capability_tx(Cap,TX)
	:
		Cap = cap(Capability) | Cap = cap(Capability,Percent)
	<-
		?capability_evolution(Capability,TX);
	.
+!get_capability_tx(Cap,TX)
	:
		Cap = parcap(Capability,AssignSet,EvolutSet)
	<-
		TX=EvolutSet;
	.

+!select_capabilities(Evo,CPSet)
	<-
		.reverse(Evo,RevEvo);
		RevEvo = [ Wk | Tail2 ];
		
		.findall(cap(Cap),agent_capability(Cap)[type(simple)],AllSimpleCapabilities);
		!filter_capabilities_that_triggers_on_world(AllSimpleCapabilities,Wk,WkSimpleCapabilities);
		!filter_capabilities_that_create_a_new_world_in_evolution(WkSimpleCapabilities,Evo,SimpleCPSet);
		//.println("simple cap set: ",SimpleCPSet);

		.findall(pc(Cap),agent_capability(Cap)[type(parametric)],AllParametricCapabilities);
		//.println("par cap set: ",AllParametricCapabilities);
		!filter_parametric_capabilities_that_triggers_on_world(AllParametricCapabilities,Wk,WkSolvedParamCapabilities);
		//.println("filtered assigned set: ",WkSolvedParamCapabilities);
		!filter_parametric_capabilities_that_create_a_new_world_in_evolution(WkSolvedParamCapabilities,Evo,ParamCPSet);
		//.println("evo set: ",ParamCPSet);
		
		.concat(SimpleCPSet,ParamCPSet,CPSet);
	.
/* OK */
+!debug_select_capabilities <- !select_capabilities([world([s2,s1,s0]),world([s2,s0]),world([s1,s2,s3,s4]),world([s1,s2])],OutCapabilities); .println(OutCapabilities); .
+!debug_select_capabilities_2 <- !select_capabilities([world([it_is(dt(2014,2,16,9,00,00)),being_at(palermo)])],CPSet); .println(CPSet); .

+!filter_capabilities_that_triggers_on_world(InCapabilities,W,OutCapabilities)
	:
		InCapabilities=[]
	<-
		OutCapabilities=[]
	.
+!filter_capabilities_that_triggers_on_world(InCapabilities,W,OutCapabilities)
	:
		InCapabilities=[ Head | Tail ]
	&	Head=cap(Capability)
	<-
		?capability_precondition(Capability,PRE);
		
		!test_condition(PRE,W,Bool);
		
		!filter_capabilities_that_triggers_on_world(Tail,W,FilteredTail);
		
		if (Bool=true) {
			OutCapabilities = [ Head | FilteredTail ];
		} else {
			OutCapabilities = FilteredTail
		}
	.
/* OK */
+!debug_filter_capabilities_that_triggers_on_world <- !filter_capabilities_that_triggers_on_world([flight,visit],world([s0,s2,s1]),OutCapabilities); .println(OutCapabilities); .



+!filter_parametric_capabilities_that_triggers_on_world(InCapabilities,W,OutCapabilities)
	:
		InCapabilities=[]
	<-
		OutCapabilities=[]
	.
+!filter_parametric_capabilities_that_triggers_on_world(InCapabilities,W,OutCapabilities)
	:
		InCapabilities=[ Head | Tail ]
	&	Head=pc(Capability)
	<-
		?capability_precondition(Capability,PRE);
		
		PRE = par_condition(Variables,ParamFormula);
		!unroll_variables_to_deduct_values(Variables,PRE,W,[],AssignmentSet,Bool);

		!filter_parametric_capabilities_that_triggers_on_world(Tail,W,FilteredTail);
		
		if (Bool=true) {
			OutCapabilities = [ apc(Capability,AssignmentSet) | FilteredTail ];
		} else {
			OutCapabilities = FilteredTail
		}
	.
+!debug_filter_parametric_capabilities_that_triggers_on_world <- !filter_parametric_capabilities_that_triggers_on_world(
	[pc(visit)],
	world([it_is(dt(2014,2,16,9,00,00)),being_at(palermo)]),
	OutCapabilities
); .println(OutCapabilities); .


+!filter_capabilities_that_create_a_new_world_in_evolution(InCapabilities,Evo,OutCapabilities)
	:
		InCapabilities=[]
	<-
		OutCapabilities=[]
	.
+!filter_capabilities_that_create_a_new_world_in_evolution(InCapabilities,Evo,OutCapabilities)
	:
		InCapabilities=[ Head | Tail ]
	&	Head=cap(Capability)
	<-
		//.println(Head);
		
		!get_last_element_from_list(Evo,Wk);

		?capability_evolution(Capability,PLAN_EVO);
		//.println(PLAN_EVO);
		
		!generate_new_world(Wk,PLAN_EVO,Wnext);
		//.println(Wnext);
		
		!unroll_evolution_to_check_new_world(Evo,Wnext,Bool);
		
		!filter_capabilities_that_create_a_new_world_in_evolution(Tail,Evo,FilteredTail);
		
		if (Bool=true) {
			OutCapabilities = [ Head | FilteredTail ];
		} else {
			OutCapabilities = FilteredTail
		}
	.
/* OK */
+!debug_filter_capabilities_that_create_a_new_world_in_evolution <- !filter_capabilities_that_create_a_new_world_in_evolution([flight],[world([s0]),world([s2,s0]),world([s1,s2])],OutCapabilities); .println(OutCapabilities); .
+!debug_filter_capabilities_that_create_a_new_world_in_evolution_2 <- !filter_capabilities_that_create_a_new_world_in_evolution([flight],[world([s0]),world([s2]),world([s1,s2])],OutCapabilities); .println(OutCapabilities); .


+!filter_parametric_capabilities_that_create_a_new_world_in_evolution(InCapabilities,Evo,OutCapabilities)
	:
		InCapabilities=[]
	<-
		OutCapabilities=[]
	.
+!filter_parametric_capabilities_that_create_a_new_world_in_evolution(InCapabilities,Evo,OutCapabilities)
	:
		InCapabilities=[ Head | Tail ]
	&	Head=apc(Capability,AssignmentSet)
	<-
		//.println("cap: ",Head);
		
		!get_last_element_from_list(Evo,Wk);

		!capability_evolution(Capability,AssignmentSet,Wk,EvolutionSet);
		//.println("evoset: ",EvolutionSet);
		
		!unroll_evolution_set_to_filter_capabilities_that_create_a_new_world(Capability,AssignmentSet,Wk,Evo,EvolutionSet,FiteredHead);
		//.println("filtered: ",FiteredHead);
		
		!filter_parametric_capabilities_that_create_a_new_world_in_evolution(Tail,Evo,FilteredTail);
		//.println("new world: ",FiteredHead);
		
		.concat(FiteredHead,FilteredTail,OutCapabilities);
	.
+!debug_filter_parametric_capabilities_that_create_a_new_world_in_evolution <- !filter_parametric_capabilities_that_create_a_new_world_in_evolution(
	[apc(visit, [assign(city,palermo),assign(datetime,dt(2014,2,16,12,30,00))] )],
	[world([being_at(palermo)]),world([being_at(palermo),visited(palermo,1)])],
	OutCapabilities
); .println(OutCapabilities); .


+!unroll_evolution_set_to_filter_capabilities_that_create_a_new_world(Capability,AssignmentSet,Wk,Evo,EvolutionSet,OutCapabilities)
	:
		EvolutionSet=[]
	<-
		OutCapabilities=[];
	.
+!unroll_evolution_set_to_filter_capabilities_that_create_a_new_world(Capability,AssignmentSet,Wk,Evo,EvolutionSet,OutCapabilities)
	:
		EvolutionSet=[ Head | Tail ]
	<-
		//.println("evolution set: ",Head);
		!generate_new_world(Wk,Head,Wnext);
		//.println("wnext: ",Wnext);
		!unroll_evolution_to_check_new_world(Evo,Wnext,Bool);
		//.println("is useful: ",Bool);
		
		!unroll_evolution_set_to_filter_capabilities_that_create_a_new_world(Capability,AssignmentSet,Wk,Evo,Tail,FilteredTail);
		//.println("tail: ",FilteredTail);
		
		if (Bool=true) {
			OutCapabilities = [ parcap(Capability,AssignmentSet,Head) | FilteredTail ];
		} else {
			OutCapabilities = FilteredTail;
		}

	.


+!unroll_evolution_to_check_new_world(Evo,Wnext,Bool)
	:
		Evo=[]
	<-
		Bool=true;
	.
+!unroll_evolution_to_check_new_world(Evo,Wnext,Bool)
	:
		Evo=[ Head | Tail ]
	<-
		//.println(Head);
		
		!check_worlds_equal(Wnext,Head,CompareBool);
		if (CompareBool \==true) {
			!unroll_evolution_to_check_new_world(Tail,Wnext,Bool)
		} else {
			Bool=false;
		}
	.

+!generate_new_world(World,PlanEvFunc,Wnext)
	:
		PlanEvFunc = []
	<-
		Wnext = World;
	.
+!generate_new_world(World,PlanEvFunc,Wnext)
	:
		PlanEvFunc = [ Head | Tail]
	<-
		//.println("operator: ",Head);
		!apply_evolution_operator(Head,World,UpdatedWorld);
		
		!generate_new_world(UpdatedWorld,Tail,Wnext);
	.
/* OK */
+!debug_generate_new_world <- !generate_new_world(world([s1,s6,s10]),[add(s2),add(s3)],Wnext); .println(Wnext); .
+!debug_generate_new_world_2 <- !generate_new_world(world([s1,s6,s10]),[add(s2),remove(s1)],Wnext); .println(Wnext); .


+!apply_evolution_operator(Operator,World,UpdatedWorld)
	:
		Operator = add(Statement)
	<-
		//.println("adding: ",Statement);
		World = world(StatementSet);
		.union(StatementSet,[Statement],UpdatedStatementSet);
		UpdatedWorld = world(UpdatedStatementSet);
	.
+!apply_evolution_operator(Operator,World,UpdatedWorld)
	:
		Operator = remove(Statement)
	<-
		//.println("removing: ",Statement);
		World = world(StatementSet);
		.delete(Statement,StatementSet,UpdatedStatementSet);
		UpdatedWorld = world(UpdatedStatementSet);
	.

	