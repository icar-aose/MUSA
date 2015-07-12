/**************************/
/*
* Last Modifies:
 * 
 * Todo (davide):
 * - controllare se un goal e' stato gia inserito nel database
 * - inserire un bottone nella GUI per rimuovere un goal selezionato
 * 
 * Bugs:  
 * 
 */
/**************************/

{ include( "role/department_head_activity.asl" ) }
{ include( "role/department_manager_activity.asl" ) }

!awake_musa.



+!awake_musa
	:
		execution(deployment)
	<-
//		?proxy(ProxyAgent);
//		.send(ProxyAgent, achieve, awake);
		
		.broadcast(achieve, awake);
		!awake_boss;
	.
+!awake_musa
	:
		execution(standalone)
	<-
		?use_gui(V);
		if(V)
		{
			makeArtifact("AddNewGoalGUI", "ids.artifact.MusaConfigGUIArtifact", [], GuiID);
			loadDefaultDatabaseConfiguration;													//Load the default db configuration
			+using_artifact("addNewGoalGUI", GuiID);											//add the ID to the belief base
			focus(GuiID);																		//focus the GUI artifact
		}
	.
	
+!awake_musa
	:
		execution(test)
	<-
		action.loadGoalBase("src/asl/goalBase.asl",GoalList);
		.length(GoalList,Len);
		for (.range(I,0,Len-1))
		{
			.nth(I,GoalList,T);
		  	.print("loaded: ",T);	
			+T;
			.broadcast(tell,T);	
		}
		
		.broadcast(achieve, awake);
		!awake_boss;
		
	.


+!awake_with_cap_failure_gui
	
	<-
		//GUI per il fallimento delle capability
		?use_capability_failure_gui(UseFailureGUI);
		if(UseFailureGUI)
		{
			makeArtifact("FailureGUI", "ids.artifact.HandleCapabilityFailureGUIartifact", [], GuiID);		//Create the GUI artifact for submitting new goal
			+using_artifact("FailureGUI", GuiID);											//adHd the ID to the belief base
			focus(GuiID);
			!get_all_capabilities(CS);
			.print("CS: ",CS);
			.print("starting musa...");			
		}
	.
	
/**
 * [davide]
 * 
 * This event is triggered when user starts MUSA from the
 * configuration GUI. This plan awake all the agents.
 */
+awake_boss
	<-
		!!awake_boss;
		.broadcast(achieve, awake);
		-awake_boss;
	.
+!awake_boss
	<-
		!awake_as_head; 		/* in peer/department_head_activity.asl */		
		!check_social_goal;
	.

+!check_social_goal 
	<-
		.wait(500);	
		!create_department_foreach_social_goal;
	.


+!create_department_foreach_social_goal
	<-
		.findall(SGName,social_goal(TC,FS,A)[pack(SGName)],SocialGoals);
		.println("Goal Packs: ",SocialGoals," injected");

		for ( .member(SG, SocialGoals) ) 			// For each social goal SG within the social goal list SocialGoals
		{	
			//prima di creare un dipartimento si deve effettuare il parsing della descrizione
			//del goal inserito. Questo e' possibile cambiando opportunamente i metodi presenti
			//nella classe [ids.goalspec.loadFromFile]
			
			if(not created_dpt(StringSG))
			{
				.term2string(SG, StringSG);					// Converts the term SG into a string StringSG.
				!create_department_for_social_goal(StringSG);
				+created_dpt(StringSG);
			}
		}
	.
	
+!create_department_for_social_goal(StringSG)
	<-
		.concat(StringSG, "_dept", DeptName);			// Unifies DeptName with "[StringSG]_dept"	
		createDepartment(DeptName, StringSG);			// Create a department for the social goal SG (in Organization artifact)
	.	

/**
 * [davide]
 * 
 * This event is triggered when user submit a jason goal pack
 * from the configuration GUI.
 */
+injectJasonGoals
	<-
		getInjectedJasonGoals(GoalList);
		!injectJasonPack(GoalList);
		.abolish(injectJasonGoals);
	.

