max_kilometer(1000).

/* NORMS */
+!norm(vacation_end,CS,Evo,Bool)
	<-
		!get_last_element_from_list(Evo,Wk);
		
		//.println("World:",Wk);
		
		PCN=par_condition([datetime],and([property(it_is,[datetime]), data_earlier_than(datetime,dt(2014,2,23,00,00,00))] ));

		//.println("CN:",PCN);
		
		!deduct_assignments_from_world(Wk,PCN,[],AssignmentSet,DeductBool);
		
		//.println("Ass:",AssignmentSet);
		//.println("Deduct:",DeductBool);
		
		if (DeductBool=true) {
			!test_parametric_condition(PCN,AssignmentSet,Wk,Bool);
			//.println("Test:",Bool);

		} else {
			Bool = false;
		}
	.
+!debug_norm_vacation_end <- !norm(vacation_end,[],[world([being_at(palermo),visited(palermo,2),it_is(dt(2014,2,17,8,30,00))])],Bool); .println(Bool); .


+!norm(no_more_than_3,CS,Evo,Bool)
	<-
		!get_last_element_from_list(Evo,Wk);
		
		!unroll_world_to_deduct_assignments_from_world(Wk,city_name,property(visited,[city_name,whatever]),VisitedCities);
		
		!unroll_visited_cities_to_check_no_more_than_duration(VisitedCities,Wk,3,Bool);
	.
+!norm(no_more_than_2,CS,Evo,Bool)
	<-
		!get_last_element_from_list(Evo,Wk);
		!unroll_world_to_deduct_assignments_from_world(Wk,city_name,property(visited,[city_name,whatever]),VisitedCities);
		!unroll_visited_cities_to_check_no_more_than_duration(VisitedCities,Wk,2,Bool);
	.

+!norm(budget,CS,Evo,Bool)
	<-
		Evo=[WI | Tail1];
		!get_last_element_from_list(Evo,Wk);
		
		Wk=world(SWk);
		!unroll_world_to_get_first_assignment_for_variable(SWk,euro,property(cost,[euro]),0,VacationCost);
		
		if (VacationCost<=1500) {
			Bool = true;
		} else {
			Bool = false;
		}
	.
+!debug_norm_budget <- !norm(budget,[],[world([cost(1700),visited(palermo,2),it_is(dt(2014,2,17,8,30,00))])],Bool); .println(Bool); .


+!norm(avoid_2visit,CS,Evo,Bool)
	<-
		Evo = [WI | Tail];
		
		!unroll_sequence_to_avoid_2_half_visit(CS,WI,Tail,Bool);		
	.



/* METRICS */
+!metric(cost,CS,Evo,Score)
	<-
		Evo=[WI | Tail1];
		!get_last_element_from_list(Evo,Wk);
		
		!count_vacation_time_in_hours(WI,Wk,VacationTime);
		
		Wk = world(SWk);
		!unroll_world_to_get_first_assignment_for_variable(Wk,euro,property(cost,[euro]),0,VacationCost);
		
		if (VacationCost>0) {
			Score= 1 / (VacationCost/VacationTime);
		} else {
			Score=1;
		}
		
		//.println("VacationCost: ",VacationCost," VacationTime: ",VacationTime," COST: ",Score);
	.


+!metric(qos,CS,Evo,Score)
	<-
		?max_kilometer(MAX_KM);
		
		Evo=[WI | Tail1];
		!get_last_element_from_list(Evo,Wk);
		
		!unroll_world_to_get_first_assignment_for_variable(Wk,km,property(dist,[km]),0,KM);
		
		!count_vacation_time_in_hours(WI,Wk,VacationTime);
		!count_visit_time(Wk,VisitTime);
		
		!unroll_sequence_to_count_capability_occurrences(CS,hotel,HotelOccur);
		
		Score=(VisitTime+(HotelOccur*12))/VacationTime-(KM/MAX_KM);
		
		//.println("VisitTime: ",VisitTime," HotelOccur: ",HotelOccur," VacationTime: ",VacationTime," QOS: ",Score);
	.


