// Internal action code for project adaptive_workflow

package st;

import java.util.Iterator;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class denormalize_predicate extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	Literal functor = (Literal) args[0];
        ListTerm terms = (ListTerm) args[1];
    	
        //System.out.println(functor.getFunctor());
        
        Structure output = new Structure(functor.getFunctor());
        
        Iterator<Term> it = terms.iterator();
        while (it.hasNext()) {
        	Term item = it.next();
        	output.addTerm(item);
        }
        
        

        return un.unifies(output,args[2]);
    }

}
