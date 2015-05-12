// Internal action code for project adaptive_workflow

package st;

import java.util.List;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class norm_predicate extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        //ts.getAg().getLogger().info("executing internal action 'st.normalize_predicate'");
        
        Structure struct = (Structure) args[0];
        
        String functor = struct.getFunctor();
        List<Term> terms = struct.getTerms(); 
        
        Structure output = new Structure("predicate");
        output.addTerm(new Atom(functor));
        //output.addTerms(terms);
        ListTermImpl list_of_terms = new ListTermImpl();
        list_of_terms.addAll(terms);
        
        output.addTerm(list_of_terms);
        
        return un.unifies(output,args[1]);
    }
}
