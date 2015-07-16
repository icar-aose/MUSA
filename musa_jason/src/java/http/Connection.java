package http;

import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Term;
import jason.asSyntax.parser.ParseException;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

import occp.http.OCCPRequestParser;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import workflow_property.MusaProperties;

public class Connection 
{
	private boolean debug = true;
	private int id;	
	private Socket connection = null;
	private ObjectOutputStream out = null;
	private ObjectInputStream in = null;
	
	private String user="";
	private String role="";
	private String session="";
	private String service="";
	private String agent="";
	
	private ListTerm remoteGoalPackToInject = null;
	protected JSONObject json_message = null;
	
	private String capabilityToFail = "";
	
	public static enum MUSA_HTTP_REQUEST {OCCP_REQUEST, GOAL_INJECTION, SET_CAPABILITY_FAILURE, MUSA_STATUS_REQUEST, SET_DATABASE_HOST};
	
	private MUSA_HTTP_REQUEST connection_request_type;
	
	
	/**
	 * Constructor for this class
	 * 
	 * @param incoming_connection
	 */
	public Connection(Socket incoming_connection) 
	{
		String message = null;
		this.connection = incoming_connection;
		
		try 
		{
			out = new ObjectOutputStream(connection.getOutputStream());
			out.flush();
			
			in = new ObjectInputStream(connection.getInputStream());
			
			if (debug) System.out.println("Reading from stream");
		} 
		catch (IOException ioException) 
		{
			if (debug) System.out.println("Error with read from stream");
			ioException.printStackTrace();
		}

		try 
		{
			while (message == null) 
				message = (String) in.readObject();
			
			System.out.println("MESSAGE RECEIVED:\n"+message);
			
			//Convert the received message string to a JSON object
			json_message = new JSONObject(new JSONTokener(message));
			
			if (debug) System.out.println("Read " + json_message.toString() );
		}
		catch (IOException e) 				{if (debug) System.out.println("Read failed");} 
		catch (ClassNotFoundException e) 	{e.printStackTrace();}
		
	}
	
	/**
	 * Parse the content of the received JSON message.
	 */
	public void readMessage()
	{
		if (debug) System.out.println("Read " + json_message.toString() );
		
		if( json_message.has("agent") && json_message.has("service") && json_message.has("session") && json_message.has("userrole") )
		{
			//#############################
			//		OCCP REQUEST
			//#############################
			
			OCCPRequestParser.parseRequestMessage(json_message);
			
			agent 		= OCCPRequestParser.getAgent();
			service 	= OCCPRequestParser.getService();
			session 	= OCCPRequestParser.getSession();
			user 		= OCCPRequestParser.getUser();
			role 		= OCCPRequestParser.getRole();
			
			connection_request_type = MUSA_HTTP_REQUEST.OCCP_REQUEST;
		}
		else if(json_message.has("goal_pack"))
		{
			//#############################
			//	GOAL INJECTION REQUEST
			//#############################
			
			this.remoteGoalPackToInject = parseGoalPack(json_message.getJSONArray("goal_pack"));
			
			connection_request_type = MUSA_HTTP_REQUEST.GOAL_INJECTION;
		}
		else if(json_message.has("capability_failure"))
		{
			//#############################
			// CAPABILITY FAILURE
			//#############################
			capabilityToFail = json_message.getString("capability_failure");
			connection_request_type = MUSA_HTTP_REQUEST.SET_CAPABILITY_FAILURE;
		}
		else if(json_message.has("request_for_musa_status"))
		{
			//#############################
			// REQUEST FOR MUSA STATUS
			//#############################
			
			connection_request_type = MUSA_HTTP_REQUEST.MUSA_STATUS_REQUEST;
		}
		else if(json_message.has("db_user") && json_message.has("db_port") && json_message.has("db_password") && json_message.has("db_database") && json_message.has("db_ip"))
		{
			//#############################
			// SET MUSA DATABASE HOST
			//#############################
			
			connection_request_type = MUSA_HTTP_REQUEST.SET_DATABASE_HOST;
			
			String user 	= json_message.getString("db_user");
			String port 	= json_message.getString("db_port");
			String pass 	= json_message.getString("db_password");
			String dbName 	= json_message.getString("db_database");
			String ip 		= json_message.getString("db_ip");
			
			MusaProperties.setWorkflow_db_user(user);
			MusaProperties.setWorkflow_db_port(port);
			MusaProperties.setWorkflow_db_userpass(pass);
			MusaProperties.setWorkflow_db_name(dbName);
			MusaProperties.setWorkflow_db_ip(ip);
			
			System.out.println("Database set to ("+ip+")");
		}
		else
		{
			try						{throw new Exception();}
			catch(Exception E)		{System.out.println("ERROR: malformed json message received. \n"+E.getMessage());}
		}
		
		//OTHER REQUESTs PARSING HERE
	}
	
	
	public String getCapabilityThatMustFail()
	{
		return this.capabilityToFail;
	}

	
	/**
	 * Parse a jason goal pack
	 * 
	 * @param array
	 * @return
	 */
	private ListTerm parseGoalPack(JSONArray array)
	{
		Term belief;
		String beliefStr = "";
		ListTerm goals = new ListTermImpl();
		
		
		for (int i=0;i<array.length();i++)
		{
			belief = null;
			JSONObject obj = array.getJSONObject(i);
			try 
			{
				beliefStr 	= obj.getString("belief").substring(0, obj.getString("belief").length()-1);
				belief 		= ASSyntax.parseTerm(beliefStr);
			} 
			catch (JSONException e) 	{e.printStackTrace();belief = null;} 
			catch (ParseException e) 	{e.printStackTrace();belief = null;}
			
			if(belief == null)
				continue;
			
			if(!goals.contains(belief))					
				goals.add(belief);
		}
		
		return goals;
	}
	
	public void reply(String reply_message) 
	{
		if (out != null) {
			try 
			{
				out.writeObject(reply_message);
				out.flush();
				if (debug) System.out.println("Sent message " + reply_message);
			} catch (IOException ioException) {
				if (debug) System.out.println("Error sending message " + reply_message);
			}
		}
	}
	
	public void reply_and_close(String reply_message) 
	{
		if (out != null) {
			try 
			{
				out.writeObject(reply_message);
				out.flush();
				if (debug) System.out.println("Sent message " + reply_message);
			} catch (IOException ioException) {
				if (debug) System.out.println("Error sending message " + reply_message);
			}
		}
		
		try {
			out.close();
			in.close();
			connection.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public MUSA_HTTP_REQUEST getRequestType()
	{
		return this.connection_request_type;
	}
	
	
	public Integer getId() {
		return new Integer(id);
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getUser() {
		return user;
	}

	public String getRole() {
		return role;
	}

	public String getSession() {
		return session;
	}

	public String getService() {
		return service;
	}

	public String getAgent() {
		return agent;
	}

	public ListTerm getGoalPack() {
		return remoteGoalPackToInject;
	}

}
