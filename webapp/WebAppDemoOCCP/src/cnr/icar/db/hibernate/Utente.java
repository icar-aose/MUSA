package cnr.icar.db.hibernate;

import java.io.Serializable;

import javax.persistence.Column;  
import javax.persistence.Entity;  
import javax.persistence.GeneratedValue;  
import javax.persistence.Id;  
import javax.persistence.Table;



@Entity
@Table(name="Utenti") 
public class Utente implements Serializable {
	 /**
	 * 
	 */
	private static final long serialVersionUID = 6873415034777549783L;
	@Id
	 @GeneratedValue 
	 private int id;  
	 @Column(name="nome")  
	 private String nome;  
	 @Column(name="cognome")  
	 private String cognome;  
	 @Column(name="email")  
	 private String email;  
	 @Column(name="telefono")  
	 private Long telefono;  
	 @Column(name="partitaIVA")  
	 private Long partitaIVA;  
	 @Column(name="username")  
	 private String username;  
	 @Column(name="password")  
	 private String password;  
	 @Column(name="infocloud") 
	 private String infocloud;
	 @Column(name="amministratore")  
	 private Byte amministratore;  
	 @Column(name="ruolo")  
	 private Integer ruolo;  
	 
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getCognome() {
		return cognome;
	}

	public void setCognome(String cognome) {
		this.cognome = cognome;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Long getTelefono() {
		return telefono;
	}

	public void setTelefono(Long telefono) {
		this.telefono = telefono;
	}

	
	public Long getPartitaIVA() {
		return partitaIVA;
	}

	public void setPartitaIVA(Long partitaIVA) {
		this.partitaIVA = partitaIVA;
	}

	public String getInfocloud() {
		return infocloud;
	}

	public void setInfocloud(String infocloud) {
		this.infocloud = infocloud;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Byte getAmministratore() {
		return amministratore;
	}

	public void setAmministratore(Byte amministratore) {
		this.amministratore = amministratore;
	}

	public Integer getRuolo() {
		return ruolo;
	}

	public void setRuolo(Integer ruolo) {
		this.ruolo = ruolo;
	}


	 
	

	
}
