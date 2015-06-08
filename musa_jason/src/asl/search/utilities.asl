/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: utility plans for space exploration
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * 
 *
 * TODOs:
 * 
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/

+!invert_percent(Percent,InvertPercent)
	<-
		InvertPercent = 1-Percent;
	.

+!calculate_average(List,Average)
	:
		List=[]
	<-
		Average=0;
	.
+!calculate_average(List,Average)
	<-
		.length(List,Len);
		!sum(List,Sum);
		Average = Sum/Len;
	.
	
+!sum(List,Sum)
	:
		List=[]
	<-
		Sum = 0;
	.
+!sum(List,Sum)
	:
		List=[Head | Tail]
	<-
		!sum(Tail,TailSum);
		Sum = Head+TailSum;
	.


+!log_solutions(Solutions)
	:
		Solutions = []
	<-
		true
	.
+!log_solutions(Solutions)
	:
		Solutions = [ Head | Tail ]
	<-
		Head = item(cs(CS),evo(Evo),Score);
		.println("SOLUTION");
		for (.member(Cap,CS)) {
			!log_capability(Cap);
		}
		!get_last_element_from_list(Evo,Wk);
		.println("World: ",Wk);
		.println("");
		
		!log_solutions(Tail);
	.
	

+!log_capability(Cap)
	:
		Cap = cap(Capability) | Cap = cap(Capability,Percent)
	<-
		.println( "(",Capability,")" );
	.
+!log_capability(Cap)
	:
		Cap = parcap(Capability,AssignSet,EvolutSet)
	<-
		!log_evolution_set(EvolutSet,EvolutSetString);
		.println( "(",Capability,EvolutSetString,")" );
	.
+!log_evolution_set(EvolutSet,EvolutSetString)
	:
		EvolutSet=[]
	<-
		EvolutSetString="";
	.
+!log_evolution_set(EvolutSet,EvolutSetString)
	:
		EvolutSet=[ Head | Tail ]
	&	Head = remove(_)
	<-
		!log_evolution_set(Tail,EvolutSetString);
	.
+!log_evolution_set(EvolutSet,EvolutSetString)
	:
		EvolutSet=[ Head | Tail ]
	&	Head = add(Property)
	<-
		!log_evolution_set(Tail,TailEvolutSetString);
		.term2string(Property,StringProperty);
		.concat("[",StringProperty,"]",TailEvolutSetString,EvolutSetString);
	.


/**
 * [davide]
 * 
 */
+!check_accumulation_equal(W1,W2,Bool)
	:
		//W1 = accumulation(world(WS_1),par_world(Vars1,PWS_1),_) &
		W1 = accumulation(_,_,_) &
		W2 = accumulation(_,_,_)
	<-	
		!denormalize_accumulation(W1, OutW1);
		!denormalize_accumulation(W2, OutW2);
		
		OutW1 = accumulation(world(WS_1),par_world(Vars1,PWS_1),_);
		OutW2 = accumulation(world(WS_2),par_world(Vars2,PWS_2),_);
	
		//.print("WS1 ->",WS_1);.print("WS2 ->",WS_2);
		//.print("\n\n\nComparing ",OutW1," \nand\n",OutW2,"\n");
		.union(WS_1,WS_2,Union_W);
		.intersection(WS_1,WS_2,Inters_W);
		.difference(Union_W,Inters_W,Diff_W);
		
		//.print("PWS1 ->",PWS_1);.print("PWS2 ->",PWS_2);
		.union(PWS_1,PWS_2,Union_PW);
		.intersection(PWS_1,PWS_2,Inters_PW);
		.difference(Union_PW,Inters_PW,Diff_PW);
		
		if ( .empty( Diff_W ) & .empty( Diff_PW ) ) { Bool=true } else { Bool = false }		
	.
/*
+!check_accumulation_equal(world(W1),world(W2),Bool)
	<-
		.union(W1,W2,Union);
		.intersection(W1,W2,Inters);
		.difference(Union,Inters,Diff);
		
		if ( .empty( Diff ) ) { Bool=true } else { Bool = false }		
	.
+!check_accumulation_equal(W1,W2,Bool)
	<-
		.union(W1,W2,Union);
		.intersection(W1,W2,Inters);
		.difference(Union,Inters,Diff);
		
		if ( .empty( Diff ) ) { Bool=true } else { Bool = false }		
	.
*/

/* 
earlier(dt(YY,MO,DD,HH,MM,SS1),dt(YY,MO,DD,HH,MM,SS2)) :- SS1 < SS2.
earlier(dt(YY,MO,DD,HH,MM1,SS1),dt(YY,MO,DD,HH,MM2,SS2)) :-  MM1 < MM2.
earlier(dt(YY,MO,DD,HH1,MM1,SS1),dt(YY,MO,DD,HH2,MM2,SS2)) :-  HH1 < HH2.
earlier(dt(YY,MO,DD1,HH1,MM1,SS1),dt(YY,MO,DD2,HH2,MM2,SS2)) :-  DD1 < DD2.
earlier(dt(YY,MO1,DD1,HH1,MM1,SS1),dt(YY,MO2,DD2,HH2,MM2,SS2)) :-  MO1 < MO2.
earlier(dt(YY1,MO1,DD1,HH1,MM1,SS1),dt(YY2,MO2,DD2,HH2,MM2,SS2)) :-  YY1 < YY2.
*/
	
+!logic_not(true,false)<-true.
+!logic_not(false,true)<-true.

+!logic_and(true,true,true) <- true.
+!logic_and(true,false,false) <- true.
+!logic_and(false,true,false) <- true.
+!logic_and(false,false,false) <- true.

+!logic_or(true,true,true) <- true.
+!logic_or(true,false,true) <- true.
+!logic_or(false,true,true) <- true.
+!logic_or(false,false,false) <- true.



+!get_last_element_from_list(List,Item)
	:
		List=[]
	<-
		Item=null;
	.
+!get_last_element_from_list(List,Item)
	<-
		.reverse(List,RevList);
		RevList = [ Item | Tail ];
	.

	
+!debug_date_increment <- st.date_increment(dt(2014,2,16,8,30,00),dt(0,0,1,20,30,00),Result); .println(Result); .
+!debug_date_difference <- st.date_difference(dt(2014,2,18,10,30,00),dt(2014,2,17,8,30,00),Result); .println(Result); .
+!debug_date_difference_2 <- st.date_difference(dt(2014,2,18,10,30,00),dt(2014,2,16,12,30,0),Result); .println(Result); .

+!debug_cartago_stack 
	<-
		.println("test CARTAGO stack");
		
		makeArtifact("stack","st.Stack",[]);
		insertItem(cs(c1,c2,c3),evo(w1,w2,w3),3);
		insertItem(cs(c4,c5,c6),evo(w4,w5,w6),1);
		insertItem(cs(c7,c8,c9),evo(w7,w8,w9),4);
		insertItem(cs(c10,c11,c12),evo(w10,w11,w12),2);
		
		pickItem( Item );
		Item = item(CS,EVO,Score);
		.println( CS,EVO,Score ) ;

		pickItem( Item1 );
		Item1 = item(CS1,EVO1,Score1);
		.println( CS1,EVO1,Score1 ) ;
	.
