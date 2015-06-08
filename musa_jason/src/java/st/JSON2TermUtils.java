package st;

import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.LiteralImpl;
import jason.asSyntax.StringTermImpl;

import org.json.JSONArray;
import org.json.JSONObject;

public class JSON2TermUtils {

	
    public static ListTerm convertJSONFlights2ListTerm(JSONObject flight_list) {
    	ListTerm return_opts = new ListTermImpl();
    	
        JSONArray opts = flight_list.getJSONArray("options");
        
        for (int i=0; i<opts.length(); i++) {
        	JSONObject opt = opts.getJSONObject(i);
        	LiteralImpl option = convertJSONFlightsTerm(opt);
         	return_opts.add(option);
        }

        return return_opts;
    }
    
    public static LiteralImpl convertJSONFlightsTerm(JSONObject flight) {
    	LiteralImpl option = new LiteralImpl("flight");
     	
     	option.addTerm(new StringTermImpl(""+flight.getInt("id")));

     	option.addTerm(convertJSONDate2Structure("dept_date",flight.getJSONObject("dept_time")));
     	
     	option.addTerm(new StringTermImpl(""+flight.getInt("duration")));
    	option.addTerm(new StringTermImpl(""+flight.getInt("price")));
    	option.addTerm(new StringTermImpl(""+flight.getBoolean("cancellable")));
    	return option;
    }

    public static LiteralImpl convertJSONDate2Structure(String funct, JSONObject date) {
    	LiteralImpl lit_date = new LiteralImpl(funct);
    	
    	lit_date.addTerm(new StringTermImpl(date.getString("year")));
    	lit_date.addTerm(new StringTermImpl(date.getString("month")));
    	lit_date.addTerm(new StringTermImpl(date.getString("day")));
    	lit_date.addTerm(new StringTermImpl(date.getString("hour")));
    	lit_date.addTerm(new StringTermImpl(date.getString("minute")));
    	
    	return lit_date;
    }
    
}
