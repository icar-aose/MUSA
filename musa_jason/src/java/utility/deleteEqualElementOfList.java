// Internal action code for project normeEWF

package utility;

import java.util.ArrayList;
import java.util.List;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class deleteEqualElementOfList extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action 'utility.deleteEqualElementOfList'");
        
        List<Term> l= (List<Term>)args[0];
        ListTerm Nl= new ListTermImpl();
        
        Nl.add(l.get(0));
        for(int i=1;i<l.size();i++){
        	if(!Nl.contains(l.get(i))){
        		Nl.add(l.get(i));
        	}
        }
        
        
        // everything ok, so returns true
        return un.unifies(Nl, args[1]);
    }
}
