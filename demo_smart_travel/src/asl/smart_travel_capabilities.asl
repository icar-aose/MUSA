timeelapse(X,time(FH,FM,FS)) :- X=(60*FH)+FM.


in_time_for_hotel(DateTime) :- DateTime = dt(YY,MM,DD,HH,M,SS) & timeelapse(XElapseTime,time(HH,M,SS)) & timeelapse(YElapseTime,time(19,0,0))
				& 	XElapseTime>=YElapseTime .

in_time_for_train_departure(X,Y,Range) :- timeelapse(XElapseTime,X) & timeelapse(YElapseTime,Y)
				& 	XElapseTime<=YElapseTime & XElapseTime>=YElapseTime-Range.



agent_capability(flight_monaco_palermo)[type(simple)].
capability_precondition(flight_monaco_palermo, condition(being_at(monaco)) ).
capability_postcondition(flight_monaco_palermo, condition(being_at(palermo)) ).
capability_cost(flight_monaco_palermo,150).
capability_evolution(flight_monaco_palermo,[add(being_at(palermo)),add(it_is(dt(2014,2,16,8,30,00))),remove(being_at(monaco))]).

agent_capability(flight_catania_monaco)[type(simple)].
capability_precondition(flight_catania_monaco, condition( and([being_at(catania),it_is(dt(2014,2,23,20,30,00))]) )).
capability_postcondition(flight_catania_monaco, condition(being_at(monaco)) ).
capability_cost(flight_catania_monaco,150).
capability_evolution(flight_catania_monaco,[add(being_at(monaco)),remove(being_at(catania))]).


agent_capability(visit)[type(parametric)].
capability_parameters(visit,[city,datetime]).
capability_precondition(visit, par_condition([city,datetime], and([ property(being_at,[city]), property(it_is,[datetime]) ]) ) ).
capability_postcondition(visit, par_condition([city,datetime,visit_time], and([ property(being_at,[city]), property(visited,[city,visit_time]) ]) ) ).

agent_capability(train)[type(parametric)].
capability_parameters(train,[fromcity,fromdatetime]).
capability_precondition(train, par_condition([fromcity,fromdatetime], and([ property(being_at,[fromcity]), property(it_is,[fromdatetime]) ]) ) ).
capability_postcondition(train, par_condition([destcity,desttime], and([ property(being_at,[destcity]), property(it_is,[desttime]) ]) ) ).

agent_capability(pulman)[type(parametric)].
capability_parameters(pulman,[fromcity,fromdatetime]).
capability_precondition(pulman, par_condition([fromcity,fromdatetime], and([ property(being_at,[fromcity]), property(it_is,[fromdatetime]) ]) ) ).
capability_postcondition(pulman, par_condition([destcity,desttime], and([ property(being_at,[destcity]), property(it_is,[desttime]) ]) ) ).

agent_capability(hotel)[type(parametric)].
capability_parameters(hotel,[city,datetime]).
capability_precondition(hotel, par_condition([city,datetime], and([ property(being_at,[city]), property(it_is,[datetime]) ]) ) ).
capability_postcondition(hotel, par_condition([city,newdate], and([ property(being_at,[city]), property(it_is,[newdate]) ]) ) ).

/* 
agent_capability(tour_palermo_agrigento)[type(parametric)].
capability_parameters(tour_palermo_agrigento,[datetime]).
capability_precondition(tour_palermo_agrigento, par_condition([datetime], and([ property(being_at,[palermo]), property(it_is,[datetime]), morning(datetime)  ]) ) ).
capability_postcondition(tour_palermo_agrigento, par_condition([newdate], and([ property(being_at,[agrigento]), property(it_is,[newdate])]) ) ).
*/

+!capability_evolution(tour_palermo_agrigento,AssignmentSet,World,EvolutionSet)
	<-
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,datetime,DateTime);
		!unroll_world_to_get_first_assignment_for_variable(World,palermo_visit_time,property(visited,[palermo,palermo_visit_time]),0,PaVisitTime);
		!unroll_world_to_get_first_assignment_for_variable(World,agrigento_visit_time,property(visited,[agrigento,agrigento_visit_time]),0,AgVisitTime);

		DateTime = dt(YY,MM,DD,HH,M,SS);
		st.date_increment(dt(YY,MM,DD,20,30,00),dt(0,0,3,0,0,0),NewDateTime);

		EvolutionSet=[
			[
				remove(it_is(DateTime)),
				remove(visited(palermo,PaVisitTime)),
				remove(visited(agrigento,AgVisitTime)),
				remove(being_at(palermo)),
				add(it_is(NewDateTime)),
				add(visited(palermo,PaVisitTime+2)),
				add(visited(agrigento,AgVisitTime+1.5)),
				add(being_at(agrigento)),
				add(cost(250)),
				add(tour(palermo_agrigento))
			]
		];

	.


