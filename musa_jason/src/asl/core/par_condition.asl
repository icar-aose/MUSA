/******************************************************************************
 * @Author: 
 *  - Luca Sabatucci 
 * 	- Davide Guastella
 * 
 * Description: plans for handling par_conditions
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 *
 * TODOs:
 * 	- il piano !create_substitution_for_properties dovrebbe essere riscritto in
 *    modo più elegante...
 *
 * Reported Bugs:  
 *
 ******************************************************************************/

{ include( "core/world.asl" ) }


 /**
 * [davide]
 * 
 * DEBUG PLAN for !check_if_all_vars_are_assigned(CN, AssignmentSet, Bool)
 */
+!debug_check_if_all_par_condition_vars_are_assigned
	<-
		!check_if_all_par_condition_vars_are_assigned(par_condition([msg],[property(printed,[msg])]), [assignment(msg,ciao)], Bool);
		.print("Assigned: ",Bool);
	.

/**
 * [davide]
 * 
 * Given a par_condition CN, check if all its variables have been assigned. More
 * precisely, this plan check if every variable in CN has a corresponding assignment
 * into the assignment set.
 * 
 */
+!check_if_vars_are_assigned(Vars, AssignmentSet, Bool)
	:
		Vars = [Head|Tail]
	<-
		!do_check_if_all_par_condition_vars_are_assigned(Vars, AssignmentSet, Bool);				//call the auxiliary plan
	.
+!check_if_all_par_condition_vars_are_assigned(CN, AssignmentSet, Bool)
	:
		CN = par_condition(Vars, _)
	<-
		!do_check_if_all_par_condition_vars_are_assigned(Vars, AssignmentSet, Bool);				//call the auxiliary plan
	.
+!do_check_if_all_par_condition_vars_are_assigned(Vars, AssignmentSet, Bool)
	:
		Vars = [Head|Tail]
	<-
		!do_check_if_all_par_condition_vars_are_assigned(Tail, AssignmentSet, BoolRec);			//recursive step
		!exists_assignment_for_term(Head,AssignmentSet,_,Found);					//check if the current var has an assignment
		.eval(Bool, BoolRec & Found);												//evaluate the output boolean value
	.
	
+!do_check_if_all_par_condition_vars_are_assigned(Vars, AssignmentSet, Bool)
	:	Vars = []
	<-	Bool=true;
	.
 
 /**
 * [davide]
 * 
 * DEBUG PLAN for !retrieve_vars_from_property_list(PropertyList,VarList)
 */
+!debug_retrieve_vars_from_property_list
	<-
		!retrieve_vars_from_property_list([property(p,[x,a]), property(q,[g,y])],VarList);
		.print("Vars: ",VarList);
	.
/**
 * [davide]
 * 
 * Given a set of property, return a list containing the terms of all the properties.
 * A property has the following form
 * 	 
 * 		property(functor,[terms])
 */
+!retrieve_vars_from_property_list(PropertyList,VarList)
	:
		PropertyList	= [Head|Tail] &
		Head			= property(_,Terms)
	<-
		!retrieve_vars_from_property_list(Tail, VarListTwo);
		.concat(Terms,VarListTwo,VarList);
	.
	
+!retrieve_vars_from_property_list(PropertyList,VarList)
	:	PropertyList=[]
	<-	VarList=[];
	.
 
 /**
 * [davide]
 * 
 * DEBUG PLAN for apply_unification_to_par_condition
 */
+!debug_apply_unification_to_par_condition
	<-
		!apply_unification_to_par_condition(par_condition([x,m,z], [property(p,[x,b]), property(q,[m,z])]) ,
													      [assignment(x,a),assignment(m,n),assignment(z,r)],
													      Out);
		.print("Out: ",Out);
	.
	
 /**
 * [davide]
 * 
 * Apply unification to a par_condition by applying assignments.
 */
+!apply_unification_to_par_condition(PC, AssignmentList, OutPC)
	:
		PC = par_condition(Vars, Formulae)
	<-
		!unroll_par_condition_formula(Formulae, UnrolledFormulae);										//Unroll the par_condition
		!apply_unification_to_par_condition_formulae(UnrolledFormulae, AssignmentList, OutFormulae);	//Apply the unification to the terms of every property
		!get_var_list_from_assignment_list(AssignmentList, AssignmentVars);						//Get vars from the assignment list
		.difference(Vars,AssignmentVars,OutVars);												//calculate the final var set
		OutPC = par_condition(OutVars, OutFormulae);											//build the output par_condition
	.

/**
 * [davide]
 * 
 * Return a list containing the variable names of the assignments within the input list. 
 */
+!get_var_list_from_assignment_list(AssignmentList, OutVars)
	:
		AssignmentList 	= [Head|Tail] &
		Head			= assignment(V,_)
	<-
		!get_var_list_from_assignment_list(Tail, OutVarsTwo);
		.concat([V],OutVarsTwo,OutVars);		
	.

+!get_var_list_from_assignment_list(AssignmentList, OutVars)
	:	AssignmentList 	= []
	<-	OutVars 		= [];
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for apply_unification_to_par_condition_formulae
 */
