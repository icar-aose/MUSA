/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: utility plans
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * Luca - bridge to artifacts
 *
 * TODOs:
 * 
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/


{ include( "peer/common_context.asl" ) }


list_contains([H | T],Element) 
	:-
		(
			H = Element
		|	members_contain(T,Element)	
		)
	.

+!check_two_sets_are_equal(A,B,Bool)
	<-
		.union(A,B,Union);
		.intersection(A,B,Inters);
		.difference(Union,Inters,Diff);
		
		if ( .empty( Diff ) ) { Bool=true } else { Bool = false }		
	.


@try_create_org_artifact[atomic]
+!create_or_use_organization_artifact(Id)<-!create_organization_artifact(Id).

@otherwise_search_org_artifact[atomic]
-!create_or_use_organization_artifact(Id)<-!use_organization_artifact(Id).

+!create_organization_artifact(Id)
	<-
		.my_name(Me);
		makeArtifact("workflow_org","ids.artifact.Organization",[Me],Id);
		+using_artifact("workflow_org",Id);
		focus(Id);
	.
+!use_organization_artifact(Id)
	<-
		.my_name(Me);
		lookupArtifact("workflow_org",Id);
		+using_artifact("workflow_org",Id);
		focus(Id);
		subscribe(Me);
	.
-!use_organization_artifact(Id)
	<-
		.wait(300);
		!use_organization_artifact(Id);
	.
 
	

@try_create_proxy_server[atomic]
+!create_or_use_proxy_server_artifact(Id) : true
	<-
		!create_proxy_server_artifact(Id);
	.
@otherwise_search_proxy_server[atomic]
-!create_or_use_proxy_server_artifact(Id) : true
	<-
		lookupArtifact("proxy_server",Id);
		+using_artifact("proxy_server",Id);
	.
+!create_proxy_server_artifact(Id) : true
	<-
		makeArtifact("proxy_server","ids.artifact.HTTPProxy",[],Id);
		+using_artifact("proxy_server",Id);
	.
+!use_proxy_server_artifact(Id) : true
	<-
		?wait_artifact("proxy_server",Id);
		+using_artifact("proxy_server",Id);
	.


@try_create_database_artifact[atomic]
+!create_or_use_database_artifact(Id) : true
	<-
		!create_database_artifact(Id);
	.
@otherwise_search_database_artifact[atomic]
-!create_or_use_database_artifact(Id) : true
	<-
		lookupArtifact("workflow_database",Id);
		+using_artifact("workflow_database",Id);
	.
+!create_database_artifact(Id)
	<-
		makeArtifact("workflow_database","ids.artifact.Database",[],Id);
	.


@try_create_http_artifact[atomic]
+!create_or_use_http_artifact(BaseUrl,Id) : true
	<-
		!create_http_artifact(BaseUrl,Id);
	.
@otherwise_search_http_artifact[atomic]
-!create_or_use_http_artifact(BaseUrl,Id) : true
	<-
		lookupArtifact("http_protocol",Id);
		+using_artifact("http_protocol",Id);
	.
+!create_http_artifact(BaseUrl,Id) : true
	<-
		makeArtifact("http_protocol","ids.artifact.HTTP",[BaseUrl],Id);
		+using_artifact("http_protocol",Id);
	.
+!use_http_protocol_artifact(Id) : true
	<-
		?wait_artifact("http_protocol",Id);
		+using_artifact("http_protocol",Id);
	.


@try_create_HTML_interface[atomic]
+!create_or_use_HTML_interface(Name,Artifact,Id) : true
	<-
		!create_HTML_interface(Name,Artifact,Id);
	.
@otherwise_search_HTML_interface[atomic]
-!create_or_use_HTML_interface(Name,Artifact,Id) : true
	<-
		lookupArtifact(Name,Id);
		+using_artifact(Name,Id);
	.
+!create_HTML_interface(Name,Artifact,Id) : true
	<-
		makeArtifact(Name,Artifact,[],Id);
		+using_artifact(Name,Id);
	.




+?wait_artifact(Name,Id) : true
  <- 
  	lookupArtifact(Name,Id);
  	//.println("Found artifact ",Name," id ",Id);
  .

-?wait_artifact(Name,Id): true
  	<- 
  		//.println("artifact ",Name," not found");
  		.wait(500);
     	?wait_artifact(Name,Id);
	.
  	
+!timestamp(TimeStamp)
	<-
		.date(YY,MO,DD);
		.time(HH,MM,SS);
		.concat("",YY,MO+1,DD,HH,MM,SS,TimeStamp);
	.
+!numeric_timestamp(Now)
	<-
		.date(YY,MO,DD);
		.time(HH,MM,SS);
		Now = ts(YY,MO+1,DD,HH,MM,SS);
	.

