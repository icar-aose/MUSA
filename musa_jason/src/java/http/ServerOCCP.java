package http;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;

public class ServerOCCP 
{
	private boolean debug = true;
	private int port = 2004;		
	private ServerSocket providerSocket = null;
	private int connection_id = 0;
	ConnectionOCCP conn = null;
	private HashMap<String,String> params;
	
	public ServerOCCP(int connectionId) throws IOException 
	{
		providerSocket = new ServerSocket(port);
		if (debug) System.out.println("Opened the connection on "+providerSocket.getInetAddress().getHostAddress());
		
		params = new HashMap<String,String>();
		this.connection_id = connectionId;
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
			
			try 
			{
				conn = new ConnectionOCCP(connection);
				conn.setId(connection_id);
			} 
			catch (Exception e) {e.printStackTrace();}
			if (debug) System.out.println("connection established");
				
			
			params.put("idOrder", String.format("%d", conn.getId()));
			params.put("idUser", ConnectionOCCP.getIdUtente());
			params.put("mailUser", ConnectionOCCP.getMail());
			params.put("user_message", ConnectionOCCP.getUserMessage());
			params.put("userAccessToken", ConnectionOCCP.getDropboxAccessToken());
			
		} 
		catch (IOException ioException) 
		{
			if (debug) System.out.println("Error with connection");
			if (debug) ioException.printStackTrace();
		}
	}
	
	public HashMap<String,String> getParams()
	{
		return this.params;
	}
	
	public ConnectionOCCP getConnection()
	{
		return this.conn;
	}
	
	public int getConnectionId() {
		return this.conn.getId();
	}

}
