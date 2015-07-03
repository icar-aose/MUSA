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

//!awake.


+!awake 
	<-
		//CARICAMENTO DELLA GOAL BASE DA FILE. COMMENTARE SE SI USA LA GUI PER LA GOAL INJECTION
		action.loadGoalBase("src/asl/goalBaseSigma.asl",GoalList);
		.length(GoalList,Len);
		for (.range(I,0,Len-1))
		{
			.nth(I,GoalList,T);
		  	.print("loaded: ",T);	
			+T;
			.broadcast(tell,T);	
		}
		//-----------------------------------------
		
		
		
		//-----------------------------------------
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
		//-----------------------------------------

		//GUI PER LA GOAL INJECTION
		?use_gui(V);
		if(V=true)
		{
			makeArtifact("AddNewGoalGUI", "ids.artifact.AddGoalGUIArtifact", [], GuiID);		//Create the GUI artifact for submitting new goal
			+using_artifact("addNewGoalGUI", GuiID);											//adHd the ID to the belief base
			focus(GuiID);																		//focus the GUI artifact
		}
		//-----------------------------------------
	
		!awake_as_head; 		/* in peer/department_head_activity.asl */		
		!check_social_goal;
		
		//GUI PER INJECTION VIA WEB
//		makeArtifact("GoalServer", "ids.artifact.GoalServer", [], GoalServerID);
//		focus(GoalServerID);
//		connect(Result);
//		run_server;
	.

+!check_social_goal 
	<-
		.wait(500);
		
		!create_department_foreach_social_goal;
		
		/*
		if(not .empty(SocialGoals))
		{
			!create_department_foreach_social_goal;
		}
		else
		{
			.print("No social goal found. Idle...");
			?frequency_long_perception_loop(Delay);
			.wait(5000);
			!check_social_goal;
		} */
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
 * This event is triggered after injecting all the goals within a pack. It creates the department for the social goal.
 */
+createDepartmentForInjectedGoalPack(PackName)
	<-
		!create_department_for_social_goal(PackName);
		occp.logger.action.info("Department for Pack ",PackName, "has been created.");
		-createDepartmentForInjectedGoalPack(PackName);
	.

/**
 * [davide]
 * Event triggered when a goal pack has to be injected. It injects a goal with the specified name, pack and description. 
 */
+goalToInject(Name, Pack, Description)
	:
		not goal_injected(Name,Pack,_)
	<-
		!doGoalInjection(Name, Pack, Description);
		.print("Goal ",Name," injected correctly!");
		-goalToInject(Name,Pack,Description);
	.
	
+goalToInject(Name, Pack, Description)
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
+!doGoalInjection(Name, Pack, Description)
	<- 
		ids.goalspec.loadFromFile(Description);				//Parse the goal
		+goal_injected(Name, Pack, Description);			//Keep a mental note about the goal
		occp.logger.action.info("Goal injected: ",Description);
		.broadcast(tell, new_goal(Description) );			//Tell the customers that a new goal has been injected						
	.
	
-!doGoalInjection(Name, Pack, Description)
	<-
		.print("[ERROR] Failed to inject goal '",Description,"'");
	.
	
/**
 * [davide]
 * Event triggered when boss agent receives a new goal to be submitted to the employees.
 */
+submitGoalToDB
	<-  
		newGoalToSubmitToDatabase_Data(Name, Pack, Description);			//Take the new goal data
		submitGoalToDatabase(Name, Pack, Description);						//Submit the new goal into the database
		+submittedToDB(Name);												//Keep a mental note about the goal
		-submitGoalToDB;
	.
	
	
	
	
	
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

	