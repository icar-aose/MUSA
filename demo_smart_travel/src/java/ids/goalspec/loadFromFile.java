// Internal action code for project artifactWithLiteral

package ids.goalspec;

import ids.goalspec.GOALspecLexer;
import ids.goalspec.GOALspecParser;
import ids.goalspec.myVisitor;
import ids.goalspec.model.Specification;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.swing.JFileChooser;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;
import jason.asSyntax.parser.ParseException;

@SuppressWarnings("serial")
public class loadFromFile extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	
    	if (args[0].isString() ) {
    		StringTerm par = (StringTerm) args[0];
    		
            File file = new File( par.getString() );
            FileInputStream fis = null;
            fis = new FileInputStream(file);

            List<String> belief_base = generateBeliefsFromFile( fis ); //par.toString() );
            Iterator<String> it = belief_base.iterator();
    		while (it.hasNext()) {
    			String belief = it.next();
    			//System.out.println("load: "+belief);
    			Literal bel = ASSyntax.parseLiteral(belief);
        		ts.getAg().addBel(bel);
    		}	
              		
    	} else {
    		throw new JasonException("Argument must be a string");
    	}
    	        
        // everything ok, so returns true
        return true;
    }
    
    private File selectFile() {
    	File file = null;
    	JFileChooser fc = new JFileChooser();
        
        int returnVal = fc.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
            file = fc.getSelectedFile();
        }
        return file;
    }
    
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
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return result;
    }

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
}
