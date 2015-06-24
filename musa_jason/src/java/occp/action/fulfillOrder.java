package occp.action;

import java.util.Date;

import occp.database.OrderTable;
import occp.model.OrderEntity;
import workflow_property.MusaProperties;
import workflow_property.WorkflowProperties;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

/**
 * 
 * @author davide
 * DA MODIFICARE
 */
public class fulfillOrder extends DefaultInternalAction
{
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
//		String ip_address 	= WorkflowProperties.get_ip_address();
//		String port 		= WorkflowProperties.get_port();
//		String database 	= "DemoOCCP";
//		String user 		= "occp_root";
////		String password 	= WorkflowProperties.get_password();
//		String password 	= "root";
	
		
		
		/*
		String ip_address 	= MusaProperties.get_demo_db_ip();
		String port 		= MusaProperties.get_demo_db_port();
		String database 	= MusaProperties.get_demo_db_name();
		String user 		= MusaProperties.get_demo_db_user();
		String password 	= MusaProperties.get_demo_db_userpass();
		
		String order_id 	= args[0].toString().replace("\"", "");
		
		OrderTable t 		= new OrderTable(ip_address,port,database,user,password);
		OrderEntity order 	= t.getOrder(Integer.parseInt(order_id));
		
		//Expedition date is set to the current date
		order.set_expedition_date(new Date());
		t.updateElementByPrimary(order);
		*/
		return true;
	}
}
