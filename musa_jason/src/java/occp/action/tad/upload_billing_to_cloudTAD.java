package occp.action.tad;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.IOException;
import java.sql.SQLException;

import musa_dropbox.Dropbox;
import occp.database.CloudServiceTable;
import occp.http.OCCPRequestParser;
import occp.logger.musa_logger;
import workflow_property.MusaProperties;

import com.dropbox.core.DbxEntry;
import com.dropbox.core.DbxException;

/**
 * DEPRECATA
 * 
 * 
 * 
 * @author davide
 *
 */
public class upload_billing_to_cloudTAD extends DefaultInternalAction 
{
	private final String DROPBOX_SERVICE_LABEL 		= "Dropbox";
	private final String GOOGLEDRIVE_SERVICE_LABEL 	= "GoogleDrive";
	
	private final String APP_KEY 		= "oi2elcjbulkxehl";
	private final String APP_SECRET 	= "we3vh8jq5az7vlx";
	CloudServiceTable table;
	
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		
		String cloud_service_name = OCCPRequestParser.getCloudServiceName();
		String access_token = OCCPRequestParser.getUserAccessToken();
		String fname 		= MusaProperties.get_demo_billing_tmp_folder() + "billing.pdf";
		String user_id 		= OCCPRequestParser.getIdUtente();
		
		System.out.println("Uploading to user cloud ID:"+user_id);
		
		if(cloud_service_name.equals(DROPBOX_SERVICE_LABEL))
		{
			return upload_to_dropbox(fname, user_id, access_token);
		}
		else if(cloud_service_name.equals(GOOGLEDRIVE_SERVICE_LABEL))
		{
			//...
		}
	
		return true;
	}

	private boolean upload_to_dropbox(String fname, String user_id, String access_token) throws IOException, DbxException, SQLException 
	{
		Dropbox dp = new Dropbox(APP_KEY, APP_SECRET);
		DbxEntry.File ff	= null;
		
		if(access_token.isEmpty())
		{
			musa_logger.get_instance().info("User "+user_id+" not registered. Authentication required...");
			return false;
		}
		else
		{
			musa_logger.get_instance().info("User "+user_id+" already registered. Authenticating...");
			dp.do_authentication(access_token);
		}
		
		
		musa_logger.get_instance().info("Uploading file "+fname+" to dropbox");
		ff = dp.uploadFile(fname);
		musa_logger.get_instance().info("[upload_billing_to_cloud] Billing uploaded to dropbox cloud storage. Public link: \'"+dp.getSharedLink(ff.path)+"\'");
		
		return true;
	}

}
