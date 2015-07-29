package occp.model;

import musa.model.Entity;

public class CloudServiceEntity extends Entity
{
	private int 		idUtente;
	private String 		accessToken;
	private String		tipoServizio;
	
	
	public int get_idUtente() 
	{
		return idUtente;
	}
	
	public void set_idUtente(int idUtente) 
	{
		this.idUtente = idUtente;
	}
	
	public String get_accessToken() 
	{
		return accessToken;
	}
	
	public void set_accessToken(String accessToken) 
	{
		this.accessToken = accessToken;
	}
	
	public String get_tipoServizio() 
	{
		return tipoServizio;
	}
	
	public void set_tipoServizio(String tipoServizio) 
	{
		this.tipoServizio = tipoServizio;
	}
}
