/**
 * TODO Fa 'quasi' lo stesso dell'internal action normalize_nested_predicate. Deve essere eliminata la ridondanza del codice.
 */
package st;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Literal;
import jason.asSyntax.Term;

import java.util.List;

/**
 * @author davide
 */
public class unroll_nested_predicate extends DefaultInternalAction 
{
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	List<Term> term_list 		= ((Literal) args[0]).getTerms();
    	List<Term> term_list_prev   = null;
    	Literal functor 			= Literal.parseLiteral(((Literal) args[0]).getFunctor());
    	Literal functor_previous 	= Literal.LFalse;
    	
    	do
    	{
    		functor_previous 	= functor;
    		functor 			= (Literal) term_list.get(0);
    		term_list_prev		= term_list;
    		term_list			= functor.getTerms();
    	}while(!term_list.isEmpty());
    	
    	//Get the new functor
        Literal NewFunctor = Literal.parseLiteral(functor_previous.getFunctor());
   
    	//Create a ListTermImpl object
    	ListTermImpl terms = new ListTermImpl();
    	
    	//Add the previously found terms (strings) to a new list of Term objects
    	terms.addAll(term_list_prev);
        String termString = terms.toString();
        termString = termString.replace("[", "");
        termString = termString.replace("]", "");
        
    	StringBuilder sb = new StringBuilder();
        sb.append(NewFunctor);
        sb.append("(");
        sb.append(termString);
        sb.append(")");
        
        return un.unifies(Literal.parseLiteral(sb.toString()),	args[1]);
    }

}