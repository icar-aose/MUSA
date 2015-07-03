package occp.action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import musa_gdrive.GoogleDrive;

public class createSpreadsheet  extends DefaultInternalAction 
{
	private final String json_app_secret_key_fname = "/home/davide/client_secrets.json";
	
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
    {
		String spreadsheet_template 	= args[0].toString().replace("\"", "");
		String user_email				= args[1].toString().replace("\"", "");
    	
    	GoogleDrive gd = new GoogleDrive();
		gd.set_data_store_dir(System.getProperty("user.home") + File.separator + ".store/fileUpload");
				
		try 
		{
			gd.set_app_secret_key_json_file(new FileInputStream(json_app_secret_key_fname));
			gd.upload_file(spreadsheet_template, true);
			gd.set_user_as_reader_for_uploaded_file(user_email);
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
        return true;
    }
}
