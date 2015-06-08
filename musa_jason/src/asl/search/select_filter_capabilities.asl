/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: plans for selecting Capabilities for the space exploration 
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 *  - !get_capability_tx(Cap,TX)
 *
 * TODOs:
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/


+!debug_get_remote_capability_tx
	<-
		.my_name(Me);
		!get_remote_capability_tx(commitment(Me,decide,_),TX);
		.print("Found evolution plan: ",TX);	
	.


+!get_remote_capability_blacklist(Commitment, IsBlacklisted)
	:
		Commitment = commitment(Agent, Cap, _)
	<-
		.send(Agent, askOne, capability_blacklist(Agent, Cap), Reply);
		
		if (Reply \== false) 	{IsBlacklisted = true;}
		else					{IsBlacklisted = false;}
	.

/**
 * 
 * Return the evolution plan related to a specific capability.
 */
+!get_remote_capability_tx(Commitment,TX)
	:
		Commitment = commitment(Agent, Cap, HeadPercent)
	<-
		.send(Agent, askOne, capability_evolution(Cap,_), Reply);
		
		if (Reply \== false) 
		{
			Reply = capability_evolution(Cap,TransferFunction)[source(Agent)];
		}
		TX = TransferFunction;
	.
-!get_remote_capability_tx(Commitment,TX)
	<-
		.print("FAILED TO GET CAPABILITY EVO PLANS FOR COMMITMENT ",Commitment);
		TX=[];
	.

/**
 * [davide]
 * 
 * Get the parameters list related to a capability
 */
+!get_remote_capability_pars(Commitment,TX)
	:
		Commitment = commitment(Agent, Cap, _)
	<-
		.send(Agent, askOne, capability_parameters(Cap,_), Reply);
		
		if (Reply \== false) 
		{
			Reply = capability_parameters(Cap,CapabilityVars)[source(Agent)];
		}
		TX = CapabilityVars;
	.
-!get_remote_capability_pars(Commitment,TX)
	<-
		.print("FAILED TO GET CAPABILITY PARAMETERS FOR COMMITMENT ",Commitment);
		TX=[];
	.

/**
 * [davide]
 * 
 * Retrieve the pre-condition of a given capability
 */
+!get_remote_capability_precondition(Commitment,PC)
	:
		Commitment = commitment(Agent, Cap, HeadPercent)
	<-
		.send(Agent, askOne, capability_precondition(Cap,_), Reply);
		
		if (Reply \== false) 
		{
			Reply = capability_precondition(Cap,PreCondition)[source(Agent)];
		}
		else
		{
			PreCondition=[];
		}
		PC = PreCondition;
	.

/**
 * [davide]
 * 
 * Retrieve the post-condition of a given capability
 */
+!get_remote_capability_postcondition(Commitment,PC)
	:
		Commitment = commitment(Agent, Cap, HeadPercent)
	<-
		.send(Agent, askOne, capability_postcondition(Cap,_), Reply);
		
		if (Reply \== false) 			{Reply = capability_postcondition(Cap,PostCondition)[source(Agent)];}
		else							{PostCondition=[];}
		
		PC = PostCondition;
	.


+!get_remote_capability_cost(Commitment,Cost)
	:
		Commitment = commitment(Agent, Cap, HeadPercent)
	<-
		.send(Agent, askOne, capability_cost(Cap,_), Reply);
		
		if (Reply \== false) 			{Reply = capability_cost(Cap,CostList)[source(Agent)];}
		else							{CostList=[];}
		
		Cost = CostList;
	.

/**
 * [davide]
 * 
 * Check if a capability is of type http_interaction
 * 
 * da eliminare...
 */
+!check_if_capability_require_http_interaction(Commitment, Out)
	:
		Commitment = commitment(Agent, Cap, HeadPercent)
	<-
		.send(Agent, askOne, agent_capability(Cap)[capability_types(_)], ReplyMultiple);
		.send(Agent, askOne, agent_capability(Cap)[type(_)], ReplySingle);
		
		if (ReplyMultiple \== false) 
		{
			
			ReplyMultiple = agent_capability(Cap)[source(Agent),capability_types(Types)];
			
			if(.member(type(http_interaction),Types))		{Out=true;}
			else											{Out=false;}
		}
		else
		{
			if (ReplySingle \== false)
			{
				ReplySingle = agent_capability(Cap)[source(Agent),type(CapabilityType)];
				
				if(CapabilityType == type(http_interaction) )		{Out=true;}
				else												{Out=false;}
			}
		}
	.

/**
 * [davide]
 * 
 * Check if a capability is of a specified type.
 * 
 */
+!check_if_capability_is_of_type(Commitment, Type, Out)
	:
		Commitment = commitment(Agent, Cap, _)
	<-
		.send(Agent, askOne, agent_capability(Cap)[capability_types(_)], ReplyMultiple);
		.send(Agent, askOne, agent_capability(Cap)[type(_)], ReplySingle);
		
		if (ReplyMultiple \== false) 
		{
			
			ReplyMultiple = agent_capability(Cap)[source(Agent),capability_types(Types)];
			
			if(.member(type(Type),Types))		{Out=true;}
			else								{Out=false;}
		}
		else
		{
			if (ReplySingle \== false)
			{
				ReplySingle = agent_capability(Cap)[source(Agent),type(CapabilityType)];
				
				if(CapabilityType == Type)		{Out=true;}
				else							{Out=false;}
			}
		}
	.

/*Da eliminare
+!apply_evolution_operator(Operator,World,UpdatedWorld)
	:
		Operator = add(Statement)
	<-
		//.println("adding: ",Statement);
		World = world(StatementSet);
		.union(StatementSet,[Statement],UpdatedStatementSet);
		UpdatedWorld = world(UpdatedStatementSet);
	.
+!apply_evolution_operator(Operator,World,UpdatedWorld)
	:
		Operator = remove(Statement)
	<-
		//.println("removing: ",Statement);
		World = world(StatementSet);
		.delete(Statement,StatementSet,UpdatedStatementSet);
		UpdatedWorld = world(UpdatedStatementSet);
	.*/

	