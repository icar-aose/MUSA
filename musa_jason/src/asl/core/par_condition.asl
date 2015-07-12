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
 *
 * Reported Bugs:  
 *
 ******************************************************************************/

{ include( "core/world.asl" ) }
{ include( "debug/par_condition_debug.asl") }

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
+!check_if_vars_are_assigned(Vars, AssignmentSet, Bool)
	:
		Vars = []
	<-
		Bool = true;
	.
	
/** 
 * [davide] 
 * 
 * Given a par_condition, check if all its vars has an assignment to which
 * it can be unified. If *every* var has an assignment, Bool is unified with
 * true
 */
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
 * Apply unification to a par_condition by applying assignments.
 */
+!apply_unification_to_par_condition(PC, AssignmentList, OutPC)
	:
		PC = par_condition(Vars, Formulae)
	<-
		!unroll_par_condition_formula(Formulae, UnrolledFormulae);										//Unroll the par_condition
		!apply_unification_to_par_condition_formulae(UnrolledFormulae, AssignmentList, OutFormulae,_);	//Apply the unification to the terms of every property
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
 * Unify each term within the given input term list by using a 
 * set of assiggnment.
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

/**
 * [davide]
 * 
 * Check if Elem appear as variable name in an assignment into the given
 * input assignment list.
 */
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
 * Given two par_condition, search for a unification that makes the par_conditions identical. 
 * par_conditions must be unrolled, that is, they must not have and, or or neg composite properties.
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
 * par_conditions must be unrolled, that is, they must not have and, or or neg composite properties.
 * 
 * Questo piano differisce dal presente in quanto vengono considerate la variabili in comune tra par_condition e stato
 * di accumulazione. 
 * 
 * 
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
		!search_for_property_with_the_same_functor(Head, PropertiesB, Property_with_same_functor_as_Head, Found);
		
		if(Found)
		{
			Head 								= property(Functor_A, FormulaA);								//Take the terms of property A
			Property_with_same_functor_as_Head 	= property(Functor_B, FormulaB);								//Take the terms of property B

			!create_substitution_for_properties(FormulaA, FormulaB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, AssignmentFound, SuccessSubstA);

			if(SuccessSubstA)	{Assignment = AssignmentFound;}
			else				{Assignment = [];}
		}
		else					{Assignment = [];}
		
		//recursive call
		!do_find_substitution_for_par_condition(Tail, PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentTwo, SuccessRec);
		
		.eval(Success, SuccessSubstitution & SuccessRec);
		.concat(OutAssignmentTwo, Assignment, OutAssignmentList);
	.
	
