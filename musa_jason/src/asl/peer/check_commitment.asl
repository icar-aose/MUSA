/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: plans for evaluating when an agent is able to commit to a goal
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * CONVERTITE RULES IN PLANS
 * aggiunto parametro Write per attivare o disattivare il log
 *
 * TODOs:
 * USARE ANNOTATION [pack] per filtrare un goal
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/


/* MACRO Check capability */	

+!check_able_to_enter_dpt( S, EnterBool, Write)
	:
		social_goal( S )[pack(P)]
	<-
		.findall(G, goal( G )[pack(P)], SubGoals);
		!check_able_to_commit_at_least_one(SubGoals, EnterBool, Write);
	.
+!check_able_to_enter_dpt( S, EnterBool, Write) <- if (Write=true) {  .println(S, " is not a social goal") }.

+!check_able_to_commit_at_least_one(SubGoals, EnterBool, Write) 
	:
		SubGoals = []
	<-
		Write = false;
	.
+!check_able_to_commit_at_least_one(SubGoals, EnterBool, Write) 
	:
		SubGoals = [Gh | Gt]
	<-
		!check_able_to_commit( Gh, GhBool, Write  );
		!check_able_to_commit_at_least_one(Gt, GtBool, Write);
		!logic_or(GhBool,GtBool,EnterBool);
	.
+!check_able_to_commit_at_least_one(SubGoals, EnterBool, Write) <- EnterBool=false.
	



+!check_able_to_commit( G, CommitBool, Write  )
	:
		goal(G)
	<-
		?triggering_condition(G, TriggeringCondition );
		?final_state(G, FinalState );
		
		!check_able_to_perceive_event(TriggeringCondition, PercBool, Write );
		!check_able_to_address(FinalState, AddrBool, Write );
		
		!logic_and(PercBool,AddrBool,CommitBool);
	.
+!check_able_to_commit( G, false, Write  ) <- if (Write=true) {  .println(G, " is not a system goal") }.


/* BASIC check 'perception an event' capability */	

+!check_able_to_perceive_event( Event , PercBool, Write  )
	:
		event_occur_when_state_true( Event, State )
	<-
		if (Write=true) { .println(check_able_to_perceive_event( Event , PercBool ), " when state true " );}
		!check_able_to_perceive_state(State, PercBool, Write );
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_event( Event , PercBool, Write  )
	:
		event_occur_after(Event, PreviousEvent, _ )
	<-
		if (Write=true) { .println(check_able_to_perceive_event( Event , PercBool ), " after "  );}
		!check_able_to_perceive_event(PreviousEvent, PercBool, Write );
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_event( Event , PercBool, Write  )
	:
	 	( 
	 		event_definition(Event, and( EventList ) ) 
	 	|	event_definition(Event, or( EventList ) )
	 	)
	<-
		if (Write=true) { .println(check_able_to_perceive_event( Event , PercBool ) , " and/or ");}
		!check_able_to_perceive_event(EventList, PercBool, Write );
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_event( Event , PercBool, Write  )
	:
	 	event_definition(Event, neg( NotEvent ), " neg " )
	<-
		if (Write=true) { .println(check_able_to_perceive_event( Event , PercBool ) );}
		!check_able_to_perceive_event(NotEvent, PercBool, Write );
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_event( EventList , PercBool, Write  )
	:
	 	EventList = [Eh | Et]
	<-
		if (Write=true) { .println(check_able_to_perceive_event( Event , PercBool ), " list " );}
		!check_able_to_perceive_event(Eh, EhPercBool, Write );
		!check_able_to_perceive_event(Et, EtPercBool, Write );
		!logic_and(EhPercBool,EtPercBool,PercBool);
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_event( EventList, PercBool, Write  )
	:
	 	EventList = []
	<-
		PercBool = true
	.
+!check_able_to_perceive_event( Event, false, Write  ) <- if (Write=true) { .println("no corrispondence with ",Event); }.



/* BASIC check 'perception a state' capability */	
+!check_able_to_perceive_state( State , PercBool, Write  )
	:
		state_true_when(State, Predicate )
	<-
		if (Write=true) { .println(check_able_to_perceive_state( State , PercBool ), " state_true_when " );}
		PercBool = true;
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_state( State , PercBool, Write  )
	:
		state_is_property(State, Predicate, ParamList )
	<-
		if (Write=true) { .println(check_able_to_perceive_state( State , PercBool ), " state_is_property " );}
		PercBool = true;
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_state( State , PercBool, Write  )
	:
		state_true_when_income_msg(State, Msg, Actor)
	<-
		?content(Msg,Content);
		
		if (Write=true) { .println(check_able_to_perceive_state( State , PercBool ), " state_true_when_income_msg " );}
		!check_agent_capability_receive_msg(Content,Actor,PercBool, Write );
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_state( State , PercBool, Write  )
	:
		state_true_when_outcome_msg(State, Msg, Actor)
	<-
		if (Write=true) { .println(check_able_to_perceive_state( State , PercBool ), " state_true_when_outcome_msg " );}
		PercBool = true;
		if (Write=true) { .println( "Result is ",PercBool); }
	.
	
