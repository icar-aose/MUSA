package musa.artifact;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;

import cartago.*;

public class HTTP extends Artifact {
	private boolean debug = false;
	
	private String baseurl;
	
	void init(String url) {
		baseurl = url;
		if (debug) System.out.println("Setup HTTP Artifact with baseurl "+url);
	}
		
	@OPERATION
	void useGET(String path,String params,OpFeedbackParam<String> response) {
		String url_to_reload = baseurl+path;
		if (params.length()>0) {			
			url_to_reload = url_to_reload+"?"+params;
		}

		String result=get(url_to_reload);
		
		if (debug) System.out.println(result);
		response.set(result);
	}
	
	@OPERATION
	void registerRoute(String route,String agentname, OpFeedbackParam<String> response) {
		String path="";
		String params="action=register&service="+route+"&agent="+agentname;
		useGET(path,params,response);
	}

	@OPERATION
	void registerEntryPoint(String service,String agentname,String label, String role, String session) {
		
		if (!checkEntryPoint( service, agentname, role, session)) 
		{
			HashMap<String, String> param_map = new HashMap<String, String>();
			param_map.put("action", "register_entrypoint");
			param_map.put("service", service);
			param_map.put("agent", agentname);
			param_map.put("label", label);
			param_map.put("role", role);
			param_map.put("session", session);
			get(baseurl+composeParams(param_map));
		}
	}
	
	@OPERATION
	void unregisterEntryPoint(String service,String agentname,String role, String session) {
		
		if (checkEntryPoint( service, agentname, role, session)) 
		{
			HashMap<String, String> param_map = new HashMap<String, String>();
			param_map.put("action", "register_entrypoint");
			param_map.put("service", service);
			param_map.put("agent", agentname);
			param_map.put("role", role);
			param_map.put("session", session);
			
			get(baseurl+composeParams(param_map));
		}
	}

	private boolean checkEntryPoint(String service,String agentname, String role, String session) 
	{
		
		HashMap<String, String> param_map = new HashMap<String, String>();
		param_map.put("action", "check_entrypoint");
		param_map.put("service", service);
		param_map.put("agent", agentname);
		param_map.put("role", role);
		param_map.put("session", session);
			
		String result = get(baseurl+composeParams(param_map));
		
		if (result.equals("null")) {
			return false;
		}
		return true;
	}

	@OPERATION
	void registerJob(String service,String agentname,String label, String user, String role, String project) {
		//System.out.println("request for register a job");
		//if (!checkJob( service, agentname, user, role, project)) {
			System.out.println("registering a job");
			HashMap<String, String> param_map = new HashMap<String, String>();
			
			param_map.put("action", "register_job");
			param_map.put("service", service);
			param_map.put("agent", agentname);
			param_map.put("label", label);
			param_map.put("user", user);
			param_map.put("role", role);
			param_map.put("project", project);
			
			String request= baseurl+composeParams(param_map);
			//System.out.println("HTTP: "+request);
			String reply = get(request);
			if (reply.equals("error")) {
				failed("register job failed","register_job_failed","web-service-not-reached");
			}
		//}
	}
	
	@OPERATION
	void unregisterJob(String service,String agentname, String user, String role, String project) {
		
		if (checkJob( service, agentname, user, role, project)) {
			HashMap<String, String> param_map = new HashMap<String, String>();
			param_map.put("action", "unregister_job");
			param_map.put("service", service);
			param_map.put("agent", agentname);
			param_map.put("user", user);
			param_map.put("role", role);
			param_map.put("project", project);
			
			get(baseurl+composeParams(param_map));
		}
	}

	private boolean checkJob(String service,String agentname, String user, String role, String project) {
		
		HashMap<String, String> param_map = new HashMap<String, String>();
		param_map.put("action", "check_job");
		param_map.put("service", service);
		param_map.put("agent", agentname);
		param_map.put("user", user);
		param_map.put("role", role);
		param_map.put("project", project);
			
		String result = get(baseurl+composeParams(param_map));
		if (result.equals("null")) {
			return false;
		}
		return true;
	}

	private String composeParams(HashMap param_map) {
		String params = "";
		String encoded_value;
		boolean first = true;
		
		Iterator<String> it = param_map.keySet().iterator();
		while (it.hasNext()) {
			String key = it.next();
			String value = (String) param_map.get(key);
			if (first) {
				params += "?";
				first = false;
			} else {
				params += "&";
			}
			try {
				encoded_value = URLEncoder.encode(value, "ISO-8859-1");
			} catch (UnsupportedEncodingException e) {
				encoded_value="";
			}
			params += key + "=" + encoded_value;
		}
		
		return params;
	}

	private String get(String url_string) 
	{
		String result = "error";
		try 
		{
			URL url = new URL(url_string);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			if (debug) System.out.println("connected to "+url);
			conn.setRequestMethod("GET");
			
			BufferedReader br 	= new BufferedReader(new InputStreamReader(conn.getInputStream()));
			StringBuilder sb 	= new StringBuilder();
			
			String read = br.readLine();
			while(read != null) 
			{
			    sb.append(read);
			    read =br.readLine();
			}
			result = sb.toString();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return result;
	}


}

