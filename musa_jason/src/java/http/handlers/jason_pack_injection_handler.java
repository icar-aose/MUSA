package http.handlers;

import http.Server;
import http.Server.MUSA_HTTP_REQUEST;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Term;
import jason.asSyntax.parser.ParseException;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Observable;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public class jason_pack_injection_handler extends Observable implements HttpHandler 
{    
	@Override
    public void handle(HttpExchange t) throws IOException 
    {
    	Server.request_type = MUSA_HTTP_REQUEST.GOAL_INJECTION;
    	
    	String theString = IOUtils.toString(t.getRequestBody());
    	System.out.println("[server] Received: "+theString);
    	
    	JSONObject json_message 			= new JSONObject(new JSONTokener(theString));
    	ListTerm goal_pack_to_inject 		= parseGoalPack(json_message.getJSONArray("goal_pack"));
    	
        String response = "ok";
        t.sendResponseHeaders(200, response.length());
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes());
        os.close();
        
        setChanged();
        notifyObservers(goal_pack_to_inject);
    }
	
	/**
	 * Parse a jason goal pack
	 * 
	 * @param array An array of json object with a single entry "belief" containing a JASON goal.
	 * @return
	 */
	private ListTerm parseGoalPack(JSONArray array)
	{
		Term belief;
		String beliefStr = "";
		ListTerm goals = new ListTermImpl();
		
		
		for (int i=0;i<array.length();i++)
		{
			belief = null;
			JSONObject obj = array.getJSONObject(i);
			try 
			{
				beliefStr 	= obj.getString("belief").substring(0, obj.getString("belief").length()-1);
				belief 		= ASSyntax.parseTerm(beliefStr);
			} 
			catch (JSONException e) 	{e.printStackTrace();belief = null;} 
			catch (ParseException e) 	{e.printStackTrace();belief = null;}
			
			if(belief == null)
				continue;
			
			if(!goals.contains(belief))					
				goals.add(belief);
		}
		
		return goals;
	}
}