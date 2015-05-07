package cnr.icar.db.hibernate;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.soap.SOAPException;

import org.apache.struts2.ServletActionContext;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.json.JSONException;
import org.json.JSONObject;


import com.dropbox.core.DbxAppInfo;
import com.dropbox.core.DbxAuthFinish;
import com.dropbox.core.DbxClient;
import com.dropbox.core.DbxException;
import com.dropbox.core.DbxRequestConfig;
import com.dropbox.core.DbxSessionStore;
import com.dropbox.core.DbxStandardSessionStore;
import com.dropbox.core.DbxWebAuth;
import com.dropbox.core.DbxWebAuth.BadRequestException;
import com.dropbox.core.DbxWebAuth.BadStateException;
import com.dropbox.core.DbxWebAuth.CsrfException;
import com.dropbox.core.DbxWebAuth.NotApprovedException;
import com.dropbox.core.DbxWebAuth.ProviderException;
import com.dropbox.core.DbxWebAuthNoRedirect;
import com.dropbox.core.json.JsonReader.FileLoadException;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

@SuppressWarnings("serial")
public class AddUtenteAction extends ActionSupport {
	
	private Utente utente=new Utente();
	private List<Utente> utenti = new ArrayList<Utente>();
	private UtenteDAO utenteDao = new UtenteDAO();
	private CloudServicesDAO cloudServiceDao = new CloudServicesDAO();
	private HttpServletRequest request=ServletActionContext.getRequest();  
	private HttpSession sessionHttp=request.getSession();  
	
	private String cognome;
	private String email;
	private String nome;
	private String partitaIVA;

	private String telefono;
	private String amministratore;

	private String infocloud;
	
	/** Interface to dropbox */ 
	DbxClient dbx_client = null;
	
	/** A container for configuration parameters for how requests to the Dropbox servers should be made */
	DbxRequestConfig config;
	/** User related access token */
	private String access_token = null;

	

	private static Connection connection = null;
	
	 private static SessionFactory factory;
    private String username;  
    private String password;  
   // private  Map session = ActionContext.getContext().getSession();
  
