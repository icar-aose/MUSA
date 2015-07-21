package occp.action;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;

import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.model.Event;

import calendar.CalendarQuickstart;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

/**
 * 
 * @author davide
 */
public class getGoogleCalendarEvents extends DefaultInternalAction
{
	private final String json_app_secret_key_fname = System.getProperty("user.home") + File.separator + ".musa/musa_google_application_keys.json";
	
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception
	{
		//Create a new google calendar object 
		CalendarQuickstart aa = new CalendarQuickstart();
		
		//Set the file path to the secret key related to the application
		aa.set_app_secret_key_json_file(new FileInputStream(json_app_secret_key_fname));
		 
		//get the list of upcoming events
		 List<Event> items = aa.getUpcomingEvents();
		 
		 if (items.size() == 0) 
	            System.out.println("No upcoming events found.");
	     else 
	     {
            System.out.println("Upcoming events:");
            for (Event event : items) 
            {
                DateTime start = event.getStart().getDateTime();
                if (start == null) 
                    start = event.getStart().getDate();

                System.out.printf("%s (%s)\n", event.getSummary(), start);
            }
	     }
		 
		return true;
		
	}
}
