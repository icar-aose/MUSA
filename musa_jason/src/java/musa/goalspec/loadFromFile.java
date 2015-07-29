// Internal action code for project artifactWithLiteral

package musa.goalspec;

import musa.goalspec.model.Specification;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.InvalidPathException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.swing.JFileChooser;

import musa.goalspec.GOALspecLexer;
import musa.goalspec.GOALspecParser;
import musa.goalspec.myVisitor;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;
import jason.asSyntax.parser.ParseException;

@SuppressWarnings("serial")
public class loadFromFile extends DefaultInternalAction 
{

//	public static void main(String [ ] args) {
//		
//        loadFromFile loader = new loadFromFile();
//        
//        File file = loader.selectFile();
//        FileInputStream fis = null;
//        try {
//			fis = new FileInputStream(file);
//	        List<String> belief_base = loader.generateGoalBeliefsFromFile( fis ); //par.toString() );
//	        Iterator<String> it = belief_base.iterator();
//			while (it.hasNext()) {
//				String belief = it.next();
//				System.out.println("loaded: "+belief);
//			}	
//		} catch (FileNotFoundException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();	
//		}
//	}

	 /**
     * Execute this internal action.
     * 
     * @param args[0] contains the goal description.
     * @param un
     * @param ts
     */
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {	
    	String goalPack= ((StringTerm) args[0]).getString();
    	String goalName= ((StringTerm) args[1]).getString();
    	String goalDescriptionOrPathToGoalBase 	= ((StringTerm) args[2]).getString();
    	String goalParams 						= ((StringTerm) args[3]).getString();
    	
    	System.out.println("PARAM LIST: "+goalParams);
    	try
    	{
    		FileSystems.getDefault().getPath(goalDescriptionOrPathToGoalBase, "");
    		
    		//args[0] is a valid file path, so proceed parsing its content.
    		executeForFile( ts, goalName, goalPack, goalDescriptionOrPathToGoalBase, goalParams );
    	}
    	catch (FileNotFoundException e) 
    	{
    		//The specified string is not a valid path. Maybe it's a description of a goal that has been added by user
    		executeForString( ts, goalName, goalPack, goalDescriptionOrPathToGoalBase, goalParams );
		}
    	catch(InvalidPathException e)
    	{
    		//The specified string is not a valid path. Maybe it's a description of a goal that has been added by user
    		executeForString( ts, goalName, goalPack, goalDescriptionOrPathToGoalBase, goalParams );
    	}
    	
    	return true;
    }
    
    /**
     * Generate the goal beliefs from a file.
     * 
     * @param ts
     * @param filePath
     * @throws FileNotFoundException 
     * @throws ParseException 
     * @throws RevisionFailedException 
     * @throws Exception
     */
    private void executeForFile(TransitionSystem ts, String goalPack, String goalName, String filePath, String Params) throws FileNotFoundException, ParseException, RevisionFailedException
    {
    	File file = new File( filePath );
        FileInputStream fis = null;
        fis = new FileInputStream(file);

        List<String> belief_base = generateGoalBeliefsFromFile( fis );
        
        Iterator<String> it = belief_base.iterator();
		while (it.hasNext()) 
		{
			//goal(process0),pack(p4)
			
			String belief = it.next();
			//System.out.println("load: "+belief);
			Literal bel = ASSyntax.parseLiteral(belief);
			
			String name = String.format("goal(%s)", goalName);
			String pack = String.format("pack(%s)", goalPack);
			bel.addAnnot(ASSyntax.parseLiteral(name));
			bel.addAnnot(ASSyntax.parseLiteral(pack));
			bel.addAnnot(ASSyntax.parseLiteral(Params));
    		ts.getAg().addBel(bel);
		}	
    }
    
    /**
     * Generate the goal beliefs from a a string.
     * 
     * @param ts
     * @param belief
     * @throws ParseException
     * @throws RevisionFailedException
     */
    private void executeForString(TransitionSystem ts, String goalPack, String goalName, String belief, String Params) throws ParseException, RevisionFailedException
    {
    	List<String> belief_base = generateGoalBeliefsFromString( belief );
        
        Iterator<String> it = belief_base.iterator();
		while ( it.hasNext() ) 
		{
			String b = it.next();
			System.out.println("load: "+b);
			Literal bel = ASSyntax.parseLiteral(b);
			
			String name = String.format("goal(%s)", goalName);
			String pack = String.format("pack(%s)", goalPack);
			bel.addAnnot(ASSyntax.parseLiteral(name));
			bel.addAnnot(ASSyntax.parseLiteral(pack));
			bel.addAnnot(ASSyntax.parseLiteral(Params));			
    		ts.getAg().addBel(bel);
		}		
    }
    
