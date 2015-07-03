/******************************************************************************
 * @Author: 
 *  - Luca Sabatucci 
 * 	- Davide Guastella
 * 
 * Description: plans for handling accumulation states
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 *	
 * TODOs:
 *
 * Reported Bugs:  
 *
 ******************************************************************************/
 
 { include( "core/world.asl" ) }
 { include( "core/par_condition.asl" ) }
 { include( "core/conditions.asl" ) }
 { include( "debug/accumulation_debug.asl" ) }
 
 
 /**
  * [davide]
  * 
  * Check if the goals in input are satisfied in an accumulation state. 
  */
+!evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,InputAssignment,SatisfiedPercent)
	<-
		!unroll_agent_goals_to_evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,InputAssignment,SatisfiedPercentList);
		!calculate_average(SatisfiedPercentList, SatisfiedPercent);
	.

+!unroll_agent_goals_to_evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,InputAssignment,SatisfiedPercentList)
	:
		AgentGoalList=[]
	<-
		SatisfiedPercentList=[];
	.
+!unroll_agent_goals_to_evaluate_satisfaction_in_accumulation(AgentGoalList,Accumulation,InputAssignment,SatisfiedPercentList)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		!check_if_goal_is_satisfied_in_accumulation(Head,Accumulation,InputAssignment,HeadSatisfied,_, AssignmentOut);
		!unroll_agent_goals_to_evaluate_satisfaction_in_accumulation(Tail,Accumulation,InputAssignment,TailSatisfiedPercentList);
		SatisfiedPercentList=[ HeadSatisfied | TailSatisfiedPercentList ];
	.

/**
 * [davide]
 * 
 * For each capability in the input capability list, check if, applying the related
 * evolution plan, a new world state is created. If not, the capability is discarded.
 *   
 * CAP -> [commitment(Me, Capability, HeadPercent),...] 
 * ACC -> accumulation(world(WS),par_world(VARS,PWS),assignment())
 * OUT -> ...
 * 
 * FUNZIONA SIA PER CAP SEMPLICI CHE PARAMETRICHE (qui in realtà non importa il tipo di capability)
 */
+!filter_capabilities_that_create_a_new_world_in_accumulation(InCapabilities,Accumulation,OutCapabilities)
	:
		InCapabilities	= [ Head | Tail ]	&
		Head			= commitment(Agent, Capability, HeadPercent)
	<-
		?orchestrate_verbose(VB);
		!apply_accu_evolution_operator([Head],Accumulation,AccuNext);			//Get the updated accumulation state 
		!check_accumulation_equal(Accumulation,AccuNext,CompareBool);			//Test A=A'
		
		if(VB=true)
		{
			.print("----------");
			.print("[filter_capabilities_that_create_a_new_world_in_accumulation] Applying cap: ",Capability);
			.print("[filter_capabilities_that_create_a_new_world_in_accumulation] current ACC: ", Accumulation);
			.print("[filter_capabilities_that_create_a_new_world_in_accumulation] new ACC: ", AccuNext);
			.print("[filter_capabilities_that_create_a_new_world_in_accumulation] Acc equals? ",CompareBool);
			.print("----------");
		}
		!filter_capabilities_that_create_a_new_world_in_accumulation(Tail,Accumulation,FilteredTail);	
		
		//If A'!=A then add the capability to the output capability set (that is, the set of
		//capabilities that effectively creates a new world state) 
		if (CompareBool \== true) 		{	OutCapabilities = [ Head | FilteredTail ];	} 
		else 							{	OutCapabilities = FilteredTail;				}
	.
+!filter_capabilities_that_create_a_new_world_in_accumulation(InCapabilities,Accumulation,OutCapabilities)
	: 	InCapabilities	= []
	<-	OutCapabilities	= []
	.	
	

/**
 * [davide]
 * 
 * Filter a given capability set, returning only those that trigger on a given accumulation state.
 * 
 */
+!filter_capabilities_that_triggers_on_accumulation(InCapabilities,Accumulation,OutCapabilities)
	:
		InCapabilities	= [ Head | Tail ]
	&	Head			= commitment(Me, Capability, HeadPercent)
	<-
		!get_remote_capability_precondition(Head, PRE);
		!elaborate_condition_truth_percent(PRE,Accumulation,ConditionTruthPercent);
		!filter_capabilities_that_triggers_on_accumulation(Tail,Accumulation,FilteredTail);
		!concatene_capability_if_percent_not_zero(FilteredTail,Head,ConditionTruthPercent,OutCapabilities);
	.
