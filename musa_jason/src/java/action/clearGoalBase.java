package action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.PrintWriter;

@SuppressWarnings("serial")
/**
 * 
 * @author Davide Guastella
 */
public class clearGoalBase extends DefaultInternalAction 
{
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		ts.getAg().getLogger().info("executing internal action 'action.clearGoalBase'");
	    
		String path = args[0].toString();
		System.out.print("Percorso: " + path.substring(1,path.length()-1));
		
		PrintWriter pw = new PrintWriter(path.substring(1,path.length()-1));
		pw.close();
		
		return true;
	}
}
