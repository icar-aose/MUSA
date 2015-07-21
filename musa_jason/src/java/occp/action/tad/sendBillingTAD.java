package occp.action.tad;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import occp.http.OCCPRequestParser;
import occp.logger.musa_logger;

import org.json.JSONArray;
import org.json.JSONObject;

import billing_pdf.Billing;

public class sendBillingTAD extends DefaultInternalAction
{
//	private static String BILLING_PATH 		= MusaProperties.get_demo_billing_tmp_folder() + "billing.pdf";
	private static String sender_username 		= "musa.customer.service@gmail.com";
	private static String sender_password 		= "pippopluto";
	private static String message_body_text 	= "Dear customer,\n\nyour order has been accepted. Enclosed, you'll find the billing related to your order.\n\nSincerely,\nMUSA";
	private static String message_subject 		= "MUSA ~~~ Your order has been accepted!";
	private static String logo_fname = "";
	
	private String billing_filename = "";
	
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		billing_filename 				= args[0].toString().replace("\"", "");
		final String user_email 		= args[1].toString().replace("\"", "");		
		final String order_id 			= OCCPRequestParser.getIdOrdine() == null ? "0" : OCCPRequestParser.getIdOrdine();
		final JSONArray product_details = OCCPRequestParser.getProductMessage();
		
		final Billing b = new Billing(billing_filename);		
		//Format the user name for the billing
		String user_name = String.format("%s %s", OCCPRequestParser.getNome(), OCCPRequestParser.getCognome());
		
		//Set the billing properties
		b.set_billing_header_title("Billing");
		b.set_billing_identifier(order_id);
		b.set_billing_logo_fname(logo_fname);
		b.set_billing_logo_resize_method(Billing.LOGO_RESIZE_METHOD.Percent);
		b.set_billing_logo_scaling_percent(27);
		b.set_customer_identifier(user_name);
		b.set_customer_email(user_email);

		//Iterate through products
		if(product_details != null)
		{
			for(int i=0;i<product_details.length();i++)
			{
				JSONObject data = product_details.getJSONObject(i);
				
				String nome_prodotto 	= data.getString("nome_prodotto") != null ? data.getString("nome_prodotto") : "";
				String prezzo 			= data.getString("prezzo") != null ? data.getString("prezzo") : "";
				/*INUTILIZZATA*/String descrizione 		= data.getString("descrizione") != null ? data.getString("descrizione") : "";
				String quantita 		= data.getString("quantita") != null ? data.getString("quantita") : "";
				/*INUTILIZZATA*/String tipologia 		= data.getString("tipologia") != null ? data.getString("tipologia") : "";
				
				//Append a product entry into the PDF billing
				b.add_billing_entry(OCCPRequestParser.getDataCreazioneOrdine(), nome_prodotto, quantita , prezzo );
			}
		}
		else
			b.add_billing_entry("2015-12-25", "Product", "1" , "99" );
		
		
		//Create the billing
		b.populate_document();
		
		musa_logger.get_instance().info("Billing created at " + billing_filename);
		musa_logger.get_instance().info("Sending billing e-mail");
		
		//Send the billing to the user email
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
		to = to.toLowerCase().replace("_at_", "@");		
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
			DataSource source = new FileDataSource(billing_filename);
			messageBodyPart.setDataHandler(new DataHandler(source));
			messageBodyPart.setFileName(billing_filename);
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
