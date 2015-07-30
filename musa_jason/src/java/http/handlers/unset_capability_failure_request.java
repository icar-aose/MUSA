package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Observable;

import org.apache.commons.io.IOUtils;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class unset_capability_failure_request extends Observable implements HttpHandler 
{	
    @Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.UNSET_CAPABILITY_FAILURE;				//Set the request type
    	
    	String theString = IOUtils.toString(t.getRequestBody());					//Get the request body
    	System.out.println("[server] Received: "+theString);
    	
    	JSONObject json_message = new JSONObject(new JSONTokener(theString));		//Create a JSON object and tokenize the received message
    	String cap_name = json_message.getString("unset_failure_capability");				//Get the capability name
    	
        String response = "unset_failure_capability ["+cap_name+"] ok";					//prepare and send the response
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();
        
        setChanged();																//notify the change to the observer
        notifyObservers(cap_name);
    }	
	
}