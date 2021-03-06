/******************************************************************************
 * @Author: 
 *  - Luca Sabatucci 
 * 	- Davide Guastella
 * 
 * Description: TODO ...
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * 
 *
 * TODOs: 
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/

{ include( "debug/world_debug.asl" ) }

/**
 * [davide]
 * 
 * Convert a FS or TC condition statement, for example
 * 
 * 	condition( or([received(request),printed(again), and([one,two])]) )
 * 
 * into a world state statement. More precisely it unrolls every predicate 
 * within the condition, removing AND, OR and NEG conditions properly.
 * The output for the previous example condition is:
 * 
 * [received(request),printed(again),one,two]
 * 
 * The second parameter is not necessary as output. It is used only for 
 * handling the NEG predicates.
 * 
 * Formally this plan builds a world state such that a certain 
 * condition within this state is valid.   
 * 
 */
 +!condition_to_world_statement(Condition, OutW)
	<-
		!condition_to_world_statement(Condition, False, OutW);
	.
 
+!condition_to_world_statement(Condition, NegFlag, OutW)
	:
		Condition = condition(CS)
	<-
		!condition_to_world_statement(CS, NegFlag, OutW);
	.
	
+!condition_to_world_statement(CS, NegFlag, OutW)
	:
		CS = or(List) | CS = and(List) 
	<-		
		!condition_to_world_statement(List, NegFlag, OutW);
	.
	
+!condition_to_world_statement(CS, NegFlag, OutW)
	:
		CS = neg(List) 
	<-		
		if(NegFlag = false)	{N=true;}
		else				{N=false;}
		!condition_to_world_statement(List, N, OutW);
	.
	
+!condition_to_world_statement(CS, NegFlag, OutW)
	:
		CS = [Head|Tail]
	<-
		!condition_to_world_statement(Head, NegFlag, OutWHead);
		!condition_to_world_statement(Tail, NegFlag, OutWTail);
		.concat(OutWHead,OutWTail,OutW);
	.

+!condition_to_world_statement(CS, NegFlag, OutW)
	:
		.literal(CS) &				//checks whether the argument CS is a literal
		NegFlag = true				
	<-
		OutW = [CS];				//We're at a leaf of the condition tree. If NegFlag is true, an  
									//even number of neg have been encountered. The predicate can be 
									//added to the output world statement list.
	.
	
+!condition_to_world_statement(CS, NegFlag, OutW)
	:
		.literal(CS) &				//checks whether the argument CS is a literal
		NegFlag = false
	<-
		OutW = [];					//We're at a leaf of the condition tree. If NegFlag is true, an  
									//odd number of neg have been encountered. The predicate cannot be 
									//added to the output world statement list.
	.

+!condition_to_world_statement(CS, NegFlag, OutW)
	:	CS 		= [] 		| 
		CS  	= false 	| 
		CS 		= true
	<-	OutW 	= [];
	.

/**
 * [davide]
 * 
 * Create a par_world without those statement that can be unified by assignments. 
 */
+!get_new_par_world(PWS,AssignmentSet, OutPWS)
	:
		PWS 	= [Head|Tail] &
		Head 	= property(F,T)
	<-
		!get_new_par_world(Tail,AssignmentSet, OutPWSTwo);		
		!exists_assignment_for_property(T,AssignmentSet,Found);
		
		if(Found=false)		{.concat([Head],OutPWSTwo,OutPWS);}
		else				{.concat([],OutPWSTwo,OutPWS);}
	.
	
+!get_new_par_world(PWS,AssignmentSet, OutPWS)
	:	PWS 	= []
	<-	OutPWS 	= [];	
	.
	
/**
 * [davide]
 * 
 * Normalize a list of statement. For example, the following list
 * 
 * 	[p(a),q(m,n)]
 * 
 * is converted to 
 * 
 * 	[property(p,[a]), property(q,[m,n])]
 */
 +!normalize_world_statement(WS, NormalizedWS)
	:	WS=[]
	<-	NormalizedWS=[];
	.

/*
 * Aggiunto 25-2-2015
 */
 +!normalize_world_statement(WS, NormalizedWS)
	:
		WS 		= [Head|Tail] &
		(Head 	= and(Pred) | 
		 Head	= or(Pred))
	<-
		!normalize_world_statement(Pred, NormalizedWSHead);
		!normalize_world_statement(Tail, NormalizedWSTail);
		.union(NormalizedWSHead, NormalizedWSTail, NormalizedWS);
	.
 +!normalize_world_statement(WS, NormalizedWS)
	:
		WS=[Head|Tail] &
		(Head == true | Head == false)
	<-
		!normalize_world_statement(Tail, NormalizedWSTwo);
		.concat( [], NormalizedWSTwo, NormalizedWS );
//		.concat( [Head], NormalizedWSTwo, NormalizedWS );
	.
+!normalize_world_statement(WS, NormalizedWS)
	:
		WS=[Head|Tail]
	<-
		!normalize_world_statement(Tail, NormalizedWSTwo);
		
		st.normalize_predicate(Head, Functor, Terms);
		.concat( [property(Functor,Terms)], NormalizedWSTwo, NormalizedWS );
	.
	