/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec;

import ids.goalspec.model.Entity;
import ids.goalspec.model.Specification;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Iterator;
import javax.swing.JFileChooser;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

/**
 *
 * @author Antonio Messina
 */
public class myGOALspec {
    

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        JFileChooser fc = new JFileChooser();
        int returnVal = fc.showOpenDialog(null);
            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = fc.getSelectedFile();
                FileInputStream fis = null;
                fis = new FileInputStream(file);
                
                // create a CharStream that reads from standard input
                ANTLRInputStream input = new ANTLRInputStream(fis);

                // create a lexer that feeds off of input CharStream
                GOALspecLexer lexer = new GOALspecLexer(input);

                // create a buffer of tokens pulled from the lexer
                CommonTokenStream tokens = new CommonTokenStream(lexer);

                // create a parser that feeds off the tokens buffer
                GOALspecParser parser = new GOALspecParser(tokens);
                 
                ParseTree tree = parser.specification();
               
                //ParseTreeWalker walker = new ParseTreeWalker();
                //GOALspecLoader loader = new GOALspecLoader();
                
                //walker.walk(loader, tree);
                
                myVisitor loader = new myVisitor();
                Specification entity = (Specification) loader.visit(tree);
                Iterator it = entity.getBeliefList().iterator();
                while (it.hasNext()) {
                    System.out.println(it.next()+".");
                }
                
                
                
                
                
                //System.out.println(tree.toStringTree(parser)); // print LISP-style tree
 
   }
    }
}