+!filter_capabilities_that_triggers_on_accumulation(InCapabilities,Accumulation,OutCapabilities)
	: 	InCapabilities	= []
	<-	OutCapabilities	= []
	.

/**
 * [davide]
 * 
 * Unrolls the agent goal list and check if every goals is satisfied in accumulation 
 */
+!unroll_agent_goals_to_check_if_satisfied_in_accumulation(AgentGoalList,Accumulation,InputAssignment,AgentGoalsSatisfied, AssignmentList)
	:	AgentGoalList 			= []
	<-	AgentGoalsSatisfied		= true;
		AssignmentList 			= [];
	.
+!unroll_agent_goals_to_check_if_satisfied_in_accumulation(AgentGoalList,Accumulation,InputAssignment,AgentGoalsSatisfied,AssignmentList)
	:
		AgentGoalList=[ Head | Tail ]
	<-
		!check_if_goal_is_satisfied_in_accumulation(Head, Accumulation, InputAssignment, HeadSatisfied, SatisfiedBool, OutAssignmentList);
		
		if (SatisfiedBool=true) 
		{
			!unroll_agent_goals_to_check_if_satisfied_in_accumulation(Tail, Accumulation, InputAssignment, AgentGoalsSatisfied, AssignmentListRec);
			.union(OutAssignmentList, AssignmentListRec, AssignmentList);
		} 
		else 
		{
			AgentGoalsSatisfied	= false;
			AssignmentList 		= OutAssignmentList;
		}
	.

/**
 * PASSO 2 NELL'ALGORITMO DI PIANIFICAZIONE
 * 
 * VERIFICA SE Social È SODDISFATTO NELLO STATO DI ACCUMULAZIONE DATO IN INGRESSO.
 * Il risultato è indipendente dall'applicazione degli eventuali assignment trovati.
 * 
 */
+!check_if_goal_pack_is_satisfied_in_accumulation(Social,AgentGoalList,Accumulation,InputAssignment, GoalPackSatisfied, AssignmentList)
	<-
		?orchestrate_verbose(VB);
		if(VB=true) 
		{
			.print("[check_if_goal_pack_is_satisfied_in_accumulation] Accumulation state: ",Accumulation);
			.print("[check_if_goal_pack_is_satisfied_in_accumulation] (Social) goal: ",Social); 
		}
		
		//first check on social goal
		!check_if_goal_is_satisfied_in_accumulation(Social,Accumulation,InputAssignment, SocialGoalSatisfiedPercent, SocialGoalSatisfied, SocialGoalAssignmentList);							//If the social goal is satisfied
		
		//if social goal is satisfied, check for agent goals
		if (SocialGoalSatisfied=true) 
		{
			!unroll_agent_goals_to_check_if_satisfied_in_accumulation(AgentGoalList,Accumulation,InputAssignment,AgentGoalsSatisfied, PackAssignmentList);	//unroll agent goals
			.union(SocialGoalAssignmentList, PackAssignmentList, AssignmentList);

			GoalPackSatisfied = true;
		} 
		else 
		{
			GoalPackSatisfied = false;
			AssignmentList = SocialGoalAssignmentList;
		}
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
 * PASSO 2 DELLA PIANIFICAZIONE
 * 
 * Verifica se un goal è soddisfatto in un dato stato di accumulazione, utilizzando eventuali assignment dati in ingresso.
 */
