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
import http.handlers.occp_request_handler;
import jason.asSyntax.ListTerm;

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
			default:
				break;
		
		}		
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
