package occp.http;

import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

public class OCCPRequestParser 
{
	private static HashMap<String,String> param_table = new HashMap<String,String>();
	private static JSONArray product_message	= null;
	private static JSONObject json_message 		= null;
	private static String user 		= "";
	private static String role 		= "";
	private static String session	= "";
	private static String service	= "";
	private static String agent		= "";
	
	public static void parseRequestMessage(JSONObject message)
	{
		json_message = message;
		
		agent 	= json_message.getString("agent");
		service = json_message.getString("service");
		session = json_message.getString("session");
		user 	= json_message.getString("username");
		role 	= json_message.getString("userrole");		
		if (json_message.has("params")) 
		{
			JSONObject params = json_message.getJSONObject("params");
			parse_params(params);
		}		
	}
	
	/**
	 * Parse the params 
	 * @param json_message
	 */
	private static void parse_params(JSONObject json_message)
	{
		if (json_message.has("orderData")) 
			parse_order_data(new JSONObject(json_message.getString("orderData")));
		
		if (json_message.has("userData")) 
			parse_user_data(new JSONObject(json_message.getString("userData")));
		
		if (json_message.has("user_message"))
			param_table.put("user_message", json_message.getString("user_message"));
	}
	
	
	/**
	 * Parse the order data field into the given json message
	 * 
	 * @param json_message
	 */
	private static void parse_order_data(JSONObject json_message)
	{
		if (json_message.has("id_ordine")) param_table.put("id_ordine", json_message.getString("id_ordine"));
		if (json_message.has("prodotti"))
		{
			set_product_message(json_message.getJSONArray("prodotti"));
		}
		if (json_message.has("totale")) 				param_table.put("totale", json_message.getString("totale"));
		if (json_message.has("valuta")) 				param_table.put("valuta", json_message.getString("valuta"));
		if (json_message.has("totale_iva")) 			param_table.put("totale_iva", json_message.getString("totale_iva"));
		if (json_message.has("data_creazione_ordine")) 	param_table.put("data_creazione_ordine", json_message.getString("data_creazione_ordine"));
		if (json_message.has("modalita_pagamento")) 	param_table.put("modalita_pagamento", json_message.getString("modalita_pagamento"));
		if (json_message.has("note")) 					param_table.put("note", json_message.getString("note"));
		if (json_message.has("stato")) 					param_table.put("stato", json_message.getString("stato"));
		
		if (json_message.has("id_utente") && !param_table.containsKey("id_utente"))
			param_table.put("id_utente", json_message.getString("id_utente"));
	}
	
	/**
	 * Parse the user data field into the given json message
	 * @param json_message
	 */
	private static void parse_user_data(JSONObject json_message)
	{	
		if (json_message.has("id_utente") && !param_table.containsKey("id_utente"))
			param_table.put("id_utente", json_message.getString("id_utente"));

		if (json_message.has("nome")) 						param_table.put("nome", json_message.getString("nome"));
		if (json_message.has("cognome")) 					param_table.put("cognome", json_message.getString("cognome"));
		if (json_message.has("mail")) 						param_table.put("mail", json_message.getString("mail"));
		if (json_message.has("ragione_sociale")) 			param_table.put("ragione_sociale", json_message.getString("ragione_sociale"));
		if (json_message.has("telefono")) 					param_table.put("telefono", json_message.getString("telefono"));
		if (json_message.has("partita_iva")) 				param_table.put("partita_iva", json_message.getString("partita_iva"));
		if (json_message.has("indirizzo")) 					param_table.put("indirizzo", json_message.getString("indirizzo"));
		if (json_message.has("indirizzo_spedizione")) 		param_table.put("indirizzo_spedizione", json_message.getString("indirizzo_spedizione"));
		
		if (json_message.has("cloudeServiceName")) 		param_table.put("cloudeServiceName", json_message.getString("cloudeServiceName"));
		if (json_message.has("accesstoken")) 				param_table.put("accesstoken", json_message.getString("accesstoken"));
	}

	
	public static JSONArray get_product_message() 
	{
		return product_message;
	}

	/**
	 * Return the JSON array containing the details on all the products in this order request.
	 * @return
	 */
	public static JSONArray getProductMessage() 
	{
		return product_message;
	}
	
	public static void set_product_message(JSONArray product_message) 
	{
		OCCPRequestParser.product_message = product_message;
	}
	
	public static String getUserMessage()
	{
		return param_table.get("user_message");
	}
	
	public static String getIdOrdine()
	{
		return param_table.get("id_ordine");
	}

	public static String getTotale()
	{
		return param_table.get("totale");
	}

	public static String getValuta()
	{
		return param_table.get("valuta");
	}

	public static String getTotaleIva()
	{
		return param_table.get("totale_iva");
	}

	public static String getDataCreazioneOrdine()
	{
		return param_table.get("data_creazione_ordine");
	}

	public static String getModalitaPagamento()
	{
		return param_table.get("modalita_pagamento");
	}

	public static String getNote()
	{
		return param_table.get("note");
	}

	public static String getStato()
	{
		return param_table.get("stato");
	}

	public static String getIdUtente()
	{
		return param_table.get("id_utente");
	}

	public static String getNome()
	{
		return param_table.get("nome");
	}

	public static String getCognome()
	{
		return param_table.get("cognome");
	}

	public static String getMail()
	{
		return param_table.get("mail");
	}

	public static String getRagioneSociale()
	{
		return param_table.get("ragione_sociale");
	}

	public static String getTelefono()
	{
		return param_table.get("telefono");
	}

	public static String getPartitaIva()
	{
		return param_table.get("partitaIVA");
	}

	public static String getIndirizzo()
	{
		return param_table.get("indirizzo");
	}
	
	public static String getUserAccessToken()
	{
		return param_table.get("accesstoken");
	}
	
	public static String getCloudServiceName()
	{
		return param_table.get("cloudeServiceName");
	}

	public static String getIndirizzoSpedizione()
	{
		return param_table.get("indirizzo_spedizione");
	}
	
	public static String getDropboxAccessToken()
	{
		return param_table.get("accesstoken");
	}

	public static String getUser() {
		return user;
	}

	public static String getRole() {
		return role;
	}

	public static String getSession() {
		return session;
	}

	public static String getService() {
		return service;
	}

	public static String getAgent() {
		return agent;
	}

}
