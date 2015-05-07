package cnr.icar.db.hibernate;

import java.io.IOException;
import java.net.URISyntaxException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.http.client.ClientProtocolException;
import org.apache.struts2.ServletActionContext;
import org.json.JSONException;
import org.json.JSONObject;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;
@SuppressWarnings("serial")
public class AddOrdineAction extends ActionSupport implements ModelDriven<Ordine>{
	private HttpServletRequest request=ServletActionContext.getRequest();  
	private HttpSession sessionHttp=request.getSession();  
	private Ordine ordine  = new Ordine();
	private List<Ordine> ordineList= new ArrayList<Ordine>();
	private List<Prodotto> prodottiInOrdine = new ArrayList<Prodotto>();
	private List<Prodotto> prodottiInDettaglioOrdine = new ArrayList<Prodotto>();
	private List<DettaglioOrdine>  dettaglioOrdine= new ArrayList<DettaglioOrdine>();
	private List<Integer> quantitaDettaglioOrdineList= new ArrayList<Integer>();
	private List<Ordine> ordiniByUser = new ArrayList<Ordine>();
	private	List<Prodotto> prodottiInOrdineSession;
	private OrdineDAO dao = new OrdineDAO();
	private UtenteDAO utentedao = new UtenteDAO();
	private DettaglioOrdineDAO dettaglioOrdinedao = new DettaglioOrdineDAO();
	private ProdottoDAO prodottoDAO = new ProdottoDAO();
	private String quantitaOrdinata;
	
	private String id_fattura;
	private String importo;
	private String data_emissione;
	private String data_evasione;
	private String evaso;
	
	@Override
	public Ordine getModel() {
	return ordine;
	}
	public String ordineSubmit(){
		return "success";
	}
	
