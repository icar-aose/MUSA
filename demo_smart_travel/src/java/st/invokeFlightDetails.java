// Internal action code for project adaptive_workflow

package st;

import org.json.JSONObject;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class invokeFlightDetails extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	StringTerm id = (StringTerm) args[0];
    	
        ServiceUtils soap = new ServiceUtils("getFlightDetails","http://localhost:13749/","http://cnr.icar.pa");
        soap.getSoapBodyElem().addChildElement("id").addTextNode(id.getString());
        soap.getSoapMessage().saveChanges();        
    	
    	String reply_message = soap.sendRequest("http://localhost:13749/TravelServices/services/FlightCompany");
        
    	JSONObject object = new JSONObject(reply_message);
        LiteralImpl return_opt = JSON2TermUtils.convertJSONFlightsTerm(object);
    	
    	return un.unifies(return_opt,args[1]);
    }
}
