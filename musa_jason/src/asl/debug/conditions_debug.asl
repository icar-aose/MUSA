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



+!debug_test_condition_6
	<-
		CN 	= par_condition([order_id,user_id],property(order_placed,[order_id,user_id]));
		Acc	= accumulation(world([order_placed(order,user),received_order(order,user)]),par_world([],[]),assignment_list([]));
		
//		!test_condition(CN, [], Acc, Bool);
		!check_if_par_condition_addresses_accumulation(CN, Acc, [], [], OutAssignment, Bool, _);
		
		.print("--->",Bool);
	.


+!debug_truth_percent_1 
	<-
		!elaborate_condition_truth_percent(
			condition( and([s1,neg(s6),or([s5,s7]) ]) ),
			world([s1,s4,s7]),
			Percent
		);
		.println(Percent);
	.
+!debug_truth_percent_2 
	<-
		!elaborate_condition_truth_percent(
			condition( and([s1,neg(s6),or([s5,s7]) ]) ),
			world([s4,s7]),
			Percent
		);
		.println(Percent);
	.
+!debug_truth_percent_3 
	<-
		!elaborate_condition_truth_percent(
			condition( and([s1,neg(s6),or([s5,s7]) ]) ),
			world([s4,s6]),
			Percent
		);
		.println(Percent);
	.
+!debug_truth_percent_4 
	<-
		!elaborate_condition_truth_percent(
			condition( or( [ and( [available(doc),classified(doc)]), incomplete(doc)]) ),
			world([available(doc),classified(doc)]),
			Percent
		);
		.println(Percent);
	.

/* OK */
+!debug_convert_terms_to_statements 
	<- 
		!convert_terms_to_statements([luca,city,duration],[city,duration],[assign(city,palermo),assign(duration,2)],Statements); 
		.println(Statements); 
	.

	