package action;

import java.util.List;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.Term;

/**
 * 
 * @author davide
 *
 */
public class evaluateCapabilityCost extends DefaultInternalAction 
{
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	int overall_capability_cost 	= 0;
    	List capability_cost_list 		= (List) args[0];
    	
    	for (int i=0; i<capability_cost_list.size(); i++)
    	{    		
    		NumberTerm current_cost = (NumberTerm) capability_cost_list.get(i);
    		int cost = Integer.parseInt(current_cost.toString());
    		
    		//...
    		
    		overall_capability_cost += cost;
    	}
    	
    	Term output_cost = ASSyntax.parseNumber(Integer.toString(overall_capability_cost));
    	
    	return un.unifies(output_cost, args[1]);
    }

}
