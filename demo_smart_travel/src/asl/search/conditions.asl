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

+!test_condition(Condition,World,Bool)
	:
		Condition = condition(LogicFormula)
	<-
		!test_logic_formula(LogicFormula,World,Bool);
	. 
+!test_condition(Condition,World,Bool)
	:
		Condition = par_condition(Variables,ParamLogicFormula)
	<-
		!deduct_assignments_from_world(World,Condition,[],AssignmentSet,_);
		!test_parametric_condition(Condition,AssignmentSet,World,Bool);
	. 
/* OK */
+!debug_test_condition <- !test_condition(condition( and([s1,neg(s6),or([s5,s7]) ]) ) ,world([s1,s4,s7]) ,Bool); .println(Bool).
+!debug_test_condition_2 <- !test_condition(condition( and([true,neg(false),or([s5,s7]) ]) ) ,world([s1,s4,s7]) ,Bool); .println(Bool).
+!debug_test_condition_3 <- !test_condition(
	par_condition([datetime],and([property(it_is,[datetime]),data_is(datetime,date(2014,2,20))])),
	world([it_is(dt(2014,2,20,8,30,0))]),
	Bool
); .println(Bool).
+!debug_test_condition_4 <- !test_condition(
	par_condition([visittime],and([property(visited,[catania,visittime]),greater_than(visittime,1)])),
	world([visited(catania,1.5)]),
	Bool
); .println(Bool).
+!debug_test_condition_5 <- !test_condition(
	par_condition([datetime], and([being_at(catania), property(it_is,[datetime]),data_is(datetime,date(2014,2,22))])),
	world([being_at(catania),cost(470.25),it_is(dt(2014,2,22,8,30,0)),visited(catania,2),visited(palermo,2),visited(siracusa,1)]),
	Bool
); .println(Bool).


