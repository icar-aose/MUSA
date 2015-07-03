

/**
 * Debug plans for testing normalize_world_statement plan
 */
+!run_debug_normalize_world_statement_test
	<-
		.print("\n~~~~~~~~\nTESTING normalize_world_statement\n~~~~~~~~");
		!debug_normalize_world_statement_1;
		!debug_normalize_world_statement_2;
		!debug_normalize_world_statement_3;
		!debug_normalize_world_statement_4;
		!debug_normalize_world_statement_5;
		.print("\n~~~~~~~~\nTEST SUCCESS\n~~~~~~~~");
	.
+!debug_normalize_world_statement_1
	<-
		.print("\n~~~~~normalize_world_statement_test 1");
		!normalize_world_statement( [and([done(secure_injured), done(assess_explosion_hazard), done(assess_fire_hazard)])], NormalizedWS ); 
		.print("NormalizedWS (Test 1): ",NormalizedWS);
	.
+!debug_normalize_world_statement_2
	<-
		.print("\n~~~~~normalize_world_statement_test 2");
		!normalize_world_statement([ and([done(g(y)),f(x)])  ], NormalizedWS);
		.print("NormalizedWS (Test 2): ",NormalizedWS);
	.
+!debug_normalize_world_statement_3
	<-
		.print("\n~~~~~normalize_world_statement_test 3");
		!normalize_world_statement([done(f(a(move(operator,ciao))))], NormalizedWS);
		.print("NormalizedWS (Test 3): ",NormalizedWS);
	.
+!debug_normalize_world_statement_4
	<-
		.print("\n~~~~~normalize_world_statement_test 4");
		!normalize_world_statement([move(operator,ciao)], NormalizedWS);
		.print("NormalizedWS (Test 4): ",NormalizedWS);
	.
+!debug_normalize_world_statement_5
	<-
		.print("\n~~~~~normalize_world_statement_test 5");
		!normalize_world_statement([done(move(operator,ciao))], NormalizedWS);
		.print("NormalizedWS (Test 5): ",NormalizedWS);
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for !get_new_par_world(PWS,AssignmentSet, OutPWS)
 */
+!debug_get_new_par_world
	<-
		!get_new_par_world([property(p,[y,t]),property(q,[z,r])],
						   [assignment(y,x),assignment(t,a)//,
						   	//assignment(z,m),assignment(r,n)
						   ], OutPWS);
		.print("OutPW:",OutPWS);
	.