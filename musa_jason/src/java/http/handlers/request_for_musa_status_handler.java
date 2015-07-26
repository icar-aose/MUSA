package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Observable;

import utility.musa_status;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class request_for_musa_status_handler extends Observable implements HttpHandler 
{
    @Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.MUSA_STATUS_REQUEST;
    	
        String response = musa_status.get_musa_status();
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();
        
        setChanged();																//notify the change to the observer
        notifyObservers();
    }

}