+!check_if_goal_is_satisfied_in_accumulation(Goal, Acc, InputAssignment, SatisfiedPercent, SatisfiedBool, AssignmentList)
	<-
		?orchestrate_verbose(VB);
		!get_goal_TC([Goal], 	[TC|_]);
		!get_goal_FS([Goal], 	[FS|_]);
		!get_goal_Pars([Goal], 	Pars);
		
		if(VB=true)
		{
			.print("[check_if_goal_is_satisfied_in_accumulation] Testing Goal: ",Goal);
		 	.print("[check_if_goal_is_satisfied_in_accumulation] GOAL TC:",TC);
			.print("[check_if_goal_is_satisfied_in_accumulation] GOAL FS:",FS);
			.print("[check_if_goal_is_satisfied_in_accumulation] Accumulation state: ",Acc);
		}
		
		!get_assignment_from_par_list(Pars,GoalAssignment);								//Retrieve assignment from parlist in the input goal
		.union(GoalAssignment, InputAssignment, InputAss);								//Concatenate the found assignment to the input assignment list
		
		Acc = accumulation(world(WS), par_world(Vars,PWS), _);
		
		!check_if_par_condition_addresses_accumulation(TC, Acc, InputAss, Pars, OutAssignmentTC, TC_Satisfied, PercentTC);
		!check_if_par_condition_addresses_accumulation(FS, Acc, InputAss, Pars, OutAssignmentFS, FS_Satisfied, PercentFS);
		
		SatisfiedPercent = PercentTC * PercentFS;										//Calculate the goal satisfaction score
		.eval(SatisfiedBool, TC_Satisfied & FS_Satisfied); 
		.union(OutAssignmentTC, OutAssignmentFS, AssignmentList);
		
		if(VB=true)	
		{	
			.println("[check_if_goal_is_satisfied_in_accumulation] TC Satisfied:",TC_Satisfied);
			.println("[check_if_goal_is_satisfied_in_accumulation] FS Satisfied:",FS_Satisfied);
			.println("[check_if_goal_is_satisfied_in_accumulation]Assignment found:",AssignmentList);
			.println("[check_if_goal_is_satisfied_in_accumulation]Acc:",Acc);
			.println("[check_if_goal_is_satisfied_in_accumulation]Goal is:",SatisfiedPercent);
			if(Satisfied > 0)	{.print("----->SATISFIED<----- (",SatisfiedPercent,")");}
			else				{.print("NOT SATISFIED(",SatisfiedPercent,")");}
		}
	.
 
/*
 * [davide]
 * 
 * Given a list of property and a list of assignment, return a list of filtered properties, where
 * for each one there's at least one assignment in the given input assignment list. 
 */
+!filter_effective_parametric_par_condition(PropertyIn, GoalVars, PropertyOut, VarOut)
 	:	PropertyIn 	= []
 	<-	PropertyOut = [];
 		VarOut		= [];
 	.
+!filter_effective_parametric_par_condition(PropertyIn, GoalVars, PropertyOut, VarOut)
	:
		PropertyIn 	= [Head|Tail] &
		Head 		= property(Functor,Terms)
	<-
		!filter_effective_parametric_par_condition(Tail, GoalVars, PropertyOutRec, VarOutRec);	
		
		.intersection(Terms,GoalVars,EffectiveVars);
		if (not .empty(EffectiveVars))	{.concat([Head],PropertyOutRec,PropertyOut);}
		else							{.concat([],PropertyOutRec,PropertyOut);}
		
		.union(VarOutRec,EffectiveVars, VarOut);
		
	.

/**
 * passo 1
 * 
 * [davide]
 * 
 * Given the current accumulation state, that is
 * 
 * 		Acc = accumulation(World,ParWorld,AssignmentSet)
 * 
 * build a corresponding par_condition containing *BOTH* predicated from World and ParWorld. 
 * This par_condition has the variables contained within the properties in ParWorld; the formula is given by the
 * logic and between the properties in ParWorld and the normalized predicates
 * in World.
 */
+!assemble_par_condition_from_accumulation(Acc, PA)
	:
		Acc=accumulation(world(WS), par_world(Vars, PWS), _)
	<-
		!retrieve_vars_from_property_list(PWS, VarList);				//Retrieve the variables of all the properties in PWS
		.intersection(VarList,Vars,UnionVarList);						//The output variables list is given by the intersection set
																		//between [Vars] list and the just calculated [VarList] list. 
		!normalize_world_statement(WS, NormalizedWS);					//Normalize WS
		.union(NormalizedWS,PWS,PAstatement);							//Calculate the final property set
		//PA=par_condition(UnionVarList,and(PAstatement));				//Assemble the output par_condition
		PA=par_condition(UnionVarList,PAstatement);
	.
 
/**
 * [davide]
 * 
 * Unroll a nested predicate, returning the inner one.
 */
+!unroll_nested_condition(Statement, UnrolledPred)
	<-
		st.unroll_nested_predicate(Statement, UnrolledPred);
	.
 
/**
 * [davide]
 * 
 * Check if SIMPLE or PARAMETRIC condition addresses an accumulation state.
 * 
 * CN 		-> condition(Statement) | par_condition
 * Acc 		-> accumulation(W,PW,Ass)
 */
