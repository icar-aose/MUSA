/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: plans for handling http interaction
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * 
 *
 * TODOs:
 * - inserire in do_find_substitution_for_par_condition il controllo sulla sostituzione in ingresso. Piu precisamente, se la sostituzione in uscita è uguale
 *   a quella in ingresso, l'algoritmo resituisce false.
 *
 * - propagazione dell'errore in do_find_substitution_for_par_condition
 *
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/

{ include( "core/par_condition.asl" ) }

// HOW TO WRITE SIMPLE CONDITIONS

// Condition = condition( formula )

// where 'formula' is:
// and([formulae]), or([formulae]), neg(formula)
// functor(terms)
// true, false



// HOW TO WRITE PARAMETRIC CONDITIONS

// ParametricCondition = par_condition( [list of variables], formula )

// where 'formula' is:
// and([formulae]), or([formulae]), neg(formula)
// functor(terms)
// property( functor, [terms] )
// equal(double,double)
// greater_than(double,double)
// lower_than(double,double)
// greater_eq(double,double)
// lower_eq(double,double)
// between(double,double,double)
// true, false



/**
 * Calculate the relevance "score", that is, the headPercent value, for a (par)condition.
 * 
 */
+!elaborate_condition_truth_percent(Condition,World,Percent)
	:
		Condition = condition(LogicFormula)
	<-
		!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent);
	. 
	
/**
 * [luca]
 * 
 */
+!elaborate_condition_truth_percent(Condition,Accumulation,Percent)
	:
		Condition 		= par_condition(Variables,ParamLogicFormula) &
		Accumulation 	= accumulation(world(WS), par_world(Vars,PWS), assignment_list(AssignmentList))
	<-
		//!check_if_condition_triggers_on_accumulation(GoalCondition, Accumulation, InputAssignment, OutAssignment, Goal_is_satisfied, Percent)
		!check_if_condition_triggers_on_accumulation(Condition, Accumulation, [], _, _, Percent);
	. 

+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = and(Operands) | LogicFormula = or(Operands)
	<-
		//.println(LogicFormula,World,Percent);
		!elaborate_truth_percent_logic_and(Operands,World,PercentList);
		!calculate_average(PercentList,Percent);
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = neg(NegLogicFormula)
	<-
		!elaborate_logic_formula_truth_percent(NegLogicFormula,World,NegPercent);
		!invert_percent(NegPercent,Percent);
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:	LogicFormula = true
	<-	Percent = 1;
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:	LogicFormula = false
	<-	Percent = 0;
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,World,Percent)
	:
		LogicFormula = Statement
	&	World = world( StateOfWorld )
	&	.member(Statement,StateOfWorld)
	<-
		Percent = 1;
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,StateOfWorld,Percent)
	:
		LogicFormula = Statement
	&	.list(StateOfWorld)
	&	.member(Statement,StateOfWorld)	
	<-
		Percent = 1;
	.
+!elaborate_logic_formula_truth_percent(LogicFormula,StateOfWorld,Percent)
	<-
		Percent = 0;
	.

+!elaborate_truth_percent_logic_and(Operands,World,PercentList)
	:
		Operands=[]
	<-
		PercentList = [];
	.
+!elaborate_truth_percent_logic_and(Operands,World,PercentList)
	:
		Operands=[ Head | Tail ]
	<-
		!elaborate_logic_formula_truth_percent(Head,World,HeadPercent);
		!elaborate_truth_percent_logic_and(Tail,World,TailPercentList);
		
		PercentList=[HeadPercent | TailPercentList];
	.
	
+!elaborate_truth_percent_logic_or(Operands,World,PercentList)
	:
		Operands=[]
	<-
		PercentList = [];
	.
+!elaborate_truth_percent_logic_or(Operands,World,PercentList)
	:
		Operands=[ Head | Tail ]
	<-
		!elaborate_logic_formula_truth_percent(Head,World,HeadPercent);
		!elaborate_truth_percent_logic_or(Tail,World,TailPercentList);
		
		PercentList=[HeadPercent | TailPercentList];
	.