	public String execute() throws JSONException, ClientProtocolException, IOException, URISyntaxException
	{
		Integer idOrdineSaved=0;
		Utente utenteOrdine=null;
		System.out.println("EXECUTE ACTION");
		String idCleinte=sessionHttp.getAttribute("idCliente").toString();
		ordine.setId_cliente(Integer.parseInt(sessionHttp.getAttribute("idCliente").toString()));
		 prodottiInOrdineSession=	(List<Prodotto>) sessionHttp.getAttribute("prodottiInOrdine");
		//CALCOLO  L'IMPORTO DELLA FATTURA 
		String[] quantitaOrdinataArray = null;
		if(quantitaOrdinata!=null){
			quantitaOrdinataArray = quantitaOrdinata.split(",");
		float importo =0;
		for(int i=0;i<prodottiInOrdineSession.size();i++){
			importo += prodottiInOrdineSession.get(i).getPrezzo()*Float.parseFloat(quantitaOrdinataArray[i]);
		}
		ordine.setImporto(importo);
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		   //get current date time with Date()
		   Date date = new Date();
		   System.out.println("date-->"+dateFormat.format(date));
		ordine.setData_emissione(date);
		ordine.setData_evasione(date);
		ordine.setEvaso((byte) 0);
		 idOrdineSaved=dao.addOrdine(ordine);
		  utenteOrdine=utentedao.getUtenteById(Integer.parseInt(idCleinte));
		// é necessario aggiunger anche un dettaglio deglio ordini, ovvere uan riga nella tabella  dettaglioOrdini 
		//per ogni prodotto presente nella lista dell'ordine.
		
		System.out.println("prodottiInOrdineSession SIZE-->"+prodottiInOrdineSession.size());
		
		System.out.println("quantitaOrdinata SIZE-->"+quantitaOrdinata);
		
		for(int i=0;i<prodottiInOrdineSession.size();i++){
			//AGGIUNGO UN DETTAGLIO ORDINE PER OGNI PRODOTTO SCELTO
			DettaglioOrdine dettaglioOrdineNew= new DettaglioOrdine();
			DettaglioOrdinePK dettaglioOrdinePK= new DettaglioOrdinePK();
			System.out.println("idOrdineSaved-->"+idOrdineSaved);
			dettaglioOrdinePK.setIdOrdine(idOrdineSaved);
			System.out.println("prodottiInOrdineSession.get(i).getId()-->"+prodottiInOrdineSession.get(i).getId());
			dettaglioOrdinePK.setIdProdotto(prodottiInOrdineSession.get(i).getId());
			
			dettaglioOrdineNew.setDettaglioOrdinePK(dettaglioOrdinePK);
			System.out.println("quantitaOrdinataArray[i].trim()-->"+quantitaOrdinataArray[i].trim());
			
			dettaglioOrdineNew.setQuantita( Integer.parseInt(quantitaOrdinataArray[i].trim()));
			dettaglioOrdinedao.addDettaglioOrdine(dettaglioOrdineNew);
			
		}
		}
		
		//TODO
		//effettuare la chaiamta a questo servizio 
		//http://194.119.214.121:8080/HTTPAgent/CheckEntry?entryService=occp_receiveOrder
		//ottengo un oggetto json che contiente i valori del corrispondente EntryPoint
		//usare questi valori per invocare correttamente il servizio
		
		//fare chiamata al servizio http://194.119.214.121:8080/HTTPAgent/RouteServer?user=emilio&role=worker
		//http://194.119.214.121:8080/HTTPAgent/RouteServer?user=idUser&role=occpUser
		//http://194.119.214.121:8080/HTTPAgent/RouteServer?order=idOrder&role=occpManager
		if(idOrdineSaved!=0){
		 JSONObject result = SerlevtManager.callPickEntity();
		SerlevtManager.callRouteServer(result,sessionHttp.getAttribute("idCliente").toString(),idOrdineSaved.toString(),utenteOrdine.getEmail());
		}
		
		sessionHttp.removeAttribute("prodottiInOrdine");
		return "success";
		
	}

	
	public String riepilogoOrdine(){
		System.out.println("RIEPILOGO ORDINE CALL ACTION");
		ordiniByUser=dao.getOrdiniByUser(sessionHttp.getAttribute("idCliente").toString());
		return "success";
	}
	
	
	public String  dettaglioOrdine(){
		System.out.println("DETTAGLIO ORDINE CALL ACTION");
	 //ottengo tutti i prodotti legati ad un ordine e li aggiungo in un campo 
		String idOrdine = ServletActionContext.getRequest().getParameter("idOrdine");
		dettaglioOrdine=dettaglioOrdinedao.getDettaglioOrdineByID(Integer.parseInt(idOrdine));
		//recupero il  valori dei prodotti presenti nel dettaglioOrdine
		for(int i=0; i<dettaglioOrdine.size();i++){
			Prodotto prodottoInDettaglio=prodottoDAO.getProdottoById(dettaglioOrdine.get(i).getDettaglioOrdinePK().idProdotto);
			prodottiInDettaglioOrdine.add(prodottoInDettaglio);
			
			//è necessario recuparare la quantità associata a ciascun prodotto nell'ordine
			quantitaDettaglioOrdineList.add(dettaglioOrdine.get(i).getQuantita());
				
			
		}
		
		return "success";	
	}
	public Ordine getOrdine() {
		return ordine;
	}

	public void setOrdine(Ordine ordine) {
		this.ordine = ordine;
	}

	public List<Ordine> getOrdineList() {
		return ordineList;
	}

