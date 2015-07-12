package workflow_property;

public class MusaProperties 
{
//	private static String workflow_db_user = "WORKFLOW_DB_USER";
//	private static String workflow_db_userpass = "WORKFLOW_DB_USERPASS";
//	private static String workflow_db_ip = "WORKFLOW_DB_IP";
//	private static String workflow_db_port = "WORKFLOW_DB_PORT";
//	private static String workflow_db_name = "WORKFLOW_DB_NAME";
	
	private static String workflow_db_user 		= "occp_root";
	private static String workflow_db_userpass 	= "occp_root_password_2014";
	private static String workflow_db_ip 		= "194.119.214.121";
	private static String workflow_db_port 		= "3306";
	private static String workflow_db_name 		= "musa_workflow";
	
	private static String demo_db_user = "DEMO_DB_USER";
	private static String demo_db_userpass = "DEMO_DB_USERPASS";
	private static String demo_db_ip = "DEMO_DB_IP";
	private static String demo_db_port = "DEMO_DB_PORT";
	private static String demo_db_name = "DEMO_DB_NAME";
	
	private static String demo_billing_tmp_folder = "DEMO_BILLING_TMP_FOLDER";
	

	public static String get_demo_billing_tmp_folder() 
	{
		String tmp_folder = System.getenv(demo_billing_tmp_folder);
		
		if( !tmp_folder.endsWith("/") )
			tmp_folder = tmp_folder.concat("/");
		
		return tmp_folder;
	}


	public static String getWorkflow_db_user() {
		return MusaProperties.workflow_db_user;
	}
	public static void setWorkflow_db_user(String workflow_db_user) {
		MusaProperties.workflow_db_user = workflow_db_user;
	}
	
	
	public static String getWorkflow_db_ip() {
		return MusaProperties.workflow_db_ip;
		//return System.getenv(workflow_db_ip);
	}
	public static void setWorkflow_db_ip(String workflow_db_ip) {
		MusaProperties.workflow_db_ip = workflow_db_ip;
	}


	public static String getWorkflow_db_port() {
		return MusaProperties.workflow_db_port;
	}
	public static void setWorkflow_db_port(String workflow_db_port) {
		MusaProperties.workflow_db_port = workflow_db_port;
	}


	public static String getWorkflow_db_name() {
		return MusaProperties.workflow_db_name;
	}
	public static void setWorkflow_db_name(String workflow_db_name) {
		MusaProperties.workflow_db_name = workflow_db_name;
	}


	public static String getWorkflow_db_userpass() {
		return MusaProperties.workflow_db_userpass;
	}
	public static void setWorkflow_db_userpass(String workflow_db_userpass) {
		MusaProperties.workflow_db_userpass = workflow_db_userpass;
	}

	//########################################

	public static String getDemo_db_user() {
		return demo_db_user;
	}


	public static void setDemo_db_user(String demo_db_user) {
		MusaProperties.demo_db_user = demo_db_user;
	}


	public static String getDemo_db_userpass() {
		return demo_db_userpass;
	}


	public static void setDemo_db_userpass(String demo_db_userpass) {
		MusaProperties.demo_db_userpass = demo_db_userpass;
	}


	public static String getDemo_db_ip() {
		return demo_db_ip;
	}


	public static void setDemo_db_ip(String demo_db_ip) {
		MusaProperties.demo_db_ip = demo_db_ip;
	}


	public static String getDemo_db_port() {
		return demo_db_port;
	}


	public static void setDemo_db_port(String demo_db_port) {
		MusaProperties.demo_db_port = demo_db_port;
	}


	public static String getDemo_db_name() {
		return demo_db_name;
	}


	public static void setDemo_db_name(String demo_db_name) {
		MusaProperties.demo_db_name = demo_db_name;
	}

	

}
