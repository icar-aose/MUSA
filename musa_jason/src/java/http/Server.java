package http;

import http.Connection.MUSA_HTTP_REQUEST;
import jason.asSyntax.ListTerm;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;

import occp.http.OCCPRequestParser;

/**
 * 
 * @author luca
 */
public class Server 
{
	private final int SERVER_PORT 		= 2004;
	private ServerSocket providerSocket = null;
	private Connection conn 			= null;
	private boolean debug 				= true;
	private int connection_id 			= 0;
	private ListTerm remoteGoalPack 	= null;
	private HashMap<String,String> 	occp_params;
	
	/**
	 * Constructor for this class
	 */
	public Server(int connectionId) throws IOException 
	{
		this.connection_id  	= connectionId;
		providerSocket 			= new ServerSocket(SERVER_PORT);
		occp_params 			= new HashMap<String, String>();
		
		
		if (debug) System.out.println("Opened the connection on "+providerSocket.getInetAddress().getHostAddress());
	}

	public void run() 
	{
		Socket connection = null;

		if (providerSocket==null) 
			return;

		try 
		{			
			if (debug) System.out.println("waiting for request...");
			
			connection  = providerSocket.accept();	//Wait for a remote request
			conn = new Connection(connection);		//Create a new Connection object
			conn.setId(connection_id);				//Assign it a unique ID
			conn.readMessage();						//Parse the received message
			
			if(conn.getRequestType() == Connection.MUSA_HTTP_REQUEST.OCCP_REQUEST)
			{
				//####################
				//	OCCP REQUEST
				//####################
				occp_params.put("idOrder", OCCPRequestParser.getIdOrdine());
				occp_params.put("idUser", OCCPRequestParser.getIdUtente());
				occp_params.put("mailUser", OCCPRequestParser.getMail());
				occp_params.put("user_message", OCCPRequestParser.getUserMessage());
				occp_params.put("userAccessToken", OCCPRequestParser.getDropboxAccessToken());
			}
			else if(conn.getRequestType() == Connection.MUSA_HTTP_REQUEST.GOAL_INJECTION)
			{
				//####################
				//	INJECTION REQUEST
				//####################
				remoteGoalPack = conn.getGoalPack();
			}
			else if(conn.getRequestType() == Connection.MUSA_HTTP_REQUEST.SET_CAPABILITY_FAILURE)
			{
				//#############################
				// CAPABILITY FAILURE
				//#############################
				
				//...
			}
			
			if (debug) System.out.println("connection established");	
		} 
		catch (IOException ioException) 
		{
			if (debug) System.out.println("Error with connection");
			if (debug) ioException.printStackTrace();
		}
	}
	
	public String getCapabilityThatMustFail()
	{
		return conn.getCapabilityThatMustFail();
	}
	
	
	/**
	 * Return the type of request received.
	 * 
	 */
	public MUSA_HTTP_REQUEST getConnectionRequestType()
	{
		return conn.getRequestType();
	}
	
	/**
	 * Return the list of goals to inject.
	 * 
	 * @return
	 */
	public ListTerm getPackToInject() 
	{
		return remoteGoalPack;
	}
	
	/**
	 * Return an hashmap containing the parameters of a OCCP request message
	 * @return
	 */
	public HashMap<String,String> getOCCPParams()
	{
		return occp_params;
	}
	
	public Connection getConnection()
	{
		return conn;
	}

	public int getConnectionId() {
		return this.conn.getId();
	}


}
