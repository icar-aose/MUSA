// Internal action code for project musa_jason

package action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Term;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;

import workflow_property.WorkflowProperties;

/**
 * @author Patrizia Ribino
 */
public class loadGoalBase extends DefaultInternalAction 
{
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
		ArrayList<String> goalList = new ArrayList<String>();
		
		// execute the internal action
		ts.getAg().getLogger().info("executing internal action 'action.loadGoalBase'");
		    
		String path = args[0].toString();
		System.out.print("Percorso" + path);
		    
		goalList		= read(path.substring(1,path.length()-1));
		ListTerm res	= new ListTermImpl();
		
		for(int i=0;i<goalList.size();i++)
			res.add(ASSyntax.parseTerm(goalList.get(i)));
		
		// everything ok, so returns true
		return un.unifies(res, args[1]);
	}
    
    public ArrayList<String> read(String path) throws IOException
    {
    	ArrayList<String> List=new ArrayList<String>();
    	FileReader f;
    	BufferedReader b;
    	String s;
    	
    	
    	if (System.getProperty("java.class.path").contains("org.eclipse.equinox.launcher"))
//    	System.out.println("---->Environment: "+WorkflowProperties.getExecutionEnvironment());
//    	if(WorkflowProperties.getExecutionEnvironment().equals("run"))
		{
    		f = new FileReader(path);
        	b = new BufferedReader(f);
        	
        	while( (s = b.readLine()) != null )
        	{
        		if(s.length()!=0)
        			List.add(s.substring(0,s.length()-1));	
        	}
        	
        	b.close();
    		return List;
		}
    	else
    	{
    		URL url = ClassLoader.getSystemResource(path);
    		InputStream is = url.openStream();
        	b = new BufferedReader(new InputStreamReader(is));

        	while( (s = b.readLine()) != null )
        	{
        		if(s.length()!=0)
        			List.add(s.substring(0,s.length()-1));	
        	}
        	b.close();
    		return List;
    	}
    	
    	/*
    	URL url = ClassLoader.getSystemResource(path);
		InputStream is = url.openStream();
    	b = new BufferedReader(new InputStreamReader(is));

    	while( (s = b.readLine()) != null )
    	{
    		if(s.length()!=0)
    			List.add(s.substring(0,s.length()-1));	
    	}
    	b.close();
		return List;
    	
    	/*
    	f = new FileReader(path);
    	b = new BufferedReader(f);
    	
    	while( (s = b.readLine()) != null )
    	{
    		if(s.length()!=0)
    			List.add(s.substring(0,s.length()-1));	
    	}
    	
    	b.close();
    			
		return List;*/
    }

}
