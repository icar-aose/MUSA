// Internal action code for project musa_jason

package action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;
import utility.musa_status;

public class set_musa_status extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
        musa_status.set_musa_status(args[0].toString());
        return true;
    }
}
