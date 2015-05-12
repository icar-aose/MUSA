// Internal action code for project adaptive_workflow

package st;

import java.util.logging.FileHandler;
import java.util.logging.Logger;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class log extends DefaultInternalAction {
	
	//private static Logger LOGGER = Logger.getLogger("agent_log");
	//private static FileHandler fh = new FileHandler("mylog.txt");
	
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	FileHandler fh = new FileHandler("mylog.txt");
    	
    	Logger LOGGER = Logger.getLogger("A:");
    	LOGGER.addHandler(fh);
    	
    	StringTerm string_to_log = (StringTerm) args[0];
    	
    	LOGGER.info(string_to_log.toString());
    	        
        // everything ok, so returns true
        return true; 
    }
}
