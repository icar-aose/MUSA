package occp.model;

import musa.model.Entity;

/**
 * 
 * @author davide
 */
public class UserEntity extends Entity 
{
	private int id;
	private String nome;
	private String cognome;
	private String email;
	private int telefono;
	private int partita_iva;
	private String username;
	private String password;
	private boolean amministratore;
	private String infocloud;
	
	
	public int get_id()
	{
		return id;
	}

	public void set_id(int v)
	{
		id = v;
	}
	
	public String get_nome()
	{
		return nome;
	}

	public void set_nome(String v)
	{
		nome = v;
	}
	

	public String get_cognome()
	{
		return cognome;
	}

	public void set_cognome(String v)
	{
		cognome = v;
	}
	

	public String get_email()
	{
		return email;
	}

	public void set_email(String v)
	{
		email = v;
	}
	
	
	public int get_telefono()
	{
		return telefono;
	}

	public void set_telefono(int v)
	{
		telefono = v;
	}

	public int get_partita_iva()
	{
		return partita_iva;
	}

	public void set_partita_iva(int v)
	{
		partita_iva = v;
	}

	public String get_username() {
		return username;
	}

	public void set_username(String username) {
		this.username = username;
	}

	public String get_password() {
		return password;
	}

	public void set_password(String password) {
		this.password = password;
	}

	public boolean get_amministratore() {
		return amministratore;
	}

	public void set_amministratore(boolean amministratore) {
		this.amministratore = amministratore;
	}

	public String get_infocloud() {
		return infocloud;
	}

	public void set_infocloud(String infocloud) {
		this.infocloud = infocloud;
	}

}
