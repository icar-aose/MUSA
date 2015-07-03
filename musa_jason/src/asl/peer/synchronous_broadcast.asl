/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: protocol for synchronous collaboration
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


+?get_max_counter(Token,MaxCounter)
	:
		max_time_for_collecting(Token,Counter)
	<-
		MaxCounter=Counter;
	.
+?get_max_counter(Token,MaxCounter)
	:
		max_time_for_collecting(Counter)
	<-
		MaxCounter=Counter;
	.
	
+!ask_for_collaborations(CollaboratorList,Predicate,ResponseList)
	<-
		!timestamp(Token); /* unique string (from common.asl) */
		
		?get_max_counter(Token,MaxCounter);
		
		+wait_collaboration(Token);
		.send(CollaboratorList, tell, collaboration_request(Token,MaxCounter-2,Predicate));	/* broadcast collaboration request */
		+collaborators(Token,CollaboratorList);
		
		!collect_all_answers(Token,0,CollaboratorList,ResponseList);	/* start collecting answers */
	.

+collaboration_answer(Token,Response)[source(Collaborator)]
	:
		wait_collaboration(Token)
	&	collaborators(Token,CollaboratorList)	
	&	.member(Collaborator,CollaboratorList)	
	&	.list(Response)
	<- 
		.delete(Collaborator,CollaboratorList,UpdateCollaboratorList);
		-+collaborators(Token,UpdateCollaboratorList);
		
		for (.member(X,Response)) {
			+collaboration_response(Token,Collaborator,X);
		}
		-collaboration_answer(Token,Response)[source(Collaborator)];
	.
+collaboration_answer(Token,Response)[source(Collaborator)]
	:
		wait_collaboration(Token)
	&	collaborators(Token,CollaboratorList)	
	&	.member(Collaborator,CollaboratorList)	
	<- 
		.delete(Collaborator,CollaboratorList,UpdateCollaboratorList);
		-+collaborators(Token,UpdateCollaboratorList);
		
		+collaboration_response(Token,Collaborator,Response);
		
		-collaboration_answer(Token,Response)[source(Collaborator)];
	.
+collaboration_answer(Token,Response)[source(Collaborator)] 
	:
		not wait_collaboration(Token)
	<- 
		.println("received out of Token: ",Response," from ",Collaborator); 
	.
+collaboration_answer(Token,Response)[source(Collaborator)] 
	<- 
		.println("receive an error: ",Response," from ",Collaborator); 
	.


+!collect_all_answers(Token,Counter,CollaboratorList,ResponseList)
	<-
		?get_max_counter(Token,MaxCounter);	/* max ripetition */
		.wait(MaxCounter);					/* wait a time */
		
		?collaborators(Token,WaitingCollaboratorList);
		/*.print("Counter: ",Counter);
		.print("MaxCounter: ",MaxCounter);
		.print("\n\n\n",.length(WaitingCollaboratorList),"\n\n");*/
		.length(WaitingCollaboratorList,Ll);
		//if (.empty(WaitingCollaboratorList) | Counter > MaxCounter )
		if (Ll = 0 | Counter > MaxCounter ) 
		{	
			/*  if all replied or time>threshold
				exit with SubSolutionList */
			-wait_collaboration(Token);
			-collaborators(Token,_);
			
			.findall(Response,collaboration_response(Token,_,Response),ResponseList);	/* collect all the sub-solutions */
			.abolish( collaboration_response(Token,_,_) );	/* forget all the answers */
		} 
		else 
		{
			/* repeat */	
			!collect_all_answers(Token,Counter+1,CollaboratorList,ResponseList);	/* continue */
		}
	.

	