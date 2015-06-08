/**************************/
// RESPONSIBILITIES:
// access DB
// for each Role in table workflow_role
//		for each User in table workflow_user
//			instantiate a new peer agent
/* Last Modifies:
 * 
 * Todo:
 * 
 * 1) (common) recover belief-base and clear dangerous predicates
 *
 * Bugs:  
 * 
*/
/**************************/

{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }


!awake.


+!awake  : execution(deployment)  
	<-
		.print("HELLO: deployment");
		!create_or_use_database_artifact(Id1);
		
		focus(Id1);
		
		readWorkflowUsers;
		
		.wait(1000);
		.my_name(Me);
		.kill_agent(Me);
	.

+!awake  : execution(test)  
	<-
		.print("HELLO: test");
		+user(luca,supervisor,"ids_quote_supervisor.asl");		
		+user(luigi,worker,"ids_quote_worker.asl");		
		+user(filippo,worker,"ids_quote_worker.asl");		
		+user(emilio,worker,"ids_quote_worker.asl");		
	.

+user(User,Role,AgentFile) : true 
	<- 
		//.concat(Role,".asl",AgentFile);
		
		.print("creating useragent for ",User," (",Role,") from file ",AgentFile);
		//.term2string(UserName,User);
		.create_agent(User,AgentFile, [ agentArchClass("c4jason.CAgentArch") ]);
		.send(User,tell,my_user(User,Role));
	.