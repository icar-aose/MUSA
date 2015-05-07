package cnr.icar.db.hibernate;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;

@Entity(name="DettaglioOrdine")  

public class DettaglioOrdine {
//TODO COMPLETARE LA DEFINIZIONE in modo da poter insereire un detaglio dell'ordine
	 @EmbeddedId
	 private DettaglioOrdinePK dettaglioOrdinePK;
	 
//	 @Column(name="idOrdine")  
//	 private Integer idOrdine;  
//	 @Column(name="idProdotto")  
//	 private Integer idProdotto;  
	 @Column(name="quantita")  
	 private Integer quantita;
	public DettaglioOrdinePK getDettaglioOrdinePK() {
		return dettaglioOrdinePK;
	}
	public void setDettaglioOrdinePK(DettaglioOrdinePK dettaglioOrdinePK) {
		this.dettaglioOrdinePK = dettaglioOrdinePK;
	}
//	public Integer getIdOrdine() {
//		return idOrdine;
//	}
//	public void setIdOrdine(Integer idOrdine) {
//		this.idOrdine = idOrdine;
//	}
//	public Date getIdProdotto() {
//		return idProdotto;
//	}
//	public void setIdProdotto(Date idProdotto) {
//		this.idProdotto = idProdotto;
//	}
	public Integer getQuantita() {
		return quantita;
	}
	public void setQuantita(Integer quantità) {
		this.quantita = quantità;
	}
	 
	 
	 
	 
}
