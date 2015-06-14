/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: social commitment
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



// ATTENZIONE
// LE CAPABILITY POSSONO ESSERE ATTIVATE SOLO SE
// LE PRECONDITION SONO VERE TENENDO CONTO DELL'EVENTUALE ASSIGNMENT (PARAMETRIC CONDITION)
	
+start_social_commitment(Context,Pack,Capability,TaskPre,TaskPost,AssignmentList)[source(Manager)]
	<-
		//occp.logger.action.info("Preparing capability ",Capability);
//		.print("Preparing capability ",Capability);




		//TODO E SE NON FOSSE PARAMETRICA???
		!prepare(Capability, Context, AssignmentList);
		
		//.abolish( start_social_commitment(Context,Pack,Capability) );
		.abolish( start_social_commitment(Context,Pack,Capability,TaskPre,TaskPost,AssignmentList) );
		
		
		
		Context = project_context(Department,ProjectName);
		
		//.println("commit to ",Context," with ",Capability);
		!request_manager_send_context(Context);
		.wait(500);
		
		!build_current_state_of_world(Context,WI);
		!commit_to_goal_pack(Context,Pack,Capability,TaskPre,TaskPost,AssignmentList);
	.
	