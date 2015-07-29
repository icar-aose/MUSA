// Internal action code for project musa_jason

package occp.action;

import occp.model.occp_capability_status;
import jason.asSemantics.*;
import jason.asSyntax.*;

/**
 * Used to set the OCCP capabilities status. This information is gathered from the web editor
 * to show the occp demo process progress togheter with the tasks' status.
 * 
 * @author davide
 *
 */
public class setOCCPcapabilityStatus extends DefaultInternalAction 
{

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	String cap_name = args[0].toString();
    	String cap_status = args[1].toString();
    	
    	occp_capability_status.getCapability_status().put(cap_name, cap_status);
    	
        return true;
    }
}
