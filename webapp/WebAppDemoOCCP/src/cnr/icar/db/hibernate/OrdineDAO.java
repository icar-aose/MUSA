package cnr.icar.db.hibernate;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.googlecode.s2hibernate.struts2.plugin.annotations.SessionTarget;
import com.googlecode.s2hibernate.struts2.plugin.annotations.TransactionTarget;

public class OrdineDAO {
	

	 @SessionTarget
	   Session session;

	   @TransactionTarget
	   Transaction transaction;

	   @SuppressWarnings("unchecked")
	   public List<Ordine> getOrdini()
	   {
		   System.out.println("CALL GET Ordine");
	      List<Ordine> ordine = new ArrayList<Ordine>();
	      try
	      {
	    	  
	    	  
	    	  ordine = session.createQuery("from Ordine").list();
	         System.out.println("GET UTENTI SIZE:"+ ordine.size());
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return ordine;
	   }

	   public int addOrdine(Ordine ordine)
	   {
		   System.out.println("ADD Ordine DAO");
		   Integer idOrdine;
	     return idOrdine= (Integer) session.save(ordine);
	   }   
	   
	   public List<Ordine> getOrdiniByUser(String idCliente)
	   {
		   System.out.println("CALL getOrdiniByUser Ordine");
	      List<Ordine> ordine = new ArrayList<Ordine>();
	      try
	      {
	    	  
	    	  
	    	  ordine = session.createQuery("from Ordine where id_cliente="+Integer.parseInt(idCliente)).list();
	         System.out.println("getOrdiniByUser SIZE:"+ ordine.size());
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return ordine;
	   }


}
