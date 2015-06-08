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
 * DEBUG PLAN for apply_unification_to_property
 */
+!debug_apply_unification_to_property
	<-
		!apply_unification_to_property([x,b],[assignment(x,a),assignment(m,z)],OutTerms);
		.print("Out: ",OutTerms);
	.
	
/**
 * DEBUG PLAN FOR exists_assignment_for_commitment
 */
+!debug_exists_assignment_for_commitment
	<-
		!find_assignment_for_commitment(print, [assignment(msg,"wella"),assignment(a,x)], OutAssignment);
		.print("OutAssignment: ",OutAssignment);	
	
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
		
		!find_substitution_for_par_condition( par_condition([a,b], and([property(p,[a]), property(f,[b,a])]) ),
							  				  par_condition([m],   and([property(p,[c]), neg(property(h,[m]))     ]) ),
											  [assignment(a,c),assignment(a,d)],
											  OutAssignment,
											  Success);
		
		.print("success: ",Success);
		.print("OutputAssignment: ",OutAssignment);
	.
/**-----------------------------------------------------------------------------------------------------*/

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
	
/* OK */
+!debug_convert_parametric_to_simple_formula 
	<- 
		!convert_parametric_to_simple_formula(  property(visited,[luca,city,duration]),
												[city,duration],
												[assign(city,palermo),assign(duration,2)],
												LogicFormula);												 
		.println(LogicFormula); 
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