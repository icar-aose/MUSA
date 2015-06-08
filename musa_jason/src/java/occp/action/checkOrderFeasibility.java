package occp.action;

import java.util.List;

import occp.database.OrderDetailTable;
import occp.database.OrderTable;
import occp.database.ProductTable;
import occp.logger.musa_logger;
import occp.model.OrderDetailEntity;
import occp.model.OrderEntity;
import occp.model.ProductEntity;
import workflow_property.MusaProperties;
import workflow_property.WorkflowProperties;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;

/**
 * 
 * @author davide
 *
 * DA MODIFICARE
 */
public class checkOrderFeasibility extends DefaultInternalAction 
{
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		/*String ip_address 	= WorkflowProperties.get_ip_address();
		String port 		= WorkflowProperties.get_port();
		String database 	= "DemoOCCP";
		String user 		= "occp_root";
		String password 	= "root";*/
		
		String ip_address 	= MusaProperties.get_demo_db_ip();
		String port 		= MusaProperties.get_demo_db_port();
		String database 	= MusaProperties.get_demo_db_name();
		String user 		= MusaProperties.get_demo_db_user();
		String password 	= MusaProperties.get_demo_db_userpass();
		
		String order_id 	= args[0].toString().replace("\"", "");
		OrderTable orders 						= new OrderTable(ip_address, port, database, user, password);
		ProductTable products 					= new ProductTable(ip_address,port,database, user, password);
		OrderDetailTable order_details_table	= new OrderDetailTable(ip_address,port,database, user, password);
		List<OrderDetailEntity> order_details 	= order_details_table.getOrderDetail(Integer.parseInt(order_id));
		ProductEntity product 					= null;
		int qta_disponibile 					= 0;
		int qta_richiesta 						= 0;
		Boolean order_success 					= true;
		
		System.out.println("Checking if order "+order_id+" can be fulfilled");
		
		musa_logger.get_instance().info("Checking if order "+order_id+" can be fulfilled");
		
		//Check the order feasibility
		for (OrderDetailEntity order_detail : order_details)
		{
			System.out.println("Getting product "+order_detail.get_idProdotto());
			product = products.getProduct(order_detail.get_idProdotto());
			
			qta_disponibile = product.get_disponibilita();
			qta_richiesta	= order_detail.get_quantita();
			
			System.out.println(String.format("product %s, q.ty request: %d, q.ty avaible: %d",product.get_id(), qta_richiesta, qta_disponibile));
			musa_logger.get_instance().info(String.format("[check_order_feasibility] product %s, q.ty request: %d, q.ty avaible: %d",product.get_id(), qta_richiesta, qta_disponibile));
			if(qta_disponibile - qta_richiesta < 0)
				order_success = false;
		}
		
		if(order_success)
		{
			System.out.println("ORDER FULFILLED");
			//Decrease the avaible product quantity in the DB
			for (OrderDetailEntity order_detail : order_details)
			{
				System.out.println("id prodotto: "+String.format("%d", order_detail.get_idProdotto()));
				
				product 				= products.getProduct(order_detail.get_idProdotto());
				System.out.println("product is ->"+product.toString());
				qta_disponibile 		= product.get_disponibilita();
				qta_richiesta			= order_detail.get_quantita();
				product.set_disponibilita(qta_disponibile - qta_richiesta);
				
				//Update the product table
				products.updateElementByPrimary(product);
			}
			
			//Update the order
			OrderEntity e = orders.getOrder(Integer.parseInt(order_id));
			e.set_order_success(order_success);
			orders.updateElementByPrimary(e);
			
			return un.unifies(ASSyntax.parseLiteral("true"), args[1]);
		}
		
    	return un.unifies(ASSyntax.parseLiteral("false"), args[1]);
	}

	
}