/*
 * [davide]
 *  
 * Test a condition (simple or parametric) in a given accumulation state. Note that
 * possible assignment must be applied on the accumulation before using this plan.
 * 
 */ 
+!test_condition(Condition,Accumulation,Bool)
	:
		Condition 		= condition(LogicFormula)				&
		Accumulation 	= accumulation(world(WS),_,_)
	<-
		!test_logic_formula(LogicFormula, WS, Bool);
	.
+!test_condition(Condition,WorldStatement,Bool)
	:
		Condition 		= condition(LogicFormula)
	<-
		!test_logic_formula(LogicFormula, WorldStatement, Bool);
	.
+!test_condition(Condition,Accumulation,Bool)
	:
		Condition 		= par_condition(Variables,ParamLogicFormula)
	<-
		!test_parametric_condition(Condition,[],Accumulation,Bool);
	. 
+!test_condition(ParCondition,AssignmentSet,Accumulation,Bool)
	:
		ParCondition 		= par_condition(Variables,ParamLogicFormula)
	<-
		!test_parametric_condition(ParCondition,AssignmentSet,Accumulation,Bool);
	. 

/**
 * [luca]
 * 
 * TODO inserire descrizione...
 */
+!convert_terms_to_statements(Terms,Variables,AssignmentSet,Statements)
	:	Terms = []
	<-	Statements= [];
	.
+!convert_terms_to_statements(Terms,Variables,AssignmentSet,Statements)
	:
		Terms = [ Head | Tail ]
	&	.member(Head,Variables)
	<-
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,Head,Value);
		!convert_terms_to_statements(Tail,Variables,AssignmentSet,TailStatements);
		Statements=[Value | TailStatements];
	.
+!convert_terms_to_statements(Terms,Variables,AssignmentSet,Statements)
	:
		Terms = [ Head | Tail ]
	<-
		!convert_terms_to_statements(Tail,Variables,AssignmentSet,TailStatements);
		Statements=[Head | TailStatements];
	.


/**
 * [davide]
 * 
 * DEBUG PLAN for +!unroll_condition_formulae
 */
+!debug_unroll_condition_formulae
	<-
		Formulae = and([received_order(order_id,user_id),true]);
		
		!unroll_condition_formulae(Formulae, OutFormulae);		
		
		.print("Input formula: ",Formulae);
		.print("Out formula: ",OutFormulae);
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
 * 
 * ---> INUTILIZZATA <---
 */
+!unroll_condition_formulae(Formula, OutParCondition)
	<-
		!unroll_condition_formulae(Formula, OutParCondition, _);
	.
	
+!unroll_condition_formulae(Formula, OutParCondition, NegFlag)
	:
		Formula = [Head|Tail]
	<-
		!unroll_condition_formulae(Head, OutParConditionH, NegFlag);
		!unroll_condition_formulae(Tail, OutParConditionT, NegFlag);
		.concat(OutParConditionH, OutParConditionT, OutParCondition);
	.

+!unroll_condition_formulae(Formula, OutParCondition, NegFlag)
	:	Formula = and(List) | Formula = or(List)
	<-	!unroll_condition_formulae(List, OutParCondition, NegFlag)
	.

+!unroll_condition_formulae(Formula, OutParCondition, NegFlag)
	:
		Formula = neg(List)
	<-
		if(NegFlag = false)		{ N=true; }
		else					{ N=false; }
		
		!unroll_condition_formulae(List, OutParCondition, N);
	.

+!unroll_condition_formulae(Formula, OutParCondition, NegFlag)
	:	not .list(Formula) & NegFlag = true
	<-	OutParCondition = [Formula];
	.
+!unroll_condition_formulae(Formula, OutParCondition, NegFlag)
	:	not .list(Formula) & NegFlag = false
	<-	OutParCondition = [];
	.	
+!unroll_condition_formulae(Formula, OutParCondition, NegFlag)
	:	Formula 			= []
	<-	OutParCondition 	= [];
	.
+!unroll_condition_formulae(Formula, OutParCondition, NegFlag)
	<-	Formula = OutParCondition;
	.


/**
 * [luca]
 * 
 * TODO inserire descrizione...
 */
