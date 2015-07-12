/**************************
 * @Author: Luca Sabatucci
 * Description:
 * 
 * Last Modifies:  
 * 
 * TODOs:
 * 
 * 
 *
 * Bugs:  
 * 
 *
 **************************/

{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }

+!debug_head
	<-
		//.println("I am the head");
		!create_organization_artifact(OrgId);
		!create_or_use_database_artifact(DBId);
		!updateLocalHost;
		
		clearJobsAndEntries;
	.


+!awake_as_head : true
	<-		
		!create_organization_artifact(OrgId);
		!create_or_use_database_artifact(DBId);
		
		if(.desire(execution(test)))			
		{
			!set_default_db;
		}
		if(.desire(execution(deployment)))
		{
			loadDefaultDatabaseConfiguration(Success);
			if(not Success)						
			{
				!set_default_db;
			}
		}
		
		!updateLocalHost;
		clearJobsAndEntries;	// MAYBE SOME JOB OR ENTRY PERSISTED TO MAS END		
	.

/**
 * Load the default MUSA database configuration
 */
+!set_default_db
	<-
		?default_db_user(User);
		?default_db_port(Port);
		?default_db_password(Pass);
		?default_db_database(DbName);
		?default_db_ip(Ip);
		
		set_default_database(User, Port, Pass, DbName, Ip);
	.


+!updateLocalHost
	<-
		//?local_ip_address(Address);
//		updateLocalHost(Address);
		updateLocalHost;
	.


+abolish(Something)
	<-
		.abolish(Something);
	.