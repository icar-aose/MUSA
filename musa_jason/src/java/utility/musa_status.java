package utility;

/**
 * This is an utility static class that contains the current status of MUSA execution. This
 * is used when the system receives a remote request for MUSA current status. 
 * 
 * @author davide
 */
public class musa_status 
{
	private static String musa_status;
	
	public static String get_musa_status()
	{
		switch(musa_status)
		{
		case "call_for_manager":
		case "organizing_solution":
			return "Organizing solution";
		case "ready":
			return "Ready";
		case "running":
			return "Executing solution";
		case "replanning":
			return "Replanning";
		}
		return "";
	}
	
	public static void set_musa_status(String s)
	{
		musa_status = s;
	}
}

