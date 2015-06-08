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

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;

import org.json.JSONObject;
import org.json.JSONTokener;

import cartago.*;

public class HTTPProxy extends Artifact 
{
	private boolean debug = false;
	private int conn_id_counter = 0;
	private Server server = null;
	private java.util.Date date = new java.util.Date();
	private Hashtable<String,Connection> open_connections;

	void init() 
	{
		open_connections = new Hashtable<String,Connection>();
		if (debug) System.out.println("Setup HTTPProxy Artifact");
	}
	
	@OPERATION
	void run_server() 
	{
		if (server!=null) 
		{
			if (debug) System.out.println("server is ready");
			server.run();
		} 
		else 
			if (debug) System.out.println("server is not ready");
	}
	
	@OPERATION
	void connect(OpFeedbackParam result) {
		if (server != null) {
			result.set("ok");
		} else {		
			try {
				server = new Server();
				if (debug) System.out.println("server created");
				result.set("ok");
			} catch (IOException e) {
				if (debug) System.out.println("server error");
				server = null;
				result.set("error");
			}
		}
	}
	
	@OPERATION
	void reply(int id, String reply) {
		if (debug) System.out.println("Sending...");
		Connection selected = open_connections.get(new Integer(id).toString());
		if (selected != null) {
			selected.reply_and_close(reply);
			
			open_connections.remove(id);
		}
	}

		
	public int generate_id() {
		int id = conn_id_counter;
		conn_id_counter++;
		return id;
	}
	
	public String generate_session() {
		Timestamp ts = new Timestamp(date.getTime());
		return ts.toString();
	}
	
	
	/**
	 * 
	 * @author luca
	 */
	private class Server 
	{
		private int port = 2004;		
		private ServerSocket providerSocket = null;

		public Server() throws IOException {
			providerSocket = new ServerSocket(port);
			if (debug) System.out.println("Opened the connection on "+providerSocket.getInetAddress().getHostAddress());
		}

		public void run() 
		{
			if (providerSocket==null) 
				return;
			
			Socket connection = null;

			try 
			{			
				if (debug) System.out.println("waiting for request...");
				connection  = providerSocket.accept();		
				Connection conn = new Connection(connection);
				if (debug) System.out.println("connection established");
				open_connections.put( conn.getId().toString() , conn );
				
				//Take parameters from the received JSON message
				HashMap<String,String> params = conn.getParam_table();
				Iterator<String> it = params.keySet().iterator();
				
				//per ogni parametro
				while (it.hasNext()) 
				{
					String key = it.next();
					String value = params.get(key);

					signal("http_param",conn.getId(),key,value);
				}

				signal("http_request",conn.getId(),conn.getSession(),conn.getAgent(),conn.getService(),conn.getUser(),conn.getRole());
				
			} 
			catch (IOException ioException) 
			{
				if (debug) System.out.println("Error with connection");
				if (debug) ioException.printStackTrace();
			}
			
		}
		
	}
	
	/**
	 * 
	 * @author luca
	 */
	private class Connection 
	{
		private int id;	
		private Socket connection = null;
		private ObjectOutputStream out = null;
		private ObjectInputStream in = null;
		private String user="";
		private String role="";
		private String session="";
		private String service="";
		private String agent="";
		
		private HashMap<String,String> param_table = new HashMap<String,String>();
		
		public Connection(Socket connection) 
		{
			id = generate_id();
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

			String message = null;
			try 
			{
				while (message == null) 
					message = (String) in.readObject();
				
				JSONObject json_message = new JSONObject(new JSONTokener(message));
				
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
			catch (IOException e) 				{if (debug) System.out.println("Read failed");} 
			catch (ClassNotFoundException e) 	{e.printStackTrace();}
		}
		
		public void reply_and_close(String reply_message) {
			if (out != null) {
				try {
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
}
