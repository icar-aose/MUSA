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
		!updateLocalHost;
		clearJobsAndEntries;	// MAYBE SOME JOB OR ENTRY PERSISTED TO MAS END		
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