+!debug_apply_unification_to_par_condition_formulae
	<-
		InProperties = [property(p,[x,b]), property(q,[m,z]), property(l,[o])];
		!apply_unification_to_par_condition_formulae(InProperties,
													 [assignment(x,a),assignment(m,n),assignment(z,r)],
													 Out,
													 UnifiedFormulae);											 
		.print("Out: ",Out);
		.difference(InProperties,UnifiedFormulae, NotUnifiedFormalae);
		.print("Not Unified Formulae: ",NotUnifiedFormalae);

	.
/**
 * [davide]
 * 
 * Apply unification for all the properties within the given formulae list using an assignment list.
 */
+!apply_unification_to_par_condition_formulae(FormulaeList, AssignmentList, OutFormulae, UnifiedFormulae)
	:
		FormulaeList = [Head|Tail]
	<-
		!apply_unification_to_par_condition_formulae(Tail, AssignmentList, OutFormulaeTwo, UnifiedFormulaeRec);		//recursive call
		
		Head = property(Functor,Terms);
		
		!exists_assignment_for_property(Terms,AssignmentList,Found);
		
		if(Found=true)
		{
			!apply_unification_to_property(Terms, AssignmentList,OutTerms);							//Apply the unification for the current property
			.concat([property(Functor,OutTerms)], OutFormulaeTwo, OutFormulae);						//Concatenate the unified property to the output properties list
			.concat([Head], UnifiedFormulaeRec, UnifiedFormulae);	
		}
		else
		{
			.concat([], OutFormulaeTwo, OutFormulae);
			.concat([], UnifiedFormulaeRec, UnifiedFormulae);
		}
	.
+!apply_unification_to_par_condition_formulae(Formula, AssignmentList, OutFormulae, UnifiedFormula)
	:
		Formula = property(Functor,Terms)
	<-
		!exists_assignment_for_property(Terms,AssignmentList,Found);
		
		if(Found=true)
		{
			UnifiedFormula = Formula;
			!apply_unification_to_property(Terms, AssignmentList,OutTerms);							//Apply the unification for the current property
			OutFormulae = [property(Functor,OutTerms)]; 	
		}
		else
		{
			UnifiedFormula 	= [];
			OutFormulae 	= [];
			//.concat([], OutFormulaeTwo, OutFormulae)
		}
	.
+!apply_unification_to_par_condition_formulae(FormulaeList, AssignmentList, OutFormulae, UnifiedFormulae)
	:	FormulaeList 		= []
	<-	OutFormulae 		= [];
		UnifiedFormulae 	= [];
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for apply_unification_to_property
 */
+!debug_apply_unification_to_property
	<-
		!apply_unification_to_property([x,b],[assignment(x,a),assignment(m,z)],OutTerms);
		.print("Out: ",OutTerms);
	.
	
/**
 * [davide]
 * 
 * Given a terms list from a property and an assignment list, apply the unification
 * and return the new terms list.
 * 
 * [TODO descrivere un pò meglio...]
 */
+!apply_unification_to_property(Terms, AssignmentList, OutTerms)
	:
		Terms = [Head|Tail]
	<-
		!apply_unification_to_property(Tail, AssignmentList, OutTermsTwo);						//recursive call
		!exists_assignment_for_term(Head, AssignmentList, OutAssignment, ExistAssignment);		//check if exists an assignment for the current term
		
		if(ExistAssignment=true)																//if exists an assignment
		{
			OutAssignment = assignment(_,V);							
			.concat([V],OutTermsTwo,OutTerms);													//concatenate the value of the assignment to the output terms list
		}	
		else
		{
			.concat([Head],OutTermsTwo,OutTerms);												//otherwise concatenate the previous existing term
		}
	.
+!apply_unification_to_property(Terms, AssignmentList, OutTerms)
	:	Terms 		= []
	<-	OutTerms 	= [];
	.

/**
 * DEBUG PLAN FOR exists_assignment_for_commitment
 */
+!debug_exists_assignment_for_commitment
	<-
		!find_assignment_for_commitment(print, [assignment(msg,"wella"),assignment(a,x)], OutAssignment);
		.print("OutAssignment: ",OutAssignment);	
	
	.	
//--------------------
//--------------------
/** DA ELIMINARE... */
+?capability_parameters(CapName,VarList) <-	VarList = [];.
-?capability_parameters(CapName,VarList) <-	VarList = [];.
//--------------------
//--------------------


/**
 * [davide]
 * 
 * Given a capability, check if its parameters have a corresponding assignment.   
 */
+!find_assignment_for_commitment(Commitment, AssignmentList, OutAssignment)
	<-
		Commitment = commitment(AgName,CapName,_); 
		!get_remote_capability_pars(Commitment,VarList); 		
		!exists_assignment_for_term_list(VarList, AssignmentList, OutAssignment);		//Find the assignment that match the input capability
	.
/**
 * [davide]
 * 
 * Check if exist assignments for the given terms. 
 */
+!exists_assignment_for_term_list(TermList, AssignmentList, OutAssignment)
	:	TermList 		= []
	<-	OutAssignment	= [];
	.
+!exists_assignment_for_term_list(TermList, AssignmentList, OutAssignment)
	:	
		TermList = [Head|Tail]
	<-
		!exists_assignment_for_term_list(Tail, AssignmentList, OutAssignmentRec);
		!exists_assignment_for_term(Head,AssignmentList,AssignmentFound,FoundBool);
		
		if(.empty(AssignmentFound))	{.union([],OutAssignmentRec,OutAssignment)	}
		else						{.union([AssignmentFound],OutAssignmentRec,OutAssignment)}
	.


