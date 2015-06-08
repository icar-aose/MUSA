package workflow_property;

public class MusaProperties 
{
	private static String workflow_db_user = "WORKFLOW_DB_USER";
	private static String workflow_db_userpass = "WORKFLOW_DB_USERPASS";
	private static String workflow_db_ip = "WORKFLOW_DB_IP";
	private static String workflow_db_port = "WORKFLOW_DB_PORT";
	private static String workflow_db_name = "WORKFLOW_DB_NAME";
	private static String demo_db_user = "DEMO_DB_USER";
	private static String demo_db_userpass = "DEMO_DB_USERPASS";
	private static String demo_db_ip = "DEMO_DB_IP";
	private static String demo_db_port = "DEMO_DB_PORT";
	private static String demo_db_name = "DEMO_DB_NAME";
	
	
	public static String get_workflow_db_user()
	{
//		System.out.println("-> "+System.getenv(workflow_db_user));
		return System.getenv(workflow_db_user);
	}

	public static String get_workflow_db_userpass()
	{
//		System.out.println("-> "+System.getenv(workflow_db_userpass));
		return System.getenv(workflow_db_userpass);
	}

	public static String get_workflow_db_ip()
	{
		return System.getenv(workflow_db_ip);
	}

	public static String get_workflow_db_port()
	{
		return System.getenv(workflow_db_port);
	}

	public static String get_workflow_db_name()
	{
		return System.getenv(workflow_db_name);
	}

	public static String get_demo_db_user()
	{
		return System.getenv(demo_db_user);
	}

	public static String get_demo_db_userpass()
	{
		return System.getenv(demo_db_userpass);
	}

	public static String get_demo_db_ip()
	{
		return System.getenv(demo_db_ip);
	}

	public static String get_demo_db_port()
	{
		return System.getenv(demo_db_port);
	}

	public static String get_demo_db_name()
	{
		return System.getenv(demo_db_name);
	}




}
