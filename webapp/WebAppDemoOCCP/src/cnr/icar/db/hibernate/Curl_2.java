package cnr.icar.db.hibernate;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

public class Curl_2 
{
	public  static String getJsonFromUrl(String codeInput) throws Exception 
	{
		final HttpClient client = new DefaultHttpClient();

		final String code 			= codeInput;
		final String client_id 		= "bpg9o57qlu9w0j0";
		final String client_secret = "gbejdmg316i4j8l";
		final String grant_type 	= "authorization_code";
	//	final String redirect_uri 	= "http://localhost:8080/LoginStruts2/utente.jsp";
		final String redirect_uri 	= "http://194.119.214.121:8080/LoginStruts2/utente.jsp";
		HttpPost post = new HttpPost("https://api.dropbox.com/1/oauth2/token");
		
		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
		nameValuePairs.add(new BasicNameValuePair("code",code));
		nameValuePairs.add(new BasicNameValuePair("grant_type",grant_type));
		nameValuePairs.add(new BasicNameValuePair("client_id",client_id));
		nameValuePairs.add(new BasicNameValuePair("client_secret",client_secret));
		nameValuePairs.add(new BasicNameValuePair("redirect_uri",redirect_uri));
		
		post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
		
		HttpResponse response = client.execute(post);
		
		BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

		String line = "";
		 StringBuilder sb = new StringBuilder();
		while ((line = rd.readLine()) != null) 
		{
			System.out.println(line);
			 sb.append(line);
			if (line.startsWith("Auth=")) 
			{
				String key = line.substring(5);
			  
				System.out.println("Key--->"+key);	          
			}
		}
	String output=sb.toString();
	System.out.println("output..->"+output);
	    return output;
    }
	
	 private static String readAll(BufferedReader rd) throws IOException {
		    StringBuilder sb = new StringBuilder();
		    String cp;
		    while ((cp = rd.readLine()) != null) {
		    	System.out.println("cp__>"+cp);
		      sb.append(cp);
		    }
		    return sb.toString();
		  }
}
