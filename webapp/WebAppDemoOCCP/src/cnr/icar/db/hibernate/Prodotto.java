package cnr.icar.db.hibernate;

import java.io.Serializable;
import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity(name="Prodotti")  
public class Prodotto implements Serializable{
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	 @GeneratedValue 
	 private int id;  
	 @Column(name="denominazione")  
	 private String denominazione;  
	 @Column(name="descrizione")  
	 private String descrizione;  
	 @Column(name="disponibilita")  
	 private Integer disponibilita;  
	 @Column(name="tipologia")  
	 private String tipologia;
	 @Column(name="prezzo")  
	 private float prezzo;
	 
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	
	public Integer getDisponibilita() {
		return disponibilita;
	}
	public void setDisponibilita(Integer disponibilita) {
		this.disponibilita = disponibilita;
	}
	public String getTipologia() {
		return tipologia;
	}
	public void setTipologia(String tipologia) {
		this.tipologia = tipologia;
	}
	public float getPrezzo() {
		return prezzo;
	}
	public void setPrezzo(float prezzo) {
		this.prezzo = prezzo;
	}

	 
}
