package action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;
import occp.logger.musa_logger;

/**
 * 
 * @author davide
 *
 */
public class initiateLogger extends DefaultInternalAction 
{
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	String fname = args[0].toString().replace("\"", "");
    	musa_logger.get_instance_and_set_log_fname(fname);
    	
    	return true;
    }

}
