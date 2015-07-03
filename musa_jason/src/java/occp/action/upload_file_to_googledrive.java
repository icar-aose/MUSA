// Internal action code for project musa_jason

package occp.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import musa_gdrive.GoogleDrive;
import jason.asSemantics.*;
import jason.asSyntax.*;

@SuppressWarnings("serial")
public class upload_file_to_googledrive extends DefaultInternalAction 
{
	private final String json_app_secret_key_fname = "/home/davide/client_secrets.json";
	
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
		String fname 		= args[0].toString().replace("\"", "");
		String user_email	= args[1].toString().replace("\"", "");
    	
    	GoogleDrive gd = new GoogleDrive();
		gd.set_data_store_dir(System.getProperty("user.home") + File.separator + ".store/fileUpload");
				
		try 
		{
			gd.set_app_secret_key_json_file(new FileInputStream(json_app_secret_key_fname));
			gd.upload_file(fname, true);
			gd.set_user_as_reader_for_uploaded_file(user_email);
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
        return true;
    }
}
