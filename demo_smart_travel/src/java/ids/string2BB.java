// Internal action code for project adaptive_workflow

package ids;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class string2BB extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        //ts.getAg().getLogger().info("executing internal action 'ids.string2BB'");

    	if (args[0].isString() ) {
    		StringTerm par = (StringTerm) args[0];
    		String belief = par.getString();
    		
    		if(!belief.equals("error")) {
    			//System.out.println("parsing: ["+belief+"]");
	    		Literal bel = ASSyntax.parseLiteral(belief);
	    		ts.getAg().addBel(bel);
    		}
    	} else {
    		throw new JasonException("Argument must be a string");
    	}
        
        // everything ok, so returns true
        return true;
    }
}
