package cnr.icar.db.hibernate;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.Proxy;
import java.net.InetSocketAddress;
import java.nio.charset.Charset;
import java.io.OutputStreamWriter;

public class Curl {

  public static void main(String[] args) {

    try {

 //   String url = "http://127.0.0.1:15672/api/traces/%2f/trololo";
    String code="F2fzt-qsjCIAAAAAAAAAVyKpzlCXAw6gYhD_hcXAHK8";
    String url="https://api.dropbox.com/1/oauth2/token";
    URL obj = new URL(url);
   // HttpURLConnection conn = (HttpURLConnection) (obj.openConnection()).getInputStream(), Charset.forName("UTF-8"));
   HttpURLConnection conn = (HttpURLConnection) obj.openConnection();

  //conn.setRequestProperty("Content-Type", "application/json");
   conn.setRequestProperty("code",code);
   conn.setRequestProperty("grant_type","authorization_code");
 //  conn.setRequestProperty("redirect_uri","http://localhost:8080/LoginStruts2/utente.jsp");
   conn.setRequestProperty("redirect_uri","http://194.119.214.121/:8080/LoginStruts2/utente.jsp");
   conn.setRequestProperty("client_id","bpg9o57qlu9w0j0x");
   conn.setRequestProperty("client_secret","gbejdmg316i4j8l");
   conn.setDoOutput(true);

    conn.setRequestMethod("POST");

//    String userpass = "bpg9o57qlu9w0j0x" + ":" + "gbejdmg316i4j8l";
//    String basicAuth = "Basic " + javax.xml.bind.DatatypeConverter.printBase64Binary(userpass.getBytes("UTF-8"));
//    System.out.println("basicAuth: "+  basicAuth);
//    conn.setRequestProperty("Authorization", basicAuth);
  
    System.out.println("conn.getRequestProperty()--_>"+  conn.getRequestProperty("Authorization"));
//    BufferedReader reader = new BufferedReader(new InputStreamReader(((HttpURLConnection) (new URL(url)).openConnection()).getInputStream(), Charset.forName("UTF-8")));
//    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), Charset.forName("UTF-8")));
  //  System.out.println("reader"+reader);
    
    String data =  "{\"format\":\"json\",\"pattern\":\"#\"}";
    System.out.println("conn.getOutputStream()-->"+conn.getOutputStream());
    OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream());
    out.write(data);
    out.close();

    new InputStreamReader(conn.getInputStream());   

    } catch (Exception e) {
    	 e.getMessage();
    e.printStackTrace();
   
    }

  }

}