+!check_able_to_perceive_state( State , PercBool, Write  )
	:
	 	( 
	 		state_definition(State, and( List ) ) 
	 	|	state_definition(State, or( List ) )
	 	)
	<-
		if (Write=true) { .println(check_able_to_perceive_state( State , PercBool ), " and/or " );}
		!check_able_to_perceive_state(List,PercBool, Write );
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_state( State , PercBool, Write  )
	:
	 	state_definition(State, neg( NotState ) )
	<-
		if (Write=true) { .println(check_able_to_perceive_state( State , PercBool ), " neg " );}
		!check_able_to_perceive_state(NotState,PercBool, Write );
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_state( StateList , PercBool, Write  )
	:
		StateList = [Sh | St]
	<-
		if (Write=true) { .println(check_able_to_perceive_state( State , PercBool ), " list " );}
		!check_able_to_perceive_state(Sh,ShPercBool, Write );
		!check_able_to_perceive_state(St,StPercBool, Write );
		
		!logic_and(ShPercBool,StPercBool,PercBool);
		if (Write=true) { .println( "Result is ",PercBool);}
	.
+!check_able_to_perceive_state( State, AddreBool, Write  )
	:
	 	State = []
	<-
		AddreBool = true
	.
+!check_able_to_perceive_state( State, false, Write  ) <- if (Write=true) { .println("no corrispondence with ",State);} .




/* BASIC check 'addressing a state' capability */	
+!check_able_to_address( State, AddreBool, Write )
	:
		state_true_when(State, Predicate )
	<-
		!check_agent_capability_address_predicate(Predicate, AddreBool, Write);
	.
+!check_able_to_address( State, AddreBool, Write )
	:
		state_is_property(State, Predicate, ParamList )
	<-
		!check_agent_capability_address_property(Predicate, ParamList, AddreBool, Write);
	.
+!check_able_to_address( State, AddreBool, Write )
	:
		state_true_when_outcome_msg(State, Msg, Actor )
	<-
		?content(Msg,Content);
		!check_agent_capability_send_msg(Content, Actor, AddreBool, Write);
	.
+!check_able_to_address( State, AddreBool, Write )
	:
	 	( 
	 		state_definition(State, and( List ) ) 
	 	|	state_definition(State, or( List ) )
	 	)
	<-
		!check_able_to_address(List, AddreBool, Write);
	.
+!check_able_to_address( State, AddreBool, Write )
	:
	 	state_definition(State, neg( NotState ) )
	<-
		!check_able_to_address(NotState, AddreBool, Write);
	.
+!check_able_to_address( State, AddreBool, Write )
	:
	 	State = [Sh | St]
	<-
		!check_able_to_address(Sh,ShPercBool, Write);
		!check_able_to_address(St,StPercBool, Write);
		
		!logic_and(ShPercBool,StPercBool,AddreBool);
	.
+!check_able_to_address( State, AddreBool, Write )
	:
	 	State = []
	<-
		AddreBool = true
	.
+!check_able_to_address( State, false, Write ) <- true.


/* ** ** ** ** ** */


/* BASIC check 'msg, predicate, property' capability */	

+!check_agent_capability_receive_msg(Content,Actor,CapacityBool, Write)
	:
		agent_capacity(C)
	&	plan_input( C, message_in(Content,Actor) )
	<-
		CapacityBool=true;
	.
+!check_agent_capability_receive_msg(Content,Actor,false, Write) <- true.

+!check_agent_capability_send_msg(Content,Actor,CapacityBool, Write)
	:
		agent_capacity(C)
	&	plan_output( C, message_out(Content,Actor) )
	<-
		CapacityBool=true;
	.
+!check_agent_capability_send_msg(Content,Actor,false, Write) <- true.

+!check_agent_capability_address_predicate(Predicate, CapacityBool, Write)
	:
		agent_capacity(C)
	&	plan_output(C,predicate(Predicate) )
	<-
		CapacityBool=true
	.
+!check_agent_capability_address_predicate(Predicate,false, Write) <- true.

+!check_agent_capability_address_property(Predicate, ParamList, CapacityBool, Write)
	:
		agent_capacity(C)
	&	plan_output(C,property(Predicate,ParamList) )
	<-
		CapacityBool=true
	.
+!check_agent_capability_address_property(Predicate, ParamList, false, Write) <- true.







								