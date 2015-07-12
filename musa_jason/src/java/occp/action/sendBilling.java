package occp.action;

import occp.database.OrderDetailTable;
import occp.database.OrderTable;
import occp.database.ProductTable;
import occp.database.UserTable;
import occp.logger.musa_logger;
import occp.model.OrderDetailEntity;
import occp.model.OrderEntity;
import occp.model.ProductEntity;
import occp.model.UserEntity;
import billing_pdf.Billing;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.*;  

import javax.mail.*;  
import javax.mail.internet.*;  
import javax.activation.*;  

import workflow_property.MusaProperties;
import workflow_property.WorkflowProperties;

/**
 * 
 * @author davide
 *
 *	Usage example:
 * 		
 * 		occp.action.sendBilling("12345", "14", "user_AT_email.com", "Hello!"); 
 * 
 *  DA MODIFICARE
 */
public class sendBilling extends DefaultInternalAction 
{
	private static String BILLING_PATH 			= "/tmp/billing.pdf";
	private static String sender_username 		= "musa.customer.service@gmail.com";
	private static String sender_password 		= "pippopluto";
	private static String message_body_text 	= "Dear customer,\n\nyour order has been accepted. Enclosed, you'll find the billing related to your order.\n\nSincerely,\nMUSA";
	private static String message_subject 		= "MUSA ~~~ Your order has been accepted!";
//	private static String logo_fname 			= "/media/dati/Work/CNR/Attività 2 - pianificazione + capability con parametri/demo_occp/logo_esempio.png";
	private static String logo_fname = "";
	
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		String ip_address 	= MusaProperties.getDemo_db_ip();
		String port 		= MusaProperties.getWorkflow_db_port();
		String database 	= MusaProperties.getDemo_db_name();
		String db_user_str 		= MusaProperties.getDemo_db_user();
		String password 	= MusaProperties.getDemo_db_userpass();
		
		final String order_id 			= args[0].toString().replace("\"", "");
		final String user_id 			= args[1].toString().replace("\"", "");
		final String user_email 		= args[2].toString().replace("\"", "");
				
		final Billing b = new Billing(BILLING_PATH);
		
		final OrderTable orders 						= new OrderTable(ip_address,port,database,db_user_str,password);
		final OrderDetailTable order_details_table		= new OrderDetailTable(ip_address,port,database,db_user_str,password);
		final UserTable users 							= new UserTable(ip_address,port,database,db_user_str,password);
		final ProductTable products 					= new ProductTable(ip_address,port,database,db_user_str,password);
		
		final UserEntity user			 	= users.getUser(Integer.parseInt(user_id));
		final OrderEntity order 			= orders.getOrder(Integer.parseInt(order_id));
		ProductEntity product 				= null;
		final List<OrderDetailEntity> order_details = order_details_table.getOrderDetail(Integer.parseInt(order_id));
		
		//Format the user name for the billing
		String user_name = String.format("%s %s", user.get_nome(), user.get_cognome());
		
		//Set the billing properties
		b.set_billing_header_title("Billing");
		b.set_billing_identifier(order_id);
		b.set_billing_logo_fname(logo_fname);
		b.set_billing_logo_resize_method(Billing.LOGO_RESIZE_METHOD.Percent);
		b.set_billing_logo_scaling_percent(27);
		b.set_customer_identifier(user_name);
		//b.set_customer_email(user.get_email());
		b.set_customer_email(user_email);

		SimpleDateFormat sdf = new SimpleDateFormat();
		String expedition_date = sdf.format(order.get_issue_date());
		sdf.applyPattern("YYYY-MM-DD");
		
		for (OrderDetailEntity order_detail : order_details)
		{
			product = products.getProduct(order_detail.get_idProdotto());
			b.add_billing_entry(expedition_date, product.get_denominazione(), String.format("%d",order_detail.get_quantita()) , String.format("%d$", Math.round(product.get_prezzo()) ));
		}
		
		b.populate_document();
		
		musa_logger.get_instance().info("Billing created at " + BILLING_PATH);
		musa_logger.get_instance().info("Sending billing e-mail");
		
		Thread sendmail_thread = new Thread("MUSA_sendmail")
		{
			public void run() 
			{
				send_billing(user_email);
				musa_logger.get_instance().info("Billing e-mail has been succesfully sent.");
			}
		};
		
		sendmail_thread.start();
		
		return true;
	}
	
	
	private void send_billing(String to)
	{
		to = to.replace("_AT_", "@");
		to = to.replace("_at_", "@"); 
		
		musa_logger.get_instance().info("sending billing to "+to);
		
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.socketFactory.port", "465");
		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.port", "465");
		
		// Get the Session object.
		Session session = Session.getInstance(props,
			new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(sender_username, sender_password);
			}
		});
		
		//compose the message  
		try
		{  
			Message message = new MimeMessage(session);  
			message.setFrom(new InternetAddress(sender_username, "MUSA"));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));  
			message.setSubject(message_subject);  
			
			// Create the message part
			BodyPart messageBodyPart = new MimeBodyPart();

			// Now set the actual message
			messageBodyPart.setText(message_body_text);

			// Create a multipar message
			Multipart multipart = new MimeMultipart();

			// Set text message part
			multipart.addBodyPart(messageBodyPart);

			// Part two is attachment
			messageBodyPart = new MimeBodyPart();
			DataSource source = new FileDataSource(BILLING_PATH);
			messageBodyPart.setDataHandler(new DataHandler(source));
			messageBodyPart.setFileName(BILLING_PATH);
			multipart.addBodyPart(messageBodyPart);

			// Send the complete message parts
			message.setContent(multipart);
			
			// Send message  
			Transport.send(message);  
		}
		catch (MessagingException mex) 			{mex.printStackTrace();} 
		catch (UnsupportedEncodingException e) {e.printStackTrace();}  
	}

}
