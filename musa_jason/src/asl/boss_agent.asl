/**************************/
/*
* Last Modifies:
 * 
 * TODO:
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
			makeArtifact("AddNewGoalGUI", "musa.artifact.MusaConfigGUIArtifact", [], GuiID);
			loadDefaultDatabaseConfiguration(Success);													//Load the default db configuration
			+using_artifact("addNewGoalGUI", GuiID);											//add the ID to the belief base
			focus(GuiID);																		//focus the GUI artifact
			
			if(not Success)
			{
				?default_db_user(User);
				?default_db_port(Port);
				?default_db_password(Pass);
				?default_db_database(DbName);
				?default_db_ip(Ip);
				loadHardCodedDatabaseConfiguration(User, Port, Pass, DbName, Ip);
			}
			
			.broadcast(achieve, awake);
			!awake_boss;
		}
	.
+!awake_musa
	:
		execution(test)
	<-
		action.loadGoalBase("src/asl/defaultGoalPack.asl",GoalList);
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
+!awake_musa
	<-
		.print("No execution profile specified. Aborting");
	.
//DEPRECATA
+!awake_with_cap_failure_gui	
	<-
		//GUI per il fallimento delle capability
		?use_capability_failure_gui(UseFailureGUI);
		if(UseFailureGUI)
		{
			makeArtifact("FailureGUI", "musa.artifact.HandleCapabilityFailureGUIartifact", [], GuiID);		//Create the GUI artifact for submitting new goal
			+using_artifact("FailureGUI", GuiID);											//adHd the ID to the belief base
			focus(GuiID);
			!get_all_capabilities(CS);
			.print("CS: ",CS);
			.print("starting musa...");			
		}
	.

/**
 * Add a new agent to MUSA 
 */
+addNewAgent(AgName, Path)
	<-
		.create_agent(AgName, Path, [agentArchClass("c4jason.CAgentArch")]);		//Create the agent using the cartago agent architecture
		.wait(1000);
		.send(AgName, achieve, awake);												//awake the new agent
		.print("Agent ",AgName," added");
		.abolish( addNewAgent(AgName, Path) );									
	.	
	
/**
 * Awake the boss agent
 */
+!awake_boss
	<-
		!awake_as_head; 		/* in peer/department_head_activity.asl */		
		!check_social_goal;
		!set_musa_status(ready);
	.

+!check_social_goal 
	<-
		.wait(500);	
		!create_department_foreach_social_goal;
	.


+!create_department_foreach_social_goal
	<-
		.findall(SGName,social_goal(TC,FS,A)[pack(SGName)],SocialGoals_1);
		.findall(SGName,social_goal(TC,FS)[pack(SGName)],SocialGoals_2);
		
		.union(SocialGoals_1,SocialGoals_2,SocialGoals);
		
		.println("Goal Packs: ",SocialGoals," injected");

		for ( .member(SG, SocialGoals) ) 						// For each social goal SG within the social goal list SocialGoals
		{	
			if(not created_dpt(StringSG))
			{
				.term2string(SG, StringSG);						// Converts the term SG into a string StringSG.
				!create_department_for_social_goal(StringSG);	// Create a new department
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
+injectJasonGoals(GoalList)
	<-
		!injectJasonPack(GoalList);
		!check_social_goal;
		
		?simulate_request_in_deployment(SimulateRequest);
		if(SimulateRequest)
		{
			?proxy(ProxyAgent);
			.send(ProxyAgent, achieve, simulate_occp_request);	
		}

		.abolish(injectJasonGoals(_));
	.

/**
 * [davide]
 * 
 * Inject a jason goal pack
 */
+!injectJasonPack(Pack)
	: 
		.list(Pack)
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
-!injectJasonPack(Pack)
	<-
		.print("Failed to inject goal pack ",Pack);		
	.	

/**
 * [davide]
 * 
 * Event triggered when a goal pack has to be injected. It injects 
 * a goal with the specified name, pack and description (GoalSPEC). 
 */
+goalToInject(Name, Pack, Description,GoalParams)
	:
		not goal_injected(Name,Pack,_)
	<-
		!doGoalInjection(Name, Pack, Description, GoalParams);
		.print("Goal ",Name," injected correctly!");
		-goalToInject(Name,Pack,Description);
		
//		.abolish(created_dpt(_)); //ATTENZIONE!!!
//		.print("Creo dipartimento...");
		.abolish( goalToInject(Name, Pack, Description,GoalParams) );
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
 * This event is triggered after injecting all the goals within a pack. It creates the department for the social goal.
 */
+createDepartmentForInjectedGoalPack(PackName)
	<-
		!create_department_for_social_goal(PackName);
		.abolish( createDepartmentForInjectedGoalPack(PackName) );
	.
	
/**
 * [davide]
 * Inject a goal (GoalSPEC).
 */
+!doGoalInjection(Name, Pack, Description, GoalParams)
	<- 
		musa.goalspec.loadFromFile(Name, Pack, Description, GoalParams);				//Parse the goal
		+goal_injected(Name, Pack, Description, GoalParams);						//Keep a mental note about the goal
		.broadcast(tell, new_goal(Name, Pack, Description,GoalParams) );			//Tell the customers that a new goal has been injected						
	.
	
-!doGoalInjection(Name, Pack, Description)
	<-
		.print("[ERROR] Failed to inject goal '",Description,"'");
	.

+submitCapabilityFailure(CapName)
	<-
		.print("Set ",CapName," to Failure state");
		.all_names(Members);
		!submitCapabilityFailureToMember(CapName, Members, tell);
		.abolish( submitCapabilityFailure(CapName) );
	.

+unsetCapabilityFailure(CapName)
	<-
		.print("Unset ",CapName," from Failure state");
		.all_names(Members);
		!submitCapabilityFailureToMember(CapName, Members, untell);
		.abolish( unsetCapabilityFailure(CapName) );
	.
	
+!submitCapabilityFailureToMember(CapName, Members, Message)
	:
		Members = []
	.
+!submitCapabilityFailureToMember(CapNameStr, Members, Message)
	:
		Members = [Head|Tail]
	<-
		!submitCapabilityFailureToMember(CapNameStr, Tail, Message);
		
		.term2string(CapName, CapNameStr);
		.send(Head,askOne, agent_capability(CapName), Reply);
		
		if(Reply \== false)
		{
			.send(Head, Message, fail(CapName));
		}
	.






+request_for_agent_capability(Agent)
	<-
		if(.atom(Agent) | .string(Agent))
		{
			.send(Agent, tell, request_for_capability_set);
			.abolish(request_for_agent_capability(_));
		}
	.
/**
 * triggered from "submitDBconfiguration" in MusaConfigGUIArtifact class
 */
+updateLocalHost
	<-
		updateLocalHost;
		.abolish( updateLocalHost );
	.

	
+agent_capability_set(CS)[source(Agent)]
	<-
		.term2string(CS,CSstr);
		set_cs_into_configuration_gui(CSstr);
		.abolish(agent_capability_set(_));
	.

+start_musa_organization(ParamListString)
	<-
		.term2string(ParamList,ParamListString);
		?proxy(ProxyAgent);
		.send(ProxyAgent, achieve, simulate_occp_request(ParamList));
		.abolish( start_musa_organization(_) );
	.

	
+!set_musa_status(Status)
	:
		track_musa_status(true)
	<-
		.abolish( musa_status(_) );
		+musa_status(Status);
		
		action.set_musa_status(Status);
	.
+!set_musa_status(Status).