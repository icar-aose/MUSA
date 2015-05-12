package st;

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
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.NodeList;

public class testSOAP {
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		testSOAP t = new testSOAP();
		t.test();
	}


	public void test() {
        
		ServiceUtils soap = new ServiceUtils("getFlightDetails","http://localhost:13749/","http://cnr.icar.pa");
        try {
			soap.getSoapBodyElem().addChildElement("id").addTextNode("3");
			soap.getSoapMessage().saveChanges();
			
			System.out.println(soap.soapMessageToString());
		} catch (SOAPException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	String reply_message = soap.sendRequest("http://localhost:13749/TravelServices/services/FlightCompany");

    	System.out.println(reply_message);
    	
	}

}
