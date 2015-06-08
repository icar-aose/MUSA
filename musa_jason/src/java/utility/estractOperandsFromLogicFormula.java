package utility;
// Internal action code for project normeEWF

import java.util.List;
import jason.asSemantics.*;
import jason.asSyntax.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Structure;

public class estractOperandsFromLogicFormula extends DefaultInternalAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action '<PCK>.estractOperandsFromLogicFormula'");
      String st=args[0].toString();
      List<Term> res=null;
      Term res2=null;
      ListTerm ls= new ListTermImpl();
     
       Structure struc= ASSyntax.parseStructure(st);
       if(struc.getFunctor().equalsIgnoreCase("and")|struc.getFunctor().equalsIgnoreCase("or") ){
    	  // System.out.print(struc+""+ struc.getTerms());
    	   res2 =struc.getTerm(0);
    	 
    	 /* for(int i=0;i<res.size();i++){
        	   ls.append((Term)res.get(i));
           }*/
    	   return un.unifies(res2, args[1]);
       }
       else if (struc.getFunctor().equalsIgnoreCase("neg")){
    	   res =((List<Term>)struc.getTerms());
       	
      	 for(int i=0;i<res.size();i++){
          	   ls.append((Term)res.get(i));
             }
      	  return un.unifies(ls, args[1]);
    	   
       }
    
       
      return un.unifies(ls, args[1]);
      
       
        // everything ok, so returns true
       // return un.unifies(ls, args[1]);
      
        // everything ok, so returns true
        
    }
}
