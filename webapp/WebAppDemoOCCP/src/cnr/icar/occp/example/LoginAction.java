package cnr.icar.occp.example;  
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import cnr.icar.db.hibernate.CloudServices;
import cnr.icar.db.hibernate.CloudServicesDAO;
import cnr.icar.db.hibernate.Utente;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;  
  
public class LoginAction extends ActionSupport {  

	private static Connection connection = null;
	//private  Map session = ActionContext.getContext().getSession();
	private HttpServletRequest request=ServletActionContext.getRequest();  
	private HttpSession sessionHttp=request.getSession();  
	private static SessionFactory factory;
    private String userName;  
    private String password;  
    private CloudServicesDAO cloudServicesDAO;  
    public String execute() {  
    	String user="occp_root";
    	String port="3306";
    	String password="root";
    	String database="DemoOCCP";
    	String ip_address="194.119.214.121";
    	System.out.println("sessionHttp idCliente LOGIN ACTION--"+sessionHttp.getAttribute("idCliente"));

    	try {
    		
    		
//    		  session.remove("idCliente");
//    		  session.remove("prodottiInOrdine");
    		Class.forName("com.mysql.jdbc.Driver").newInstance();
    		String parameters = "jdbc:mysql://"+ip_address+":"+port+"/"+database;		
    		connection = DriverManager.getConnection(parameters,user,password);
    		factory = new Configuration().configure().buildSessionFactory();
    		System.out.println("EXECUTE");
    		Map<String, Object> session = ActionContext.getContext().getSession();
   		  	session.remove("idCliente");
    		sessionHttp.removeAttribute("idCliente");
    		sessionHttp.removeAttribute("prodottiInOrdine");
    		session.remove("cloudInfo");
    		session.remove("idCliente");

    	} catch (InstantiationException e) {
    		// TODO Auto-generated catch block
    		e.printStackTrace();
    	} catch (IllegalAccessException e) {
    		// TODO Auto-generated catch block
    		e.printStackTrace();
    	} catch (ClassNotFoundException e) {
    		// TODO Auto-generated catch block
    		e.printStackTrace();
    	} catch (SQLException e) {
    		// TODO Auto-generated catch block
    		e.printStackTrace();
    	}



    		 
    		  //creating configuration object  
    		    Configuration cfg=new Configuration();  
    		    cfg.configure("hibernate.cfg.xml");//populates the data of the configuration file  
    		      
    		    //creating seession factory object  
    		    SessionFactory factory=cfg.buildSessionFactory();  
    		      
    		    //creating session object  
    		    Session sessionFactory=factory.openSession();  
    		      
    		    //creating transaction object  
    		    Transaction t=sessionFactory.beginTransaction();  
    		    
    			Utente utente=getUtenteByLogin(getUserName(), getPassword());
            	
        	 	//inserire l'id dell'utente in sessione
    			
            	if(utente!=null){
            		//session.put("idCliente",utente.getId());
            		sessionHttp.setAttribute("idCliente",utente.getId());
            		System.out.println("TIPOLOGIA UTENTE---->"+utente.getAmministratore());
            		if (utente.getAmministratore()==1){
            			System.out.println("UTENE ADMIN---->");
            			return NONE;
            			
            		}
            		cloudServicesDAO=new CloudServicesDAO();
            		List<CloudServices> cloudServicesToUser=new ArrayList<CloudServices> (); 
            		if( cloudServicesDAO.getCloudServicesByUser(utente.getId())!=null){
            	 cloudServicesToUser= (List<CloudServices>) cloudServicesDAO.getCloudServicesByUser(utente.getId());
            		System.out.println("UTENE Comune---->");
            		}
            		   Map<String, Object> session = ActionContext.getContext().getSession();
                		  session.put("idCliente",utente.getId());
                		  if(cloudServicesToUser.size()>0)
                		  session.put("cloudInfo","true");
                		 
                			  
                		  System.out.println("ID UTENTE LOGIN ACTION-->"+session.get("idCliente"));
            		 return SUCCESS;  
       
            	}
            	else
            		 return ERROR;  
    }  
    public String  logoutUtente(){
    	
    	System.out.println("LOGOUT UTENTE");
    	sessionHttp.removeAttribute("idCliente");
		sessionHttp.removeAttribute("prodottiInOrdine");
		return SUCCESS;  
		
    }
    public void listUtenti( ){
       Session session = factory.openSession();
       Transaction tx = null;
       try{
          tx = session.beginTransaction();
          List utenti = session.createQuery("FROM Utenti").list(); 
          for (Iterator iterator =utenti.iterator(); iterator.hasNext();){
             Utente utente = (Utente) iterator.next(); 
//             System.out.print("First Name: " + employee.getNome()); 
//             System.out.print("  Last Name: " + employee.getCognome()); 
//             System.out.println("  Email: " + employee.getEmail()); 
          }
          tx.commit();
       }catch (HibernateException e) {
          if (tx!=null) tx.rollback();
          e.printStackTrace(); 
       }finally {
          session.close(); 
       }
    }
    public String getUserName() {  
        return userName;  
    }  
  
    public void setUserName(String userName) {  
        this.userName = userName;  
    }  
  
    public String getPassword() {  
        return password;  
    }  
  
    public void setPassword(String password) {  
        this.password = password;  
    }  
    public Utente getUtenteByLogin(String username, String password){
    	Utente utente=null;
    	 Session session = factory.openSession();
         Transaction tx = null;
         try{
            tx = session.beginTransaction();
            List utenti = session.createQuery("FROM Utente where username='"+username+"' and password='"+password+"'").list(); 
            for (Iterator iterator =utenti.iterator(); iterator.hasNext();){
                utente =  (Utente) iterator.next(); 
//               System.out.print("First Name: " + employee.getNome()); 
//               System.out.print("  Last Name: " + employee.getCognome()); 
//               System.out.println("  Email: " + employee.getEmail()); 
            }
            tx.commit();
         }catch (HibernateException e) {
            if (tx!=null) tx.rollback();
            e.printStackTrace(); 
         }finally {
            session.close(); 
         }
    	return utente;
    		
    	
    }

//	public Map getSession() {
//		return session;
//	}
//
//	public void setSession(Map session) {
//		this.session = session;
//	}
//  
//    public boolean validate() {  
//    	//verifico se esiste nel DB un utente cn username e password inseriti
//    	Utente utente=getUtenteByLogin(getUserName(), getPassword());
//    	boolean utenteRegistrato=false;
//    	if(utente!=null)
//    		utenteRegistrato=true;
//    	return utenteRegistrato;
//    		
////        if (getUserName().length() == 0) {  
////            addFieldError("userName", "UserName.required");  
////        } else if (!getUserName().equals("Antonella")) {  
////            addFieldError("userName", "Invalid User");  
////        }  
////        if (getPassword().length() == 0) {  
////            addFieldError("password", getText("password.required"));  
////        }  
//    }  
}  