+!unroll_assignments_to_get_value_for_variable(AssignmentSet,Variable,Value)
	:	AssignmentSet 	= []
	<-	Value 			= null;
	.
+!unroll_assignments_to_get_value_for_variable(AssignmentSet,Variable,Value)
	:
		AssignmentSet=[ Head | Tail ]
	&	Head=assign(FreeVariable,ConstantValue)
	<-
		//.println("comparing ",Head," with ",Variable);
		if (FreeVariable = Variable) {
			Value=ConstantValue;
		} else {
			!unroll_assignments_to_get_value_for_variable(Tail,Variable,Value);
		}	
	.


+!test_logic_formula(LogicFormula,WorldStatement,Bool)
	:
		not .ground(LogicFormula)
	<-
		.print("[conditions->test_logic_formula] ",LogicFormula," is not bounded\n\n");
		.wait(50000);
		Bool = false;
		
	.

+!test_logic_formula(LogicFormula,WorldStatement,Bool)
	:	
		.list(WorldStatement)	
	<-
		!test_logic_formula(LogicFormula,world(WorldStatement),Bool);
	.	
+!test_logic_formula(LogicFormula,WorldStatement,Bool)
	:	
		LogicFormula = [Head|_]	
	<-
		!test_logic_formula(Head,WorldStatement,Bool);
	.	
+!test_logic_formula(LogicFormula,World,Bool)
	:
		LogicFormula = and(Operands)
	<-
		!test_logic_and(Operands,World,Bool);
	.
+!test_logic_formula(LogicFormula,World,Bool)
	:
		LogicFormula = or(Operands)
	<-
		!test_logic_or(Operands,World,Bool);
	.
+!test_logic_formula(LogicFormula,World,Bool)
	:
		LogicFormula = neg(NegLogicFormula)
	<-
		!test_logic_formula(NegLogicFormula,World,NegBool);
		!logic_not(NegBool,Bool);
	.
+!test_logic_formula(LogicFormula,World,Bool)
	:
		LogicFormula = true | LogicFormula = false
	<-
		Bool = LogicFormula;
	.

/**
 * [Patrizia]
 */
+!test_logic_formula(LogicFormula,World,Bool)
	:
		LogicFormula 	= after(Statement)
	&	World 			= world( StateOfWorld )
	<-
		//.println("111111");
		if (.member(Statement,StateOfWorld)) 	{	Bool = true;} 
		else 									{	Bool = false;}
		//.println(LogicFormula," : ",Bool);
	.
/**
 * [Patrizia]
 * 
 * before is satisfied only if it is not contained within the world state
 */
+!test_logic_formula(LogicFormula,World,Bool)
	:
		LogicFormula 	= before(Statement)
	&	World 			= world( StateOfWorld )
	<-
		//.println("222222");
		if (.member(Statement,StateOfWorld)) 	{	Bool = false;} 
		else 									{	Bool = true;}
		//.println(LogicFormula," : ",Bool);
	.

+!test_logic_formula(LogicFormula,World,Bool)
	:
		LogicFormula 	= Statement
	&	World 			= world( StateOfWorld )
	<-
		//.print("Testing logic formula ",LogicFormula," ...");
		if (.member(Statement,StateOfWorld)) 
		{
			Bool = true;
			//.print("Statement ",Statement," is member of ",StateOfWorld);
		} 
		else 
		{
			Bool = false;
		}
		//.println(Statement," : ",Bool);
	.

+!test_logic_and(Operands,World,Bool)
	:	Operands	= []
	<-	Bool 		= true;
	.
+!test_logic_and(Operands,World,Bool)
	:
		Operands=[ Head | Tail ]
	<-
		!test_logic_formula(Head,World,HeadBool);
		!test_logic_and(Tail,World,TailBool);
		!logic_and(HeadBool,TailBool,Bool);
	.
	
+!test_logic_or(Operands,World,Bool)
	:
		Operands=[]
	<-
		Bool = false;
	.
+!test_logic_or(Operands,World,Bool)
	:
		Operands=[ Head | Tail ]
	<-
		!test_logic_formula(Head,World,HeadBool);
		!test_logic_or(Tail,World,TailBool);
		!logic_or(HeadBool,TailBool,Bool);
	.