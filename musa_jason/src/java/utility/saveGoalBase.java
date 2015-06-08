package utility;
// Internal action code for project normeEWF

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class saveGoalBase extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action '<PCK>.saveGoalBase'");
       
         save(args[0].toString()+".\n");
        // everything ok, so returns true
        return true;
    }
    
  public  void save(String goal) {
        String path = "src/asl/goalBaseSigma.asl";
        
        try {
          File file = new File(path);
          FileWriter fw = new FileWriter(file,true);
          BufferedWriter bw = new BufferedWriter(fw);
          bw.append(goal);
          bw.flush();
          bw.close();
        }
        catch(IOException e) {
          e.printStackTrace();
        }
      }
}
