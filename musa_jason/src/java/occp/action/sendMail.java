package occp.action;

import http.ConnectionOCCP;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

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

import occp.logger.musa_logger;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;

/**
 * 
 * @author davide
 *
 */
public class sendMail extends DefaultInternalAction 
{
	private static String sender_username 		= "musa.customer.service@gmail.com";
	private static String sender_password 		= "pippopluto";
	
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception 
	{
		final String to 				= args[0].toString().replace("\"", "");
//		final String to 				= ConnectionOCCP.getMail();
		final String email_subject 		= args[1].toString().replace("\"", "");
		final String email_body 		= args[2].toString().replace("\"", "");
		final String personal_name 		= args[3].toString().replace("\"", "");
		
		musa_logger.get_instance().info("Sending billing to "+to);
		
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
			message.setFrom(new InternetAddress(sender_username, personal_name));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));  
			message.setSubject(email_subject);  
			
			// Create the message part
			BodyPart messageBodyPart = new MimeBodyPart();

			// Now set the actual message
			messageBodyPart.setText(email_body);

			// Create a multipar message
			Multipart multipart = new MimeMultipart();

			// Set text message part
			multipart.addBodyPart(messageBodyPart);

			// Send the complete message parts
			message.setContent(multipart);
			
			// Send message  
			Transport.send(message);  
		}
		catch (MessagingException mex) 			{mex.printStackTrace();return false;} 
		catch (UnsupportedEncodingException e) {e.printStackTrace();return false;}  
		
		return true;
	}
}
