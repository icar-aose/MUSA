package cnr.icar.db.hibernate;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.googlecode.s2hibernate.struts2.plugin.annotations.SessionTarget;
import com.googlecode.s2hibernate.struts2.plugin.annotations.TransactionTarget;

public class UtenteDAO {
	 @SessionTarget
	   Session session;

	   @TransactionTarget
	   Transaction transaction;

	   @SuppressWarnings("unchecked")
	   public List<Utente> getUtenti()
	   {
		   System.out.println("CALL GET UTENTI");
	      List<Utente> utenti = new ArrayList<Utente>();
	      try
	      {
	    	  
	    	  
	         utenti = session.createQuery("from Utente").list();
	         System.out.println("GET UTENTI SIZE:"+ utenti.size());
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return utenti;
	   }
	   public Utente getUtenteById(int idUtente)
	   {
		 
		   Utente utente = new Utente();
	      try
	      {
	    	  
	    	  utente = 
	                   (Utente)session.get(Utente.class,  new Integer(idUtente)); 
	      //   prodotto = (Prodotto) session.createQuery("from Prodotto where id='"+idProdotto+"'").list();
	         
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      return utente;
	   }

	   public int addUtente(Utente utente)
	   {
		   System.out.println("ADD UTENTE DAO");
		   Integer idUtente;
		      return idUtente=(Integer)  session.save(utente);
	   }
		 public void updateUtente(Utente utente){
			 System.out.println("UTENE TO UPDATE"+utente.getId());
			 session.update(utente);
		 }
}
