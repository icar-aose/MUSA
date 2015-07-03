// Internal action code for project musa_jason

package utility;

import jason.asSemantics.*;
import jason.asSyntax.*;

public class abs extends DefaultInternalAction 
{
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	int value = Math.abs(Integer.parseInt(args[0].toString()));
    	
    	Term output_val = ASSyntax.parseNumber(Integer.toString(value));
    	
        return un.unifies(output_val, args[1]);
    }
}