+!test_parametric_condition(PCN,AssignmentSet,World,Bool)
	:
		PCN = par_condition(Variables,ParamLogicFormula)
	<-
		!unroll_variables_to_check_bound(Variables,AssignmentSet,BoundBool);
		//.println("bound: ",BoundBool);
		
		if (BoundBool=true) {
		
			!convert_parametric_to_simple_formula(ParamLogicFormula,Variables,AssignmentSet,LogicFormula);
			//.println("converted formula: ",LogicFormula);
			!test_logic_formula(LogicFormula,World,Bool);
			
		} else {
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



+!deduct_assignments_from_world(World,PCN,InputAssignmentSet,OutputAssignmentSet,Bool)
	<-
		PCN = par_condition(Parameters,ParamLogicFormula);
		!unroll_variables_to_deduct_values(Parameters,PCN,World,InputAssignmentSet,OutputAssignmentSet,Bool);
	.
+!debug_deduct_assignments_from_world <- !deduct_assignments_from_world(
	world([being_at(palermo),visited(palermo,2),it_is(dt(2014,2,17,8,30,00))]),
	par_condition([datetime],and([property(it_is,[datetime])] )),
	[],
	OutputAssignmentSet,Bool
); .println(Bool); .println(OutputAssignmentSet); .
+!debug_deduct_assignments_from_world_2 <- !deduct_assignments_from_world(
	world([being_at(palermo),it_is(dt(2014,2,16,12,30,0)),visited(palermo,0.5),done(visit_half_day_morn,palermo,16)]),
	par_condition([datetime],and([property(it_is,[datetime]), data_earlier_than(datetime,dt(2014,2,23,00,00,00))] )),
	[],
	OutputAssignmentSet,Bool
); .println(Bool); .println(OutputAssignmentSet); .



+!unroll_variables_to_deduct_values(Variables,PCN,World,InputAssignmentSet,OutputAssignmentSet,Bool)
	:
		Variables=[]
	<-
		//.println("all variables are assigned: ",InputAssignmentSet);
		
		//.println("testing: ",PCN," in world ",World, " with Ass:",InputAssignmentSet);
		!test_parametric_condition(PCN,InputAssignmentSet,World,AssignValidityBool);
		
		//.println("test over world: ",AssignValidityBool);
		
		//!check_assignment_set(InputAssignmentSet,ParamLogicFormula,WorldStatements,AssignValidityBool);
		if (AssignValidityBool=true) {
			OutputAssignmentSet=InputAssignmentSet;
			Bool=true;
		} else {
			OutputAssignmentSet=[];
			Bool=false;
		}	
	.
+!unroll_variables_to_deduct_values(Variables,PCN,World,InputAssignmentSet,OutputAssignmentSet,Bool)
	:
		Variables=[ Head | Tail ]
		
	<-
		//.println("considering variable: ",Head);
		
			
		PCN = par_condition(Parameters,ParamLogicFormula);
		//.println("PNC: ",PCN);
		
		World=world(WorldStatements);
		//.println("World: ",World," that is ",WorldStatements);
		
		!unroll_world_to_deduct_assignments_from_world(WorldStatements,Head,ParamLogicFormula,HeadAlternativeValues);
		
		//.println("possible values: ",HeadAlternativeValues);
		
		!unroll_assign_alternatives(HeadAlternativeValues,Head,Tail,PCN,World,InputAssignmentSet,OutputAssignmentSet,Bool);
	.

+!unroll_assign_alternatives(AlternativeValues,Variable,OtherVariables,PCN,World,InputAssignmentSet,OutputAssignmentSet,Bool)
	:
		AlternativeValues=[]
	<-
		//.println("no more values for variable: ",Variable);
		OutputAssignmentSet=InputAssignmentSet;
		Bool = false;
	.
+!unroll_assign_alternatives(AlternativeValues,Variable,OtherVariables,PCN,World,InputAssignmentSet,OutputAssignmentSet,Bool)
	:
		AlternativeValues=[ Head | Tail ]
	<-
		HeadAssign = assign(Variable,Head);
		//.println("let suppose: ",HeadAssign);
		UpdatedInputAssignmentSet = [HeadAssign | InputAssignmentSet];

		!unroll_variables_to_deduct_values(OtherVariables,PCN,World,UpdatedInputAssignmentSet,TryOutputAssignmentSet,CompleteBool);
		//.println("supposition: ",HeadAssign," was ",CompleteBool);
		
		if (CompleteBool=false) {
			!unroll_assign_alternatives(Tail,Variable,OtherVariables,PCN,World,InputAssignmentSet,OutputAssignmentSet,Bool);
		} else  {
			OutputAssignmentSet = TryOutputAssignmentSet;
			Bool = true;
		}
	.		
+!debug_unroll_variables_to_deduct_values_1 <- !unroll_variables_to_deduct_values(
	[a,b,c],
	//par_condition([city,duration],property(visited,[luca,city,duration])),
	par_condition([a,b,c],and( [property(p1,[a]), property(p2,[b,c]), property(p3,[c]) ] )  ),
	world([p1(5),p2(luca,2),p3(2),p3(1)]),
	[],
	OutputAssignmentSet,Bool
); .println(OutputAssignmentSet); .println(Bool); .
+!debug_unroll_variables_to_deduct_values_2 <- !unroll_variables_to_deduct_values(
	[a,b,c],
	//par_condition([city,duration],property(visited,[luca,city,duration])),
	par_condition([a,b,c],and( [property(p1,[a]), property(p2,[b,c]), property(p3,[c]) ] )  ),
	world([p1(5),p2(luca,2),p3(3),p3(1)]),
	[],
	OutputAssignmentSet,Bool
); .println(OutputAssignmentSet); .println(Bool); .

//unroll_world_to_get_first_assignment_for_variable(world([visited(palermo,3),visited(cefalu,1)]),visit_time,property(visited,[cefalu,visit_time]),_50VisitTime)

+!unroll_world_to_get_first_assignment_for_variable(World,Variable,ParamLogicFormula,Default,Value)
	:
		World = world(WorldStatements)
	<-
		//.println(WorldStatements);
		!unroll_world_to_get_first_assignment_for_variable(WorldStatements,Variable,ParamLogicFormula,Default,Value);
	.
+!unroll_world_to_get_first_assignment_for_variable(WorldStatements,Variable,ParamLogicFormula,Default,Value)
	<-
		!unroll_world_to_deduct_assignments_from_world(WorldStatements,Variable,ParamLogicFormula,Values);
		if (Values = [Head | Tail]) {
			Value = Head;
		} else {
			Value = Default;
		}
	.
+!debug_unroll_world_to_get_first_assignment_for_variable <- !unroll_world_to_get_first_assignment_for_variable(
	world([visited(palermo,2),visited(catania,1.5)]),
	visit_time,
	property(visited,[catania,visit_time]),
	0,
	Value
); .println(Value); .


+!unroll_world_to_deduct_assignments_from_world(World,Variable,ParamLogicFormula,AlternativeValues)
	:
		World = world(WorldStatements)
	<-
		!unroll_world_to_deduct_assignments_from_world(WorldStatements,Variable,ParamLogicFormula,AlternativeValues);
	.
+!unroll_world_to_deduct_assignments_from_world(WorldStatements,Variable,ParamLogicFormula,AlternativeValues)
	:
		WorldStatements = [ ]
	<-
		AlternativeValues=[ ];
	.
+!unroll_world_to_deduct_assignments_from_world(WorldStatements,Variable,ParamLogicFormula,AlternativeValues)
	:
		WorldStatements = [ Head | Tail ]
	<-
		//.println("world statement: ",Head);
		st.normalize_predicate(Head,Functor,Terms);
		//.println("normalized statement: ",property(Functor,Terms));
		
		//.println("pushing into: ",ParamLogicFormula);
		!push(property(Functor,Terms),ParamLogicFormula,Variable,Values);
		!unroll_world_to_deduct_assignments_from_world(Tail,Variable,ParamLogicFormula,TailAlternativeValues);
		.union(Values,TailAlternativeValues,AlternativeValues)	
	.
+!debug_unroll_world_to_deduct_assignments_from_world <- !unroll_world_to_deduct_assignments_from_world(
	[visited(palermo,2),enjoyed(palermo)],
	city,
	and([property(enjoyed,[city]),property(visited,[city,duration])]),
	AlternativeValues
); .println(AlternativeValues); .
+!debug_unroll_world_to_deduct_assignments_from_world_2 <- !unroll_world_to_deduct_assignments_from_world(
	[visited(palermo,2),enjoyed(cefalu)],
	city,
	and([property(enjoyed,[city]),property(visited,[city,duration])]),
	AlternativeValues
); .println(AlternativeValues); .

+!debug_unroll_world_to_deduct_assignments_from_world_3 <- !unroll_world_to_deduct_assignments_from_world(
	[it_is(dt(2014,2,16,9,00,00)),being_at(palermo)],
	datetime,
	and([ property(being_at,[city]), property(it_is,[datetime]) ]),
	AlternativeValues
); .println(AlternativeValues); .
+!debug_unroll_world_to_deduct_assignments_from_world <- !unroll_world_to_deduct_assignments_from_world(
	[visited(palermo,2),visited(catania,1)],city,property(visited,[city,visit_time]),Values
); .println(Values); .
+!debug_unroll_world_to_deduct_assignments_from_world <- !unroll_world_to_deduct_assignments_from_world(
	[visited(palermo,2),visited(catania,1)],city,property(visited,[city,whatever]),Values
); .println(Values); .





+!push(NormStatement,ParamLogicFormula,Variable,Values)
	:
		ParamLogicFormula = and(ParametricOperands) | ParamLogicFormula = or(ParametricOperands)
	<-
		!unroll_operands_to_push(ParametricOperands,NormStatement,Variable,Values);
	.
+!push(NormStatement,ParamLogicFormula,Variable,Values)
	:
		ParamLogicFormula = neg(ParametricOperand)
	<-
		Values=[];
	.
+!push(NormStatement,ParamLogicFormula,Variable,Values)
	:
		ParamLogicFormula = property(Functor,ParTerms)
	&	NormStatement = property(Functor,Terms)
	&	.length(ParTerms,Len) & .length(Terms,Len)
	<-
		!unroll_terms_to_unify_variable(ParTerms,Terms,Variable,Values);
	.
+!push(NormStatement,ParamLogicFormula,Variable,Values)
	<-
		Values=[];
	.
+!debug_push_1 <- !push(property(visited,[palermo,2]),property(visited,[city,duration]),city,Values); .println(Values); .
+!debug_push_2 <- !push(property(visited,[palermo,2]),and([property(enjoyed,[city,duration]),property(visited,[city,duration])]),city,Values); .println(Values); .
+!debug_push_2 <- !push(property(visited,[palermo,2]),and([property(visited,[city,a]),property(visited,[city,duration])]),city,Values); .println(Values); .


+!unroll_operands_to_push(ParametricOperands,NormStatement,Variable,Values)
	:
		ParametricOperands = []
	<-
		Values=[]
	.
+!unroll_operands_to_push(ParametricOperands,NormStatement,Variable,Values)
	:
		ParametricOperands = [ Head | Tail ]
	<-
		!push(NormStatement,Head,Variable,HeadValues);
		!unroll_operands_to_push(Tail,NormStatement,Variable,TailValues);
		.union( HeadValues, TailValues, Values);
	.



+!unroll_terms_to_unify_variable(ParTerms,Terms,Variable,Values)
	:
		ParTerms = []
	<-
		Values=[]
	.
+!unroll_terms_to_unify_variable(ParTerms,Terms,Variable,Values)
	:
		ParTerms = [ HeadParTerm | TailParTerm ] & Terms=[ HeadTerm | TailTerm ]
	&	HeadParTerm = Variable
	<-
		!unroll_terms_to_unify_variable(TailParTerm,TailTerm,Variable,TailValues);
		//.println(HeadTerm);
		.union([HeadTerm],TailValues,Values);
	.
+!unroll_terms_to_unify_variable(ParTerms,Terms,Variable,Values)
	:
		ParTerms = [ HeadParTerm | TailParTerm ] & Terms=[ HeadTerm | TailTerm ]
	&	HeadParTerm = HeadTerm
	<-
		!unroll_terms_to_unify_variable(TailParTerm,TailTerm,Variable,Values);
	.
+!unroll_terms_to_unify_variable(ParTerms,Terms,Variable,Values)
	:
		ParTerms = [ HeadParTerm | TailParTerm ] & Terms=[ HeadTerm | TailTerm ]
	&	HeadParTerm = whatever
	<-
		//.println(ok);
		!unroll_terms_to_unify_variable(TailParTerm,TailTerm,Variable,Values);
	.
+!unroll_terms_to_unify_variable(ParTerms,Terms,Variable,Values)
	<-
		Values=[];
	.
/* OK */
+!debug_unroll_terms_to_unify_variable <- !unroll_terms_to_unify_variable([city,duration],[palermo,10],city,Values); .println(Values); .



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
		//.println("received ",Date1,",",Date2);
		!convert_terms_to_statements([Date1,Date2],Variables,AssignmentSet,[SDate1,SDate2]);
		
		//.println("converto into ",SDate1,",",SDate2);

		if (earlier(SDate1,SDate2)) {
			LogicFormula=true;
			//.println(SDate1," earlier than ",SDate2);
		} else {
			LogicFormula=false;
			//.println(SDate1," later than ",SDate2);
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
+!debug_convert_parametric_to_simple_formula <- !convert_parametric_to_simple_formula(property(visited,[luca,city,duration]),[city,duration],[assign(city,palermo),assign(duration,2)],LogicFormula); .println(LogicFormula); .



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



+!convert_terms_to_statements(Terms,Variables,AssignmentSet,Statements)
	:
		Terms = []
	<-
		Statements= [];
	.
+!convert_terms_to_statements(Terms,Variables,AssignmentSet,Statements)
	:
		Terms = [ Head | Tail ]
	&	.member(Head,Variables)
	<-
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,Head,Value);
		//.println(Head," : ",Value);
		!convert_terms_to_statements(Tail,Variables,AssignmentSet,TailStatements);
		Statements=[Value | TailStatements];
	.
+!convert_terms_to_statements(Terms,Variables,AssignmentSet,Statements)
	:
		Terms = [ Head | Tail ]
	<-
		//.println(Head," : constant value");
		!convert_terms_to_statements(Tail,Variables,AssignmentSet,TailStatements);
		Statements=[Head | TailStatements];
	.
/* OK */
+!debug_convert_terms_to_statements <- !convert_terms_to_statements([luca,city,duration],[city,duration],[assign(city,palermo),assign(duration,2)],Statements); .println(Statements); .


+!unroll_assignments_to_get_value_for_variable(AssignmentSet,Variable,Value)
	:
		AssignmentSet=[]
	<-
		Value=null;
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



+!unroll_variables_to_check_bound(Variables,AssignmentSet,Bool)
	:
		Variables=[]
	<-
		Bool=true
	.
+!unroll_variables_to_check_bound(Variables,AssignmentSet,Bool)
	:
		Variables=[ Head | Tail ]
	<-
		!unroll_assignment_to_check_variable( AssignmentSet, Head, HeadBool );
		!unroll_variables_to_check_bound(Tail,AssignmentSet,TailBool);
		!logic_and(HeadBool, TailBool, Bool);
	.

+!unroll_assignment_to_check_variable( AssignmentSet, Variable, Bool )
	:
		AssignmentSet=[]
	<-
		Bool = false;
	.
+!unroll_assignment_to_check_variable( AssignmentSet, Variable, Bool )
	:
		AssignmentSet=[ Head | Tail ]
	<-
		Head=assign(FreeVariable,ConstantValue);
		
		if (FreeVariable = Variable) {
			Bool = true
		} else {
			!unroll_assignment_to_check_variable( Tail, Variable, Bool );
		}
	.

+!test_logic_formula(LogicFormula,WorldStatement,Bool)
	:	
		.list(WorldStatement)	
	<-
		!test_logic_formula(LogicFormula,world(WorldStatement),Bool);
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

+!test_logic_formula(LogicFormula,World,Bool)
	:
		LogicFormula = Statement
	&	World = world( StateOfWorld )
	<-
		if (.member(Statement,StateOfWorld)) {
			Bool = true;
		} else {
			Bool = false;
		}
		//.println(Statement," : ",Bool);
	.

+!test_logic_and(Operands,World,Bool)
	:
		Operands=[]
	<-
		Bool = true;
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

	
	
	
	
