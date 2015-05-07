package cnr.icar.db.hibernate;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.googlecode.s2hibernate.struts2.plugin.annotations.SessionTarget;
import com.googlecode.s2hibernate.struts2.plugin.annotations.TransactionTarget;

public class CloudServicesDAO {
	 @SessionTarget
	   Session session;

	   @TransactionTarget
	   Transaction transaction;
	   
	   

	   public void addCloudService(CloudServices cloudServices)
	   {
		   session.save(cloudServices);
	   }
	   
	   public CloudServices getCloudServicesById(CloudServicePK idCloudServices)
	   {
		 
		   CloudServices cloudServices = new CloudServices();
	      try
	      {
	    	  
	    	  cloudServices = 
	                   (CloudServices)session.get(CloudServices.class,  idCloudServices); 
	      //   prodotto = (Prodotto) session.createQuery("from Prodotto where id='"+idProdotto+"'").list();
	         
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return cloudServices;
	   }

	   @SuppressWarnings("unchecked")
	public List<CloudServices> getCloudServicesByUser(Integer idUtente)
	   {
		   System.out.println("CALL getCloudServicesByUser");
		   System.out.println("CALL getCloudServicesByUser  idUtente-->"+idUtente);
	      List<CloudServices> cloudServices = new ArrayList<CloudServices>();
	      try
	      {
	    	  
	    	  
	    	 // cloudServices = sessiontarget.createQuery("from CloudServices where cloudServicePK.idUtente="+idUtente).list();
	    	 String query=" from CloudService";
	    	  System.out.println(query);
	    	  System.out.println("session: "+session);
	    	  
	    	  if(session.createQuery(query)!=null)
	    	  cloudServices = session.createQuery(query).list();
		         System.out.println("GET cloudServices BY ID SIZE:"+ cloudServices.size());
		     
	        
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return cloudServices;
	   }
	   
}

