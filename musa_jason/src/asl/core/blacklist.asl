/**
 * [davide]
 * 
 * Score the sequence of blacklisted capability set CS.
 * 
 * NOTE: CS is assumed to be a set of >only< blacklisted capability 
 */
+!score_blacklisted_CS(CS,OutScore)
	:
		CS 		= [Head|Tail]					&
		Head 	= commitment(Agent,Cap,_)
	<-
		BV = false;
		!score_blacklisted_CS(Tail,OutScoreRec);
		?orchestration_start_at(Orchestration_start_time);
		
		!get_remote_capability_blacklist(Head, Reply);
		
		if(Reply \== no_timestamp)
		{
			Capability_blacklist_timestamp = Reply;
			!how_many_times_elapsed(Capability_blacklist_timestamp,Orchestration_start_time, Blacklist_time);
			?blacklist_expiration(ExpHH,ExpMM,ExpSS);
			!timestamp_add(Capability_blacklist_timestamp, duration(0,0,0,ExpHH,ExpMM,ExpSS), BlacklistTimeStampDelayed);
			!how_many_times_elapsed(Capability_blacklist_timestamp, BlacklistTimeStampDelayed, Blacklist_max_time);
			
			if(BV)
			{			
				.print("######################");
				.print("Score for [",Cap,"]: ", (Blacklist_time/Blacklist_max_time));
				.print("Blacklist_time for [",Cap,"]: ",Blacklist_time);
				.print("Blacklist_max_time for [",Cap,"]: ",Blacklist_max_time);
				.print("######################");
			}
			OutScore = OutScoreRec + (Blacklist_max_time/Blacklist_time); 	
		
		}
	.
+!score_blacklisted_CS(CS,OutScore)
	:	CS 			= []
	<-	OutScore 	= 0;
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for +!get_blacklisted_capability_list+!update_capability_blacklist_expiration
 */
+!debug_get_blacklisted_capability_list
	<-
		CS = [commitment(worker,receive_order,_),commitment(worker,place_order,_), commitment(worker,place_order_alternative,_), commitment(worker,place_order_alternative2,_)];
		
		!get_blacklisted_capability_list(CS, BlacklistedCS);
		.print("CS: ",CS);
		.print("BlacklistedCS: ",BlacklistedCS);
	.

/**
 * [davide]
 * 
 * Given a set CS of capabilities, return the blacklisted subset of CS capabilities. 
 */
+!get_blacklisted_capability_list(CS, BlacklistedCS)
	<-
		!get_blacklisted_capability_list_aux(CS, _, BlacklistedCS);		
	.
+!get_blacklisted_capability_list_aux(CS, BlacklistedCapName, BlacklistedCS)
	:
		CS 		= [Head|Tail] 				&
		Head 	= commitment(Agent,Cap,_)
	<-
		!get_blacklisted_capability_list_aux(Tail, BlacklistedCapNameRec, BlacklistedCSRec);			//recursive call
		.send(Agent, askOne, capability_blacklist(Agent,Cap,_), Reply);									//ask to Agent if Cap is blacklisted
		if(Reply \== false & not .member(Cap, BlacklistedCapNameRec))									//If a reply is received, Cap is blacklisted
		{
			.union(BlacklistedCSRec, [Head], BlacklistedCS);
			.union(BlacklistedCapNameRec, [Cap], BlacklistedCapName);
		}
		else					
		{
			.union(BlacklistedCSRec, [], BlacklistedCS);
			.union(BlacklistedCapNameRec, [], BlacklistedCapName);
		}
	.
+!get_blacklisted_capability_list_aux(CS, BlacklistedCapName, BlacklistedCS)
	:	CS 					= []
	<-	BlacklistedCS 		= [];
		BlacklistedCapName 	= [];
	.

/**
 * [davide]
 * 
 * DEBUG PLAN for +!update_capability_blacklist_expiration
 */
+!debug_update_capability_blacklist_expiration(Context)
	<-
		CS = [commitment(worker,receive_order,_),commitment(worker,place_order,_), commitment(worker,place_order_alternative,_), commitment(worker,place_order_alternative2,_)];
		
		!get_blacklisted_capability_list(CS, BlacklistedCS);
		.print("CS: ",CS);
		.print("BlacklistedCS: ",BlacklistedCS);

		.my_name(Me);
		+capability_blacklist(Me, receive_order);
		!register_statement(capability_blacklist(Me, receive_order), Context);
		
		.print("waiting....");
		.wait(10000);
		!update_capability_blacklist(CS,Context);
		
		.print("waiting....");
		.wait(1000);
		
		!get_blacklisted_capability_list(CS, BlacklistedCS_2);
		.print("BlacklistedCS: ",BlacklistedCS_2);
	.

/**
 * [davide]
 * 
 * Update the agents blacklist. For each commitment in CS, this plan check
 * if a capability is blacklisted, and if true, then check if its persistence 
 * period within the blacklist has expired. In this case, the capability is 
 * removed from the blacklist.
 * 
 * This is executed by the dpt manager.
 */
+!update_capability_blacklist(CS, DBTimestamp, Context)
	:
		CS 		= [Head|Tail] 						&
		Head 	= commitment(Agent,Capability,_)
	<-
		?blacklist_verbose(BV);
		
		//Recursive call
		!update_capability_blacklist(Tail, DBTimestamp, Context);
		
		?capability_blacklist(Agent, Capability, TSblacklist);
		
		//get the blacklist expiration time
		?blacklist_expiration(HDelay,MDelay,SDelay);
		
		//Add the expiration rate to the capability blacklist timestamp
		!timestamp_add(TSblacklist, duration(0,0,0,HDelay,MDelay,SDelay), TimeStampDelayed);
		
		//Take the less recent timestamp
		!pick_less_recent(TimeStampDelayed, DBTimestamp, LessRecentTS );
		
		LessRecentTS 		= ts(LESS_Y, LESS_MTH, LESS_DAY, LESS_H, LESS_M, LESS_S);
		TimeStampDelayed	= ts(TS_Y, TS_MTH, TS_DAY, TS_H, TS_M, TS_S);
		
		//If the blacklist capability timestamp, to which the expiration rate has been added,
		//if less recent than the current timestamp
		if( LESS_Y==TS_Y 	& LESS_MTH==TS_MTH 		& LESS_DAY==TS_DAY	&
			LESS_H==TS_H 	& LESS_M==TS_M			& LESS_S==TS_S ) 	
		{ 
			//tell the owner of the capability to remove it from the blacklist
			.send( Agent, tell, abolish( capability_blacklist(Agent, Capability,_) ) );
			
			removeCapabilityFromBlacklist(Capability, Agent);
			.send(Agent, tell, remove_from_blacklist(Capability));
			
			
			if(BV){.print("[BLACKLIST] Capability [",Capability,"] blacklist period expired.");}
		}
	.
+!update_capability_blacklist(CS, DBTimestamp, Context)
	:
		CS 		= []
	.