/**
 * [davide]
 * 
 * DEBUG PLAN for +!exists_assignment_for_property plan
 */
+!debug_exists_assignment_for_property
	<-
		!exists_assignment_for_property([x,a],[assignment(a,r)],Found);
		.print("Found: ",Found);
	.

+!exists_assignment_for_property(TermList,AssignmentList,Found)
	:
		TermList=[Head|Tail]
	<-
		!exists_assignment_for_property(Tail,AssignmentList,FoundRec);
		!exists_assignment_for_term(Head,AssignmentList,_,FoundTwo);
		.eval(Found, FoundRec | FoundTwo);
	.

+!exists_assignment_for_property(TermList,AssignmentList,Found)
	:	TermList=[]
	<-	Found=false;
	.

/**
 * [davide]
 * 
 * Search for an assignment that has T as variable name.
 */
+!exists_assignment_for_term(T,AssignmentList,OutAssignment,Found)
	:	
		AssignmentList 	= [Head|Tail] 				&
		Head			= assignment(Var,Val) 		&
		T 				= Var
	<-	
		OutAssignment	= Head;
		Found			= true;
	.
	
+!exists_assignment_for_term(T,AssignmentList,OutAssignment,Found)
	:
		AssignmentList 	= [Head|Tail] 				&
		Head			= assignment(Var,Val) 		&
		T 			  	\== Var
	<-
		!exists_assignment_for_term(T,Tail,OutAssignment,Found);
	.
	
+!exists_assignment_for_term(T,AssignmentList,OutAssignment,Found)
	:
		AssignmentList = []
	<-
		Found			= false;
		OutAssignment 	= [];
	.

//se è una lista di elementi, allora fai ricorsione e ritorna lista di elementi contenuti in assignmentList
+!check_if_assignment_list_contains(Elem, AssignmentList, Return, Bool)
	:
		Elem = []
	<-
		Return = [];
		Bool = false;
	.
+!check_if_assignment_list_contains(Elem, AssignmentList, Return, Bool)
	:
		Elem = [Head|Tail]
	<-
		!check_if_assignment_list_contains(Head, AssignmentList, ReturnHead, BoolHead);
		!check_if_assignment_list_contains(Tail, AssignmentList, ReturnTail, BoolTail);
		
		.union([ReturnHead],ReturnTail,Return);
		.eval(Bool, BoolHead|BoolTail);
	.

 /**
 * [davide]
 * 
 * Check if an assignment list contains an assignment with the input
 * element as first term. That is, for example: given 
 * 
 * Elem = b
 * AssignmentList = [assignment(a,1), assignment(b,1)]
 * 
 * this plan returns:
 * 
 * Return = assignment(b,1)
 * Bool = true
 */	
+!check_if_assignment_list_contains(Elem, AssignmentList, Return, Bool)
	:
		AssignmentList = [Head|Tail] 	&
		Head = assignment(Var,Val) 		&
		not .list(Elem) &
		Elem \== Var
	<-
		!check_if_assignment_list_contains(Elem, Tail, Return, Bool)
	.
+!check_if_assignment_list_contains(Elem, AssignmentList, Return, Bool)
	:
		AssignmentList = [Head|Tail] 	&
		Head = assignment(Var,Val) 		&
		not .list(Elem) 				&
		(Elem = Var | Elem = Val) 
	<-
		Bool	= true;
		Return 	= Head;
	.
 +!check_if_assignment_list_contains(Elem, AssignmentList, Return, Bool)
	:
		AssignmentList = []
	<-
		Bool	= false;
		Return 	= [];
	.
	
 /**
 * [davide]
 * 
 * DEBUG PLANS for do_find_substitution_for_par_condition
 */
+!debug_do_par_condition_unification_1
	<-
		!do_find_substitution_for_par_condition([property(p,[x,b]), property(q,[m,z])], 
									  [property(p,[a,y]), property(q,[n,r])], 
									  [x,m,z], 
									  [y],
									  [], 
									  OutAssignmentList,
									  Success);
									  
		.print("par_condition A: par_condition(",[x,m,z],",",[property(p,[x,b]), property(q,[m,z])],")");
		.print("par_condition B: par_condition(",[y],",",[property(p,[a,y]), property(q,[n,r])],")");		
		.print("success: ",Success);
		if(Success=true)
		{
			.print("OutAssignment: ",OutAssignmentList);
		}				
	.		
+!debug_do_par_condition_unification_2
	<-
	.print("unifico");
		!do_find_substitution_for_par_condition([property(p,[x,a]), property(p,[b,y])], 
									  [property(p,[b,y]), property(p,[a,a])], 
									  [x,y], 
									  [y], 
									  [],
									  OutAssignmentList,
									  Success);
		
		.print("par_condition A: par_condition(",[x,y],",",[property(p,[x,a]), property(p,[b,y])],")");
		.print("par_condition B: par_condition(",[y],",",[property(p,[b,y]), property(p,[a,a])],")");		
		.print("success: ",Success);
		if(Success=true)
		{
			.print("OutAssignment: ",OutAssignment);
		}
	.
/**-----------------------------------------------------------------------------------------------------*/

/**
 * [davide]
 * 
 * DEBUG PLAN for unify_par_condition
 */
