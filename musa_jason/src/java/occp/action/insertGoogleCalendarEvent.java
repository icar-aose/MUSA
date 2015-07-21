// Internal action code for project musa_jason

package occp.action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.File;
import java.io.FileInputStream;

import calendar.CalendarQuickstart;

/**
 * 
 * @author davide
 */
public class insertGoogleCalendarEvent extends DefaultInternalAction 
{
	private final String json_app_secret_key_fname = System.getProperty("user.home") + File.separator + ".musa/musa_google_application_keys.json";
	
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
//    	String event_name 	= args[0].toString();
//    	String description 	= args[1].toString();
    	String event_name = "Evento musa";
    	String description = "Event description!";
    	
    	//Create a new google calendar object 
		CalendarQuickstart aa = new CalendarQuickstart();
		
		//Set the file path to the secret key related to the application
		aa.set_app_secret_key_json_file(new FileInputStream(json_app_secret_key_fname));
		
		aa.insertNewEvent(event_name, description);
		
		System.out.println("[google service] Event added to calendar");
    	
        return true;
    }
}
