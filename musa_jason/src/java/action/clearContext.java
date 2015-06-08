package action;

import occp.logger.musa_logger;
import ids.database.ValueTable;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

/**
 * This Jason internal action deletes all the entries from the table 'adw_value', that is, the context.
 * 
 * @author davide
 */
public class clearContext extends DefaultInternalAction 
{
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		new ValueTable().deleteAll();
		musa_logger.get_instance().info("Context cleared correctly");
		
		return true;
	}

}
