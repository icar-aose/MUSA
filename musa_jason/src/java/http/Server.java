package http;

import http.handlers.capability_failure_request_handler;
import http.handlers.jason_pack_injection_handler;
import http.handlers.musa_status_request_handler;
import http.handlers.occp_request_handler;
import http.handlers.remote_db_config_handler;
import http.handlers.set_default_db_config_handler;
import ids.artifact.HTTPProxy;

import java.io.IOException;
import java.net.InetSocketAddress;

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
	private final String OCCP_REQUEST_CONTEXT 				= "/occp_request";
	private final String REMOTE_DB_CONFIG_CONTEXT 			= "/remote_db_config";
	private final String SET_DEFAULT_DB_CONTEXT 			= "/set_default_db_config";
	
	capability_failure_request_handler cap_handler 	= null;
	jason_pack_injection_handler jason_pack_handler = null;
	musa_status_request_handler musa_status_handler = null;
	occp_request_handler occp_request_handler 		= null;
	remote_db_config_handler db_config_handler 		= null;
	set_default_db_config_handler default_db_handler = null;
	
	public static enum MUSA_HTTP_REQUEST {OCCP_REQUEST, GOAL_INJECTION, SET_CAPABILITY_FAILURE, MUSA_STATUS_REQUEST, SET_DATABASE_HOST, SET_DEFAULT_DB_CONFIG};
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
		
		cap_handler 			= new capability_failure_request_handler();
		jason_pack_handler 		= new jason_pack_injection_handler();
		musa_status_handler 	= new musa_status_request_handler();
		occp_request_handler 	= new occp_request_handler();
		db_config_handler 		= new remote_db_config_handler();
		default_db_handler 		= new set_default_db_config_handler();
		
		cap_handler.addObserver(proxy_artifact);
		jason_pack_handler.addObserver(proxy_artifact);
		occp_request_handler.addObserver(proxy_artifact);
		db_config_handler.addObserver(proxy_artifact);
		default_db_handler.addObserver(proxy_artifact);
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
			server.createContext(OCCP_REQUEST_CONTEXT, 				occp_request_handler);
			server.createContext(REMOTE_DB_CONFIG_CONTEXT, 			db_config_handler);
	        server.createContext(SET_DEFAULT_DB_CONTEXT,			default_db_handler);
			
	        server.setExecutor(null);
	        server.start();
	        
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}

}
