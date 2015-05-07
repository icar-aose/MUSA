package cnr.icar.db.hibernate;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

@SuppressWarnings("serial")
public class AddProdottoAction extends ActionSupport implements ModelDriven<Prodotto>
{
	//private Map<String,Object> session= new ActionMap();
	private 	Prodotto prodotto= new Prodotto();
	private List<Prodotto> prodotti = new ArrayList<Prodotto>();
	private String prodottoSelezionato;
	private String prodottoSelezionatoElimina;
	private List<Prodotto> prodottiInOrdine = new ArrayList<Prodotto>();
	private ProdottoDAO prodottiDao = new ProdottoDAO();
	private HttpServletRequest request=ServletActionContext.getRequest();  
	private HttpSession sessionHttp=request.getSession();  
	public String execute()
	{
		
		HttpServletRequest request=ServletActionContext.getRequest();  
		HttpSession session=request.getSession();  
		System.out.println("EXECUTE ADDPRODOTTO");
		session.setAttribute("prodottiInOrdine", prodottiInOrdine);
	
	return "success";
	}
	
	 
	public String listProdotti()
	{
		System.out.println("LIST UTENTI CALLED");
		prodotti = prodottiDao.getProdotti();
		System.out.println("utenti action size: "+ prodotti.size());
		return "success";
	}
	
