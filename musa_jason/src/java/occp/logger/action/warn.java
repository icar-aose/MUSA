package occp.logger.action;

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
public class warn extends DefaultInternalAction 
{
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		String message = "";
		
		for (Term t : args)
		{
			message += t.toString().replace("\"", ""); 
		}
		musa_logger.get_instance().warn(message);
		return true;
	}
}