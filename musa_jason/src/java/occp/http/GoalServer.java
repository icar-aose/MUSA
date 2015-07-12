package occp.http;

import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Term;
import jason.asSyntax.parser.ParseException;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.Timestamp;
import java.util.Hashtable;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;


/**
 * Used to inject goals remotely from the occp web interface.
 *   
 * @author davide
 */
public class GoalServer extends Artifact 
{
	private final int GOAL_SERVER_PORT = 2005;
	
	private boolean debug = true;
	private int conn_id_counter = 0;
	private Server server = null;
	private java.util.Date date = new java.util.Date();
	private Hashtable<String,Connection> open_connections;

	private ListTerm goalList;
	
	void init() 
	{
		goalList = new ListTermImpl();
		open_connections = new Hashtable<String,Connection>();
		if (debug) System.out.println("Setup GoalServer Artifact");
	}

	
	@OPERATION
	private void get_received_goals(OpFeedbackParam<ListTerm> goals)
	{
		goals.set(this.goalList);
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
	void connect(OpFeedbackParam<String> result) 
	{
		if (server != null) 
			result.set("ok");
		else 
		{		
			try 
			{
				server = new Server();
				if (debug) System.out.println("goal server created");
				result.set("ok");
			} 
			catch (IOException e) 
			{
				if (debug) System.out.println("goal server error");
				server = null;
				result.set("goal server error");
			}
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
		private ServerSocket providerSocket = null;

		public Server() throws IOException
		{
			providerSocket = new ServerSocket(GOAL_SERVER_PORT);
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
				
				signal("remote_goal_pack_injected");
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

		public Connection(Socket connection) 
		{
			BufferedReader br = null;
			id = generate_id();
			this.connection = connection;
			
			try 
			{
				if (debug) System.out.println(connection.getOutputStream().toString());
				br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
				
				if (debug) System.out.println("Reading from stream");
			} 
			catch (IOException ioException) 
			{
				if (debug) System.out.println("Error with read from stream --> "+ioException.getMessage());
			}

			String message = null;
			try 
			{
				Term belief;
				String beliefStr = "";
				message = new String(br.readLine());
				
				JSONObject json_message = new JSONObject(new JSONTokener(message));
				if (debug) System.out.println("Read " + json_message.toString() );
				
				if(json_message.has("goal_pack"))
				{
					JSONArray GoalPack = json_message.getJSONArray("goal_pack");
	
					for (int i=0;i<GoalPack.length();i++)
					{
						belief = null;
						JSONObject obj = GoalPack.getJSONObject(i);
						try 
						{
							beliefStr 	= obj.getString("belief").substring(0, obj.getString("belief").length()-1);
							belief 		= ASSyntax.parseTerm(beliefStr);
						} 
						catch (JSONException e) 	{e.printStackTrace();belief = null;} 
						catch (ParseException e) 	{e.printStackTrace();belief = null;}
						
						if(belief == null)
							continue;
						
						if(!goalList.contains(belief))					
							goalList.add(belief);
					}
				}
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
				connection.close();
			} 
			catch (IOException e) 
			{
				e.printStackTrace();
			}
		}

		public Integer get_id() {
			return id;
		}

	}
	
}

