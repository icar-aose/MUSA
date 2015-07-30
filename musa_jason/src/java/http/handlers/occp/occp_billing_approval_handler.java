package http.handlers.occp;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Observable;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

/**
 * Used for receiving remote billing approval.
 * 
 * ~~~ only for remote requests testing ~~~
 * @author davide
 *
 */
public class occp_billing_approval_handler extends Observable implements HttpHandler 
{	
    @Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.OCCP_BILLING_APPROVAL;				//Set the request type
    	
        String response = "billing approved";					
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();
        
        setChanged();																//notify the change to the observer
        notifyObservers();
    }
}