	public void setOrdineList(List<Ordine> ordineList) {
		this.ordineList = ordineList;
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

	public OrdineDAO getDao() {
		return dao;
	}

	public void setDao(OrdineDAO dao) {
		this.dao = dao;
	}

	public String getQuantitaOrdinata() {
		return quantitaOrdinata;
	}

	public void setQuantitaOrdinata(String quantitaOrdinata) {
		this.quantitaOrdinata = quantitaOrdinata;
	}

	public List<Prodotto> getProdottiInOrdine() {
		return prodottiInOrdine;
	}

	public void setProdottiInOrdine(List<Prodotto> prodottiInOrdine) {
		this.prodottiInOrdine = prodottiInOrdine;
	}

	public List<Prodotto> getProdottiInOrdineSession() {
		return prodottiInOrdineSession;
	}

	public void setProdottiInOrdineSession(List<Prodotto> prodottiInOrdineSession) {
		this.prodottiInOrdineSession = prodottiInOrdineSession;
	}

	public DettaglioOrdineDAO getDettaglioOrdinedao() {
		return dettaglioOrdinedao;
	}

	public void setDettaglioOrdinedao(DettaglioOrdineDAO dettaglioOrdinedao) {
		this.dettaglioOrdinedao = dettaglioOrdinedao;
	}

	public List<Ordine> getOrdiniByUser() {
		return ordiniByUser;
	}

	public void setOrdiniByUser(List<Ordine> ordiniByUser) {
		this.ordiniByUser = ordiniByUser;
	}

	public String getId_fattura() {
		return id_fattura;
	}

	public void setId_fattura(String id_fattura) {
		this.id_fattura = id_fattura;
	}

	public String getImporto() {
		return importo;
	}

	public void setImporto(String importo) {
		this.importo = importo;
	}

	public String getData_emissione() {
		return data_emissione;
	}

	public void setData_emissione(String data_emissione) {
		this.data_emissione = data_emissione;
	}

	public String getData_evasione() {
		return data_evasione;
	}

	public void setData_evasione(String data_evasione) {
		this.data_evasione = data_evasione;
	}

	public String getEvaso() {
		System.out.println("EVASO IN GET-->"+evaso);
		return evaso;
	}

	public void setEvaso(String evaso) {
		System.out.println("EVASO IN SET-->"+evaso);
		if(evaso.equalsIgnoreCase("0")){
		this.evaso = "ORDINE NON EVASO";
		}
		else
			this.evaso = " ORDINE EVASO";
			
	}

	public List<DettaglioOrdine> getDettaglioOrdine() {
		return dettaglioOrdine;
	}

	public void setDettaglioOrdine(List<DettaglioOrdine> dettaglioOrdine) {
		this.dettaglioOrdine = dettaglioOrdine;
	}

	public List<Prodotto> getProdottiInDettaglioOrdine() {
		return prodottiInDettaglioOrdine;
	}

	public void setProdottiInDettaglioOrdine(
			List<Prodotto> prodottiInDettaglioOrdine) {
		this.prodottiInDettaglioOrdine = prodottiInDettaglioOrdine;
	}

	public List<Integer> getQuantitaDettaglioOrdineList() {
		return quantitaDettaglioOrdineList;
	}

	public void setQuantitaDettaglioOrdineList(
			List<Integer> quantitaDettaglioOrdineList) {
		this.quantitaDettaglioOrdineList = quantitaDettaglioOrdineList;
	}

	public ProdottoDAO getProdottoDAO() {
		return prodottoDAO;
	}

	public void setProdottoDAO(ProdottoDAO prodottoDAO) {
		this.prodottoDAO = prodottoDAO;
	}
	
	
	
	
	
//	private 	Ordine ordineNew= new Ordine();
//	HttpServletRequest request=ServletActionContext.getRequest();  
//	HttpSession sessionHttp=request.getSession();  
//	@Override
//	public Ordine getModel() {
//		// TODO Auto-generated method stub
//		return null;
//	}
//	
//	public String addOrdine(){
//		List<Prodotto> prodottiInOrdineSession=	(List<Prodotto>) sessionHttp.getAttribute("prodottiInOrdine");
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
//	public Ordine getOrdineNew() {
//		return ordineNew;
//	}
//
//	public void setOrdineNew(Ordine ordineNew) {
//		this.ordineNew = ordineNew;
//	}
//	
//
//	
	
}
