{ include( "search/search_algorithm.asl" ) }
{ include( "smart_travel_capabilities.asl" ) }
{ include( "smart_travel_norms_metrics.asl" ) }
{ include( "smart_travel_sicily_data.asl" ) }

/* search configuration */
search_number_of_steps(5000).
search_number_of_solutions(5).
search_max_depth(24).

/* used for statistics */
depth(0).
branch([]).
size([]).
first_solution(0).
total_step(0).


!test.

+!test
	<-
		.println("** INITIALIZE TEST FOR SMART TRAVEL DEMO **");
		!log_capabilities;
		
		
		!debug_search_with_many_goals;
	
		!reset_stats;
		!debug_search_with_few_goals;

		!reset_stats;
		!debug_search_with_few_goals_ct;

		!reset_stats;
		!debug_search_with_few_goals_ct_sy;

		!reset_stats;
		!debug_search_with_few_goals_ct_sy_me;
		
		
	.

+!log_capabilities
	<-
		.findall(Cap,agent_capability(Cap)[type(Simple)],CapList);
		.println("List of available capabilities/services");
		for ( .member(X,CapList) ) {
			.println(X);
		}		
	.
	
+!reset_stats
	<-
		-+depth(0);
		-+branch([]);
		-+size([]);
		
		-+first_solution(0);
		-+total_step(0);
	.
	
+!log_stat_solutions(Name,OutSolutions)
	<-
		.length(OutSolutions,Len);
		
		?depth(Depth);
		
		?branch(BranchList);
		!calculate_average(BranchList,AverageBranch);
		.max(BranchList,MaxBranch);
		
		?size(SizeList);
		!calculate_average(SizeList,AverageSize);
		.max(SizeList,MaxSize);
		
		?first_solution(First);
		?total_step(Total);

		.println("Statistics:");
		.println(Name,";",Len,";",First,";",Total,";",Depth,";",AverageBranch,";",AverageSize,";",MaxSize);

		
		.println("Discovered Solution: ",Len);	
		.println("First Solution: ",First);	
		.println("Total Steps: ",Total);	
		.println("Max Depth: ",Depth);	
		.println("AverageBranch: ",AverageBranch);
		.println("AverageSize: ",AverageSize);	
		.println("MaxSize: ",MaxSize);
		.println("MaxBranch: ",MaxBranch);
		.println("------------------------------");
		
	.

+!debug_search_with_few_goals_ct_sy_me 
	<- 
	.println("*************");
	.println("*START TEST*");
	.println("Test Description:"); 
	.println("7 days, first day at catania"); 
	.println("visit catania at least 3 days"); 
	.println("visit messina at least 2 days"); 
	.println("visit siracusa at least 1 day"); 
	
	!initialize_search(
	world([being_at(catania),it_is(dt(2014,2,16,8,30,00))]),
	pack(
		social_goal(
			condition(being_at(catania)),
			par_condition([datetime],
				and([being_at(catania),property(it_is,[datetime]),data_is(datetime,date(2014,2,22))])
			),[system,luca]
		),
		[
			agent_goal(condition(true),condition(visited(catania,3)),system,maintain),
			agent_goal(condition(true),condition(visited(messina,2)),system,maintain),
			agent_goal(condition(true),condition(visited(siracusa,1)),system,maintain)
			
		]
		,[vacation_end,budget,avoid_2visit]
		,[qos]
	),
	OutSolutions
); 
	!log_solutions(OutSolutions); 
	!log_stat_solutions("search_with_few_goals_ct_sy_me",OutSolutions); 
.

+!debug_search_with_few_goals_ct_sy 
	<- 
	.println("*************");
	.println("*START TEST*");
	.println("Test Description:"); 
	.println("7 days, first day at catania"); 
	.println("visit catania at least 3 days"); 
	.println("visit siracusa at least 1 day"); 
	
	
	!initialize_search(
	world([being_at(catania),it_is(dt(2014,2,16,8,30,00))]),
	pack(
		social_goal(
			condition(being_at(catania)),
			par_condition([datetime],
				and([being_at(catania),property(it_is,[datetime]),data_is(datetime,date(2014,2,22))])
			),[system,luca]
		),
		[
			agent_goal(condition(true),condition(visited(catania,3)),system,maintain),
			agent_goal(condition(true),condition(visited(siracusa,1)),system,maintain)
			
		]
		,[vacation_end,budget,avoid_2visit]
		,[qos]
	),
	OutSolutions
); 
	!log_solutions(OutSolutions); 
	!log_stat_solutions("search_with_few_goals_ct_sy",OutSolutions); 
.


+!debug_search_with_few_goals_ct 
	<- 
	.println("*************");
	.println("*START TEST*");
	.println("Test Description:"); 
	.println("7 days, first day at catania"); 
	.println("visit catania at least 3 days"); 	
	
	!initialize_search(
	world([being_at(catania),it_is(dt(2014,2,16,8,30,00))]),
	pack(
		social_goal(
			condition(being_at(catania)),
			par_condition([datetime],
				and([being_at(catania),property(it_is,[datetime]),data_is(datetime,date(2014,2,22))])
			),[system,luca]
		),
		[
			agent_goal(condition(true),condition(visited(catania,3)),system,maintain)
		]
		,[vacation_end,budget,avoid_2visit]
		,[qos]
	),
	OutSolutions
); 
	!log_solutions(OutSolutions); 
	!log_stat_solutions("debug_search_with_few_goals_ct",OutSolutions); 
.


