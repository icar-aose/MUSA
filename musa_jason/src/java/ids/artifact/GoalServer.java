package ids.artifact;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.Timestamp;
import java.util.Hashtable;

import org.json.JSONObject;
import org.json.JSONTokener;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

/**
 * 
 * @author davide
 */
public class GoalServer extends Artifact 
{
	private boolean debug = true;
	private int conn_id_counter = 0;
	private Server server = null;
	private java.util.Date date = new java.util.Date();
	private Hashtable<String,Connection> open_connections;

	void init() 
	{
		open_connections = new Hashtable<String,Connection>();
		if (debug) System.out.println("Setup GoalServer Artifact");
	}
	
	@OPERATION
	void run_server() 
	{
		if (server!=null) 
		{
			if (debug) System.out.println("goal server is ready");
			server.run();
		} 
		else 
			if (debug) System.out.println("goal server is not ready");
	}
	
	@OPERATION
	void connect(OpFeedbackParam result) {
		if (server != null) {
			result.set("ok");
		} else {		
			try {
				server = new Server();
				if (debug) System.out.println("goal server created");
				result.set("ok");
			} catch (IOException e) {
				if (debug) System.out.println("goal server error");
				server = null;
				result.set("goal server error");
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
				open_connections.put( conn.get_id().toString() , conn );
				
				String action = conn.get_action();
				
				
				if(action.equals("add_to_db"))
				{
					System.out.println("Add to database");
				}
				else if(action.equals("inject_goal"))
				{
					System.out.println("inject goal");
				}
				
				//signal("goalToInject",conn.get_goal(),conn.get_pack(),conn.get_description());
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
		private InputStream in = null;
		
		private String host = "";
		private String port = "";
		private String goal = "";
		private String pack = "";
		private String description = "";
		private String action = "";
				
		
		public Connection(Socket connection) 
		{
			id = generate_id();
			this.connection = connection;
			
			try 
			{
				if (debug) System.out.println(connection.getOutputStream().toString());
				in = new DataInputStream(connection.getInputStream());
				if (debug) System.out.println("Reading from stream");
			} 
			catch (IOException ioException) 
			{
				if (debug) System.out.println("Error with read from stream --> "+ioException.getMessage());
			}

			String message = null;
			try 
			{
				byte[] msg = new byte[1000];
				in.read(msg);
				message = new String(msg);
				
				JSONObject json_message = new JSONObject(new JSONTokener(message));
				if (debug) System.out.println("Read " + json_message.toString() );
				System.out.println("Read " + json_message.toString() );
				
				action 			= json_message.getString("action");
				goal 			= json_message.getString("goal_name");
				pack 			= json_message.getString("goal_pack");
				description 	= json_message.getString("goal_description");
			} 
			catch (IOException e) 				{if (debug) System.out.println("Read failed");}
		}
		
		public void reply_and_close(String reply_message) 
		{
			if (out != null) 
			{
				try 
				{
					out.writeObject(reply_message);
					out.flush();
					if (debug) System.out.println("Sent message " + reply_message);
				} 
				catch (IOException ioException) 
				{
					if (debug) System.out.println("Error sending message " + reply_message);
				}
			}
			
			try 
			{
				out.close();
				in.close();
				connection.close();
			} 
			catch (IOException e) 
			{
				e.printStackTrace();
			}
		}


		public String get_port() 
		{
			return port;
		}

		public String get_goal() 
		{
			return goal;
		}

		public String get_pack() 
		{
			return pack;
		}

		public String get_description() {
			return description;
		}

		public Integer get_id() {
			return id;
		}

		public String get_action() 
		{
			return action;
		}
	}
	
}

