// Internal action code for project normeEWF

package utility;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Vector;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class generatePossibleStateofWorld extends DefaultInternalAction {
	   private static List states;
	   private static String combinazioni[];
	   String  StateOfWorld;
	   private static int count = 0;
	   int N,J;
	   String[] ListStateWorld;
	  // ListTerm l= ASSyntax.createList();
	   
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	
    	List states = new ArrayList();
    	StateOfWorld =new String();
    	// execute the internal action
        ts.getAg().getLogger().info("executing internal action 'utility.generatePossibleStateofWorld'");
        List input= (List) args[0];
     //  String st=input.toString();
       //st.substring(st.indexOf("["),st.indexOf("]"));
      
        /* for(int h=0;h<st.split(",").length;h++){
        	 String elem= input.get(h).toString();
        	 states.add(elem);
         }*/
      // System.out.println("FFFFFFFFFFFFFFFFFFFFFFF"+st);
       for(int h=0;h<input.size();h++){
      	 String elem= input.get(h).toString();
      	//System.out.println("ELEM"+elem);
      	 states.add(elem);
       }    
         
         N=states.size();
       
         for(int k=1;k<=N;k++){
         J=0; 
         combinazioni=new String[k];
         generateCombination(states,J,N,k);
         //System.out.println("HHHHHHHHHHHHHHHHHHHHHHHHH"+StateOfWorld);
         }
         StateOfWorld="listofWorld(["+StateOfWorld+"])";
        
        // System.out.println("JJJJ"+ListStateWorld);
        
         Term res= ASSyntax.parseTerm(StateOfWorld);
      
        // everything ok, so returns true
        return un.unifies(res, args[1]);
  
    }

private void generateCombination(List states,int j,int N, int K){
	 
	  for(int i = 0; i<N-K+1; i++){
		 // System.out.println("i="+i+"J="+j+"K="+K+"N="+N);
		  combinazioni[j] =  (String)states.get(i);
		 
      if(K!=1){
      	
    	  generateCombination(states.subList(i+1, states.size()),j+1,states.subList(i+1, states.size()).size(),K-1);
       
       }

       else {
    	   if(StateOfWorld.equals("")){
    	   StateOfWorld=StateOfWorld+"["+combinazioni[0];
    	   }
    	   else{
    		   StateOfWorld=StateOfWorld+",["+combinazioni[0];
    	   }
    	   for(int f=1;f<combinazioni.length;f++){
    		   StateOfWorld=StateOfWorld+","+combinazioni[f];
    	   }
    	   StateOfWorld=StateOfWorld+"]";
    	  // System.out.println(StateOfWorld+""+"valK"+K+"Vali"+i+"ValJ"+j);
      	 count++;
      	 
      // }
       }
   }
}
}
 

