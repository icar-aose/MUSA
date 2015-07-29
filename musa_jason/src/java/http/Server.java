package http;

import http.handlers.capability_failure_request_handler;
import http.handlers.capability_injection_request_handler;
import http.handlers.jason_pack_injection_handler;
import http.handlers.request_for_musa_status_handler;
import http.handlers.remote_db_config_handler;
import http.handlers.request_for_capability_status_handler;
import http.handlers.set_default_db_config_handler;
import http.handlers.unset_capability_failure_request;
import http.handlers.occp.occp_billing_approval_handler;
import http.handlers.occp.occp_request_handler;
import http.handlers.occp.occp_simulated_request_handler;

import java.io.IOException;
import java.net.InetSocketAddress;

import musa.artifact.HTTPProxy;

import com.sun.net.httpserver.HttpServer;

/**
 * 
 * @author davide
 */
public class Server
{
	private final int SERVER_PORT 		= 2004;

	private final String CAPABILITY_FAILURE_CONTEXT 		= "/failure_capability";
	private final String JASON_PACK_INJECTION_CONTEXT 		= "/jason_pack_injection";
	private final String MUSA_STATUS_REQUEST_CONTEXT 		= "/musa_status_request";
	private final String REMOTE_DB_CONFIG_CONTEXT 			= "/remote_db_config";
	private final String SET_DEFAULT_DB_CONTEXT 			= "/set_default_db_config";
	private final String UNSET_CAPABILITY_FAILURE_CONTEXT 	= "/unset_failure_capability";
	private final String CAPABILITY_INJECTION_CONTEXT	 	= "/capability_injection";
	private final String REQUEST_CAPABILITY_STATUS	 		= "/capability_status_request";
	
	private final String OCCP_REQUEST_CONTEXT 				= "/occp_request";
	private final String OCCP_BILLING_APPROVAL_CONTEXT	 	= "/approve_billing";
	private final String OCCP_SIMULATED_REQUEST_CONTEXT	 	= "/occp_simulate_request";
	
	capability_failure_request_handler cap_handler 	= null;
	jason_pack_injection_handler jason_pack_handler = null;
	request_for_musa_status_handler musa_status_handler = null;
	occp_request_handler occp_request_handler 		= null;
	remote_db_config_handler db_config_handler 		= null;
	set_default_db_config_handler default_db_handler = null;
	unset_capability_failure_request unset_cap_failure_handler = null;
	capability_injection_request_handler cap_injection_handler = null;
	request_for_capability_status_handler request_cap_status = null;
	occp_billing_approval_handler approval_handler = null;
	occp_simulated_request_handler simulated_request_handler = null;
	
	public static enum MUSA_HTTP_REQUEST {  GOAL_INJECTION,
											CAPABILITY_INJECTION,
											SET_CAPABILITY_FAILURE, 
											UNSET_CAPABILITY_FAILURE, 
											MUSA_STATUS_REQUEST, 
											SET_DATABASE_HOST, 
											SET_DEFAULT_DB_CONFIG,
											REQUEST_FOR_CAPABILITY_STATUS,
											/*###OCCP REQUEST CONTEXT###*/
											OCCP_BILLING_APPROVAL,
											OCCP_REQUEST,
											OCCP_SIMULATE_REQUEST};
											
	public static MUSA_HTTP_REQUEST request_type;
	
	private HTTPProxy proxy_artifact = null;
	
	/**
	 * Constructor for this class
	 * 
	 * @param a the HTTPProxy artifact that observes the HTTP request handlers
	 */
	public Server(HTTPProxy a)
	{
		proxy_artifact 			= a;
			
		cap_handler 				= new capability_failure_request_handler();
		jason_pack_handler 			= new jason_pack_injection_handler();
		musa_status_handler 		= new request_for_musa_status_handler();
		db_config_handler 			= new remote_db_config_handler();
		default_db_handler 			= new set_default_db_config_handler();
		unset_cap_failure_handler 	= new unset_capability_failure_request();
		cap_injection_handler		= new capability_injection_request_handler();
		request_cap_status 			= new request_for_capability_status_handler();
		
		approval_handler 			= new occp_billing_approval_handler();
		occp_request_handler 		= new occp_request_handler();
		simulated_request_handler 	= new occp_simulated_request_handler();
		
		cap_handler.addObserver(proxy_artifact);
		jason_pack_handler.addObserver(proxy_artifact);
		occp_request_handler.addObserver(proxy_artifact);
		db_config_handler.addObserver(proxy_artifact);
		default_db_handler.addObserver(proxy_artifact);
		unset_cap_failure_handler.addObserver(proxy_artifact);
		cap_injection_handler.addObserver(proxy_artifact);
		request_cap_status.addObserver(proxy_artifact);
		approval_handler.addObserver(proxy_artifact);
		simulated_request_handler.addObserver(proxy_artifact);
		
	}
	
	/**
	 * Run the HTTP server
	 */
	public void run() 
	{
		HttpServer server;
		try 
		{
			server = HttpServer.create(new InetSocketAddress(SERVER_PORT), 0);
	        
			server.createContext(CAPABILITY_FAILURE_CONTEXT, 		cap_handler );
			server.createContext(JASON_PACK_INJECTION_CONTEXT, 		jason_pack_handler);
			server.createContext(MUSA_STATUS_REQUEST_CONTEXT, 		musa_status_handler);
			server.createContext(REMOTE_DB_CONFIG_CONTEXT, 			db_config_handler);
	        server.createContext(SET_DEFAULT_DB_CONTEXT,			default_db_handler);
	        server.createContext(UNSET_CAPABILITY_FAILURE_CONTEXT,	unset_cap_failure_handler);
	        server.createContext(CAPABILITY_INJECTION_CONTEXT,		cap_injection_handler);
	        server.createContext(REQUEST_CAPABILITY_STATUS, 		request_cap_status);
	        
	        server.createContext(OCCP_BILLING_APPROVAL_CONTEXT, 	approval_handler);
	        server.createContext(OCCP_REQUEST_CONTEXT, 				occp_request_handler);
	        server.createContext(OCCP_SIMULATED_REQUEST_CONTEXT, 	simulated_request_handler);
	        
	        server.setExecutor(null);
	        server.start();
	        
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}

}
