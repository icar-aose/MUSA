package occp.model;

import java.util.HashMap;

public class occp_capability_status
{	
	public static HashMap<String,String> capability_status = new HashMap<>();

	public static HashMap<String, String> getCapability_status() {
		return capability_status;
	}

	public static String getCapabilityTaskID(String cap_name)
	{
		switch (cap_name) 
		{
			case "receive_order":				return "0";
			case "place_order":					return "1";//inserimentto ordine
			case "set_user_data":				return "2";//inserimento dati utente
			case "check_order_feasibility":		return "3";//preparazione consegna
			case "complete_transaction":		return "4";
			case "deliver_billing":				return "5";//emissione fattura
			case "notify_gdrive_upload":		return "6";//(NON È SUL BPMN adesso..) notifica emissione su gdrive
			case "upload_to_google_drive":		return "7";//upload fattura
			case "upload_billing_to_dropbox":	return "8";//upload fattura
			case "fulfill_order":				return "9";//evasione ordine
			case "notifica_calendario":			return "10";
			case "notify_order_unfeasibility":	return "11";//notifica utente
			case "delete_order":				return "12";//sospensione
			default:							return "-1";
		}
	}
 
}