+!debug_visit_metric <- !metric(visit,[],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([visited(palermo,2),visited(catania,1.5),visited(messina,0.5),it_is(dt(2014,2,21,8,30,00))])
	],Score
); .println(Score); .
+!debug_visit_metric_2 <- !metric(visit,[],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([visited(palermo,0.5),it_is(dt(2014,2,16,12,30,00))])
	],Score
); .println(Score); .
+!debug_visit_metric_3 <- !metric(visit,[],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([visited(palermo,1),it_is(dt(2014,2,16,20,30,00))])
	],Score
); .println(Score); .
+!debug_qos_metric_1 <- !metric(qos,[cap(hotel)],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([visited(palermo,1),it_is(dt(2014,2,17,20,30,00))])
	],Score
); .println(Score); .
+!debug_qos_metric_2 <- !metric(qos,[cap(hotel),cap(hotel)],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([visited(palermo,2),it_is(dt(2014,2,18,8,30,00))])
	],Score
); .println(Score); .
+!debug_qos_metric_3 <- !metric(qos,[cap(train),cap(train)],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([being_at(catania),it_is(dt(2014,2,18,8,30,00))])
	],Score
); .println(Score); .
+!debug_qos_metric_4 <- !metric(qos,[cap(hotel),cap(hotel)],
	[
		world([being_at(palermo),it_is(dt(2014,2,16,8,30,00))]),
		world([visited(palermo,2),it_is(dt(2014,2,18,8,30,00))])
	],Score
); .println(Score); .





+!unroll_visited_cities_to_check_no_more_than_duration(VisitedCities,Wk,Time,Bool)
	:
		VisitedCities=[ ]
	<-
		Bool=true;
	.
+!unroll_visited_cities_to_check_no_more_than_duration(VisitedCities,Wk,Time,Bool)
	:
		VisitedCities=[ Head | Tail ]
	<-
		//.println(Head);
		!unroll_world_to_get_first_assignment_for_variable(Wk,visit_time,property(visited,[Head,visit_time]),0,VisitTime);
		//.println(VisitTime);
		if (VisitTime > Time) {
			//.println("City: ",Head," time: ",VisitTime," violated: ",Time);
			Bool = false;
		} else {
			!unroll_visited_cities_to_check_no_more_than_duration(Tail,Wk,Time,Bool);
		}
	.

+!debug_norm_no_more_than_3 <- !norm(no_more_than_3,[],
	[ world([visited(palermo,2)]),world([visited(palermo,2),visited(cefalu,1)]),world([visited(palermo,3.5),visited(cefalu,1)]) ],
	Bool
); .println(Bool); .


+!check_if_element_is_fullday_visit(Visit,Bool)
	:
		Visit = parcap(visit,AssigSet,Evolution)
	<-
		.member( remove( visited(City1,Old) ), Evolution);
		.member( add( visited(City2,New) ), Evolution);
		if (City1=City2 & New-Old=1) {
			Bool=true;
		} else {
			Bool=false;
		}
	.


+!count_vacation_time_in_hours(WI,Wk,VacationTime)
	<-
		!unroll_world_to_get_first_assignment_for_variable(WI,date,property(it_is,[date]),0,StartDate);
		!unroll_world_to_get_first_assignment_for_variable(Wk,date,property(it_is,[date]),0,CurrentDate);
		st.date_difference(CurrentDate,StartDate,VacationTime);
	.
	
+!count_visit_time(Wk,VisitTime)
	<-
		Wk = world(SWk);
		!unroll_world_to_deduct_assignments_from_world(SWk,city_name,property(visited,[city_name,whatever]),VisitedCities);
		!unroll_visited_cities_to_count_visit_time(VisitedCities,Wk,VisitHours);
		VisitTime = VisitHours;
	.	
+!debug_count_visit_time <- !count_visit_time([visited(palermo,2),visited(catania,1.5),visited(messina,0.5)],VisitTime); .println(VisitTime); .

+!unroll_visited_cities_to_count_visit_time(VisitedCities,Wk,VisitTime)
	:
		VisitedCities=[]
	<-
		VisitTime=0;
	.
+!unroll_visited_cities_to_count_visit_time(VisitedCities,SWk,VisitTime)
	:
		VisitedCities=[Head | Tail]
	<-
		!unroll_world_to_get_first_assignment_for_variable(SWk,visit_time,property(visited,[Head,visit_time]),0,HeadVisitTime);
		!unroll_visited_cities_to_count_visit_time(Tail,SWk,TailVisitTime);
		!convert_visit_time_in_visit_hours(HeadVisitTime,HeadVisitHours);
		VisitTime=HeadVisitHours+TailVisitTime;
	.
	
