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

import http.Connection;
import http.Connection.MUSA_HTTP_REQUEST;
import http.Server;
import jason.asSyntax.ListTerm;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Hashtable;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

public class HTTPProxy extends Artifact 
{
	private boolean debug 				= true;
	private int conn_id_counter 		= 0;
	private Server server 				= null;
	private ListTerm goalPackToInject 	= null;
	private java.util.Date date 		= new java.util.Date();
	private Hashtable<String,Connection> open_connections;
	
	
	/**
	 * Method called when this artifact is created from jason using 'makeArtifact'.
	 */
	void init() 
	{
		open_connections = new Hashtable<String,Connection>();
		if (debug) System.out.println("Setup HTTPProxy Artifact");
	}
	
	@OPERATION
	void run_server() 
	{
		if (server==null) 
		{
			if (debug) System.out.println("server is not ready");
			return;
		}
		
		if (debug) System.out.println("server is ready");
		
		server.run();
	
		if(server.getConnectionRequestType() == MUSA_HTTP_REQUEST.OCCP_REQUEST)
		{
			//#############################
			//		OCCP REQUEST
			//#############################
			
			for (String key : server.getOCCPParams().keySet())
			{
				String value = server.getOCCPParams().get(key);
				signal("http_param",server.getConnection().getId(), key, value);
			}
			
			signal("http_request", 	server.getConnection().getId(),
									server.getConnection().getSession(),
									server.getConnection().getAgent(),
									server.getConnection().getService(),
									server.getConnection().getUser(),
									server.getConnection().getRole() );
		}
		else if(server.getConnectionRequestType() == MUSA_HTTP_REQUEST.GOAL_INJECTION)
		{
			//#############################
			//	GOAL INJECTION REQUEST
			//#############################
			
			goalPackToInject = server.getPackToInject();
			signal("remote_goal_pack_injected");
		}
		else if(server.getConnectionRequestType() == Connection.MUSA_HTTP_REQUEST.SET_CAPABILITY_FAILURE)
		{
			//#############################
			// CAPABILITY FAILURE
			//#############################
			
			signal("submitCapabilityFailure", server.getCapabilityThatMustFail());
		}
		else if(server.getConnectionRequestType() == Connection.MUSA_HTTP_REQUEST.MUSA_STATUS_REQUEST)
		{
			//#############################
			// MUSA STATUS REQUEST
			//#############################
			
			signal("request_for_musa_status");
		}
		else if(server.getConnectionRequestType() == Connection.MUSA_HTTP_REQUEST.SET_DATABASE_HOST)
		{
			signal("changed_database_configuration");
		}
		
	}
	
	
	@OPERATION
	void reply_with_musa_status(String status)
	{
		System.out.println("Request for musa status. Reply: "+status);
		
		Connection selected = open_connections.get(new Integer(this.server.getConnectionId()).toString());
		
		String replyMessage = "{\"request_for_musa_status\":\""+status+"\"}";

		if (selected != null) 
		{
			selected.reply(replyMessage);
		}
	}
	
	/**
	 * Unify the parameter with the goal pack to inject, received
	 * from a HTTP request. 
	 * 
	 */
	@OPERATION
	private void get_received_goals(OpFeedbackParam<ListTerm> goals)
	{
		goals.set(this.goalPackToInject);
	}
	
	@OPERATION
	void connect(OpFeedbackParam<String> result) 
	{
		if (server != null) 
		{
			result.set("ok");
			return;
		}
		
		try 
		{				
			server = new Server(generate_id());
			
			if (debug) System.out.println("server created");
			result.set("ok");
		} 
		catch (IOException e) 
		{
			if (debug) System.out.println("server error");
			result.set("error");
			server = null;
		}
	
	}
	
	@OPERATION
	void reply(int id, String reply) 
	{
		if (debug) System.out.println("Sending...");
		Connection selected = open_connections.get(new Integer(id).toString());
		
		if (selected != null) 
		{
			selected.reply_and_close(reply);
			open_connections.remove(id);
		}
	}

		
	public int generate_id() 
	{
		int id = conn_id_counter;
		conn_id_counter++;
		return id;
	}
	
	public String generate_session() 
	{
		Timestamp ts = new Timestamp(date.getTime());
		return ts.toString();
	}
	
}
