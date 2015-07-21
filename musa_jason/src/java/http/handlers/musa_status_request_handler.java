package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Observable;

import org.apache.commons.io.IOUtils;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class musa_status_request_handler extends Observable implements HttpHandler 
{
    @Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.MUSA_STATUS_REQUEST;
    	
    	String theString = IOUtils.toString(t.getRequestBody());
    	System.out.println("[server] Received: "+theString);
    	
        String response = "ok";
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();
        
        setChanged();																//notify the change to the observer
        notifyObservers();
    }

}