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
		!create_or_use_organization_artifact(OrgId);
		!create_or_use_database_artifact(DBId);
		!updateLocalHost;
		
		clearJobsAndEntries;
	.


+!awake_as_head : true
	<-		
//		!create_organization_artifact(OrgId);
		!create_or_use_organization_artifact(OrgId);
		!create_or_use_database_artifact(DBId);
		
		if(execution(test))			
		{
			!set_default_db;
		}
		if(execution(deployment))
		{
			//Try to load the default database configuration from file ~./musa/config.properties
			loadDefaultDatabaseConfiguration(Success);
			
			//If file doesn't exists nor file can't be read, set the default hard-coded
			//database configuration (in configuration.asl)
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
		updateLocalHost;
	.


+abolish(Something)
	<-
		.abolish(Something);
	.