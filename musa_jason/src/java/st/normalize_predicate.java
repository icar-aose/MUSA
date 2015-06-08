// Internal action code for project adaptive_workflow

package st;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Atom;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Structure;
import jason.asSyntax.Term;

public class normalize_predicate extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        //ts.getAg().getLogger().info("executing internal action 'st.normalize_predicate'");
        
        Structure struct = (Structure) args[0];
        
        Atom functor = new Atom( struct.getFunctor() );
        ListTermImpl terms = new ListTermImpl( );
        terms.addAll(struct.getTerms());
        
        boolean uno = un.unifies(functor,args[1]);
        boolean due = un.unifies(terms,args[2]);
        
        return uno && due;
    }
}
