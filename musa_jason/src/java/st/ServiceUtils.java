package st;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Iterator;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.Name;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;

public class ServiceUtils {
	private String service_name;
	private String serverURI;
	private String namespace;
	private SOAPMessage soapMessage = null;
	private SOAPElement soapBodyElem = null;

	public ServiceUtils(String service_name, String serverURI, String namespace) {
		super();
		this.service_name = service_name;
		this.serverURI = serverURI;
		this.namespace = namespace;
		try {
			createSOAPRequest();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String soapMessageToString() {
		String result = null;

		if (soapMessage != null) {
			ByteArrayOutputStream baos = null;
			try {
				baos = new ByteArrayOutputStream();
				soapMessage.writeTo(baos);
				result = baos.toString();
			} catch (Exception e) {
			} finally {
				if (baos != null) {
					try {
						baos.close();
					} catch (IOException ioe) {
					}
				}
			}
		}
		return result;
	}

	private void createSOAPRequest() throws SOAPException {
		MessageFactory messageFactory = MessageFactory.newInstance();
		soapMessage = messageFactory.createMessage();
		SOAPPart soapPart = soapMessage.getSOAPPart();

		SOAPEnvelope envelope = soapPart.getEnvelope();

		SOAPBody soapBody = envelope.getBody();
		soapBodyElem = soapBody.addChildElement(service_name, "", namespace);

		MimeHeaders headers = soapMessage.getMimeHeaders();
		headers.addHeader("SOAPAction", serverURI + "getOptions");

		soapMessage.saveChanges();
	}

	public String sendRequest(String endpoint) {

		String reply_message = null;
		try {
			SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory
					.newInstance();
			SOAPConnection soapConnection = soapConnectionFactory
					.createConnection();

			SOAPMessage soapResponse = soapConnection.call(soapMessage,
					endpoint);

			reply_message = getReplyMessageContent(soapResponse);
			soapConnection.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return reply_message;
	}

	private String getReplyMessageContent(SOAPMessage soapResponse) {
		String resp = "";
		SOAPBody respBody;
		try {
			respBody = soapResponse.getSOAPPart().getEnvelope().getBody();
			Iterator it = respBody.getChildElements();
			while (it.hasNext()) {
				SOAPElement soapBodyElem = (SOAPElement) it.next();
				Name elem_name = soapBodyElem.getElementName();
				if (elem_name.getLocalName().equals(service_name + "Response")) {
					Iterator it2 = soapBodyElem.getChildElements();

					while (it2.hasNext()) {
						SOAPElement soapElem = (SOAPElement) it2.next();
						Name elem_name2 = soapElem.getElementName();
						if (elem_name2.getLocalName().equals(
								service_name + "Return")) {
							resp = soapElem.getTextContent();
						}
					}
				}
			}
		} catch (SOAPException e) {
			e.printStackTrace();
		}
		return resp;
	}

	public SOAPMessage getSoapMessage() {
		return soapMessage;
	}

	public SOAPElement getSoapBodyElem() {
		return soapBodyElem;
	}

}
