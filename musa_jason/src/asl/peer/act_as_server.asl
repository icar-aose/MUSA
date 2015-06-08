/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: plans for handling http interaction
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

/**
 * Event triggered when an agent receives a request from client
 */
+request(Path,ParamSet)[source(Proxy)]
	<-
		.my_name(Me);
		?http_interface(Capability,RequestType,Path,Artifact);
		
		Request = request(Path,ParamSet,Proxy);
//		.println("\n\nParamSet: ",ParamSet,"\n\n");
		
		!check_interface_is_ready(Capability, RequestType, Bool);

		if (Bool=true) 
		{
			!get_context(Capability, Request, RequestType, Context);
			!serve_request_with_capacity(Capability, RequestType, Request, Context);
		} 
		else 
		{
			ReturnHtml = "agent error: interface is not ready";
			.send(Proxy, tell, html_response(Path, ParamSet, ReturnHtml));
		}

		-request(Path,ParamSet)[source(Proxy)];
	.

+!get_context(Capability, Request, RequestType, OutContext)
	:
		RequestType 	= request_page
	&	Request 		= request(Path,ParamSet,Proxy)
	&	ParamSet 		= paramset(Session,User,Params)
	&	ready_for_request(Capability, Context )
	&	Context = project_context(Department,Session)
	
	<-
		OutContext = Context;
	.
+!get_context(Capability, Request, RequestType, OutContext)
	:
		RequestType 	= request_page
	&	Request 		= request(Path,ParamSet,Proxy)
	&	ParamSet 		= paramset(Session,User,Params)	
	&	ready_for_request(Capability, Context )
	&	Context=department_context(Session)
	
	<-
		OutContext = Context;
	.
+!get_context(Capability, Request, RequestType, OutContext)
	:
		RequestType	= request_result
	&	Request 	= request(Path,ParamSet,Proxy)
	&	ParamSet 	= paramset(Session,User,Params)
	
	&	ready_for_reply(Capability, Context )
	&	Context = project_context(Department,Session)
	
	<-
		OutContext = Context;
	.
+!get_context(Capability, Request, RequestType, OutContext)
	:
		RequestType 	= request_result
	&	Request 		= request(Path,ParamSet,Proxy)
	&	ParamSet 		= paramset(Session,User,Params)
	
	&	ready_for_reply(Capability, Context )
	&	Context = department_context(Session)
	
	<-
		OutContext = Context;
	.
	
+!register_user_params_to_context(ParamSet, Context)
	:
		ParamSet = paramset(_,_,ParamList)
	<-
		!register_user_params_to_context(ParamList, Context);
	.
+!register_user_params_to_context(ParamSet, Context)
	:
		ParamSet 	= [Head|Tail]	&
		Head 		= param(VarName,VarValue)
	<-
		.print("[register_user_params_to_context] registering ",Head);
		!register_data_value(VarName, VarValue, Context);
		!register_user_params_to_context(Tail, Context);
	.

+!register_user_params_to_context(ParamSet, Context)
	:
		ParamSet = []
	.



/**
 * [luca]
 * 
 * Check if a capability is ready for receiving requests.
 */
+!check_interface_is_ready(Capability, request_page, Bool)
	:
		ready_for_request(Capability, Context )
	&	( Context=department_context(Project) | Context=project_context(Department,Project) )
	<-
		Bool=true;
	.
+!check_interface_is_ready(Capability, request_result, Bool)
	:
		ready_for_reply(Capability, Context )
	&	( Context=department_context(Project) | Context=project_context(Department,Project) )
	<-
		Bool=true;
	.
+!check_interface_is_ready(Capability, RequestType, Bool)
	<-
		Bool=false;
	.

+!serve_request_with_capacity(Capability, request_page, Request, Context)
	:
		( Context=department_context(Session) | Context=project_context(_,Session) )
	<-
		Request 	= request(Path,ParamSet,Proxy);
		ParamSet 	= paramset(Session,User,Params);
		
		!send_reply_to_proxy_agent(Capability, Request, ParamSet);
	.
+!serve_request_with_capacity(Capability, request_page, Request, Context)
	<-
		Request 	= request(Path,ParamSet,Proxy);
		ReturnHtml 	= "agent error: request page protocol error";
		
		.send(Proxy, tell, html_response(Path, ParamSet, ReturnHtml));	
	.

/**
 * !!!
 */
+!serve_request_with_capacity(Capability, request_result, Request, Context)
	:
		Context 	= department_context(Session)
	<-
		Request 	= request(Path,ParamSet,Proxy);
		ParamSet 	= paramset(Session,User,Params);
		
		!timestamp(TimeStamp);
		.concat(Session,TimeStamp,ProjectName);	
		NewContext = project_context(Session,ProjectName);			
		addProject(ProjectName,Session,"","","null");				// this goes here to allow data registration in the capability body	
		+manager_of(Session,ProjectName,[]);						//set the owner of the capability as project manager
		!register_user_params_to_context(ParamSet, NewContext);		//register the parameters within the HTTP request into the context
		!send_reply_to_proxy_agent(Capability, Request, ParamSet);	//Send a reply to proxy agent
		!!create_project(Session,ProjectName);						// in project_manager_activity.asl 		
		
		!activate_capability(Capability,NewContext,[]);				//activate the capability
	.

+!serve_request_with_capacity(Capability, request_result, Request, Context)
	:
		Context 	= project_context(_,Session)
	<-
		Request 	= request(Path,ParamSet,Proxy);
		ParamSet 	= paramset(Session,User,Params);
		!send_reply_to_proxy_agent(Capability, Request, ParamSet);

		+done(Capability,Context);
	.
+!serve_request_with_capacity(Capability, request_result, Request, Context)
	<-
		.println("error with capability ",Capability, " in ",Context);
	.

