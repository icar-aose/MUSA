// Internal action code for project adaptive_workflow

package st;

import org.json.JSONObject;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class invokeBookFlight extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	StringTerm id = (StringTerm) args[0];
    	
        ServiceUtils soap = new ServiceUtils("reserveFlight","http://localhost:13749/","http://cnr.icar.pa");
        soap.getSoapBodyElem().addChildElement("id").addTextNode(id.getString());
        soap.getSoapMessage().saveChanges();        
    	
    	String reply_message = soap.sendRequest("http://localhost:13749/TravelServices/services/FlightCompany");
        
    	StringTermImpl resp_term = new StringTermImpl(reply_message);
    	
    	return un.unifies(resp_term,args[1]);
    }
}