    //---
    
    
    private File selectFile() {
    	File file = null;
    	JFileChooser fc = new JFileChooser();
        
        int returnVal = fc.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
            file = fc.getSelectedFile();
        }
        return file;
    }
    
  //TODO deprecata da eliminare
    private List<String> generateBeliefs(String specification) {
    	List<String> result = new LinkedList<String>();
		InputStream is;
		
		ANTLRInputStream input;
		try {
			is = new ByteArrayInputStream(specification.getBytes("UTF-8"));
			input = new ANTLRInputStream(is);
			
			// create a lexer that feeds off of input CharStream
			GOALspecLexer lexer = new GOALspecLexer(input);
	
			// create a buffer of tokens pulled from the lexer
			CommonTokenStream tokens = new CommonTokenStream(lexer);
	
			// create a parser that feeds off the tokens buffer
			GOALspecParser parser = new GOALspecParser(tokens);
			 
			ParseTree tree = parser.specification();
	
			myVisitor loader = new myVisitor();
			Specification entity = (Specification) loader.visit(tree);
			result = entity.getBeliefList();
			
		} 
		catch (UnsupportedEncodingException e) 	{e.printStackTrace();} 
		catch (IOException e) 					{e.printStackTrace();}
		
    	return result;
    }

  //TODO deprecata da eliminare
    private List<String> generateBeliefsFromFile(FileInputStream fis) {
    	List<String> result = new LinkedList<String>();
		
		ANTLRInputStream input;
		try {
			input = new ANTLRInputStream(fis);
			
			// create a lexer that feeds off of input CharStream
			GOALspecLexer lexer = new GOALspecLexer(input);
	
			// create a buffer of tokens pulled from the lexer
			CommonTokenStream tokens = new CommonTokenStream(lexer);
	
			// create a parser that feeds off the tokens buffer
			GOALspecParser parser = new GOALspecParser(tokens);
			 
			ParseTree tree = parser.specification();
	
			myVisitor loader = new myVisitor();
			Specification entity = (Specification) loader.visit(tree);
			result = entity.getBeliefList();
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
    	return result;
    }
    
    //TODO copiarlo e fare la stessa cosa non per i stream ma per le stringhe. Gli devo passare solo la descrizione. Questa genera 
    //automaticamente la BB e restituisce una lista di
    //stringhe
    private List<String> generateGoalBeliefsFromFile(FileInputStream fis) 
    {
    	List<String> result = new LinkedList<String>();
		
		ANTLRInputStream input;
		try 
		{
			input = new ANTLRInputStream(fis);
			
			// create a lexer that feeds off of input CharStream
			GOALspecLexer lexer = new GOALspecLexer(input);
	
			// create a buffer of tokens pulled from the lexer
			CommonTokenStream tokens = new CommonTokenStream(lexer);
	
			// create a parser that feeds off the tokens buffer
			GOALspecParser parser = new GOALspecParser(tokens);
			 
			ParseTree tree = parser.specification();
	
			myVisitor loader = new myVisitor();
			Specification entity = (Specification) loader.visit(tree);
			result = entity.getGoalBeliefList();
		} 
		catch (UnsupportedEncodingException e) 
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return result;
    }

    /**
     * Generate a new goal belief from a string.
     * 
     * @param belief
     * @return
     */
    private List<String> generateGoalBeliefsFromString(String belief) 
    {
    	List<String> result = new LinkedList<String>();
		
		ANTLRInputStream input = new ANTLRInputStream(belief);
		
		// create a lexer that feeds off of input CharStream
		GOALspecLexer lexer = new GOALspecLexer(input);

		// create a buffer of tokens pulled from the lexer
		CommonTokenStream tokens = new CommonTokenStream(lexer);

		// create a parser that feeds off the tokens buffer
		GOALspecParser parser = new GOALspecParser(tokens);
		 
		ParseTree tree = parser.specification();

		myVisitor loader = new myVisitor();
		Specification entity = (Specification) loader.visit(tree);
		result = entity.getGoalBeliefList();
		
    	return result;
    }
    
}
