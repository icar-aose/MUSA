package cnr.icar.db.hibernate;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.googlecode.s2hibernate.struts2.plugin.annotations.SessionTarget;
import com.googlecode.s2hibernate.struts2.plugin.annotations.TransactionTarget;

public class ProdottoDAO {
	
	 @SessionTarget
	   Session session;

	   @TransactionTarget
	   Transaction transaction;

	   @SuppressWarnings("unchecked")
	   public List<Prodotto> getProdotti()
	   {
		 
	      List<Prodotto> prodotti = new ArrayList<Prodotto>();
	      try
	      {
	         prodotti = session.createQuery("from Prodotto").list();
	         
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return prodotti;
	   }
	   
	   public Prodotto getProdottoById(int idProdotto)
	   {
		 
		   Prodotto prodotto = new Prodotto();
	      try
	      {
	    	  
	    	   prodotto = 
	                   (Prodotto)session.get(Prodotto.class,  new Integer(idProdotto)); 
	      //   prodotto = (Prodotto) session.createQuery("from Prodotto where id='"+idProdotto+"'").list();
	         
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return prodotto;
	   }

	   public void addProdotto(Prodotto prodotto)
	   {
	      session.save(prodotto);
	   }

}