/* VISIT CITY TRANSFER FUNCTION */
+!capability_evolution(visit,AssignmentSet,World,EvolutionSet)
	<-
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,datetime,DateTime);
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,city,CityName);		
		!unroll_world_to_get_first_assignment_for_variable(World,visit_time,property(visited,[CityName,visit_time]),0,VisitTime);
		
		DateTime = dt(YY,MM,DD,HH,M,SS);		
		if (HH>=7 & HH<12) {
			EvolutionSet=[
				[
					remove(it_is(DateTime)),
					remove(visited(CityName,VisitTime)),
					add(it_is(dt(YY,MM,DD,12,30,00))),
					add(visited(CityName,VisitTime+0.5)),
					add(done(visit_half_day_morn,CityName,DD))
				],[
					remove(it_is(DateTime)),
					remove(visited(CityName,VisitTime)),
					add(it_is(dt(YY,MM,DD,20,30,00))),
					add(visited(CityName,VisitTime+1)),
					add(done(visit_full_day,CityName,DD))
				]
			];
		} else { 
			if (HH>=12 & HH<20) {
				EvolutionSet=[
					[
						remove(it_is(DateTime)),
						remove(visited(CityName,VisitTime)),
						add(it_is(dt(YY,MM,DD,20,30,00))),
						add(visited(CityName,VisitTime+0.5)),
						add(done(visit_half_day_after,CityName,DD))
					]
				];
			} else {
				EvolutionSet=[];
			}		
		}
	.


/* TRAIN TRANSFER FUNCTION */
+!capability_evolution(train,AssignmentSet,World,EvolutionSet)
	<-
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,fromdatetime,CurrentDateTime);
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,fromcity,CurrentCityName);		
		!unroll_world_to_get_first_assignment_for_variable(World,euro,property(cost,[euro]),0,CurrentCost);
		!unroll_world_to_get_first_assignment_for_variable(World,km,property(dist,[km]),0,CurrentDist);
		
		CurrentDateTime=dt(YYYY,MM,DD,HH,M,SS);
		
		.findall(DestCity,train(CurrentCityName,DestCity,DeptTime,ArrTime,Payment) & in_time_for_train_departure(time(HH,M,SS),DeptTime,180),Destinations);		
		.union(Destinations,[],DestinationSet);
		
		!unroll_destinations_to_compose_train_list(DestinationSet,CurrentCityName,CurrentDateTime,TrainList);
		!unroll_trainlist_to_compose_evolutionset(TrainList,CurrentDateTime,CurrentCost,CurrentDist,EvolutionSet);  
	.


/* PULMAN TRANSFER FUNCTION */
+!capability_evolution(pulman,AssignmentSet,World,EvolutionSet)
	<-
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,fromdatetime,CurrentDateTime);
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,fromcity,CurrentCityName);		
		!unroll_world_to_get_first_assignment_for_variable(World,euro,property(cost,[euro]),0,CurrentCost);
		!unroll_world_to_get_first_assignment_for_variable(World,km,property(dist,[km]),0,CurrentDist);
		
		CurrentDateTime=dt(YYYY,MM,DD,HH,M,SS);
		
		.findall(DestCity,pulman(CurrentCityName,DestCity,DeptTime,ArrTime,Payment) & in_time_for_train_departure(time(HH,M,SS),DeptTime,180),Destinations);		
		.union(Destinations,[],DestinationSet);
		
		!unroll_destinations_to_compose_pulman_list(DestinationSet,CurrentCityName,CurrentDateTime,TrainList);
		!unroll_pulmanlist_to_compose_evolutionset(TrainList,CurrentDateTime,CurrentCost,CurrentDist,EvolutionSet);  
	.