    public String execute() {  
    	
    	if(sessionHttp.getAttribute("idCliente")!=null)
    	modifyUserData();
    	else{
    		Utente userNEw=new Utente();
    		userNEw.setCognome(getCognome());
    		userNEw.setEmail(getEmail());
    		userNEw.setNome(getNome());
    		userNEw.setPartitaIVA(Long.parseLong(getPartitaIVA()));
    		userNEw.setPassword(getPassword());
    		userNEw.setTelefono(Long.parseLong(getTelefono()));
    		utenteDao.addUtente(userNEw);
    		
    	}
//    	String user="occp_root";
//    	String port="3306";
//    	String password="root";
//    	String database="DemoOCCP";
//    	String ip_address="194.119.214.121";
//System.out.println("sessionHttp idCliente--"+sessionHttp.getAttribute("idCliente"));
//if(sessionHttp.getAttribute("idCliente")!=null){
//	System.out.println("CAll MODIFY USER");
//	Utente utenteTOModify=utenteDao.getUtenteById((int) sessionHttp.getAttribute("idCliente"));
//	utenteTOModify.setCognome(getCognome());
//	utenteTOModify.setEmail(getEmail());
//	utenteTOModify.setNome(getNome());
//	utenteTOModify.setPartitaIVA(Long.parseLong(getPartitaIVA()));
//	utenteTOModify.setPassword(getPassword());
//	utenteTOModify.setTelefono(Long.parseLong(getTelefono()));
//	
//	if(getAmministratore().equals("true"))
//		utenteTOModify.setAmministratore((byte) 1);
//	else
//		utenteTOModify.setAmministratore((byte) 0);
//	utenteTOModify.setUsername(getUsername());
//
//	utenteTOModify.setInfocloud(getInfocloud());
//	
//} else{
//	System.out.println("CAll ADD USER");
//    	try {
//    		Class.forName("com.mysql.jdbc.Driver").newInstance();
//    		String parameters = "jdbc:mysql://"+ip_address+":"+port+"/"+database;		
//    		connection = DriverManager.getConnection(parameters,user,password);
//    		factory = new Configuration().configure().buildSessionFactory();
//    		System.out.println("EXECUTE");
////    		session.remove("idCliente");
////    		session.remove("prodottiInOrdine");
//    		sessionHttp.removeAttribute("idCliente");
//    		sessionHttp.removeAttribute("prodottiInOrdine");
//
//    	} catch (InstantiationException e) {
//    		// TODO Auto-generated catch block
//    		e.printStackTrace();
//    	} catch (IllegalAccessException e) {
//    		// TODO Auto-generated catch block
//    		e.printStackTrace();
//    	} catch (ClassNotFoundException e) {
//    		// TODO Auto-generated catch block
//    		e.printStackTrace();
//    	} catch (SQLException e) {
//    		// TODO Auto-generated catch block
//    		e.printStackTrace();
//    	}
//
//
//
//    		 
//    		  //creating configuration object  
//    		    Configuration cfg=new Configuration();  
//    		    cfg.configure("hibernate.cfg.xml");//populates the data of the configuration file  
//    		      
//    		    //creating seession factory object  
//    		    SessionFactory factory=cfg.buildSessionFactory();  
//    		      
//    		    //creating session object  
//    		    Session session=factory.openSession();  
//    		      
//    		    //creating transaction object  
//    		    Transaction t=session.beginTransaction();  
//		utente=new Utente();
//		
//		System.out.println(" getUsername UTENTE ACTION-->"+getUsername());
//		System.out.println(" GETpassword UTENTE ACTION-->"+getPassword());
//		System.out.println(" getInfocloud UTENTE ACTION-->"+getInfocloud());
//		utente.setCognome(getCognome());
//		utente.setEmail(getEmail());
//		utente.setNome(getNome());
//		utente.setPartitaIVA(Long.parseLong(getPartitaIVA()));
//		utente.setPassword(getPassword());
//		utente.setTelefono(Long.parseLong(getTelefono()));
//		
//		if(getAmministratore().equals("true"))
//		utente.setAmministratore((byte) 1);
//		else
//			utente.setAmministratore((byte) 0);
//		utente.setUsername(getUsername());
//	
//		utente.setInfocloud(getInfocloud());
//		
//		Integer idNewUtente=utenteDao.addUtente(utente);
//		System.out.println(" idNewUtente-->"+idNewUtente);
//		sessionHttp.setAttribute("idCliente", idNewUtente);
//	
//	
//}
return "success";
    }
    public void  modifyUserData(){
    	System.out.println(" CALL MODIFY USER DATA");
    	System.out.println("sessionHttp idCliente-MODIFY USER DATA-"+sessionHttp.getAttribute("idCliente"));
    
    	Utente utenteLogged=utenteDao.getUtenteById((int) sessionHttp.getAttribute("idCliente"));
    	System.out.println(" utenteLogged.getNome()-->"+utenteLogged.getNome());
    	setNome(utenteLogged.getNome());
    	setCognome(utenteLogged.getCognome());
    	System.out.println("AutenteLogged.getPassword()"+utenteLogged.getPassword());
    	setPassword(utenteLogged.getPassword());
    	setUsername(utenteLogged.getUsername());
    	setEmail(utenteLogged.getEmail());
    	System.out.println("AutenteLogged.getInfocloud()"+utenteLogged.getInfocloud());
    	setInfocloud(utenteLogged.getInfocloud());
    	setPartitaIVA(utenteLogged.getPartitaIVA().toString());
    	System.out.println("AMMINISTRATORE???--_>>"+utenteLogged.getAmministratore());
    	if(utenteLogged.getAmministratore()==1)
    	setAmministratore("true");
    	else
    		setAmministratore("false");
    	setTelefono(utenteLogged.getTelefono().toString());
    	//effettuo l'update dell'utente
    	utenteDao.updateUtente(utenteLogged);
    	
    }
	
