package utility;
// Internal action code for project normeEWF
// Internal action code for project normeEWF

import java.util.List;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class orConditionFromList extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action '<PCK>.generateORConditionFromList'");
       
       List l= (List) args[0];
       String s="or(["+l.get(0);
       for(int i=1;i<l.size();i++){
    	s=s+","+l.get(i);   
       }
       s=s+"])";
        
       Term res = ASSyntax.parseTerm(s);
       
       // everything ok, so returns true
       return un.unifies(res, args[1]);
 
    }
}