/* HOTEL TRANSFER FUNCTION */
+!capability_evolution(hotel,AssignmentSet,World,EvolutionSet)
	<-
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,datetime,CurrentDateTime);
		!unroll_assignments_to_get_value_for_variable(AssignmentSet,city,CurrentCityName);		
		!unroll_world_to_get_first_assignment_for_variable(World,euro,property(cost,[euro]),0,Cost);
		
		CurrentDateTime = dt(YY,MM,DD,HH,M,SS);
		
		if (in_time_for_hotel( CurrentDateTime) ) {
			st.date_increment(dt(YY,MM,DD,8,30,00),dt(0,0,1,0,0,0),NewDateTime);
			NewCost = Cost + 70;
			Evo=[
				remove(it_is(CurrentDateTime)),
				remove(cost(Cost)),
				add(it_is(NewDateTime)),
				add(cost(NewCost)),
				add(done(hotel,CurrentCityName,DD))
			];
			EvolutionSet=[Evo];
		} else {
			EvolutionSet=[];
		}
	.


+!dubug_hotel_capability_evolution <- !capability_evolution(hotel,[assign(city,palermo),assign(datetime,dt(2014,2,16,20,00,00))],null,EvolutionSet); .println(EvolutionSet); .
+!debug_train_capability_evolution <- !capability_evolution(train,[assign(fromcity,palermo),assign(fromdatetime,dt(2014,2,16,13,50,00))],world([it_is(dt(2014,2,16,9,00,00)),being_at(palermo)]),EvolutionSet); .println(EvolutionSet); .
+!debug_train_capability_evolution_2 <- !capability_evolution(train,[assign(fromcity,palermo),assign(fromdatetime,dt(2014,2,16,9,00,00))],world([it_is(dt(2014,2,16,9,00,00)),being_at(palermo)]),EvolutionSet); .println(EvolutionSet); .
+!debug_train_capability_evolution_3 <- !capability_evolution(train,[assign(fromcity,palermo),assign(fromdatetime,dt(2014,2,16,8,30,00))],world([]),EvolutionSet); .println(EvolutionSet); .
+!debug_visit_capability_evolution <- !capability_evolution(visit,
	[assign(datetime,dt(2014,2,16,8,30,00)),assign(city,palermo)],
	world([visited(palermo,0.5)]),
	EvolutionSet
); .println(EvolutionSet); .
+!debug_visit_capability_evolution_2 <- !capability_evolution(visit,
	[assign(datetime,dt(2014,2,16,10,52,00)),assign(city,agrigento)],
	world([being_at(agrigento),it_is(dt(2014,2,16,10,52,00))]),
	EvolutionSet
); .println(EvolutionSet); .
/* *********** */




/* *********** */
/* UTILITIES   */
/* *********** */
+!unroll_destinations_to_compose_pulman_list(Destinations,CurrentCityName,CurrentDateTime,TrainList)
	:
		Destinations=[]
	<-
		TrainList=[];
	.
+!unroll_destinations_to_compose_pulman_list(Destinations,CurrentCity,CurrentDateTime,TrainList)
	:
		Destinations=[ Head | Tail ]
	<-
		CurrentDateTime=dt(YYYY,MM,DD,HH,M,SS);
		
		//.println("for: ",Head);
		
		.findall(DeptTime,pulman(CurrentCity,Head,DeptTime,ArrTime,Payment) & in_time_for_train_departure(time(HH,M,SS),DeptTime,180),Departures);
		//.println("departures: ",Departures);

		!unroll_departures_to_find_closer(Departures,CurrentDateTime,BestDpt);
		?pulman(CurrentCity,Head,BestDpt,Arrival,Payment);
		
		!unroll_destinations_to_compose_pulman_list(Tail,CurrentCity,CurrentDateTime,TailTrainList);
		
		TrainList = [ pulman(CurrentCity,Head,BestDpt,Arrival,Payment) | TailTrainList ];
	.

+!unroll_destinations_to_compose_train_list(Destinations,CurrentCityName,CurrentDateTime,TrainList)
	:
		Destinations=[]
	<-
		TrainList=[];
	.
+!unroll_destinations_to_compose_train_list(Destinations,CurrentCity,CurrentDateTime,TrainList)
	:
		Destinations=[ Head | Tail ]
	<-
		CurrentDateTime=dt(YYYY,MM,DD,HH,M,SS);
		
		//.println("for: ",Head);
		
		.findall(DeptTime,train(CurrentCity,Head,DeptTime,ArrTime,Payment) & in_time_for_train_departure(time(HH,M,SS),DeptTime,180),Departures);
		//.println("departures: ",Departures);

		!unroll_departures_to_find_closer(Departures,CurrentDateTime,BestDpt);
		?train(CurrentCity,Head,BestDpt,Arrival,Payment);
		
		!unroll_destinations_to_compose_train_list(Tail,CurrentCity,CurrentDateTime,TailTrainList);
		
		TrainList = [ train(CurrentCity,Head,BestDpt,Arrival,Payment) | TailTrainList ];
	.


