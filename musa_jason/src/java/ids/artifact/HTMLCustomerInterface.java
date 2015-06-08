// CArtAgO artifact code for project adaptive_workflow

package ids.artifact;

import cartago.*;

public class HTMLCustomerInterface extends Artifact {
	private boolean debug = true;
	
	private String route_url = "RouteServer";
	
	void init(String route) {
		route_url = route;
		if (debug) System.out.println("Setup HTML Interface for customer");
	}
	
	@OPERATION
	void generateQuoteRequest(OpFeedbackParam html,String agent, String session,String user, String role, String path) {
		String output = "";
		output = output + "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
		output = output + "<HTML>\n";
		
		output = output + "<HEAD>\n";
		output = output + "<TITLE>Quote Request</TITLE>\n";
		output = output + "</HEAD>\n";
		
		output = output + "<BODY>\n";
		
		output = output + "<p>Insert Quote Data</p>\n";
		output = output + "<form action='"+route_url+"' method='get'>\n";
		
		output = output + "<input type='text' name='doc'>";

		output = output + "<input type='hidden' name='service' value='"+path+"'>";
		output = output + "<input type='hidden' name='agent' value='"+agent+"'>";
		output = output + "<input type='hidden' name='session' value='"+session+"'>";
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
	void generateQuoteReply(OpFeedbackParam html,String agent, String session,String user, String role) {
		String output = "";
		output = output + "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
		output = output + "<HTML>\n";
		
		output = output + "<HEAD>\n";
		output = output + "<TITLE>Quote Request - Reply</TITLE>\n";
		output = output + "</HEAD>\n";
		
		output = output + "<BODY>\n";
		
		output = output + "<p>We are elaborating the request</p>\n";
		String home_page_url;
		if (user != null && user.length()>0) {
			home_page_url="ParticipantServer?user="+user+"&role="+role;
		} else {
			home_page_url="ParticipantServer?role="+role;
		}
		output = output + "<p>[<a href='"+home_page_url+"'>Back to Home</a>]</p>\n";
		
		output = output + "</BODY>\n";	
		output = output + "</HTML>\n";
		
		html.set(output);
	}

	@OPERATION
	void generatePageCustomerApproval(OpFeedbackParam html,String agent, String user, String role,String project,int doc) {
		String output = "";
		output = output + "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
		output = output + "<HTML>\n";
		
		output = output + "<HEAD>\n";
		output = output + "<TITLE>Quote Approve</TITLE>\n";
		output = output + "</HEAD>\n";
		
		output = output + "<BODY>\n";
		
		output = output + "<p>Take a Decision for Quote "+doc+"</p>\n";
		
		String accept_action = route_url+ "?service=cust_approved&agent="+agent+"&session="+project+"&user="+user+"&role="+role;
		String reject_action = route_url+ "?service=cust_rejected&agent="+agent+"&session="+project+"&user="+user+"&role="+role;
		
		output = output + "<p><a href='"+accept_action+"'>Ok, the document is accepted</a></p>\n";
		output = output + "<p><a href='"+reject_action+"'>No, the document is rejected</a></p>\n";
		
		output = output + "</BODY>\n";	
		output = output + "</HTML>\n";
		
		html.set(output);
	}
}

