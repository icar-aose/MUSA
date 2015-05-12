// CArtAgO artifact code for project adaptive_workflow

package ids.artifact;

import cartago.*;

public class HTMLSupervisorInterface extends Artifact {
	private boolean debug = true;
	
	private String route_url = "RouteServer";
	
	void init(String route) {
		route_url = route;
		if (debug) System.out.println("Setup HTML Interface for worker");
	}
	
	@OPERATION
	void generatePageQuoteSupervisor(OpFeedbackParam html,String agent, String user, String role,String project,int doc,String acceptpath,String rejectpath,String revisepath) {
		String output = "";
		output = output + "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
		output = output + "<HTML>\n";
		
		output = output + "<HEAD>\n";
		output = output + "<TITLE>Quote Edit</TITLE>\n";
		output = output + "</HEAD>\n";
		
		output = output + "<BODY>\n";
		
		output = output + "<p>Take a Decision for Quote "+doc+"</p>\n";
		
		String accept_action = route_url+ "?service="+acceptpath+"&agent="+agent+"&session="+project+"&user="+user+"&role="+role;
		String reject_action = route_url+ "?service="+rejectpath+"&agent="+agent+"&session="+project+"&user="+user+"&role="+role;
		String torevise_action = route_url+ "?service="+revisepath+"&agent="+agent+"&session="+project+"&user="+user+"&role="+role;
		
		output = output + "<p><a href='"+accept_action+"'>Ok, the document is accepted</a></p>\n";
		output = output + "<p><a href='"+torevise_action+"'>Ok, but the document must be revised</a></p>\n";
		output = output + "<p><a href='"+reject_action+"'>No, the document is rejected</a></p>\n";
		
		output = output + "</BODY>\n";	
		output = output + "</HTML>\n";
		
		html.set(output);
	}

	@OPERATION
	void generatePageSuperviseNotification(OpFeedbackParam html,String agent, String session,String user, String role) {
		String output = "";
		output = output + "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
		output = output + "<HTML>\n";
		
		output = output + "<HEAD>\n";
		output = output + "<TITLE>Quote Edit - Reply</TITLE>\n";
		output = output + "</HEAD>\n";
		
		output = output + "<BODY>\n";
		
		output = output + "<p>The decision has been sent</p>\n";
		
		String home_page_url="ParticipantServer?user="+user+"&role="+role;
		output = output + "<p>[<a href='"+home_page_url+"'>Back to Home</a>]</p>\n";
		
		output = output + "</BODY>\n";	
		output = output + "</HTML>\n";
		
		html.set(output);
	}

}