earlier(ts(YY,MO,DD,HH,MM,SS1),ts(YY,MO,DD,HH,MM,SS2)) :- SS1 < SS2.
earlier(ts(YY,MO,DD,HH,MM1,SS1),ts(YY,MO,DD,HH,MM2,SS2)) :-  MM1 < MM2.
earlier(ts(YY,MO,DD,HH1,MM1,SS1),ts(YY,MO,DD,HH2,MM2,SS2)) :-  HH1 < HH2.
earlier(ts(YY,MO,DD1,HH1,MM1,SS1),ts(YY,MO,DD2,HH2,MM2,SS2)) :-  DD1 < DD2.
earlier(ts(YY,MO1,DD1,HH1,MM1,SS1),ts(YY,MO2,DD2,HH2,MM2,SS2)) :-  MO1 < MO2.
earlier(ts(YY1,MO1,DD1,HH1,MM1,SS1),ts(YY2,MO2,DD2,HH2,MM2,SS2)) :-  YY1 < YY2.


+!pick_most_recent(TS1,no_timestamp,TS1 ) : true <- true.
+!pick_most_recent(no_timestamp,TS2,TS2 ) : true <- true.
+!pick_most_recent(TS1,TS2,TS2 ) : earlier(TS1,TS2) <- true.
+!pick_most_recent(TS1 ,TS2, TS1 ) <- true.

+!pick_less_recent(TS1,no_timestamp,TS1 ) : true <- true.
+!pick_less_recent(no_timestamp,TS2,TS2 ) : true <- true.
+!pick_less_recent(TS1,TS2,TS1 ) : earlier(TS1,TS2) <- true.
+!pick_less_recent(TS1 ,TS2, TS2 ) <- true.



+!timestamp_add(TimeStampA,Delay,TimeStampDelayed)
	:
		TimeStampA = no_timestamp
	<-
		TimeStampDelayed = no_timestamp;
	.

+!timestamp_add(TimeStampA,Delay,TimeStampDelayed) : TimeStampA = ts(YY,MO,DD,HH,MM,SS) & Delay = duration(YYd,MOd,DDd,HHd,MMd,SSd)
	<-
		TimeStampDelayed = ts(YY+YYd,MO+MOd,DD+DDd,HH+HHd,MM+MMd,SS+SSd);
	.
	
/**
 * [davide]
 * 
 * Returns the seconds elapsed between two timestamps.
 */
+!how_many_seconds_elapsed(TimeStampFrom,TimeStampTo,Out) 
	: 
		TimeStampFrom 	= ts(_,_,_,_,_,SS_from) &
		TimeStampTo 	= ts(_,_,_,_,_,SS_to)
	<-
		Out = SS_to - SS_from;
	.
/*
 * [davide]
 *
 * Returns the minutes elapsed (in seconds) between two timestamps.
 */
+!how_many_minutes_elapsed(TimeStampFrom,TimeStampTo,Out) 
	: 
		TimeStampFrom 	= ts(_,_,_,_,MM_from,_) &
		TimeStampTo 	= ts(_,_,_,_,MM_to,_)
	<-
		Out = (MM_to - MM_from) * 60; 	//secondi
	.
/*
 * [davide]
 *
 * Returns the hours elapsed (in seconds) between two timestamps. 
 */
+!how_many_hours_elapsed(TimeStampFrom,TimeStampTo,Out) 
	: 
		TimeStampFrom 	= ts(_,_,_,HH_from,_,_) &
		TimeStampTo 	= ts(_,_,_,HH_to,_,_)
	<-
		Out = (HH_to - HH_from) * 3600; //secondi
	.

/**
 * [davide]
 * 
 * Get the elapsed time (seconds) from two timestamps.
 */
+!how_many_times_elapsed(TimeStampFrom,TimeStampTo,Out)
	:
		TimeStampFrom = no_timestamp | TimeStampTo = no_timestamp
	<-
		Out = 0;
	.
+!how_many_times_elapsed(TimeStampFrom,TimeStampTo,Out)
	<-
		!how_many_seconds_elapsed(TimeStampFrom,TimeStampTo,OutSS);
		!how_many_minutes_elapsed(TimeStampFrom,TimeStampTo,OutMM);
		!how_many_hours_elapsed(TimeStampFrom,TimeStampTo,OutHH);
		Out = OutSS+OutMM+OutHH;
	.


+!logically_negate(true,false)<-true.
+!logically_negate(false,true)<-true.

+!logic_and(true,true,true) <- true.
+!logic_and(true,false,false) <- true.
+!logic_and(false,true,false) <- true.
+!logic_and(false,false,false) <- true.

+!logic_or(true,true,true) <- true.
+!logic_or(true,false,true) <- true.
+!logic_or(false,true,true) <- true.
+!logic_or(false,false,false) <- true.

+!selective_print(Predicate,Agent) : .my_name(Agent) <- .println(Predicate).
+!selective_print(Predicate,Agent) : true <- true.