+!check_if_par_condition_addresses_accumulation(CN, Acc, InAssignment, GoalParams, OutAssignment, Bool, HeadPercent)
 	:
 		CN = condition(or([])) | CN = condition(false) 
 	<-
 		OutAssignment 	= [];
 		HeadPercent 	= 0;
 		Bool 			= false;
 	.
+!check_if_par_condition_addresses_accumulation(CN, Acc, InAssignment, GoalParams, OutAssignment, Bool, HeadPercent)
 	:
 		CN = condition(and([])) | CN = condition(true) 
 	<-
 		OutAssignment 	= [];
 		HeadPercent 	= 1;
 		Bool 			= true;
 	.
// Plan for handling composite 'or' conditions.
+!check_if_par_condition_addresses_accumulation(CN, Acc, InAssignment, GoalParams, OutAssignment, Bool, HeadPercent)
	 :
	 	CN = condition(or(StatementList)) & 
	 	StatementList = [Head|Tail]
	 <-
	 	!check_if_par_condition_addresses_accumulation(condition(Head),Acc, InAssignment, GoalParams, OutAssignment_1, Bool_1, HeadPercent_1);
	 	!check_if_par_condition_addresses_accumulation(condition(or(Tail)),Acc, InAssignment, GoalParams,OutAssignment_2, Bool_2, HeadPercent_2);
	 	
	 	//TODO DA VERIFICARE: calculate_average
		!calculate_average([HeadPercent_1,HeadPercent_2],HeadPercent);
	 	//HeadPercent = HeadPercent_1+HeadPercent_2;
	 	
	 	.eval(Bool, Bool_1 | Bool_2);
	 	.union(OutAssignment_1,OutAssignment_2,OutAssignment);
	 .
//Plan for handling composite 'neg' conditions.
+!check_if_par_condition_addresses_accumulation(CN, Acc, InAssignment, GoalParams, OutAssignment, Bool, HeadPercent)
	 :
	 	CN = condition(neg(Statement))
	 <-
	 	!check_if_par_condition_addresses_accumulation(condition(Statement),Acc, InAssignment, GoalParams, OutAssignment, BoolHead, HeadPercentHead);
	 	HeadPercent = 1-HeadPercentHead;
	 	.eval(Bool, (not BoolHead));
	 .

//Plan for handling composite 'and' conditions.
+!check_if_par_condition_addresses_accumulation(CN, Acc, InAssignment, GoalParams, OutAssignment, Bool, HeadPercent)
	 :
	 	CN = condition(and(StatementList)) & 
	 	StatementList = [Head|Tail]
	 <-
	 	!check_if_par_condition_addresses_accumulation(condition(Head),Acc, InAssignment, GoalParams, OutAssignment_1, Bool_1, HeadPercent_1);
	 	!check_if_par_condition_addresses_accumulation(condition(and(Tail)),Acc, InAssignment, GoalParams, OutAssignment_2, Bool_2, HeadPercent_2);
	 	
	 	!calculate_average([HeadPercent_1,HeadPercent_2],HeadPercent);
	 	
	 	.eval(Bool, Bool_1 & Bool_2);
	 	.union(OutAssignment_1,OutAssignment_2,OutAssignment);
	 .
 
+!check_if_par_condition_addresses_accumulation(CN, Acc, InAssignment, GoalParams, OutAssignment, Bool, HeadPercent)
	:
		Acc = accumulation(world(WS), par_world(Vars, PWS), _)	&
		CN 	= condition( CNs ) 
	<-
		?accumulation_verbose(VB);

//Step 1 -> Assemble the par_condition from both the accumulation state and the input condition CN
		!assemble_par_condition_from_accumulation(accumulation(world([]), par_world(Vars, PWS), _), PA);
		
		//Convert CN, the input condition, to a par_condition CNI_tmp
		!convert_simple_condition_to_par_condition(CN, CNI_tmp);			
		CNI_tmp = par_condition(CNI_tmp_Vars, PC_Properties);
