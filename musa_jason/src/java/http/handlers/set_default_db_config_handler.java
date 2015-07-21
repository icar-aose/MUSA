package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Observable;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class set_default_db_config_handler  extends Observable implements HttpHandler 
{
    @Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.SET_DEFAULT_DB_CONFIG;
    	
        String response = "ok";
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();

        setChanged();
        notifyObservers();
    }
}