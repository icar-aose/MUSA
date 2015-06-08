package occp.logger.action;

import occp.logger.musa_logger;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

/**
 * 
 * @author davide
 *
 */
public class fatal extends DefaultInternalAction 
{
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
String message = "";
		
		for (Term t : args)
		{
			message += t.toString().replace("\"", ""); 
		}
		musa_logger.get_instance().fatal(message);
		return true;
	}

}
