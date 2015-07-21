package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Observable;

import occp.http.OCCPRequestParser;

import org.apache.commons.io.IOUtils;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class occp_request_handler extends Observable implements HttpHandler 
{
	private static String agent = "";
	private static String service = "";
	private static String session = "";
	private static String user = "";
	private static String role = "";
	
    private static HashMap<String,String> occp_params = new HashMap<>();

	@Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.OCCP_REQUEST;
    	
    	String theString = IOUtils.toString(t.getRequestBody());
    	System.out.println("[server] Received: "+theString);
    	
    	JSONObject json_message = new JSONObject(new JSONTokener(theString));
    	
    	OCCPRequestParser.parseRequestMessage(json_message);
     	set_request_params();
    	
        String response = "request rececived";
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();
        
        setChanged();
        notifyObservers();
    }

	private void set_request_params()
	{
		occp_params.clear();
    	occp_params.put("idOrder", OCCPRequestParser.getIdOrdine());
		occp_params.put("idUser", OCCPRequestParser.getIdUtente());
		occp_params.put("mailUser", OCCPRequestParser.getMail());
		occp_params.put("user_message", OCCPRequestParser.getUserMessage());
		occp_params.put("userAccessToken", OCCPRequestParser.getDropboxAccessToken());
    	
		agent 		= OCCPRequestParser.getAgent();
		service 	= OCCPRequestParser.getService();
		session 	= OCCPRequestParser.getSession();
		user 		= OCCPRequestParser.getUser();
		role 		= OCCPRequestParser.getRole();
	}
	
	
	public static String getAgent() {
		return agent;
	}

	public static String getService() {
		return service;
	}

	public static String getSession() {
		return session;
	}

	public static String getUser() {
		return user;
	}

	public static String getRole() {
		return role;
	}

	public static HashMap<String, String> getOccp_params() {
		return occp_params;
	}
}