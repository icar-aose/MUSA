package st;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTerm;
import jason.asSyntax.Literal;
import jason.asSyntax.Structure;
import jason.asSyntax.Term;

import java.util.Iterator;

public class denormalize_nested_predicate extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	Literal functor = (Literal) args[0];
        ListTerm terms = (ListTerm) args[1];
        
        System.out.println(args[0].toString()+" is the functor");
        
        if(args[1] instanceof Literal)
        {
        	System.out.println(args[1].toString()+" is a Literal");
        }
        else
        {
        	System.out.println(args[1].toString()+" is a List of Term");
        }        
        
        Structure output = new Structure(functor.getFunctor());
        return "".toString();
    }

}