+!debug_unify_par_condition
	<-	
		.print("Test sulle par condition:\n",par_condition([x,m,z], and([property(p,[x,b]), property(q,[m,z])]),"\n",par_condition([y],     and([property(p,[a,y]), property(q,[n,r])]))));
		!find_substitution_for_par_condition( par_condition([x,m,z,o], and([property(p,[x,b]), property(q,[m,z]), property(k,[o,q])]) ),
							  				  par_condition([y],     and([property(p,[a,y]), property(q,[n,r])]) ),
							 [assignment(x,a)],
							 OutAssignment,
							 Success);
		
		.print("success: ",Success);
		.print("OutputAssignment: ",OutAssignment);
	.
	
+!debug_unify_par_condition_2
	<-	
		P1 = par_condition([a,b], and([property(p,[a]), property(f,[b,a])]) );
		P2 = par_condition([m],   and([property(p,[c]), neg(property(h,[m]))     ]) );
		!find_substitution_for_par_condition( P1,
							  				  P2,
											  [assignment(a,c),assignment(a,d)],
											  OutAssignment,
											  Success);
		.print("P1: ",P1);
		.print("P2: ",P2);
		.print("success: ",Success);
		.print("OutputAssignment: ",OutAssignment);
	.
	
+!debug_unify_par_condition_3
	<-	
		P1 = par_condition([],[property(received_emergency_notification,[locationT,worker_operatorT])]); //CNI_tmp
		P2 = par_condition([location,worker_operator],and([property(received_emergency_notification,[location,worker_operator])])); //PA
		!find_substitution_for_par_condition( P1,
							  				  P2,
							  				  [],
											  [],
											  OutAssignment,
											  Success);
		.print("P1: ",P1);
		.print("P2: ",P2);
		.print("success: ",Success);
		.print("OutputAssignment: ",OutAssignment);
	.
/**-----------------------------------------------------------------------------------------------------*/

/**
 * [davide]
 * 
 * Given two par_condition, search for a unification that makes the par_conditions identical. 
 * 
 * Le par_condition sono srotolate!
 */
+!find_substitution_for_par_condition(ParConditionA, ParConditionB, InputAssignment, OutAssignment, Success)
 	:
 		ParConditionA =  par_condition(VarsA, FormulaA) &
 		ParConditionB =  par_condition(VarsB, FormulaB)
 	<-
 		!unroll_par_condition_formula(FormulaA, UnrolledFormulaA);		//Unroll the formula of the first par_condition
 		!unroll_par_condition_formula(FormulaB, UnrolledFormulaB);		//Unroll the formula of the second par_condition
 		
 		!do_find_substitution_for_par_condition(UnrolledFormulaA,		//Create the unification
			 									UnrolledFormulaB, 
			 									VarsA, 
			 									VarsB, 
			 									InputAssignment, 		//PER ADESSO LA PASSO COME INSIEME VUOTO, altrimenti la lista in output non conterrà due assignment per la stessa variabile ma con due valori differenti.
			 									OutAssign, 
			 									Success);
			 									
		.union(InputAssignment,OutAssign,OutAssignment);
  	.
/**
 * [davide]
 * 
 * Given two par_condition, search for a unification that makes the par_conditions identical. 
 * 
 * Le par_condition sono srotolate!
 * 
 * Questo piano differisce dal presente in quanto vengono considerate la variabili in comune tra par_condition e stato
 * di accumulazione. 
 */
+!find_substitution_for_par_condition(ParConditionA, ParConditionB, InputVars, InputAssignment, OutAssignment, Success)
 	:
 		ParConditionA =  par_condition(ParVarsA, FormulaA) &
 		ParConditionB =  par_condition(ParVarsB, FormulaB)
 	<-
 		!unroll_par_condition_formula(FormulaA, UnrolledFormulaA);		//Unroll the formula of the first par_condition
 		!unroll_par_condition_formula(FormulaB, UnrolledFormulaB);		//Unroll the formula of the second par_condition
 		
 		.intersection(ParVarsA, InputVars, VarsA);
 		.intersection(ParVarsB, InputVars, VarsB);
 		//.print("InputVars: ",InputVars);
	/*.print("VarsA: ",VarsA);
	.print("VarsB: ",VarsB);*/
 		!do_find_substitution_for_par_condition(UnrolledFormulaA,					//Create the unification
			 									UnrolledFormulaB, 
			 									VarsA, 
			 									VarsB, 
			 									InputAssignment, 
			 									OutAssignment, 
			 									Success);
  	.
 
  /**
  * [davide]
  * 
  * Given the unrolled properties lists from two par_condition, unify these par_condition by creating a set of assignment that makes the
  * two par condition identical. 
  * 
  * Create a unification for the given par_condition properties lists. This is an auxiliary recursive plan used by !unify_par_condition.
  * 
  * Properties(A/B) 			-> the unrolled formula from the input par_conditions
  * Par_condition_(A/B)_vars 	-> the variable lists of the input par_conditions
  * InAssignment 				-> the input assignment list
  * OutAssignmentList 			-> the output assignment list
  */