/**
 * [davide]
 * 
 * Inject a jason goal pack
 */
+!injectJasonPack(Pack)
	<-
		.length(Pack,Len);
		for (.range(I,0,Len-1))
		{
			.nth(I,Pack,T);
		  	.print("loaded: ",T);	
			+T;
			.broadcast(tell,T);	
		}
	.

/**
 * [davide]
 * Event triggered when a goal pack has to be injected. It injects a goal with the specified name, pack and description. 
 */
+goalToInject(Name, Pack, Description,GoalParams)
	:
		not goal_injected(Name,Pack,_)
	<-
		!doGoalInjection(Name, Pack, Description,GoalParams);
		.print("Goal ",Name," injected correctly!");
		-goalToInject(Name,Pack,Description);
		
		//forzo a ricreare il goalpack
		.abolish(created_dpt(_)); //ATTENZIONE!!!
		.print("Creo dipartimento...");
		!check_social_goal;
	.
	
+goalToInject(Name, Pack, Description,GoalParams)
	:
		.findall(gi(N,P), goal_injected(Name,Pack,Description), GoalList) 	&
		.length(GoalList, L) 												&
		L > 0
	<-
		.print("Goal '",Description,"' already injected.");
		-goalToInject(Name,Pack,Description)
	.
	
/**
 * [davide]
 * Inject a goal.
 */
+!doGoalInjection(Name, Pack, Description, GoalParams)
	<- 
		ids.goalspec.loadFromFile(Name, Pack, Description, GoalParams);				//Parse the goal
		+goal_injected(Name, Pack, Description, GoalParams);			//Keep a mental note about the goal
		occp.logger.action.info("Goal injected: ",Description,",",GoalParams);
		.broadcast(tell, new_goal(Name, Pack, Description,GoalParams) );			//Tell the customers that a new goal has been injected						
	.
	
-!doGoalInjection(Name, Pack, Description)
	<-
		.print("[ERROR] Failed to inject goal '",Description,"'");
	.



//#####################################################
//PIANI RELATIVI AL FALLIMENTO MANUALE DELLE CAPABILITY 
//#####################################################
/**
 * [davide]
 * 
 * Plan triggered when the failure GUI is activated. Boss agent gather all
 * the avaible capabilities and put them into the gui's combobox control.
 * From the gui, user can choose a capability and decide if to make it
 * fails or not.
 */
+!get_all_capabilities(CS)
	<-
		.broadcast(tell, request_for_capability_set);
		.wait(3000);
		.findall(commitment(Ag,Cap,HeadPercent), commitment(Ag,Cap,HeadPercent), CapSet);
		
		for(.member(Commitment,CapSet))
		{
			.print("member: ",Commitment);			
			Commitment = commitment(AgentName,CapName,_);
			addCapabilityToFailureGUI(AgentName, CapName);
		}
		
	.
	
+!wait_for_response
	<-
		.findall(Ag, agent_response(Ag), AgSet);
		.all_names(AllAgents);

		!check_if_agent_is_in_set(AgSet, AllAgents, Bool);
		
		if(Bool == false)
		{
			.wait(500);
			.print("Non ho ancora ricevuto tutte le risposte....");
			!!wait_for_response;
		}
	.
+!check_if_agent_is_in_set(Agent, AGset, Bool)
	:
		Agent = [Head|Tail]
	<-
		!check_if_agent_is_in_set(Tail, AGset, BoolRec);
		
		if(.member(Head,AGset))	{.eval(Bool,true & BoolRec);}
		else					{.eval(Bool,false & BoolRec);}
	.
+!check_if_agent_is_in_set(Agent, AGset, Bool)
	:	Agent = []
	<-	Bool = true;
	.
	
/**
 * Event triggered when the submit button into the capability 
 * failure GUI is clicked. 
 */
+submitCapabilityFailure
	<-
		getFailureCapabilityInfo(Ag,Cap,Failure);
		
		.print("Submit for ",Cap);
		
		.all_names(Members);
		.send(Members, tell, capability_failure_state(Ag,Cap,Failure));
	.

	