	public String addProdottiInOrdine(){
		//System.out.println("CALL ADD PRODOTTI IN ORDINE"+session.get("prodottiInOrdine"));
		//TODO Commentata riga sottostante verificare se tutto funzioan bene
	//	sessionHttp.setAttribute("idCliente", "115");
		
		if(sessionHttp.getAttribute("prodottiInOrdine")!=null)
			prodottiInOrdine= (List<Prodotto>) sessionHttp.getAttribute("prodottiInOrdine");
		prodotti=prodottiDao.getProdotti();
		System.out.println("prodottiInOrdine--_>"+prodottiInOrdine);
		String[] prodottoSelezionatoArray = null;
		
		if(prodottoSelezionato!=null){
			 prodottoSelezionatoArray = prodottoSelezionato.split(",");
			 System.out.println("prodottoSelezionatoArray .length--_>"+prodottoSelezionatoArray.length);
			for(int i=0;i<prodottoSelezionatoArray.length;i++){
				System.out.println("prodottoSelezionatoArray[i]-->"+prodottoSelezionatoArray[i]);
				Prodotto prodottoToAdd=prodottiDao.getProdottoById(Integer.parseInt(prodottoSelezionatoArray[i].trim()));
				System.out.println("prodottoToAdd--_>"+prodottoToAdd);
				prodottiInOrdine.add(prodottoToAdd);
			}
		}
		sessionHttp.setAttribute("prodottiInOrdine",prodottiInOrdine);
		System.out.println("prodottoSelezionato ID-->"+prodottoSelezionato);
		return "success";
	 
	}
	
	
	@SuppressWarnings({ "unchecked", "unused" })
	public String deleteProdottiInOrdine(){

		if(sessionHttp.getAttribute("prodottiInOrdine")!=null){
			String[] prodottoSelezionatoArray = null;
			prodottiInOrdine= (List<Prodotto>) sessionHttp.getAttribute("prodottiInOrdine");
			
			System.out.println("prodottiInOrdine DELETE--_>"+prodottiInOrdine);
			List<Prodotto> prodottiInOrdineNew = new ArrayList<Prodotto>();
			if(prodottoSelezionatoElimina!=null){
				 prodottoSelezionatoArray = prodottoSelezionatoElimina.split(",");
				 for(int i=0;i<prodottoSelezionatoArray.length;i++){
					 Prodotto prodottoToRemove=prodottiDao.getProdottoById(Integer.parseInt(prodottoSelezionatoArray[i].trim()));
					 System.out.println("PRODOTTO DA ELIMINRE ID "+prodottoToRemove.getId());
					 for(int j=0;j<prodottiInOrdine.size();j++){
						 if(prodottoToRemove.getId()==prodottiInOrdine.get(j).getId())
							 prodottiInOrdine.remove(j);
							 
							
						}
					
				 }
				
			}
		}
//			prodottiInOrdine= (List<Prodotto>) sessionHttp.getAttribute("prodottiInOrdine");
//		prodotti=prodottiDao.getProdotti();
//		System.out.println("prodottiInOrdine DELETE--_>"+prodottiInOrdine);
//		String[] prodottoSelezionatoArray = null;
//		List<Prodotto> prodottiInOrdineNew = new ArrayList<Prodotto>();
//		if(prodottoSelezionatoElimina!=null){
//			 prodottoSelezionatoArray = prodottoSelezionatoElimina.split(",");
//			 System.out.println("prodottoSelezionatoArray DELETE.length--_>"+prodottoSelezionatoArray.length);
//			for(int i=0;i<prodottoSelezionatoArray.length;i++){
//				System.out.println("prodottoSelezionatoArray[i]- DELETE->"+prodottoSelezionatoArray[i]);
//				Prodotto prodottoToRemove=prodottiDao.getProdottoById(Integer.parseInt(prodottoSelezionatoArray[i].trim()));
//				prodottiInOrdine.remove(prodottoToRemove);
//				for(int j=0;j<prodottiInOrdine.size();j++){
//					if(!(prodottiInOrdine.get(j).equals(prodottoToRemove))){
//						System.out.println("PRODOTTO DA NON ELIMINRE "+prodottoToRemove);
//						prodottiInOrdineNew.add(prodottiInOrdine.get(j));
//					}
//				}
//				System.out.println("prodottoToAdd- DELETE-_>"+prodottoToRemove);
//				System.out.println("prodottiInOrdine- DELETE-_>"+prodottiInOrdine.size());
//			//	prodottiInOrdine.remove(prodottoToRemove);
//			}
//		}
//		
//		sessionHttp.removeAttribute("prodottiInOrdine");
//		sessionHttp.setAttribute("prodottiInOrdine",prodottiInOrdine);
//		System.out.println("sessionHttp. SIZE DELETE->"+sessionHttp.getAttribute("prodottiInOrdine"));
//		System.out.println("prodottiInOrdine SIZE DELETE->"+prodottiInOrdine.size());
//		System.out.println("prodottiInOrdineNew SIZE DELETE->"+prodottiInOrdineNew.size());
//		
//		System.out.println("prodottoSelezionato ID-n DELETE->"+prodottoSelezionatoElimina);
		return "success";
	 
	}
	
//	public String addOrdine(){
//		List<Prodotto> prodottiInOrdineSession=	(List<Prodotto>) session.getAttribute("prodottiInOrdine");
//	
//		ordineNew.setId_cliente(115);
//		ordineNew.setImporto(100);
//		ordineNew.setData_emissione(new Date (15/04/2015));
//		ordineNew.setData_evasione(new Date (15/04/2015));
//		
//		OrdineDAO ordineDAO=new OrdineDAO();
//		ordineDAO.addOrdine(ordineNew);
//		
//		for(int i=0;i<prodottiInOrdineSession.size();i++){
//			//AGGIUNGO UN DETTAGLIO ORDINE PER OGNI PRODOTTO SCELTO
//			
//		}
//		System.out.println("prodottiInOrdineSession SIZE-->"+prodottiInOrdineSession.size());
//		return "success";
//	}
//	

	
	
	public String getProdottoSelezionato() {
		return prodottoSelezionato;
	}


	public String getProdottoSelezionatoElimina() {
		return prodottoSelezionatoElimina;
	}


	public void setProdottoSelezionatoElimina(String prodottoSelezionatoElimina) {
		this.prodottoSelezionatoElimina = prodottoSelezionatoElimina;
	}


	public void setProdottoSelezionato(String prodottoSelezionato) {
		this.prodottoSelezionato = prodottoSelezionato;
	}


	public HttpServletRequest getRequest() {
		return request;
	}


	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}


	public HttpSession getSession() {
		return sessionHttp;
	}


	public void setSession(HttpSession session) {
		this.sessionHttp = session;
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
	
	public List<Prodotto> getProdottiInOrdine() {
		return prodottiInOrdine;
	}

	public void setProdottiInOrdine(List<Prodotto> prodottiInOrdine) {
		this.prodottiInOrdine = prodottiInOrdine;
	}


	@Override
	public Prodotto getModel() {
		// TODO Auto-generated method stub
		return prodotto;
	}


	
}