+!do_find_substitution_for_par_condition(PropertiesA, PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	:
		PropertiesA = [Head|Tail] & .list(PropertiesB)
	<-	
		!search_for_property_with_the_same_functor(Head, PropertiesB, Out_property, Found);
		
		if(Found=true)
		{
			Head 			= property(_,VH);																										//Take the terms of property A
			Out_property 	= property(_,VO);																										//Take the terms of property B
			!create_substitution_for_properties(VH,VO,Par_condition_A_vars,Par_condition_B_vars,InAssignment,OutAssignment_A, SuccessSubstA);		//Create a substitution A->B
			!create_substitution_for_properties(VO,VH,Par_condition_B_vars,Par_condition_A_vars,InAssignment,OutAssignment_B, SuccessSubstB);		//Create a substitution B->A
			
			if(.eval(SuccessSubstitution, (SuccessSubstA & SuccessSubstB)))
			{
				.concat(OutAssignment_A, OutAssignment_B, OutAssignment);																			//Concatenate the resulting assignment list
				Assignment = OutAssignment;
			}
			else
			{
				Assignment = [];
			}
		}
		else
		{
			Assignment = [];
		}
		!do_find_substitution_for_par_condition(Tail, PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentTwo, SuccessRec);
		.eval(Success, SuccessSubstitution & SuccessRec);
		.concat(OutAssignmentTwo, Assignment, OutAssignmentList);
	.
	
+!do_find_substitution_for_par_condition(PropertiesA, PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	:
		PropertiesA = property(F,T) & .list(PropertiesB)
	<-	
		!do_find_substitution_for_par_condition([PropertiesA], PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	.

+!do_find_substitution_for_par_condition(PropertiesA, PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	:
		PropertiesA = property(F,T) & not .list(PropertiesB)
	<-	
		!do_find_substitution_for_par_condition([PropertiesA], [PropertiesB], Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	.
	
+!do_find_substitution_for_par_condition(PropertiesA, PropertiesB, Par_condition_A_vars, Par_condition_B_vars,InAssignment, OutAssignmentList, Success)
	:	PropertiesA = []
	<-	OutAssignmentList = [];
	.

+!debug_unroll_par_condition_formula_1
	<-
		!unroll_par_condition_formula(
			and([property(p,[x,b]), property(q,[m,z])]),
			OutParCondition
		);
		
		.print("OutParCondition: ", OutParCondition);
	.	
	
+!debug_unroll_par_condition_formula_2
	<-
		!unroll_par_condition_formula(
			and([property(p,[x,b]), property(q,[m,z])]),
			OutParCondition
		);
		
		.print("OutParCondition: ", OutParCondition);
	.	
//
/**
 * [davide]
 * 
 * Unroll the properties within the formula of a given par_condition formula. For example,
 * the output for the following formula
 * 
 * 	and([property(p,[x,b]), property(q,[m,z])])
 *
 * 	is given by
 *  
 * 	[property(p,[x,b]),property(q,[m,z])]
 */
+!unroll_par_condition_formula(Formula, OutParCondition)
	<-
		!unroll_par_condition_formula(Formula, OutParCondition, _);
	.
	
+!unroll_par_condition_formula(Formula, OutParCondition, NegFlag)
	:
		Formula = [Head|Tail]
	<-
		!unroll_par_condition_formula(Head, OutParConditionH, NegFlag);
		!unroll_par_condition_formula(Tail, OutParConditionT, NegFlag);
		.concat(OutParConditionH,OutParConditionT,OutParCondition);
	.

+!unroll_par_condition_formula(Formula, OutParCondition, NegFlag)
	:
		Formula = and(List) | Formula = or(List)
	<-
		!unroll_par_condition_formula(List, OutParCondition, NegFlag)
	.

+!unroll_par_condition_formula(Formula, OutParCondition, NegFlag)
	:
		Formula = neg(List)
	<-
		if(NegFlag = false)
		{
			N=true;
		}
		else
		{
			N=false;
		}
		!unroll_par_condition_formula(List, OutParCondition, N);
	.

+!unroll_par_condition_formula(Formula, OutParCondition, NegFlag)
	:
		Formula = property(_,_) &
		NegFlag = true
	<-
		OutParCondition = [Formula];
	.
	
+!unroll_par_condition_formula(Formula, OutParCondition, NegFlag)
	:
		Formula = property(_,_) &
		NegFlag = false
	<-
		OutParCondition = [];
	.
	
+!unroll_par_condition_formula(Formula, OutParCondition, NegFlag)
	:
		Formula = []
	<-
		OutParCondition = [];
	.
+!unroll_par_condition_formula(Formula, OutParCondition, NegFlag)
	<-
		Formula = OutParCondition;
	.
	
	
	
/**
 * [davide]
 * 
 * DEBUG PLANS for search_for_property_with_the_same_functor
 */
+!debug_search_for_property_with_the_same_functor_1
	<-
		!search_for_property_with_the_same_functor(property(p,[x,y]), [  property(a,[x,y]), property(a,[x,o]), property(p,[x,y]) ], OutProperty, Bool);
		.print("OutProperty: ",OutProperty);
	.
+!debug_search_for_property_with_the_same_functor_2
	<-
		!search_for_property_with_the_same_functor(property(p,[x,y]), [  property(a,[x,y]), property(b,[x,o]), property(c,[x,y]) ], OutProperty, Bool);
		.print("OutProperty: ",OutProperty);
	.	

/**
 * [davide]
 * 
 * Given an input property in the form of 
 * 
 * 		property( functor, [terms] )
 * 
 * return a property (the first found) within the property list that has the same functor as InProperty.
 */
+!search_for_property_with_the_same_functor(InProperty, PropertyList, OutProperty, Bool)
	:
		InProperty 		= property(AFunctor, _) &
		PropertyList 	= [Head|Tail]	&
		Head 			= property(BFunctor, _) &
		AFunctor 		= BFunctor 
	<-
		OutProperty = Head;
		Bool 		= true;
	.

+!search_for_property_with_the_same_functor(InProperty, PropertyList, OutProperty, Bool)
	:
		InProperty 		= property(AFunctor, _) &
		PropertyList 	= [Head|Tail]	&
		Head 			= property(BFunctor, _) &
		AFunctor 		\== BFunctor 
	<-
		!search_for_property_with_the_same_functor(InProperty, Tail, OutProperty, Bool);
	.

+!search_for_property_with_the_same_functor(InProperty, PropertyList, OutProperty, Bool)
	:
		PropertyList = []
	<-
		OutProperty = [];
		Bool 		= false;
	.

/**
 * [davide]
 * 
 * DEBUG PLANS for create_substitution_for_properties
 */
+!debug_create_substitution_for_properties_1
	<-
		!create_substitution_for_properties([b,y],[a,a],[x,y],[y],[],OutAssignmentA,SuccessA);
		!create_substitution_for_properties([a,a],[b,y],[y],[x,y],[],OutAssignmentB,SuccessB);
		
		.concat(OutAssignmentA,OutAssignmentB,OutAssignment);
		.eval(Success, SuccessA & SuccessB);
		.print("Success: ",Success);
		if(Success=true)
		{
			.print("OutAssignment: ",OutAssignment);
		}
	.
+!debug_create_substitution_for_properties_2
	<-
		!create_substitution_for_properties([x,b],[a,y],[x,m,z],[y],[],OutAssignmentA,SuccessA);
		!create_substitution_for_properties([a,y],[x,b],[y],[x,m,z],[],OutAssignmentB,SuccessB);
		
		.concat(OutAssignmentA,OutAssignmentB,OutAssignment);
		.eval(Success, SuccessA & SuccessB);
		.print("Success: ",Success);
		if(Success=true)
		{
			.print("OutAssignment: ",OutAssignment);
		}
	.
/**
 * [davide]
 * 
 * Create a substitution for the term lists of two properties that has the same functor.
 * VarA and VarB are the lists of variable in the par_condition containing the properties
 * related to the given term lists. 
 * 
 * Return:
 * 	- OutAssignment -> a list of assignment.
 * 
 * Notes:
 * 	- TermsA and TermsB are assumed to be related to two properties that have THE SAME functor.
 * 
 * OK
 */
 +!create_substitution_for_properties(TermsA,TermsB,VarA,VarB,InAssignment, OutAssignment, Success)
	:
		InAssignment = assignment_list(AS)
	<-
		!create_substitution_for_properties(TermsA,TermsB,VarA,VarB,AS, OutAssignment, Success);
	.
+!create_substitution_for_properties(TermsA,TermsB,VarA,VarB,InAssignment, OutAssignment, Success)
	:
		TermsA 			= [Head|Tail] 	&
		TermsB 			= [HeadB|TailB]
	<-
		?verbose_par_condition(VB);
		if( not .member(Head, VarA) & not .member(HeadB, VarB) )									//both terms are costant
		{
			A			= [];
			SuccessLocal= false;																	//return an error
		}
		else
		{
			if( .member(Head, VarA) & .member(HeadB, VarB) )										//both terms are variables
			{
				if(VB=true){.print("[create_substitution_for_properties] Both terms are vars. TermsA: ",TermsA," TermsB: ",TermsB);}
				!check_if_assignment_list_contains(Head,	InAssignment, AssignmentA, BoolAssA);		//Check if var A has been already unified
				!check_if_assignment_list_contains(HeadB, 	InAssignment, AssignmentB, BoolAssB);		//Check if var B has been already unified
				
				if(BoolAssA = true & BoolAssB = false)												
				{
					AssignmentA = assignment(_,ValA);												
					A = [assignment(HeadB,ValA)];
				}
				else
				{
					if(BoolAssA = false & BoolAssB = true)
					{
						AssignmentB = assignment(_,ValB);
						A = [assignment(Head,ValB)];
					}
					else
					{
						A = [assignment(Head,HeadB)];
					}
				}
			}
			else
			{
				if( .member(Head, VarA) & not .member(HeadB, VarB) )
				{
					A = [assignment(Head,HeadB)];							//Create an assignment
					SuccessLocal=true;
				}
				else
				{
					A = [];
				}
			}
		}
		!create_substitution_for_properties(Tail,TailB,VarA,VarB,InAssignment, OutAssignmentRec, SuccessRec);		//Recursive call on the rest of terms in termsA
		
		.eval(Success,SuccessLocal & SuccessRec);
		
		if(VB=true)
		{
			.print("[create_substitution_for_properties] Created assignment A: ",A," between terms ",TermsA," and ",TermsB);
			.print("[create_substitution_for_properties] InAssignment? ",InAssignment);
		}
		if(not .member(A,InAssignment))
		{
			if(Head\==HeadB) 	{.concat(OutAssignmentRec,A,OutAssignment);}
			else				{.concat(OutAssignmentRec,[],OutAssignment);}	
		}
	.

+!create_substitution_for_properties(TermsA,TermsB,VarA,VarB,InAssignment, OutAssignment,Success)
	:	TermsA = [] | TermsB = []
	<-	OutAssignment = [];
	.
	
+!test_parametric_condition(PCN,AssignmentSet,World,Bool)
	:
		PCN 	= [Head|Tail] &
		Head 	= par_condition(_,_)
	<-
		!test_parametric_condition(Head,AssignmentSet,World,Bool);
	.
/* 
 * [luca]
 * THIS PLAN
 * works with parametric conditions where all variables are assigned.
 * 
 * PCN 				=> par_condition(Variables,ParamLogicFormula)
 * AssignmentSet	=> [assign(Var, Val),...]
 * World 			=> world(WS)
 * Bool				=> Output boolean value
 */
+!test_parametric_condition(PCN,AssignmentSet,World,Bool)
	:
		PCN = par_condition(Variables,ParamLogicFormula)
	<-
		//Check if every variable has a corresponding assignment
		!check_if_vars_are_assigned(Variables,AssignmentSet,BoundBool);
		
		//If all variables are bounded
		if (BoundBool=true)
		{
			//convert the input parametric condition to a simple formula
			!convert_parametric_to_simple_formula(ParamLogicFormula, Variables, AssignmentSet, LogicFormula);
			
			//test the obtained simple formula in world  
			!test_logic_formula(LogicFormula, World, Bool);
		} 
		else 
		{
			Bool = false;
		}		
	. 
/* OK  */
+!debug_test_parametric_condition <- !test_parametric_condition(
	par_condition([city,duration],property(visited,[luca,city,duration])),
	[assign(city,palermo),assign(duration,2)],
	world([s1,visited(luca,palermo,3),s7]),
	Bool
); .println(Bool).
+!debug_test_parametric_condition_2 <- !test_parametric_condition(
	par_condition([activity], and([property(done,[activity]),eq(activity,classify)]) ),
	[assign(activity,classify)],
	world([s1,done(classify),s7]),
	Bool
); .println(Bool).
+!debug_test_parametric_condition_3 <- !test_parametric_condition(
	par_condition([datetime],and([property(it_is,[datetime]),data_earlier_than(datetime,dt(2014,2,20,24,0,0))])),
	[assign(datetime,dt(2014,2,17,8,30,0))],
	world([being_at(palermo),visited(palermo,2),it_is(dt(2014,2,17,8,30,0))]),
	Bool
); .println(Bool); .
+!debug_test_parametric_condition_4 <- !test_parametric_condition(
	par_condition([datetime],and([property(it_is,[datetime]),data_is(datetime,date(2014,2,17))])),
	[assign(datetime,dt(2014,2,17,8,30,0))],
	world([being_at(palermo),visited(palermo,2),it_is(dt(2014,2,17,8,30,0))]),
	Bool
); .println(Bool); .

+!debug_convert_parametric_to_simple_formula
	<-
		!convert_parametric_to_simple_formula(property(f,[a,b]),[],[],SimpleFormula);
		.print("Simple formula: ",SimpleFormula);
	.


/**
 * [davide]
 * 
 * DEBUG PLAN for !convert_parametric_formulae_to_simple_formula(PW,Out)
 */
+!debug_convert_parametric_formulae_to_simple_formula
	<-
		!convert_parametric_formulae_to_simple_formula([property(f,[x,d]), property(q,[g,y])], Out);
		.print("Out:",Out);
	.

/**
 * [davide]
 * 
 * Convet a parametric formulae list to a simple formulae list.
 * 
 */
+!convert_parametric_formulae_to_simple_formula(PW,Out)
	:
		PW 	= [Head|Tail] &
		Head= property(F,T)
	<-
		!convert_parametric_formulae_to_simple_formula(Tail,OutTwo);
		!convert_parametric_to_simple_formula( Head, [], [], SF);
		.concat([SF], OutTwo, Out);
	.

+!convert_parametric_formulae_to_simple_formula(PW,Out)
	:	PW 	= []
	<-	Out = [];
	.

/**
 * [davide]
 * 
 * conversione di una lista di formule
 */
+!convert_parametric_to_simple_formula(ParamLogicFormulae,Variables,AssignmentSet,LogicFormula)
	:
		ParamLogicFormulae = [Head|Tail]
	<-
		!convert_parametric_to_simple_formula(Tail,Variables,AssignmentSet,LogicFormulaRec);
		!convert_parametric_to_simple_formula(Head,Variables,AssignmentSet,LogicFormulaHead);
		.concat([LogicFormulaHead],LogicFormulaRec,LogicFormula);
	.
+!convert_parametric_to_simple_formula(ParamLogicFormulae,Variables,AssignmentSet,LogicFormula)
	:	ParamLogicFormulae 	= []
	<-	LogicFormula 		= []
	.	

/**
 * [luca]
 * 
 * TODO inserire descrizione...
 */
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
		ParamLogicFormula = and(ParametricOperands)
	<-
		!convert_parametric_to_simple_list(ParametricOperands,Variables,AssignmentSet,Operands);
		LogicFormula = and(Operands);
	.
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
		ParamLogicFormula = or(ParametricOperands)
	<-
		!convert_parametric_to_simple_list(ParametricOperands,Variables,AssignmentSet,Operands);
		LogicFormula = or(Operands);
	.
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
		ParamLogicFormula = neg(ParametricOperand)
	<-
		!convert_parametric_to_simple_formula(ParametricOperand,Variables,AssignmentSet,Operand);
		LogicFormula = neg(Operand);
	.
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
		ParamLogicFormula = property(Functor,Terms)
	<-
		!convert_terms_to_statements(Terms,Variables,AssignmentSet,Statements);
		st.denormalize_predicate(Functor,Statements,LogicFormula);
	.
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
 		ParamLogicFormula = equal(Double1,Double2)
	<-
		!convert_terms_to_statements([Double1,Double2],Variables,AssignmentSet,[SDouble1,SDouble2]);
		if (SDouble1=SDouble2) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.	
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
 		ParamLogicFormula = greater_than(Double1,Double2)
	<-
		!convert_terms_to_statements([Double1,Double2],Variables,AssignmentSet,[SDouble1,SDouble2]);
		if (SDouble1>SDouble2) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.	
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
 		ParamLogicFormula = lower_than(Double1,Double2)
	<-
		!convert_terms_to_statements([Double1,Double2],Variables,AssignmentSet,[SDouble1,SDouble2]);
		if (SDouble1<SDouble2) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.	
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
 		ParamLogicFormula = greater_eq(Double1,Double2)
	<-
		!convert_terms_to_statements([Double1,Double2],Variables,AssignmentSet,[SDouble1,SDouble2]);
		if (SDouble1>=SDouble2) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.	
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
 		ParamLogicFormula = lower_eq(Double1,Double2)
	<-
		!convert_terms_to_statements([Double1,Double2],Variables,AssignmentSet,[SDouble1,SDouble2]);
		if (SDouble1<=SDouble2) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.	
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
 		ParamLogicFormula = between(Double1,Double2,Double3)
	<-
		!convert_terms_to_statements([Double1,Double2,Double3],Variables,AssignmentSet,[SDouble1,SDouble2,SDouble3]);
		if (SDouble1>=SDouble2 & SDouble1<=SDouble3) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
		ParamLogicFormula = data_earlier_than(Date1,Date2)
	<-
		//.println("receive",Date1,",",Date2);
		!convert_terms_to_statements([Date1,Date2],Variables,AssignmentSet,[SDate1,SDate2]);
		
		//.println("converto into ",SDate1,",",SDate2);

		if (earlier(SDate1,SDate2)) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
		ParamLogicFormula = data_is(Date1,Date2)
	<-
		!convert_terms_to_statements([Date1,Date2],Variables,AssignmentSet,[SDate1,SDate2]);
		SDate1 = dt(YYYY1,MM1,DD1,_,_,_);
		SDate2 = date(YYYY2,MM2,DD2);
		
		if ( (YYYY1 = YYYY2) & (MM1 = MM2) & (DD1 = DD2) ) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	:
		ParamLogicFormula = morning(Date)
	<-
		!convert_terms_to_statements([Date],Variables,AssignmentSet,[SDate]);
		SDate = dt(YYYY,MM,DD,HH,M,SS);
		
		if ( HH>=7 & HH<12 ) {
			LogicFormula=true;
		} else {
			LogicFormula=false;
		}
	.
+!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula)
	<-
		LogicFormula=ParamLogicFormula;
	.
		
/* OK */
+!debug_convert_parametric_to_simple_formula 
	<- 
		!convert_parametric_to_simple_formula(  property(visited,[luca,city,duration]),
												[city,duration],
												[assign(city,palermo),assign(duration,2)],
												LogicFormula);												 
		.println(LogicFormula); 
	.



+!convert_parametric_to_simple_list(ParametricOperands,Variables,AssignmentSet,Operands)
	:
		ParametricOperands=[]
	<-
		Operands=[];
	.
+!convert_parametric_to_simple_list(ParametricOperands,Variables,AssignmentSet,Operands)
	:
		ParametricOperands=[ Head | Tail ]
	<-
		!convert_parametric_to_simple_formula(Head,Variables,AssignmentSet,HeadLogicFormula);
		!convert_parametric_to_simple_list(Tail,Variables,AssignmentSet,TailLogicFormula);
		Operands = [HeadLogicFormula | TailLogicFormula];
	.

 /**
 * [davide]
 * 
 * DEBUG PLAN for !assemble_par_condition_from_accumulation
 */
+!debug_convert_simple_condition_to_par_condition
	<-
		!convert_simple_condition_to_par_condition(world([p(x),q(y,j)]), PA);
		.print("PA: ",PA);	
	.

/**
 * passo 1
 * 
 * [davide]
 * 
 * Convert a condition, for example
 * 	
 * 		run(John)
 * 
 * into a par_condition, that is
 * 	
 * 		par_condition([],[property(run,[John])])
 */
+!convert_simple_condition_to_par_condition(CN,CNP)
	:
		CN=condition(CNS)
	<-
		!normalize_world_statement([CNS], NormalizedCNS);			//Normalize WS
		CNP = par_condition([],NormalizedCNS);						//Assemble the output par_condition
	.
+!convert_simple_condition_to_par_condition(CN,CNP)
	:	CN 	= par_condition(_,_)
	<-	CNP = CN
	.	


	