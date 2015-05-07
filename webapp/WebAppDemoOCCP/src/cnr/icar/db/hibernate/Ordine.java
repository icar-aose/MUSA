package cnr.icar.db.hibernate;


import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity(name="Ordini")  
public class Ordine {
	
	 @Id
	 @GeneratedValue 
	 private int id_fattura;  
	 @Column(name="importo")  
	 private float importo;  
	 @Column(name="data_emissione")  
	 private Date data_emissione;  
	 @Column(name="data_evasione")  
	 private Date data_evasione;  
	 @Column(name="id_cliente")  
	 private Integer id_cliente;
	 @Column(name="evaso")  
	 private Byte evaso;
	public int getId_fattura() {
		return id_fattura;
	}
	public void setId_fattura(int id_fattura) {
		this.id_fattura = id_fattura;
	}
	public float getImporto() {
		return importo;
	}
	public void setImporto(float importo) {
		this.importo = importo;
	}
	public Date getData_emissione() {
		return data_emissione;
	}
	public void setData_emissione(Date data_emissione) {
		this.data_emissione = data_emissione;
	}
	public Date getData_evasione() {
		return data_evasione;
	}
	public void setData_evasione(Date data_evasione) {
		this.data_evasione = data_evasione;
	}
	public Integer getId_cliente() {
		return id_cliente;
	}
	public void setId_cliente(Integer id_cliente) {
		this.id_cliente = id_cliente;
	}
	public Byte getEvaso() {
		return evaso;
	}
	public void setEvaso(Byte evaso) {
		this.evaso = evaso;
	}  
	 
	 
	

}
