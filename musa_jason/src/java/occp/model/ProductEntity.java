package occp.model;

import ids.model.Entity;

public class ProductEntity  extends Entity
{
	private int id;
	private String denominazione;
	private String descrizione;
	private float prezzo;
	private String tipologia;
	private int disponibilita;

	public int get_id()
	{
		return id;
	}
	
	public void set_id(int v)
	{
		id = v;
	}
	
	public String get_denominazione()
	{
		return denominazione;
	}
	
	public void set_denominazione(String v)
	{
		denominazione = v;
	}
	
	public String get_descrizione()
	{
		return descrizione;
	}
	
	public void set_descrizione(String v)
	{
		descrizione = v;
	}
	
	public float get_prezzo()
	{
		return prezzo;
	}
	
	public void set_prezzo(float v)
	{
		prezzo = v;
	}
	
	public String get_tipologia()
	{
		return tipologia;
	}
	
	public void set_tipologia(String v)
	{
		tipologia = v;
	}

	public int get_disponibilita() 
	{
		return disponibilita;
	}

	public void set_disponibilita(int disponibilita) 
	{
		this.disponibilita = disponibilita;
	}

}
