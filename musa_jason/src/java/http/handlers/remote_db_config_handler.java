package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Observable;

import org.apache.commons.io.IOUtils;
import org.json.JSONObject;
import org.json.JSONTokener;

import workflow_property.MusaProperties;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class remote_db_config_handler extends Observable implements HttpHandler 
{
    @Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.SET_DATABASE_HOST;
    	String theString = IOUtils.toString(t.getRequestBody());
    	System.out.println("[server] Received: "+theString);
    	
    	JSONObject json_message = new JSONObject(new JSONTokener(theString));		//Create a JSON object and tokenize the received message
    	
    	String db_user = json_message.getString("db_user");
    	String db_port = json_message.getString("db_port");
    	String db_password = json_message.getString("db_password");
    	String db_name = json_message.getString("db_database");
    	String db_ip = json_message.getString("db_ip");
  
    	MusaProperties.setWorkflow_db_ip(db_ip);
    	MusaProperties.setWorkflow_db_name(db_name);
    	MusaProperties.setWorkflow_db_port(db_port);
    	MusaProperties.setWorkflow_db_user(db_user);
    	MusaProperties.setWorkflow_db_userpass(db_password);
    	
        String response = "ok";
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();

        setChanged();
        notifyObservers();
    }
}