+!convert_visit_time_in_visit_hours(Time,Hours)
	<-
		RoundTime = math.floor(Time);
		RoundHours = RoundTime * 12;
		
		FracTime = Time - RoundTime;
		FracHours = FracTime * 7;
		
		Hours = RoundHours+FracHours;
	.
+!debug_convert_visit_time_in_visit_hours <- !convert_visit_time_in_visit_hours(2.5,Hours); .println(Hours); .


+!unroll_sequence_to_count_capability_occurrences(CS,Cap,Time)
	:
		CS=[]
	<-
		Time=0;
	.
+!unroll_sequence_to_count_capability_occurrences(CS,Cap,Time)
	:
		CS=[ Head | Tail ]
	&	( Head=parcap(Capacity,_,_) | Head=cap(Capacity) )
	&	Capacity = Cap
	<-
		!unroll_sequence_to_count_capability_occurrences(Tail,Cap,TailTime);
		Time = TailTime + 1;
	.
+!unroll_sequence_to_count_capability_occurrences(CS,Cap,Time)
	:
		CS=[ Head | Tail ]
	<-
		!unroll_sequence_to_count_capability_occurrences(Tail,Cap,Time);
	.


+!unroll_sequence_to_avoid_2_half_visit(Sequence,WI,E,Bool)
	:
		Sequence = []
	<-
		Bool=true;
	.
+!unroll_sequence_to_avoid_2_half_visit(Sequence,WI,E,Bool)
	:
		Sequence = [ CSHead | CSTail ]
	&	E = [ EHead | ETail ]
	&	CSHead = parcap(visit,AssigSet,Evolution)	
	<-
		.member( remove( visited(City1,Old) ), Evolution);
		.member( add( visited(City2,New) ), Evolution);
		Duration = New-Old;
		
		if (City1=City2 & Duration = 0.5) {
		
			!get_last_element_from_list(E,Wk);
			!unroll_world_to_get_first_assignment_for_variable(Wk,curr_date,property(it_is,[curr_date]),dt(0,0,0,0,0,0),CurrDate);
			CurrDate = dt(YY,MM,DD,HH,M,SS);
	
			if ( HH>=7 & HH<12 ) {
				!check_if_next_element_is_hafday_visit(CSTail,IDBool);
				if (IDBool=true) {
					Bool = false;
					Continue = false;
				} else {
					Continue=true;
				}
			} else {
				Continue=true;
			}
			
		} else {
			Continue=true;
		}
		
		if (Continue=true) {
			!unroll_sequence_to_avoid_2_half_visit(CSTail,WI,ETail,Bool);
		}
	.
+!unroll_sequence_to_avoid_2_half_visit(Sequence,WI,E,Bool)
	:
		Sequence = [ CSHead | CSTail ]
	&	E = [ EHead | ETail ]
	<-
		!unroll_sequence_to_avoid_2_half_visit(CSTail,WI,ETail,Bool);
	.
+!debug_unroll_sequence_to_avoid_2_half_visit 
	<-
		!unroll_sequence_to_avoid_2_half_visit(
			[
				parcap(visit,[],[remove(visited(palermo,0)),add(visited(palermo,0.5))]),
				parcap(visit,[],[remove(visited(palermo,0)),add(visited(palermo,0.5))]),
				parcap(hotel,[],[])
			],
			world([being_at(palermo),it_is(dt(2014,2,16,8,30,0))]),
			[
				world([being_at(palermo),it_is(dt(2014,2,16,12,30,0)),visited(palermo,0.5)]),
				world([being_at(palermo),it_is(dt(2014,2,16,8,30,0)),visited(palermo,1)]),
				world([being_at(palermo),it_is(dt(2014,2,17,8,30,0)),visited(palermo,1)])
			],
			Bool
		);
		.println(Bool);
	.


+!check_if_next_element_is_hafday_visit(Sequence,Bool)
	:
		Sequence=[]
	<-
		IDBool=false;
	.
+!check_if_next_element_is_hafday_visit(Sequence,Bool)
	:
		Sequence=[ Visit | Tail ]
	&	Visit = parcap(visit,AssigSet,Evolution)
	<-
		.member( remove( visited(City1,Old) ), Evolution);
		.member( add( visited(City2,New) ), Evolution);
		if (City1=City2 & New-Old=0.5) {
			Bool=true;
		} else {
			Bool=false;
		}
	.
+!check_if_next_element_is_hafday_visit(Sequence,Bool)
	<-
		IDBool=false;
	.



