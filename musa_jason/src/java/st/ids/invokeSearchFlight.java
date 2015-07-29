// Internal action code for project adaptive_workflow

package st.ids;

import org.json.JSONArray;
import org.json.JSONObject;

import st.JSON2TermUtils;
import st.ServiceUtils;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class invokeSearchFlight extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        ServiceUtils soap = new ServiceUtils("getFlightList","http://localhost:13749/","http://cnr.icar.pa");

    	StringTerm day_arg = (StringTerm) args[0];
    	StringTerm month_arg = (StringTerm) args[1];
    	StringTerm year_arg = (StringTerm) args[2];
    	StringTerm dept_arg = (StringTerm) args[3];
    	StringTerm dest_arg = (StringTerm) args[4];
        
    	soap.getSoapBodyElem().addChildElement("day").addTextNode(day_arg.toString());
    	soap.getSoapBodyElem().addChildElement("month").addTextNode(month_arg.toString());
    	soap.getSoapBodyElem().addChildElement("year").addTextNode(year_arg.toString());
    	soap.getSoapBodyElem().addChildElement("departure").addTextNode(dept_arg.toString());
    	soap.getSoapBodyElem().addChildElement("destination").addTextNode(dest_arg.toString());

    	String reply_message = soap.sendRequest("http://localhost:13749/TravelServices/services/FlightCompany");
    	
        JSONObject object = new JSONObject(reply_message);
        ListTerm return_opts = JSON2TermUtils.convertJSONFlights2ListTerm(object);
    	
    	return un.unifies(return_opts,args[5]);
    }
    
}
