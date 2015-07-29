package occp.model;

import java.util.Date;

import musa.model.Entity;

public class OrderEntity  extends Entity
{
	private int user_id;
	private int amount;
	private int billing_id;
	private Date issue_date;
	private Date expedition_date;
	private Boolean order_success;
	
	
	public int get_user_id() 
	{
		return user_id;
	}
	
	public void set_user_id(int user_id) 
	{
		this.user_id = user_id;
	}
	
	public int get_amount() 
	{
		return amount;
	}
	
	public void set_amount(int amount) 
	{
		this.amount = amount;
	}
	
	public int get_billing_id() 
	{
		return billing_id;
	}
	
	public void set_billing_id(int billing_id) 
	{
		this.billing_id = billing_id;
	}
	
	public Date get_issue_date() 
	{
		return issue_date;
	}
	
	public void set_issue_date(Date issue_date) 
	{
		this.issue_date = issue_date;
	}
	
	public Date get_expedition_date() 
	{
		return expedition_date;
	}
	
	public void set_expedition_date(Date expedition_date) 
	{
		this.expedition_date = expedition_date;
	}
	
	public Boolean get_order_success() 
	{
		return order_success;
	}

	public void set_order_success(Boolean order_success) 
	{
		this.order_success = order_success;
	}
	
	@Override
	public boolean equals(Object obj) 
	{
		OrderEntity entity = (OrderEntity)obj;
		
		if( this.get_user_id() == entity.get_user_id() )
			return true;
		
		return false;
	}

	
}
