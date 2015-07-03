// Internal action code for project musa_jason

package occp.action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.FileInputStream;

import calendar.CalendarQuickstart;

import com.google.api.client.util.DateTime;

public class insertGoogleCalendarEvent extends DefaultInternalAction 
{
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	//Create a new google calendar object 
		CalendarQuickstart aa = new CalendarQuickstart();
		
		//Set the file path to the secret key related to the application
		aa.set_app_secret_key_json_file(new FileInputStream("/home/davide/musa_google_application_keys.json"));
		
		//Create and insert the event
		String event_name 		= "Product delivery";
		String location 		= "test street, 10";
		String description 		= "Delivery of the product I ordered";
		DateTime event_date 	=  new DateTime("2015-10-24T17:00:00-07:00");
		
		aa.insertNewEvent(event_name, description);
		
		System.out.println("Evento inserito nel calendario");
    	
        return true;
    }
}