//		
		//TODO In realtà il !get_assignment_from_par_list sarebbe inutile perche gli assignment ottenuti dalla parlist del goal da testare sono  già inclusi in InAssignment.
		!get_assignment_from_par_list(GoalParams, GoalAssignmentList);
		
		//potrei piuttosto verificare banalmente l'intersezione (vuota o no)
		!get_var_list_from_assignment_list(GoalAssignmentList, GoalVars);

		.union(GoalVars,Vars,AllVars);
		!find_substitution_for_par_condition(CNI_tmp, PA, AllVars, InAssignment, OutAssignment, Success);
		
		if(VB=true)
		{
			.print("-----------------------------------------------");
			.print("[check_if_par_condition_addresses_accumulation] FIND_SUBSTITUTION SUCCESS: ",Success);
			.print("[check_if_par_condition_addresses_accumulation] PA: ",PA);		
			.print("[check_if_par_condition_addresses_accumulation] CNI_tmp: ",CNI_tmp);		
			.print("[check_if_par_condition_addresses_accumulation] Input Assignment: ",InAssignment);
			.print("[check_if_par_condition_addresses_accumulation](PASSO 1) CNI: ",CNI);
			.print("[check_if_par_condition_addresses_accumulation](PASSO 2) Assignment trovati: ",OutAssignment);
		}
		
		//if a substitution has been found
		if(Success=true)
		{
			//Step 3 -> apply the substitution to the accumulation state, generating a dummy accumulation state.
			.union(OutAssignment,InAssignment,AssignmentList);
			
			!apply_substitution_to_Accumulation(Acc ,AssignmentList, AccII);
			
			if(VB=true)
			{
				.print("[check_if_par_condition_addresses_accumulation](PASSO 3) Accumulation nuovo: ",AccII);
				.print("-----------------------------------------------");
			}
			
			AccII = accumulation(world(WII), par_world(VarList, PWII), _);
			//Step 4 -> Test the condition within the dummy accumulation state (where the found assignment have been applied).
			
			!test_condition(CN, WII, Bool);
			
			if(VB=true){.print("[check_if_par_condition_addresses_accumulation] ----->TEST_CONDITION: ",Bool);}
			
			//Now test the goal condition only on the non-parametric part of the accumulation state, where are contained the
			//predicates just unified with the found assignment.
			!elaborate_logic_formula_truth_percent(CN, world(WII), HeadPercent);
		}
		else
		{
			Bool 		= false;
			HeadPercent = 0;
		}
	.

+!check_if_par_condition_addresses_accumulation(CN, Acc, InAssignment, GoalParams, OutAssignment, Bool, HeadPercent)
	:
		Acc = accumulation(world(WS), par_world(VarList, PWS), _)
	&	CN = par_condition( PCNVar, PCNproperties )
	<-
		//Passo1 -> Converto lo stato di accumulazione in ingresso in una par_condition
		!assemble_par_condition_from_accumulation(Acc, PA);
		
		//Passo2
		!find_substitution_for_par_condition(CN, PA, InAssignment, OutAssignment, Success);
		
		if(Success=true)
		{
			//Passo3
			!apply_substitution_to_Accumulation(Acc ,OutAssignment, AccII);
			
			//Creo il nuovo stato di accumulazione
			AccII = accumulation(world(WII),par_world(PWIIVars, PWII),_);
			
			// CN' <- applico la sostituzione a CN
			!apply_unification_to_par_condition(CN, OutAssignment, OutPC);
//			.print("@@@@@@@@@@@@@@@@ input PC: ",CN);
//			.print("@@@@@@@@@@@@@@@@ unified PC: ",OutPC);
			
			
			//Unisci tutti gli assignment e verifica se questo soddisfa tutte le variabili della par_condition in ingresso
			
			.union(InAssignment,OutAssignment, NewAssignmentSet);
			!check_if_all_par_condition_vars_are_assigned(CN, NewAssignmentSet, VarsAssigned);
//			
//			.print("@@@@@@@@@@@@@@@@ NewAssignmentSet = ",NewAssignmentSet);
//			.print("@@@@@@@@@@@@@@@@ InAssignment = ",InAssignment);
//			.print("@@@@@@@@@@@@@@@@ OutAssignment = ",OutAssignment);
//			.print("@@@@@@@@@@@@@@@@ VarsAssigned = ",VarsAssigned);
			if(VarsAssigned = false)
			{
				Bool = false;
				
			}
			else
			{
				//Passo4
				!get_var_list_from_assignment_list(NewAssignmentSet, Vars); 
//				.print("Converting ",OutPC," [Vars] ",Vars," [AssSet] ",NewAssignmentSet);
				
				OutPC = par_condition([],OutPCLogicFormula);
				!convert_parametric_to_simple_formula(OutPCLogicFormula, Vars, NewAssignmentSet, LogicFormula);
				
//				.print("...................LogicFormula: ",LogicFormula);
//				.print("@@@@@@@@@@@@@@@@ testing  ",LogicFormula,"\non\n",WII);
				
//				!test_condition(LogicFormula, WII, Bool);
				!test_logic_formula(LogicFormula,WII,Bool);
//				!test_condition(OutPC, AccII, Bool);
//				.print("@@@@@@@@@@@@@@@@ test_condition = ",Bool);
				!elaborate_logic_formula_truth_percent(CN, world(WII), HeadPercent);
			} 
		}
		else
		{
			Bool=false;
		}
	.


	