+!debug_search_with_many_goals 
	<- 
	.println("*************");
	.println("*START TEST*");
	.println("Test Description:"); 
	.println("7 days, first day at palermo"); 
	.println("visit palermo at least 2 days"); 
	.println("visit agrigento 1 or 1.5 days"); 
	.println("being at siracuse the forth day"); 
	.println("visit catania 1 or 2 days"); 
	
	
	!initialize_search(
	world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
	pack(
		social_goal(
			condition(being_at(palermo)),
			par_condition([datetime],
				and([being_at(catania),property(it_is,[datetime]),data_is(datetime,date(2014,2,22))])
			),[system,luca]
		),
		[
			agent_goal(condition(true),condition(visited(palermo,2)),system,maintain),
			agent_goal(condition(true),par_condition([visittime],and([property(visited,[agrigento,visittime]),between(visittime,1,1.5)])),system,maintain),
			agent_goal(par_condition([datetime],and([property(it_is,[datetime]),data_is(datetime,date(2014,2,20))])),condition(being_at(siracusa)),system),
			agent_goal(condition(true),par_condition([visittime],and([property(visited,[catania,visittime]),between(visittime,1,2)])),system,maintain)	
		]
		,[vacation_end,budget,avoid_2visit]
		,[qos]
	),
	OutSolutions
); 
	!log_solutions(OutSolutions); 
	!log_stat_solutions("debug_search_with_many_goals",OutSolutions); 
.
/* Result (step 72): WI=world(
	[
		being_at(catania),cost(461.5),dist(527),it_is(dt(2014,2,22,20,30,0)),
		
		visited(agrigento,1),visited(catania,1),visited(palermo,2),visited(siracusa,2),
		
		done(hotel,agrigento,18),done(hotel,palermo,16),done(hotel,palermo,17),done(hotel,siracusa,19),done(hotel,siracusa,20),done(hotel,siracusa,21),
		done(pulman,catania,taormina),done(pulman,taormina,catania),done(train,agrigento,catania),done(train,catania,siracusa),done(train,palermo,agrigento),
		done(train,siracusa,catania),done(visit_full_day,agrigento,18),done(visit_full_day,catania,22),done(visit_full_day,palermo,16),done(visit_full_day,palermo,17),
		done(visit_full_day,siracusa,20),done(visit_full_day,siracusa,21)
	]
)  */

+!debug_replan_with_many_goals <- !initialize_search(
	world([being_at(palermo),it_is(dt(2014,2,18,8,30,00)),visited(palermo,2),cost(140)]),
	pack(
		social_goal(
			condition(being_at(palermo)),
			par_condition([datetime],
				and([being_at(catania),property(it_is,[datetime]),data_is(datetime,date(2014,2,22))])
			),[system,luca]
		),
		[
			agent_goal(condition(true),condition(visited(palermo,3)),system,maintain),
			//agent_goal(condition(true),par_condition([visittime],and([property(visited,[agrigento,visittime]),between(visittime,1,1.5)])),system,maintain),
			agent_goal(par_condition([datetime],and([property(it_is,[datetime]),data_is(datetime,date(2014,2,20))])),condition(being_at(siracusa)),system),
			agent_goal(condition(true),par_condition([visittime],and([property(visited,[catania,visittime]),between(visittime,1,2)])),system,maintain)	
		]
		,[vacation_end,budget,avoid_2visit]
		,[qos]
	),
	OutSolutions
); 
	!log_solutions(OutSolutions); 
	!log_stat_solutions("debug_replan_with_many_goals",OutSolutions); 
.
/* Result (step 162): WI=world(
	[
		being_at(catania),cost(451.35),dist(342),it_is(dt(2014,2,22,9,57,0)),visited(catania,1),visited(palermo,3),visited(siracusa,2),
		done(hotel,palermo,18),done(hotel,siracusa,19),done(hotel,siracusa,20),done(hotel,siracusa,21),done(pulman,palermo,catania),
		done(train,catania,siracusa),done(train,siracusa,catania),done(visit_full_day,catania,19),done(visit_full_day,palermo,18),
		done(visit_full_day,siracusa,20),done(visit_full_day,siracusa,21)
	]
) */


+!debug_search_with_few_goals 
	<- 
	.println("*************");
	.println("*START TEST*");
	.println("Test Description:"); 
	.println("7 days, first day and last day at palermo"); 
	.println("visit palermo 2 or 3 days"); 
	
	
	!initialize_search(
	world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
	pack(
		social_goal(
			condition(being_at(palermo)),
			par_condition([datetime],
				and([being_at(palermo),property(it_is,[datetime]),data_is(datetime,date(2014,2,22))])
			),[system,luca]
		),
		[
			agent_goal(condition(true),par_condition([visittime],and([property(visited,[palermo,visittime]),between(visittime,2,3)])),system,maintain)
		]
		,[vacation_end,budget,avoid_2visit]
		,[qos]
	),
	OutSolutions
); 
	!log_solutions(OutSolutions); 
	!log_stat_solutions("debug_search_with_few_goals",OutSolutions); 
.
/* Result (step 600) : WI=world(
	[
		being_at(palermo),cost(464.50000000000006),dist(632),it_is(dt(2014,2,22,15,0,0)),visited(catania,2),visited(palermo,2),visited(taormina,2),
		done(hotel,catania,18),done(hotel,messina,21),done(hotel,palermo,16),done(hotel,palermo,17),done(hotel,taormina,19),done(hotel,taormina,20),
		done(pulman,catania,taormina),done(pulman,palermo,catania),done(pulman,taormina,catania),done(train,catania,messina),done(train,messina,palermo),
		done(visit_full_day,catania,18),done(visit_full_day,catania,21),done(visit_full_day,palermo,16),done(visit_full_day,palermo,17),
		done(visit_full_day,taormina,19),done(visit_full_day,taormina,20)
	]
)*/
