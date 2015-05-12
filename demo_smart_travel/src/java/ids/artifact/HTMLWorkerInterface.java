// CArtAgO artifact code for project adaptive_workflow

package ids.artifact;

import cartago.*;

public class HTMLWorkerInterface extends Artifact {
	private boolean debug = true;
	
	private String route_url = "RouteServer";
	
	void init(String route) {
		route_url = route;
		if (debug) System.out.println("Setup HTML Interface for worker");
	}
	
	@OPERATION
	void generatePageQuoteWork(OpFeedbackParam html,String agent, String user, String role,String project,int doc,String path) {
		String output = "";
		output = output + "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
		output = output + "<HTML>\n";
		
		output = output + "<HEAD>\n";
		output = output + "<TITLE>Quote Edit</TITLE>\n";
		output = output + "</HEAD>\n";
		
		output = output + "<BODY>\n";
		
		output = output + "<p>Attachment for Quote "+doc+"</p>\n";

		output = output + "<form action='"+route_url+"' method='get'>\n";
		
		output = output + "<input type='text' name='attachment'>";
		output = output + "<input type='hidden' name='service' value='"+path+"'>";
		output = output + "<input type='hidden' name='agent' value='"+agent+"'>";
		output = output + "<input type='hidden' name='session' value='"+project+"'>";
		output = output + "<input type='hidden' name='user' value='"+user+"'>";
		output = output + "<input type='hidden' name='role' value='"+role+"'>";
		
		output = output + "<input type='submit' value='Submit'>\n";
		output = output + "</select>\n";
		output = output + "</form>\n";		
		
		output = output + "</BODY>\n";	
		output = output + "</HTML>\n";
		
		html.set(output);
	}

	@OPERATION
	void generatePageQuoteWorkFix(OpFeedbackParam html,String agent, String user, String role,String project,int doc,int attachment,String path) {
		String output = "";
		output = output + "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
		output = output + "<HTML>\n";
		
		output = output + "<HEAD>\n";
		output = output + "<TITLE>Quote Fix</TITLE>\n";
		output = output + "</HEAD>\n";
		
		output = output + "<BODY>\n";
		
		output = output + "<p>Quote "+doc+" is attached to "+attachment+"</p>\n";
		output = output + "<p>Supervisor has discovered problems in Quote "+doc+"</p>\n";

		output = output + "<form action='"+route_url+"' method='get'>\n";
		
		output = output + "<input type='text' name='attachment' value='"+attachment+"'>";
		output = output + "<input type='hidden' name='service' value='"+path+"'>";
		output = output + "<input type='hidden' name='agent' value='"+agent+"'>";
		output = output + "<input type='hidden' name='session' value='"+project+"'>";
		output = output + "<input type='hidden' name='user' value='"+user+"'>";
		output = output + "<input type='hidden' name='role' value='"+role+"'>";
		
		output = output + "<input type='submit' value='Submit'>\n";
		output = output + "</select>\n";
		output = output + "</form>\n";		
		
		output = output + "</BODY>\n";	
		output = output + "</HTML>\n";
		
		html.set(output);
	}

	@OPERATION
	void generatePageWorkNotification(OpFeedbackParam html,String agent, String session,String user, String role) {
		String output = "";
		output = output + "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
		output = output + "<HTML>\n";
		
		output = output + "<HEAD>\n";
		output = output + "<TITLE>Quote Edit - Reply</TITLE>\n";
		output = output + "</HEAD>\n";
		
		output = output + "<BODY>\n";
		
		output = output + "<p>The attachment has been elaborated</p>\n";
		
		String home_page_url="ParticipantServer?user="+user+"&role="+role;
		output = output + "<p>[<a href='"+home_page_url+"'>Back to Home</a>]</p>\n";
		
		output = output + "</BODY>\n";	
		output = output + "</HTML>\n";
		
		html.set(output);
	}


}

