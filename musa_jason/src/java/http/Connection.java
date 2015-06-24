package http;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONObject;
import org.json.JSONTokener;

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
	protected JSONObject json_message = null;
	private HashMap<String,String> param_table = new HashMap<String,String>();
	
	public Connection(Socket connection) 
	{
		String message = null;
//		id = generate_id();
		this.connection = connection;
		
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
		}
		
		
		try 
		{
			while (message == null) 
				message = (String) in.readObject();
			
			json_message = new JSONObject(new JSONTokener(message));
			
			if (debug) System.out.println("Read " + json_message.toString() );
		}
		catch (IOException e) 				{if (debug) System.out.println("Read failed");} 
		catch (ClassNotFoundException e) 	{e.printStackTrace();}
		
//		readMessage();
	}
	
	/**
	 * Read the content of a JSON message request
	 */
	protected void readMessage()
	{
		if (debug) System.out.println("Read " + json_message.toString() );
		System.out.println("Read " + json_message.toString() );
		
		if( !(json_message.has("agent") && json_message.has("service") && json_message.has("session") && json_message.has("userrole")) )
		{
			try						{throw new Exception();}
			catch(Exception E)		{System.out.println("ERROR: malformed json message received. \n"+E.getMessage());}
		}
		agent 	= json_message.getString("agent");
		service = json_message.getString("service");
		if (json_message.has("session")) 	session = json_message.getString("session");
		if (json_message.has("username")) 	user = json_message.getString("username");
		if (json_message.has("userrole")) 	role = json_message.getString("userrole");
	}
	
	/**
	 * 
	 */
	public void readParams()
	{
		if (json_message.has("params")) 
		{
			JSONObject params = json_message.getJSONObject("params");
			Iterator it = params.keys();
			
			while (it.hasNext()) 
			{
				String key 		= (String) it.next();
				String param 	= params.getString(key);
				param_table.put(key, param);
			}
		}
	}
	
	public void reply_and_close(String reply_message) {
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

	public HashMap<String, String> getParam_table() {
		return param_table;
	}
}
