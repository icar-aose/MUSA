/**************************
 * @Author: Luca Sabatucci
 * Description: capability orchestration
 * 
 * Last Modifies:  
 * 
 *
 * TODOs:
 * 
 *
 * Bugs:  
 * 
 *
 **************************/


/*
 * DPT MONITOR CAPABILITY ORCHESTRATION
 */
 +!prepare_capability(Capability,Context,Assignment) 
 	<-
 		!prepare(Capability,Context,Assignment);
	.
+!prepare_capability(Capability,Context) 
 	<-
 		!prepare(Capability,Context);
	. 

+!activate_capability(Capability,Context,Assignment) 
 	<-
		!action(Capability,Context,Assignment);
		!terminate(Capability,Context,Assignment);
	.
+!activate_capability(Capability,Context) 
 	<-
		!action(Capability,Context);
		!terminate(Capability,Context);
	.
 
 +!register_capability(Capability,Context)
 	<-
		!register_page(Capability,Context);
		+ready_for_request(Capability,Context);
		+ready_for_reply(Capability, Context );
 	.
 
 +!retreat_capability(Capability,Context)
	<-  
		-ready_for_request(Capability,Context);
		-ready_for_reply(Capability, Context );
		.my_name(Me);
		Commitment 	= commitment(Me,Capability,_);
		!check_if_capability_is_of_type(Commitment, http_interaction, IsInteraction);
		if(IsInteraction==true)
		{
			!unregister_page(Capability,Context);
		}
	.

+!invoke_project_capability(Capability,Context,Assignment) 
	<- 
		if(not fail(Capability)) 
		{
//			if(execution(deployment)){.wait(8000);}
			
			!action(Capability,Context,Assignment);
		}
		
		.my_name(Me);
		!check_if_capability_is_of_type(commitment(Me,Capability,_), http_service, IsService);
		
		if(not IsService)	
		{
			if(not fail(Capability))
			{
				!terminate(Capability,Context,Assignment);	
			}
		}
		
		+done(Capability,Context);
	.
+!invoke_project_capability(Capability,Context) 
	<- 
		if(not fail(Capability)) 
		{
//			if(execution(deployment)){.wait(8000);}
			!action(Capability,Context);
		}
		
		.my_name(Me);
		!check_if_capability_is_of_type(commitment(Me,Capability,_), http_service, IsService);

		if(not IsService)	
		{
			if(not fail(Capability))
			{
				!terminate(Capability,Context);	
			}
		}	
		
		+done(Capability,Context);
	.

+!retreat_project_capability(Capability,Context)
	<-
		.my_name(Me);
		Commitment 	= commitment(Me,Capability,_);
		!check_if_capability_is_of_type(Commitment, http_service, IsService);
		!check_if_capability_is_of_type(Commitment, parametric, IsParametric);
		if(IsService==true)	
		{
			if(IsParametric==true)	{!terminate(Capability,Context,Assignment);}
			else					{!terminate(Capability,Context);}
		}
		else
		{
			-ready_for_request(Capability,Context);
			-ready_for_reply(Capability,Context);
		}
	.

//---------------------------------------------
-!prepare(Capability,Context,Assignment)
	<-
		+error(Capability,Context);
	.
-!action(Capability,Context,Assignment)
	<-
		+error(Capability,Context);
	.
-!terminate(Capability,Context,Assignment)
	<-
		+error(Capability,Context);
	.

-!prepare(Capability,Context)
	<-
		+error(Capability,Context);
	.
-!action(Capability,Context)
	<-
		+error(Capability,Context);
	.
-!terminate(Capability,Context)
	<-
		+error(Capability,Context);
	.

-!register_page(Capability,Context)
	<-
		+error(Capability,Context);
	.
-!generate_html_request_page(Capability, Path, ParamSet, Context, ReturnHtml)
	<-
		+error(Capability,Context);
		!unregister_page(Capability,Context);
		ReturnHtml="capability error";
	.
-!generate_html_result_page(Capability, Path, ParamSet, Context, ReturnHtml)
	<-
		+error(Capability,Context);
		!unregister_page(Capability,Context);
		ReturnHtml="capability error";
	.
-!unregister_page(Capability,Context)
	<-
		+error(Capability,Context);
	.

	
	