+!unroll_departures_to_find_closer(Departures,CurrentDateTime,BestDpt)
	:
		Departures=[Dpt]
	<-
		BestDpt=Dpt;
	.
+!unroll_departures_to_find_closer(Departures,CurrentDateTime,BestDpt)
	:
		Departures=[Head | Tail]
	<-
		!unroll_departures_to_find_closer(Tail,CurrentDateTime,BestTailDpt);
		
		Head=time(HH1h,M1h,_);
		BestTailDpt=time(HH1t,M1t,_);
		CurrentDateTime=dt(_,_,_,HH2,M2,_);
		DeltaHead = ((HH1h*60)+M1h)-((HH2*60)+M2);
		DeltaTail = ((HH1t*60)+M1t)-((HH2*60)+M2);
		
		if (DeltaHead <= DeltaTail) {
			BestDpt = Head;
		} else {
			BestDpt = BestTailDpt;
		}
	.


+!unroll_pulmanlist_to_compose_evolutionset(TrainList,CurrentDateTime,CurrentCost,CurrDist,EvolutionSet)
	:
		TrainList=[]
	<-
		EvolutionSet=[];
	.
+!unroll_pulmanlist_to_compose_evolutionset(TrainList,CurrentDateTime,CurrentCost,CurrDist,EvolutionSet)
	:
		TrainList=[ Head | Tail ]
	<-
		Head=pulman(DptCityName,DestCityName,DptTime,DestTime,Payment);
		
		?distance(DptCityName,DestCityName,Distance);
		
		//.println(Head);
		CurrentDateTime = dt(YY,MM,DD,HH,M,SS);
		DestTime = time(DH,DM,DS);
		DestDate=dt(YY,MM,DD,DH,DM,DS);
		
		Evo=[
			remove(it_is(CurrentDateTime)),
			remove(being_at(DptCityName)),
			remove(cost(CurrentCost)),
			remove(dist(CurrDist)),
			add(it_is(DestDate)),
			add(being_at(DestCityName)),
			add(cost(CurrentCost+Payment)),
			add(dist(CurrDist+Distance)),
			add(done(pulman,DptCityName,DestCityName))
		];
		//.println(Evo);
		HeadEvolutionSet=[Evo];
		!unroll_pulmanlist_to_compose_evolutionset(Tail,CurrentDateTime,CurrentCost,CurrDist,TailEvolutionSet);
		.concat(HeadEvolutionSet,TailEvolutionSet,EvolutionSet);
	.

	
+!unroll_trainlist_to_compose_evolutionset(TrainList,CurrentDateTime,CurrentCost,CurrentDist,EvolutionSet)
	:
		TrainList=[]
	<-
		EvolutionSet=[];
	.
+!unroll_trainlist_to_compose_evolutionset(TrainList,CurrentDateTime,CurrentCost,CurrentDist,EvolutionSet)
	:
		TrainList=[ Head | Tail ]
	<-
		Head=train(DptCityName,DestCityName,DptTime,DestTime,Payment);
		//.println(Head);
		
		?distance(DptCityName,DestCityName,Distance);

		//.println(CurrentDist);
		//.println(Distance);
		
		//.println(Head);
		CurrentDateTime = dt(YY,MM,DD,HH,M,SS);
		DestTime = time(DH,DM,DS);
		DestDate=dt(YY,MM,DD,DH,DM,DS);
		
		Evo=[
			remove(it_is(CurrentDateTime)),
			remove(being_at(DptCityName)),
			remove(cost(CurrentCost)),
			remove(dist(CurrDist)),
			add(it_is(DestDate)),
			add(being_at(DestCityName)),
			add(cost(CurrentCost+Payment)),
			add(dist(CurrentDist+Distance)),
			add(done(train,DptCityName,DestCityName))
		];
		//.println(Evo);
		
		HeadEvolutionSet=[Evo];
		!unroll_trainlist_to_compose_evolutionset(Tail,CurrentDateTime,CurrentCost,CurrentDist,TailEvolutionSet);
		.concat(HeadEvolutionSet,TailEvolutionSet,EvolutionSet);
	.
/* *********** */





	
	