    public String  updateUserData(){
    	System.out.println(" CALL updateUserData");
    	System.out.println("sessionHttp idCliente-MODIFY USER DATA-"+sessionHttp.getAttribute("idCliente"));
    	if(sessionHttp.getAttribute("idCliente")!=null){
    		
    	
    
    	Utente utenteLogged=utenteDao.getUtenteById((int) sessionHttp.getAttribute("idCliente"));
    	System.out.println(" utenteLogged.getNome()-->"+utenteLogged.getNome());
    	utenteLogged.setNome(nome);
    	utenteLogged.setCognome(cognome);
    	if(amministratore=="true")
    	utenteLogged.setAmministratore((byte) 1);
    	else
    		utenteLogged.setAmministratore((byte)0);
    	utenteLogged.setEmail(email);
    	utenteLogged.setInfocloud(infocloud);
    	utenteLogged.setPartitaIVA(Long.parseLong(partitaIVA));
    	utenteLogged.setPassword(password);
    	utenteLogged.setRuolo(1);
    	utenteLogged.setTelefono(Long.parseLong(telefono));
    	utenteLogged.setUsername(username);
    	
    	setCognome(utenteLogged.getCognome());
    	System.out.println("AutenteLogged.getPassword()"+utenteLogged.getPassword());
    	setPassword(utenteLogged.getPassword());
    	setUsername(utenteLogged.getUsername());
    	setEmail(utenteLogged.getEmail());
    	System.out.println("AutenteLogged.getInfocloud()"+utenteLogged.getInfocloud());
    	setInfocloud(utenteLogged.getInfocloud());
    	setPartitaIVA(utenteLogged.getPartitaIVA().toString());
    	System.out.println("AMMINISTRATORE???--_>>"+utenteLogged.getAmministratore());
    	if(utenteLogged.getAmministratore()==1)
    	setAmministratore("true");
    	else
    		setAmministratore("false");
    	setTelefono(utenteLogged.getTelefono().toString());
    	//effettuo l'update dell'utente
    	utenteDao.updateUtente(utenteLogged);
    	}
    	else
    	{
    		//effettuo l'inseriemnto di  un nuovo utente 
    		Utente utenteNew= new Utente();
    		utenteNew.setNome(nome);
    		utenteNew.setCognome(cognome);
        	if(amministratore=="true")
        		utenteNew.setAmministratore((byte) 1);
        	else
        		utenteNew.setAmministratore((byte)0);
        	utenteNew.setEmail(email);
        	utenteNew.setInfocloud(infocloud);
        	utenteNew.setPartitaIVA(Long.parseLong(partitaIVA));
        	utenteNew.setPassword(password);
        	utenteNew.setRuolo(1);
        	utenteNew.setTelefono(Long.parseLong(telefono));
        	utenteNew.setUsername(username);
        	utenteDao.addUtente(utenteNew);
    		
    	}
    	return "success";
    	
    }
	public String updateInfoCloud() {
		System.out.println("SESSION ID CLIENTE UPDATE INFOCLOUD ACTION--_>>"+	sessionHttp.getAttribute("idCliente"));
		System.out.println("CODE UPDATE INFOCLOUD ACTION--_>>"+	request.getParameter("code"));
		CloudServicePK idCloudServices=new CloudServicePK();
		idCloudServices.setIdUtente(Integer.parseInt(sessionHttp.getAttribute("idCliente").toString()));
		idCloudServices.setTipoServizio("Dropbox");
		
		System.out.println("cloudServiceDao.getCloudServicesById(idCloudServices)-_>>"+	cloudServiceDao.getCloudServicesById(idCloudServices));
		if(request.getParameter("code")!=null){
			System.out.println("IN IF--_>>"+	request.getParameter("code"));
			//aggiorno il dato nel database
			//new CloudeServicesRecord
			CloudServices cloudServiceNew= new CloudServices();
			CloudServicePK cloudServiceNewPk= new CloudServicePK();
			cloudServiceNewPk.setIdUtente(Integer.parseInt(sessionHttp.getAttribute("idCliente").toString()));
			cloudServiceNewPk.setTipoServizio("Dropbox");
			System.out.println("IN IF-333-_>>");
			String code=request.getParameter("code");
			//Fare l'invocazione al servizio web cn la seruente URI, si ottiene un 
	//	String urlDropbox="	https://api.dropbox.com/1/oauth2/token?code="+code+"&grant_type=authorization_code&redirect_uri=http://localhost:8080/LoginStruts2/utente.jsp";
				//-u bpg9o57qlu9w0j0:gbejdmg316i4j8l";
		
		
//		 String url;
//		try {
//			url = Curl_2.getJsonFromUrl();
//		} catch (Exception e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		}

		    
		// System.out.println("urlDropbox----_>"+urlDropbox);
		
		 try {
			JSONObject json = readJsonFromCode(code);
			access_token=(String) json.get("access_token");
			  System.out.println("JSON__>"+json.toString());
			    System.out.println("access_token-->"+json.get("access_token"));
			    System.out.println("ACCESS TOKEN--->"+access_token);
		        cloudServiceNew.setAccessToken(access_token);
				cloudServiceNew.setCloudServicePK(cloudServiceNewPk);
				cloudServiceDao.addCloudService(cloudServiceNew);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
//		Bisogna convertire il code in access_code
		
		      //cloudServiceNew.setAccessToken(request.getParameter("code"));
		      
					
			
			return "success";
		}
		return "none";
	}
	
	
	

		  public static JSONObject readJsonFromCode(String code) throws Exception {
		   
		  
		   //   BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
		      String jsonText = Curl_2.getJsonFromUrl(code);
		      JSONObject json = new JSONObject(jsonText);
		      return json;
		    
		  }
		    
	public String listUtenti()
	{
		System.out.println("LIST UTENTI CALLED");
		utenti = utenteDao.getUtenti();
		System.out.println("utenti action size: "+ utenti.size());
	return "success";
	}
	public Utente getUtente() {
		return utente;
	}
	public void setUtente(Utente utente) {
		this.utente = utente;
	}
	public List<Utente> getUtenti() {
		return utenti;
	}
	public void setUtenti(List<Utente> utenti) {
		this.utenti = utenti;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getCognome() {
		return cognome;
	}
	public void setCognome(String cognome) {
		this.cognome = cognome;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getPartitaIVA() {
		return partitaIVA;
	}
	public void setPartitaIVA(String partitaIVA) {
		this.partitaIVA = partitaIVA;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	
	public String getAmministratore() {
		return amministratore;
	}
	public void setAmministratore(String amministratore) {
		this.amministratore = amministratore;
	}
	public String getInfocloud() {
		return infocloud;
	}
	public void setInfocloud(String infocloud) {
		this.infocloud = infocloud;
	}
	
	
	

	
	}
