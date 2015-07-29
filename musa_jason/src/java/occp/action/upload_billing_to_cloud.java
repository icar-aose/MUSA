package occp.action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import musa_dropbox.Dropbox;
import occp.database.CloudServiceTable;

import occp.model.CloudServiceEntity;
import workflow_property.MusaProperties;

import com.dropbox.core.DbxEntry;
import com.dropbox.core.DbxException;

/**
 * Upload a file (which file name is specified as args[0]) into the google drive cloud storage.
 * 
 * @author davide
 * 
 * Example of usage:
 * 
 * 		occp.action.upload_billing_to_cloud("/tmp/myFile.txt", true);
 * 
 * DA MODIFICARE
 */
public class upload_billing_to_cloud extends DefaultInternalAction 
{
	private final String DROPBOX_SERVICE_LABEL 		= "Dropbox";
	private final String GOOGLEDRIVE_SERVICE_LABEL 	= "GoogleDrive";
	
	private final String APP_KEY 		= "oi2elcjbulkxehl";
	private final String APP_SECRET 	= "we3vh8jq5az7vlx";
	CloudServiceTable table;
	
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		String ip_address 	= MusaProperties.getDemo_db_ip();
		String port 		= MusaProperties.getWorkflow_db_port();
		String database 	= MusaProperties.getDemo_db_name();
		String user 		= MusaProperties.getDemo_db_user();
		String password 	= MusaProperties.getDemo_db_userpass();
		
		String fname 				= args[0].toString().replace("\"", "");
		String user_id 				= args[2].toString().replace("\"", "");
		
		System.out.println("Uploading to user cloud ID:"+user_id);
		
		table = new CloudServiceTable(ip_address,port,database,user,password);
		List<CloudServiceEntity> user_clouds = table.getUserCloudServices(Integer.parseInt(user_id));
		
		if(user_clouds.isEmpty())
			return true;
		
		for (CloudServiceEntity cloud : user_clouds )
		{
			String service_type = cloud.get_tipoServizio();
			String access_token = cloud.get_accessToken();
			
			if(service_type.equals(DROPBOX_SERVICE_LABEL))
			{
				return upload_to_dropbox(fname, user_id, access_token);
			}
			else if(service_type.equals(GOOGLEDRIVE_SERVICE_LABEL))
			{
				
			}

		}
		
		return false;
	}

	private boolean upload_to_dropbox(String fname, String user_id, String access_token) throws IOException, DbxException, SQLException 
	{
		Dropbox dp = new Dropbox(APP_KEY, APP_SECRET);
		DbxEntry.File ff	= null;
		
		if(access_token.isEmpty())		return false;
		else							dp.do_authentication(access_token);
		
		ff = dp.uploadFile(fname);
		
		return true;
	}

}
