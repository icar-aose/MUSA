/**************************/
/* Last Modifies:
 * 
 * Todo:
 * 
 * message signal: +http_request(Id,Session,Result,User,Role,Params)
 * dove Params=[param(type,value)]
 * 
 *
 * Bugs:  
 * 
*/
/**************************/

package ids.artifact;


import http.Server;
import http.handlers.occp.occp_request_handler;
import jason.asSyntax.ListTerm;

import java.util.HashMap;
import java.util.Observable;
import java.util.Observer;

import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;

public class HTTPProxy extends Artifact implements Observer
{
	private boolean debug 				= true;
	private Server server 				= null;
	private ListTerm goalPackToInject 	= null;
	
	/**
	 * Method called when this artifact is created from jason using 'makeArtifact'.
	 */
	void init() 
	{
		if (debug) System.out.println("Setup HTTPProxy Artifact");
		
		server = new Server(this);
	}
	
	@OPERATION
	void run_server() 
	{
		if (server == null) 
		{
			if (debug) System.out.println("server is not ready");
			return;
		}
		
		if (debug) System.out.println("server is ready");
		server.run();
	}
	
	/**
	 * Called when an observable handler signal a request. 
	 */
	@Override
	@OPERATION
	public void update(Observable o, Object arg) 
	{
		switch(Server.request_type)
		{
			case GOAL_INJECTION:
				goalPackToInject = (ListTerm)arg;
				execInternalOp("notify_jason_pack_injection",goalPackToInject);
				break;
			case MUSA_STATUS_REQUEST:
				
				break;
			case OCCP_REQUEST:
				execInternalOp("notify_occp_request");
				break;
			case SET_CAPABILITY_FAILURE:
				execInternalOp("notify_capability_failure_state", arg.toString());
				break;
			case SET_DATABASE_HOST:
				execInternalOp("notify_db_update");
				break;
			case SET_DEFAULT_DB_CONFIG:
				execInternalOp("notify_set_default_db_config");
				break;
			case UNSET_CAPABILITY_FAILURE:
				execInternalOp("notify_unset_capability_failure_state", arg.toString());
				break;
				
			case CAPABILITY_INJECTION:
				execInternalOp("notify_inject_capability", arg);
				break;
				
			case OCCP_BILLING_APPROVAL:
				execInternalOp("notify_occp_billing_approval");
				break;
				
			case OCCP_SIMULATE_REQUEST:
				execInternalOp("notify_simulate_occp_request");
				break;
			default:
				break;
		
		}		
	}
	
	@INTERNAL_OPERATION
	void notify_simulate_occp_request()
	{
		signal("simulate_occp_request");
	}
	
	@INTERNAL_OPERATION
	void notify_occp_billing_approval()
	{
		
	}
	
	
	
	@INTERNAL_OPERATION
	void notify_inject_capability(Object cap_info_obj)
	{
		HashMap<String,String> cap_info = (HashMap<String,String>)cap_info_obj;
		
		String agent_owner 		= cap_info.remove("agent_owner");
		String capability_plans = cap_info.remove("capability_plans").replaceAll("\\s", ""); 
		String prepare_plan = "";
		String action_plan = "";
		String terminate_plan = "";
		
		String[] plans = capability_plans.split("\\+!");
		for (String plan : plans)
		{
			if(plan.startsWith("prepare"))		prepare_plan	= "+!"+plan;
			if(plan.startsWith("action"))		action_plan		= "+!"+plan;
			if(plan.startsWith("terminate"))	terminate_plan	= "+!"+plan;
		}
		
		String cap_name 		= cap_info.remove("capability_name");
		String cap_type 		= cap_info.remove("capability_type");
		String cap_params 		= cap_info.remove("capability_parameters");
		String cap_pre 			= cap_info.remove("capability_precondition");
		String cap_post 		= cap_info.remove("capability_postcondition");
		String cap_cost 		= cap_info.remove("capability_cost");
		String cap_evo 			= cap_info.remove("capability_evolution");
		
		System.out.println("Sending signal. Agent: "+agent_owner);
		
		signal("inject_implementation_capability",agent_owner, prepare_plan, action_plan, terminate_plan);
		signal("inject_abstract_capability",agent_owner, cap_name, cap_type, cap_params, cap_pre, cap_post, cap_cost, cap_evo);
	}
	
	@INTERNAL_OPERATION
	void notify_occp_request()
	{
		for (String key : occp_request_handler.getOccp_params().keySet())
		{
			String value = occp_request_handler.getOccp_params().get(key);
			System.out.println("Key: "+key+" value: "+value);
			signal("http_param", 0, key, value);
		}
		
		System.out.println("Sending request...");
		signal("http_request", 	0,
								occp_request_handler.getSession(),
								occp_request_handler.getAgent(),
								occp_request_handler.getService(),
								occp_request_handler.getUser(),
								occp_request_handler.getRole() );
	}
	
	@INTERNAL_OPERATION
	void notify_jason_pack_injection(ListTerm pack)
	{
		signal("remote_goal_pack_injected",pack);
	}
	
	@INTERNAL_OPERATION
	void notify_capability_failure_state(String capName)
	{
		signal("submitCapabilityFailure",capName);
	}
	
	@INTERNAL_OPERATION
	void notify_unset_capability_failure_state(String capName)
	{
		signal("unsetCapabilityFailure",capName);
	}
	
	@INTERNAL_OPERATION
	void notify_db_update()
	{
		signal("update_database_configuration");
	}
	
	@INTERNAL_OPERATION
	void notify_set_default_db_config()
	{
		signal("update_database_configuration");
	}
	
}