/**
 * [davide]
 * 
 * Given an accumulation state, this plan takes the properties in par_world which functor is not contained into its
 * var list. In this way, at the end of this process, the Accumulation state will effectively contains parametric
 * and non-parametric statements in the right lists.
 * 
 */
+!denormalize_accumulation(Accumulation, OutAccumulation)
	:
		Accumulation = accumulation(world(WS),par_world(VarList,PWS),Assignment)
	<-
		!filter_par_world_to_keep_only_parametric_condition(PWS,VarList,OutPWS,OutWS,OutVarList);
		.union(WS,OutWS,InWS);
		
		OutAccumulation = accumulation(world(InWS), par_world(OutVarList, OutPWS), Assignment);
	.

/**
 * [davide]
 * 
 * This plan filter a list of properties in which at least one term is contained into the input var list.
 */
+!filter_par_world_to_keep_only_parametric_condition(PWS,VarList,OutPWS,OutWS,OutVarList)
	:
		PWS 	= [Head|Tail] &
		Head 	= property(Functor,Terms)
	<-
		!filter_par_world_to_keep_only_parametric_condition(Tail,VarList,OutPWSRec,OutWSRec,OutVarListRec);
		.intersection(Terms,VarList,Intersection);
		
		!unroll_property_to_get_var_list(Head,VarList,OutVarListCurrent);
		.union(OutVarListCurrent,OutVarListRec,OutVarList);
		
		if(not .empty(Intersection))	//almeno un termine in Head è contenuto nella lista delle variabili
		{
			.concat(OutPWSRec,[Head],OutPWS);
			.concat(OutWSRec,[],OutWS);
		}
		else							//Head non contiene alcun termine contenuto nella lista delle variabili 
		{
			.concat(OutPWSRec,[],OutPWS);
			st.denormalize_predicate(Functor,Terms,LogicFormula);
			.concat(OutWSRec,[LogicFormula],OutWS);
		}
	.
+!filter_par_world_to_keep_only_parametric_condition(PWS,VarList,OutPWS,OutWS,OutVarList)
	:	PWS  		= []
	<-	OutPWS		= [];
		OutWS		= [];
		OutVarList 	= [];
	.	

/**
 * [davide]
 * 
 * Given a property, return the list of its terms which have to be
 * unified (that is, its vars) 
 */
+!unroll_property_to_get_var_list(Property, VarList, OutVarList)
	:
		Property = property(Functor,Terms)
	<-
		.intersection(Terms,VarList,OutVarList);
	.

/**
 * passo 3
 * 
 * [davide]
 * 
 * Apply a substitution (by using the assignment set) to an accumulation state.
 */
+!apply_substitution_to_Accumulation(Acc ,AssignmentSet, AccNew)
	:
		Acc = accumulation(world(WS),par_world(VarList, PWS),AssSet)
	<-
		!apply_unification_to_par_condition_formulae(PWS, AssignmentSet, UnifiedPWS, UnifiedFormulaeList);	//Apply the substitution to par_world
		
		//Take the set difference between the unified formulae and these not unified. 
		.difference(PWS,UnifiedFormulaeList, NotUnifiedFormalae);
		
		//Normalize the not unified formulae
		!convert_parametric_formulae_to_simple_formula(NotUnifiedFormalae, NotUnifiedSimpleFormulae);
		!convert_parametric_formulae_to_simple_formula(UnifiedPWS, SimpleUnifiedPWS);	//Convert the par_world statements to simple formulae
		
		.union(SimpleUnifiedPWS,WS,WSII_temp);
		.union(WSII_temp,NotUnifiedSimpleFormulae,WSII);
		
		AccNew = accumulation(world(WSII),par_world(VarList, PWS),AssSet);
	.