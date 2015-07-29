package occp.action;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.util.Date;

import occp.database.OrderTable;

import occp.model.OrderEntity;
import workflow_property.MusaProperties;

/**
 * 
 * @author davide
 * DA MODIFICARE
 */
public class registerOrder extends DefaultInternalAction 
{
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		String ip_address 	= MusaProperties.getDemo_db_ip();
		String port 		= MusaProperties.getWorkflow_db_port();
		String database 	= MusaProperties.getDemo_db_name();
		String user 		= MusaProperties.getDemo_db_user();
		String password 	= MusaProperties.getDemo_db_userpass();
		
		
		String order_id = args[0].toString();
		String user_id 	= args[1].toString();
		
		order_id 	= order_id.replace("\"", "");
		user_id 	= user_id.replace("\"", "");
		
		//OrderTable orders 	= new OrderTable("194.119.214.121","3306","DemoOCCP","occp_root","root");
		OrderTable orders 	= new OrderTable(ip_address,port,database,user,password);
		OrderEntity e 		= new OrderEntity();
		
		//Metto solo le informazioni necessarie
		System.out.println(order_id);
		
		e.set_billing_id(Integer.parseInt(order_id));
		e.set_user_id(Integer.parseInt(user_id));
		e.set_issue_date(new Date());
		
		//...
		e.set_amount(10);
		
		//OrderTable t = new OrderTable(ip_address,port,database,user,password);
		
		//Check if order already exists
		if(orders.getOrder(Integer.parseInt(order_id)) != null)
			return true;
		
		orders.insertElement(e);
		
		return true;
	}
}
