package cnr.icar.db.hibernate;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

  
@SuppressWarnings("deprecation")
public class HibernateMain {  

	private static Connection connection = null;
 public static void main(String[] args) {  
   

String user="occp_root";
String port="3306";
String password="root";
String database="DemoOCCP";
String ip_address="194.119.214.121";


try {
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	String parameters = "jdbc:mysql://"+ip_address+":"+port+"/"+database;		
	connection = DriverManager.getConnection(parameters,user,password);
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
	    Session session=factory.openSession();  
	      
	    //creating transaction object  
	    Transaction t=session.beginTransaction();  
	          
	    Utente e1=new  Utente();  
	    e1.setId(115);  
	    e1.setNome("Antonella");  
	    e1.setCognome("Cavaleri"); 
	    e1.setEmail("anto_cavaleri@virgilio.it");  
	    e1.setTelefono(Long.parseLong("123345"));  
	    
	      
	    session.persist(e1);//persisting the object  
	      
	    t.commit();//transaction is committed  
	    session.close();  
	      
	    System.out.println("successfully saved");  
	 
	 
 }  
  
}  
