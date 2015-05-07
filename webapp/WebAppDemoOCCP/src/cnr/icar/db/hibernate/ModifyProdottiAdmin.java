package cnr.icar.db.hibernate;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

public class ModifyProdottiAdmin extends ActionSupport implements ModelDriven<Prodotto>{
	private List<Prodotto> prodotti = new ArrayList<Prodotto>();
	private ProdottoDAO prodottiDao = new ProdottoDAO();
	private String prodottoSelezionato;
	private List<Prodotto> prodottiToModify = new ArrayList<Prodotto>();
	private HttpServletRequest request=ServletActionContext.getRequest();  
	private HttpSession sessionHttp=request.getSession();  
	
	private String denominazione;
	private String descrizione;
	private float prezzo;
	private String disponibilita;
	private String tipologia;
	
	public String execute()
	{
		
		HttpServletRequest request=ServletActionContext.getRequest();  
		HttpSession session=request.getSession();  
		List<Prodotto>  prodottiToModify= (List<Prodotto>) sessionHttp.getAttribute("prodottiToModify");
		//TODO verificare perchè non arrivano valori di descrizione prezzo e quantità eccc
		for(int i=0;i<prodottiToModify.size();i++){
			System.out.println("denominazione-_>"+denominazione);
			System.out.println("descrizione-_>"+descrizione);
			System.out.println("prezzo-_>"+prezzo);
			System.out.println("quantita_disponibile-_>"+disponibilita);
			Prodotto prodotto=prodottiDao.getProdottoById(prodottiToModify.get(i).getId());
			System.out.println("tipologia-_>"+tipologia);
			//prelevo il prodotto dal db e ne setto i nuovi valori
//			Prodotto prodottoMofify=prodottiToModify.get(i);
			prodotto.setDenominazione(denominazione);
			prodotto.setDescrizione(descrizione);
			prodotto.setPrezzo(prezzo);
			prodotto.setDisponibilita((Integer.parseInt(disponibilita)));
			prodotto.setTipologia(tipologia);
			
		}

		//prelevare dalla jsp i dati della tabella e inserirli nel db
		System.out.println("EXECUTE ModifyProdottiAdmin");
		
	
	return "success";
	}

	
	public String listProdottiModify()
	{
		System.out.println("LIST UTENTI CALLED");
		prodotti = prodottiDao.getProdotti();
		System.out.println("utenti action size: "+ prodotti.size());
		return "success";
	}
	
	public String addProdottiToModify(){
		//System.out.println("CALL ADD PRODOTTI IN ORDINE"+session.get("prodottiInOrdine"));
		
		
//		if(sessionHttp.getAttribute("prodottiInOrdine")!=null)
//			prodottiToModify= (List<Prodotto>) sessionHttp.getAttribute("prodottiInOrdine");
		prodotti=prodottiDao.getProdotti();
		System.out.println("prodottiInOrdine--_>"+prodottiToModify);
		String[] prodottoSelezionatoArray = null;
		if(prodottoSelezionato!=null){
			 prodottoSelezionatoArray = prodottoSelezionato.split(",");
			 System.out.println("prodottoSelezionatoArray .length--_>"+prodottoSelezionatoArray.length);
			for(int i=0;i<prodottoSelezionatoArray.length;i++){
				System.out.println("prodottoSelezionatoArray[i]-->"+prodottoSelezionatoArray[i]);
				Prodotto prodottoToAdd=prodottiDao.getProdottoById(Integer.parseInt(prodottoSelezionatoArray[i].trim()));
				System.out.println("prodottoToAdd--_>"+prodottoToAdd);
				prodottiToModify.add(prodottoToAdd);
			}
		}
//		sessionHttp.setAttribute("prodottiInOrdine",prodottiToModify);
		System.out.println("prodottoSelezionato ID-->"+prodottoSelezionato);
		sessionHttp.setAttribute("prodottiToModify",prodottiToModify);
		return "success";
	 
	}
	@Override
	public Prodotto getModel() {
		// TODO Auto-generated method stub
		return null;
	}


	public List<Prodotto> getProdotti() {
		return prodotti;
	}


	public void setProdotti(List<Prodotto> prodotti) {
		this.prodotti = prodotti;
	}


	public ProdottoDAO getProdottiDao() {
		return prodottiDao;
	}


	public void setProdottiDao(ProdottoDAO prodottiDao) {
		this.prodottiDao = prodottiDao;
	}


	public String getProdottoSelezionato() {
		return prodottoSelezionato;
	}


	public void setProdottoSelezionato(String prodottoSelezionato) {
		this.prodottoSelezionato = prodottoSelezionato;
	}


	


	public List<Prodotto> getProdottiToModify() {
		return prodottiToModify;
	}


	public void setProdottiToModify(List<Prodotto> prodottiToModify) {
		this.prodottiToModify = prodottiToModify;
	}


	public HttpServletRequest getRequest() {
		return request;
	}


	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}


	public HttpSession getSessionHttp() {
		return sessionHttp;
	}


	public void setSessionHttp(HttpSession sessionHttp) {
		this.sessionHttp = sessionHttp;
	}


	public String getDenominazione() {
		return denominazione;
	}


	public void setDenominazione(String denominazione) {
		this.denominazione = denominazione;
	}


	public String getDescrizione() {
		return descrizione;
	}


	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}


	public float getPrezzo() {
		return prezzo;
	}


	public void setPrezzo(float prezzo) {
		this.prezzo = prezzo;
	}




	public String getDisponibilita() {
		return disponibilita;
	}


	public void setDisponibilita(String disponibilita) {
		this.disponibilita = disponibilita;
	}


	public String getTipologia() {
		return tipologia;
	}


	public void setTipologia(String tipologia) {
		this.tipologia = tipologia;
	}
	
	

}
