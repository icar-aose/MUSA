/**
 * [davide]
 * 
 * Score the sequence of blacklisted capability set CS.
 * 
 * NOTE: CS is assumed to be a set of >only< blacklisted capability 
 */
+!score_blacklisted_CS(CS, OutScore)
	:
		CS 		= [Head|Tail]					&
		Head 	= task(_, _, _, cs(TaskCS), _, _ ) 
	<-
		!score_blacklisted_CS(TaskCS, OutScore);
	.
+!score_blacklisted_CS(CS, OutScore)
	:
		CS 		= [Head|Tail]					&
		Head 	= commitment(Agent,Cap,_)
	<-
		!score_blacklisted_CS(Tail,OutScoreRec);
	
		?blacklist_verbose(BV);
		?orchestration_start_at(Orchestration_start_time);
		
		!get_remote_capability_blacklist(Head, Reply);
		
		if(Reply \== no_timestamp)	
		{
			Failure_timestamp = Reply;
			?blacklist_expiration(ExpHH, ExpMM, ExpSS);
			!how_many_times_elapsed(ts(0,0,0,0,0,0), ts(0,0,0,ExpHH,ExpMM,ExpSS), TotalBlacklistTime);
			
			//Misuro quanto tempo è passato dall'inizio della pianificazione corrente al momento in cui è stata messa in blacklist la capability [Head]
			!how_many_times_elapsed(Failure_timestamp, Orchestration_start_time, Past_in_blacklist_time);
			
			//aggiungo una certa quantita temporale (definita in configuration.asl) al timestamp della capability in blacklist
			!timestamp_add(Failure_timestamp, duration(0,0,0,ExpHH,ExpMM,ExpSS), RemoveTimestamp);
			
			//misuro quanto tempo è passato dal momento in cui [Head] è stata messa in blacklist, allo stesso timestamp incrementato di una quantità predefinita
			//Questa quantita indica quant'è il tempo massimo per cui la capability deve rimanere in blacklist.
			!how_many_times_elapsed(Orchestration_start_time, RemoveTimestamp, Yet_to_finish_time);
			
			if(BV)
			{			
				.print("######################");
				.print("Score for [",Cap,"] from agent [",Agent,"]: ", (Past_in_blacklist_time/Blacklist_max_time));
				.print("orchestration started at ",Orchestration_start_time);
				.print(Head," in blacklist since ",Failure_timestamp);
				.print("Past in blacklist [",Cap,"]: ",Past_in_blacklist_time);
				.print("yet to finish for [",Cap,"]: ",Yet_to_finish_time);
				.print("RemoveTimestamp: ",RemoveTimestamp);
			}
			
			//if(Blacklist_time >= Blacklist_max_time)
			if (Yet_to_finish_time <= 0)
			{
				//remove the capability from the blacklist table into the database
				removeCapabilityFromBlacklist(Cap, Agent);
				
				//tell the owner of the capability to remove it from the blacklist
				.send(Agent, tell, remove_from_blacklist(Cap));
				
				if(BV){.print("[#############BLACKLIST#############] Capability [",Cap,"] blacklist period expired. Removing from blacklist.");}
				
				OutScore=0;
			}
			else
			{
				Score = Yet_to_finish_time/TotalBlacklistTime;
				.send(Agent, tell, capability_blacklist_cost(Cap, Score));
				
				OutScore = OutScoreRec + Score;
				if(BV)
				{
					.print("SCORE [",Cap,"]: ",Score);
					.print("######################");
				}
			}	
		}
		else
		{
			OutScore = 0;
		}
	.
+!score_blacklisted_CS(CS, OutScore)
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