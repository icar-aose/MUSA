package st;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Literal;
import jason.asSyntax.Term;

import java.util.List;

/**
 * This class rapresents the internal action for normalizing nested predicates. Let
 * 
 * f(g(q(x,y)))
 * 
 * be an example of nested predicate. This internal action will separate the inner predicate q
 * from the terms x and y. These literals are unified with the outputt vars.
 * 
 * @author davide
 *
 */
public class normalize_nested_predicate extends DefaultInternalAction 
{
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	List<Term> term_list 		= ((Literal) args[0]).getTerms();
    	List<Term> term_list_prev   = null;
    	Literal functor 			= Literal.parseLiteral(((Literal) args[0]).getFunctor());//Literal.LFalse;
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
        
    	//Unifies the functor and the terms(separated) with the output vars
        boolean uno = un.unifies(NewFunctor,	args[1]);
        boolean due = un.unifies(terms,		args[2]);
        
        return uno && due;
    }

}