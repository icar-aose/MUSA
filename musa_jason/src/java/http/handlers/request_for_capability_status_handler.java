package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.Observable;

import org.json.JSONArray;
import org.json.JSONObject;

import occp.model.occp_capability_status;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class request_for_capability_status_handler extends Observable implements HttpHandler 
{
    @Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.REQUEST_FOR_CAPABILITY_STATUS;
    	Iterator<String> it = occp_capability_status.getCapability_status().keySet().iterator();
    	
    	JSONObject main 			= new JSONObject();
    	JSONArray cap_status      	= new JSONArray();
        
		while (it.hasNext()) 
		{
			String key 		= it.next();
			String value 	= (String) occp_capability_status.getCapability_status().get(key);
			String ID 		= occp_capability_status.getCapabilityTaskID(key);
			
			JSONObject this_cap = new JSONObject();
			
			this_cap.put("id_task", 			ID);
			this_cap.put("capability_name", 	key);
			this_cap.put("capability_state", 	value);
			cap_status.put(this_cap);
		}
		main.put("capability_status",cap_status);
    	
        String response = main.toString().trim();
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();

        setChanged();
        notifyObservers();
    }
}