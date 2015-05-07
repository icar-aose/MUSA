package cnr.icar.db.hibernate;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.googlecode.s2hibernate.struts2.plugin.annotations.SessionTarget;
import com.googlecode.s2hibernate.struts2.plugin.annotations.TransactionTarget;

public class DettaglioOrdineDAO {
	
	 @SessionTarget
	   Session session;

	   @TransactionTarget
	   Transaction transaction;

	   @SuppressWarnings("unchecked")
	   public List<DettaglioOrdine> getDettaglioOrdine()
	   {
		   System.out.println("CALL GET DettaglioOrdine");
	      List<DettaglioOrdine> dettaglioOrdine = new ArrayList<DettaglioOrdine>();
	      try
	      {
	    	  
	    	  
	    	  dettaglioOrdine = session.createQuery("from DettaglioOrdine").list();
	         System.out.println("GET DettaglioOrdine SIZE:"+ dettaglioOrdine.size());
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return dettaglioOrdine;
	   }

	   public void addDettaglioOrdine(DettaglioOrdine dettaglioOrdine)
	   {
		   System.out.println("ADD DettaglioOrdine DAO");
	      session.save(dettaglioOrdine);
	   }   
	   public List<DettaglioOrdine> getDettaglioOrdineByID(int idOrdine)
	   {
		   System.out.println("CALL GET DettaglioOrdine BY ID");
	      List<DettaglioOrdine> dettaglioOrdine = new ArrayList<DettaglioOrdine>();
	      try
	      {
	    	  
	    	  
	    	  dettaglioOrdine = session.createQuery("from DettaglioOrdine where dettaglioOrdinePK.idOrdine="+idOrdine).list();
	         System.out.println("GET DettaglioOrdine BY ID SIZE:"+ dettaglioOrdine.size());
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return dettaglioOrdine;
	   }

}
