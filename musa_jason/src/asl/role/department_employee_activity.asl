/**************************
 * @Author: Luca Sabatucci
 * Description:
 * 
 * Last Modifies:  
 * 
 * TODOs:
 * Vedi nota in place_coordinator_application
 * Vedi nota in select_coordinator
 * 
 *
 * Bugs:  
 * 
 *
 **************************/

{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }
{ include( "peer/project_persistance.asl" )}
{ include( "peer/act_as_server.asl" )}
{ include( "peer/capability_lifecycle.asl")}
{ include( "peer/synchronous_broadcast.asl" )}
{ include( "peer/capability_execution.asl" )}
{ include( "role/department_manager_activity.asl" )}
{ include( "role/project_employee_activity.asl" )}
{ include( "role/project_manager_activity.asl" )}
{ include( "search/collaborative_search_with_accumulation.asl" )}

{ include( "peer/check_commitment.asl" )}


+!debug_employee
	<-
		//.println("I am the staff");
		!use_organization_artifact(OrgId);
	.

+!debug_manager
	<-
		//.println("I am the manager");
		!create_or_use_database_artifact(DBId);
		!use_organization_artifact(OrgId);
		?url_for_agent_services(Url);
		!create_or_use_http_artifact(Url,Id);
	.

+!awake_as_employee : true 
	<- 
		!create_or_use_database_artifact(DBId);
		
		?url_for_agent_services(Url);
		!create_or_use_http_artifact(Url,Id); 
		
		//!join_organization;	
		!use_organization_artifact(OrgId);
	.

// signal from Organization artifact
+nominate_manager(ManagerName,GoalPack)
	:
		execution(test) 
	<-
		.my_name(Me);
		.term2string(PackTerm,GoalPack);
		subscribeDpt(Me,PackTerm);
	.

+nominate_manager(ManagerName,GoalPack) 
	<-
		.term2string(PackTerm,GoalPack);
		!check_able_to_enter_dpt( PackTerm, CommitBool, false);
		!dpt_subscription(PackTerm, CommitBool);
	.

+!dpt_subscription(PackTerm, CommitBool)
	:
		CommitBool=true
	<-
		.my_name(Me);
		subscribeDpt(Me,PackTerm);
	.	
+!dpt_subscription(PackTerm, CommitBool) <- true.


/**
 * [davide]
 * 
 * Event triggered from boss agent when a new goal is 
 * injected into the system from the goal injection GUI.
 * 
 */
+new_goal(Name, Pack, Description,GoalParams)[source(X)]
	<-
		ids.goalspec.loadFromFile(Name, Pack, Description,GoalParams);
	.

/**
 * [davide]
 * 
 * Set a capability to failure state by adding a belief fail([CAPABILITY_NAME]) to the belief
 * base of the agent who owns the capability.
 */
+capability_failure_state(Ag,CapStr,Failure)
	<-
		.print("SETTING FAILURE STATE FOR ",CapStr," to ",Failure);
		.term2string(Cap,CapStr);
		
		if(.desire( agent_capability(CapStr) ))
		{
			if(Failure)		{-+fail(Cap);}
			else			{.abolish(fail(Cap));}	
		}
		
		.abolish(capability_failure_state(Ag,Cap,_));
	.

/**
 * [davide]
 * 
 * Event triggered when an employee receive a signal from the dpt manager
 * to remove a capability from the blacklist.
 */
+remove_from_blacklist(Capability)[source(Manager)]
	<-
		?blacklist_verbose(BV);
		.my_name(Me);
		
		if(BV){.print("[BLACKLIST] Capability ",Capability," removed from local blacklist");}

		.abolish( capability_blacklist(Me,Capability,_) );
		.abolish( capability_blacklist_cost(Me,Capability,_) );
		.abolish( remove_from_blacklist(Capability) );
	.
	
+request_for_capability_set[source(X)]
	<-		
		.my_name(Me);
		.findall(Cap, agent_capability(Cap), CS);
		
		.send(X, tell, agent_capability_set(CS));
		
		.abolish( request_for_capability_set );
	.
	
/**
 * [davide]
 * 
 * Add the prepare/action/terminate plans to the agent's plans library.
 */
+inject_implementation_capability_plans(Prepare, Action, Terminate)
	<-
		.my_name(Me);
		
		.add_plan(Prepare, Me, end);
		.add_plan(Action, Me, end);
		.add_plan(Terminate, Me, end);
		
		
		
		.list_plans({ +!prepare(_,_,_) });
		.list_plans({ +!action(_,_,_) });
		.list_plans({ +!terminate(_,_,_) });
		
		.abolish( inject_implementation_capability_plans(_,_,_) );
	.	
	
