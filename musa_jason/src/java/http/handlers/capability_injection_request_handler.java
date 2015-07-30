package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Observable;

import org.apache.commons.io.IOUtils;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class capability_injection_request_handler extends Observable implements HttpHandler 
{	
    @Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.CAPABILITY_INJECTION;				//Set the request type
    	
    	String theString = IOUtils.toString(t.getRequestBody());					//Get the request body
    	System.out.println("[server] Received: "+theString);
    	
    	JSONObject json_message = new JSONObject(new JSONTokener(theString));		//Create a JSON object and tokenize the received message
    	
    	HashMap<String,String> capability_info = new HashMap<>();
    	capability_info.put("agent_owner", 					json_message.getString("agent_owner"));
    	capability_info.put("capability_name", 				json_message.getString("capability_name"));
    	capability_info.put("capability_type", 				json_message.getString("capability_type"));
    	capability_info.put("capability_parameters", 		json_message.getString("capability_parameters"));
    	capability_info.put("capability_precondition", 		json_message.getString("capability_precondition"));
    	capability_info.put("capability_postcondition", 	json_message.getString("capability_postcondition"));
    	capability_info.put("capability_cost", 				json_message.getString("capability_cost"));
    	capability_info.put("capability_evolution", 		json_message.getString("capability_evolution"));
    	capability_info.put("capability_plans", 			json_message.getString("capability_plans"));
    	
        String response = "ok";					//prepare and send the response
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();
        
        setChanged();																//notify the change to the observer
        notifyObservers(capability_info);
    }	
	
}