+!do_find_substitution_for_par_condition(PropertiesA, PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	:	PropertiesA = property(F,T) & .list(PropertiesB)
	<-	!do_find_substitution_for_par_condition([PropertiesA], PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	.
+!do_find_substitution_for_par_condition(PropertiesA, PropertiesB, Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	:	PropertiesA = property(F,T) & not .list(PropertiesB)
	<-	!do_find_substitution_for_par_condition([PropertiesA], [PropertiesB], Par_condition_A_vars, Par_condition_B_vars, InAssignment, OutAssignmentList, Success)
	.
+!do_find_substitution_for_par_condition(PropertiesA, PropertiesB, Par_condition_A_vars, Par_condition_B_vars,InAssignment, OutAssignmentList, Success)
	:	PropertiesA 		= []
	<-	OutAssignmentList 	= [];
	.
	
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
 * Create a substitution for the term lists of two properties that has the same functor.
 * VarA and VarB are the lists of variable in the par_condition containing the properties
 * related to the given term lists. 
 * 
 * Return:
 * 	- OutAssignment -> a list of assignment.
 * 
 * Notes:
 * 	- TermsA and TermsB are assumed to be related to two properties that have THE SAME functor.
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
			if(Head==HeadB)
			{
				//Terms A and B are equal. In this case we have an identity substitution.
				A = [assignment(Head,HeadB)];
				SuccessLocal= true;	
			}
			else
			{
				A			= [];
				SuccessLocal= false;
			}
		}
		else
		{
			if( .member(Head, VarA) & .member(HeadB, VarB) )										//both terms are variables
			{
				if(VB){.print("[create_substitution_for_properties] Both terms are vars. TermsA: ",TermsA," TermsB: ",TermsB);}
				!check_if_assignment_list_contains(Head,	InAssignment, AssignmentForA, ExistsAssignmentForA);		//Check if var A has been already unified (that is, an assignment for A already exists)
				!check_if_assignment_list_contains(HeadB, 	InAssignment, AssignmentForB, ExistsAssignmentForB);		//Check if var B has been already unified (that is, an assignment for B already exists)
				
				if(ExistsAssignmentForA == true & ExistsAssignmentForB == false)												
				{
					AssignmentForA = assignment(_,ValA);												
					A = [assignment(HeadB,ValA)];
				}
				else
				{
					if(ExistsAssignmentForA == false & ExistsAssignmentForB == true)
					{
						AssignmentForB = assignment(_,ValB);
						A = [assignment(Head,ValB)];
					}
					else
					{
						A = [assignment(Head,HeadB)];					//Both A and B doesn't have an assignment. So, Create a new assignment.
					}
				}
				SuccessLocal = true;
			}
			else
			{
				if( .member(Head, VarA) & not .member(HeadB, VarB) )	{A = [assignment(Head,HeadB)];}			//A is variable, B is not variable
				else													{A = [assignment(HeadB,Head)];}			//A is not variable, B is variable
				SuccessLocal=true;
			}
		}
		!create_substitution_for_properties(Tail,TailB,VarA,VarB,InAssignment, OutAssignmentRec, SuccessRec);		//Recursive call on the rest of terms in termsA
		
		.eval(Success,SuccessLocal & SuccessRec);
		
		if(VB)
		{
			.print("[create_substitution_for_properties] Created assignment A: ",A," between terms ",TermsA," and ",TermsB);
			.print("[create_substitution_for_properties] InAssignment? ",InAssignment);
		}
		if(not .member(A,InAssignment))
		{
			.union(OutAssignmentRec, A, OutAssignment);
//			if(Head\==HeadB) 	{.concat(OutAssignmentRec,A,OutAssignment);}
//			else				{.concat(OutAssignmentRec,[],OutAssignment);}	
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
 * AssignmentSet	=> [assignment(Var, Val),...]
 * World 			=> accumulation state accumulation(world(WS),par_world(Vars,Properties),AssignmentSet)
 * Bool				=> Output boolean value
 */
+!test_parametric_condition(PCN,AssignmentSet,World,Bool)
	:
		PCN = par_condition(Variables,ParamLogicFormula)			
	<-
		//Check if every variable has a corresponding assignment
		!check_if_vars_are_assigned(Variables,AssignmentSet,BoundBool);
		
		//If all variables are bounded
		if (BoundBool)
		{
			//convert the input parametric condition to a simple formula using the input assignment set
//			!convert_parametric_to_simple_formula(ParamLogicFormula, Variables, AssignmentSet, LogicFormula);
			!check_if_par_condition_addresses_accumulation(PCN, World, [], [], OutAssignment, Bool, _);			
		} 
		else 
		{
			Bool = false;
		}		
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
+!convert_simple_condition_list_to_par_conditions(CNlist,CNPlist)
	:
		CNlist = [Head|Tail]
	<-
		!convert_simple_condition_list_to_par_conditions(Tail,CNPlistRec);
		!convert_simple_condition_to_par_condition(Head,CNP);
		.union(CNPlistRec,[CNP],CNPlist);
	.
+!convert_simple_condition_list_to_par_conditions(CNlist,CNPlist)
	:
		CNlist=[]
	<-
		CNPlist = [];
	.
	
+!convert_simple_condition_to_par_condition(CN,CNP)
	:
		CN=condition(CNS)
	<-
		!normalize_world_statement([CNS], NormalizedCNS);			//Normalize WS
		CNP = par_condition([],NormalizedCNS);						//Assemble the output par_condition
	.
+!convert_simple_condition_to_par_condition(CN,CNP)
	:
		CN=Statement
	<-
		!normalize_world_statement([Statement], NormalizedCNS);			//Normalize WS
		CNP = par_condition([],NormalizedCNS);						//Assemble the output par_condition
	.
+!convert_simple_condition_to_par_condition(CN,CNP)
	:	CN 	= par_condition(_,_)
	<-	CNP = CN
	.
	
	
	
+!unroll_par_condition_to_get_properties(PCL, Properties)
	:
		PCL 	= [Head|Tail]				&
		Head 	= par_condition([],PC)
	<-
		!unroll_par_condition_to_get_properties(Tail, PropertiesRec);
		.union(PC,PropertiesRec,Properties);
	.
+!unroll_par_condition_to_get_properties(PCL, Properties)
	:
		PCL 	= []
	<-
		Properties = [];
	.
	