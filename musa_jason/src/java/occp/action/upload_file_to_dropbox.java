// Internal action code for project musa_jason

package occp.action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.IOException;
import java.sql.SQLException;

import musa_dropbox.Dropbox;

import com.dropbox.core.DbxException;

@SuppressWarnings("serial")
public class upload_file_to_dropbox extends DefaultInternalAction 
{
	//MUSA related app key for dropbox
	private final String APP_KEY 		= "oi2elcjbulkxehl";
	private final String APP_SECRET 	= "we3vh8jq5az7vlx";
	
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
    	String fname 		= args[0].toString().replace("\"", "");
		String access_token = args[1].toString().replace("\"", "");
		
		upload_to_dropbox(fname, access_token);
		
        return true;
    }
    
    private boolean upload_to_dropbox(String fname, String access_token) throws IOException, DbxException, SQLException 
	{
		Dropbox dp 			= new Dropbox(APP_KEY, APP_SECRET);
		
		//If access token is not supplied, show a web page where the user have to authenticate.
		if(access_token.isEmpty())		{return false;}
		else							{dp.do_authentication(access_token);}
		
		return dp.uploadFile(fname) == null;
	}
}
