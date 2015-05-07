package cnr.icar.occp.example;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ProvaServlet {
	
	 private static final String PROTOCOL="http";
	//private static final String HOST="194.119.214.121";
	private static final String HOST="localhost";
	 private static final int PORT=8080;
	  
	public static void main(String[] args) throws JSONException {
		 HttpClient httpclient = null;
		 HttpGet httpPost = null;
		 
		  System.out.println("Preparo il metodo GETs");
		  URIBuilder builder = new URIBuilder();//Costruzione endpoint servlet con parametri
		 builder.setScheme(PROTOCOL).setHost(HOST).setPort(PORT).setPath("/HTTPAgent/PickEntity")
		  .setParameter("entryService", "access_to_order");
		
		
//		  
//		  builder.setScheme(PROTOCOL).setHost(HOST).setPort(PORT).setPath("/HTTPAgent/RouteServer")
		    //  .setParameter("entryService", "access_to_order")
//		  .setParameter("user", "199")
//		  .setParameter("agent", "provaAgent")
//		  .setParameter("role", "provaRuolo")
//		  .setParameter("session", "provaSession") 
//		  .setParameter("service","provaService")
//		  .setParameter("idOrdine", "idOrdine")
		      ;
		  try {
		   URI uri = builder.build();
		   httpPost = new HttpGet(uri);
		    
		   System.out.println("Instanzio un http client");
		   httpclient = HttpClients.createDefault();
		 
		   System.out.println("Invoco la servlet: "+httpPost.getURI());
		    
		   HttpResponse response = httpclient.execute(httpPost);
		   
		   HttpEntity entity = response.getEntity();
//		 System.out.println(" CONENT ENTITY"+entity.getContent());
//		 System.out.println("Risposta: "+EntityUtils.toString(entity));
		   //converto la string adella response ricevuta in un file json
		   
		   if (entity != null) {
	           String retSrc = EntityUtils.toString(entity); 
	           // parsing JSON
	           JSONObject result = new JSONObject(retSrc); //Convert String to JSON Object

	           String agent = result.getString("agent"); 
	           String service = result.getString("service"); 
	           String session = result.getString("session"); 
	           JSONObject roleList = result.getJSONObject("role");
	            // JSONObject oj = roleList.getJSONObject(0);
	             String role = roleList.getString("name"); 
//	             
	             System.out.println("agent-->"+agent);
	             System.out.println("service-->"+service);
	             System.out.println("session-->"+session);
	             System.out.println("role-->"+role);
	             
	          URIBuilder builder2 =  new URIBuilder();
			builder2.setScheme(PROTOCOL).setHost(HOST).setPort(PORT).setPath("/HTTPAgent/RouteServer")
	 		    //  .setParameter("entryService", "access_to_order")
	 		  .setParameter("user", "199")
	 		  .setParameter("agent", agent)
	 		  .setParameter("role", role)
	 		  .setParameter("session", session) 
	 		  .setParameter("service",service)
	 		  .setParameter("idOrdine", "idOrdine")
	 		      ;
	          
	          URI uri2 = builder2.build();
			   HttpGet httpPost2 = new HttpGet(uri2);
			    
			   System.out.println("Instanzio un http client");
			   CloseableHttpClient httpclient2 = HttpClients.createDefault();
			 
			  
			System.out.println("Invoco la servlet: "+httpPost2.getURI());
			    
			   HttpResponse response2 = httpclient.execute(httpPost2);
			   
			   HttpEntity entity2 = response2.getEntity();
	             
	        }
	
		   
		  
		   
		  } catch (IOException e) {
		   e.printStackTrace();
		  } catch (URISyntaxException e) {
		   e.printStackTrace();
		  } finally {
			  httpPost.releaseConnection();
		        }
	}

	
	public void callCheckEntry(String serviceName){
		
	}
}