/**
 * [davide]
 * 
 * After serving a user request with a capability, send a reply to proxy agent. The
 * reply is a plain html message.
 */
+!send_reply_to_proxy_agent(Capability, Request, ParamSet)
	<-
		Request 	= request(Path,ParamSet,Proxy);
		ParamSet 	= paramset(Session,User,Params);
		
		.my_name(Me);
		Commitment 	= commitment(Me,Capability,_);
		
		//!check_if_capability_require_http_interaction(Commitment, RequireInteraction);
		!check_if_capability_is_of_type(Commitment, http_interaction, RequireInteraction);
		if(RequireInteraction==true)
		{
			!generate_html_page(Capability, Path, ParamSet, NewContext, ReturnHtml);
			.send(Proxy, tell, html_response(Path, ParamSet, ReturnHtml));	
		}
		else
		{
			!check_if_capability_is_of_type(Commitment, http_service, IsService);
			
			if(IsService==true)
			{
				.send(Proxy, tell, html_response(Path, ParamSet, "OK"));	
			}
			else
			{
				//TODO IMPLEMENTARE
				.send(Proxy, tell, html_response(Path, ParamSet, "OK"));
			}
		}
	
	.



+!generate_html_page(Capability, Path, ParamSet, Context, ReturnHtml) 
	: 
		http_interface(Capability,request_page,Path,Artifact)
	&	using_artifact(Artifact,IdInterface)
	&	ParamSet = paramset(Session ,user(UserNameString,UserRoleString),HTTPParams)
	&	my_user(UserName,UserRole)	&	.term2string(UserName,UserNameString)	&  .term2string(UserRole,UserRoleString)
	<-
		!generate_html_request_page(Capability, Path, ParamSet, Context, ReturnHtml);
	.
+!generate_html_page(Capability, Path, ParamSet, Context, ReturnHtml) 
	: 
		http_interface(Capability,request_result,Path,Artifact)
	&	ParamSet = paramset(Session ,user(UserNameString,UserRoleString),HTTPParams)
	&	my_user(UserName,UserRole)	&	.term2string(UserName,UserNameString)	&  .term2string(UserRole,UserRoleString)
	&	using_artifact(Artifact,IdInterface)
	<-
		!action(Capability, Path, UserName, UserRole, HTTPParams, Context);
		!generate_html_result_page(Capability, Path, ParamSet, Context, ReturnHtml);
		+done(Capability,Context);
	.
+!generate_html_page(Capability, Path, ParamSet, Context, ReturnHtml)
	<-
		.println("cannot generate page");
		?http_interface(Capability,request_page,Path,Artifact);
		.println("Artifact ",Artifact);
		
		?using_artifact(Artifact,IdInterface);
		.println("IdArtifact ",IdInterface);
		
		ParamSet = paramset(Session ,user(UserNameString,UserRoleString),HTTPParams);
		.println("Session ",Session);
		
		.term2string(UserName,UserNameString);
		.term2string(UserRole,UserRoleString);
		.println("UserName ",UserName);
		.println("UserRole ",UserRole);
		
		?my_user(User,UserRole);
		.println("User ",User);
		.println("User ",User);
		
		.println(generate_html_page(Capability, Path, ParamSet, Context, ReturnHtml));
		ReturnHtml="cannot generate page";
	.


/**
 * [luca]
 * 
 * Registra un servizio offerto da una capability nel database. 
 * 
 */
+!standard_register_HTTP_page(Capability, ServiceDescription, Context )
	/*:
		http_interface(Capability,request_page,ServiceAccess,Artifact)*/
	<- 
		?http_interface(Capability,_,ServiceAccess,Artifact);
		
		//TODO questa informazione non andrebbe presa dal database?
		?my_user(UserName,UserRole);
		
		.my_name(Me);
		occp.logger.action.info("[",Me,"] registering service [",Capability,"] to database.");
		!registerStandardHTTPInterface(ServiceAccess,Me,ServiceDescription,UserName,UserRole,Context);
	.
+!registerStandardHTTPInterface(Path,Owner,Description,UserName,UserRole,Context)
	:
		Context=department_context(Session)
	<-
		.println("standard register entry point");
		.println("registering ",registerEntryPoint(Path,Owner,Description,UserRole,Session));
		registerEntryPoint(Path,Owner,Description,UserRole,Session);
	.
+!registerStandardHTTPInterface(Path,Owner,Description,UserName,UserRole,Context)
	:
		Context=project_context(Department,Project)
	<-
		.println("standard register job");
		registerJob(Path,Owner,Description,UserName,UserRole,Project);
	.
-!registerStandardHTTPInterface(Path,Owner,Description,UserName,UserRole,Context)
	<-
		.println("generic error in registering job");
	.

-!registerStandardHTTPInterface(Path,Owner,Description,UserName,UserRole,Context)[error_msg(Msg),register_job_failed("web-service-not-reached")]
	<-
		.println("error in registering job: ",Msg);
	.

+!standard_unregister_HTTP_page(Capability, Context )
	:
		http_interface(Capability,request_page,ServiceAccess,Artifact)
	<- 
		.my_name(Me);
		?my_user(UserName,UserRole);
		!unregisterStandardHTTPInterface(ServiceAccess,Me,UserName,UserRole,Context);
	.
+!unregisterStandardHTTPInterface(Path,Owner,UserName,UserRole,Context)
	:
		Context=department_context(Session)
	<-
		unregisterEntryPoint(Path,Owner,UserRole,Session);
	.
+!unregisterStandardHTTPInterface(Path,Owner,UserName,UserRole,Context)
	:
		Context=project_context(Department,Project)
	<-
		unregisterJob(Path,Owner,UserName,UserRole,Project);
	.
			