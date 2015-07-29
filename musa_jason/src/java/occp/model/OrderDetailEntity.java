package occp.model;

import musa.model.Entity;

public class OrderDetailEntity extends Entity
{
	private int idOrdine;
	private int idProdotto;
	private int quantita;

	public int get_idOrdine() 
	{
		return idOrdine;
	}

	public void set_idOrdine(int idOrdine) 
	{
		this.idOrdine = idOrdine;
	}

	public int get_idProdotto() 
	{
		return idProdotto;
	}

	public void set_idProdotto(int idProdotto) 
	{
		this.idProdotto = idProdotto;
	}

	public int get_quantita() 
	{
		return quantita;
	}

	public void set_quantita(int quantita) 
	{
		this.quantita = quantita;
	}



}
