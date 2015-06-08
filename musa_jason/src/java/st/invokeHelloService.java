// Internal action code for project adaptive_workflow

package st;

import javax.xml.soap.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class invokeHelloService extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action '<PCK>.invokeHelloService'");

        try{
	        SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
	        SOAPConnection soapConnection = soapConnectionFactory.createConnection();
	        
	        String url = "http://localhost:13749/TravelServices/services/Hello";
	        SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(), url);
	        
	        printSOAPResponse(soapResponse);
	        
	        soapConnection.close();
        } catch (Exception e) {
        	e.printStackTrace();
        }
        // everything ok, so returns true
        return true;
    }

	private SOAPMessage createSOAPRequest() throws Exception {
		MessageFactory messageFactory = MessageFactory.newInstance();
		SOAPMessage soapMessage = messageFactory.createMessage();
		SOAPPart soapPart = soapMessage.getSOAPPart();
		
		String serverURI = "http://localhost:13749/";
		
		SOAPEnvelope envelope = soapPart.getEnvelope();
		envelope.addNamespaceDeclaration("http://cnr.icar.pa", serverURI);
		
		SOAPBody soapBody = envelope.getBody();
		SOAPElement soapBodyElem = soapBody.addChildElement("helloName", "http://cnr.icar.pa");
		SOAPElement soapBodyElem1 = soapBodyElem.addChildElement("name", "http://cnr.icar.pa");
		soapBodyElem1.addTextNode("Luca");
		
		MimeHeaders headers = soapMessage.getMimeHeaders();
		headers.addHeader("SOAPAction", serverURI  + "helloName");
		soapMessage.saveChanges();
		
		System.out.print("Request SOAP Message = ");
        soapMessage.writeTo(System.out);
        System.out.println();
        
		return soapMessage;
	}
	private void printSOAPResponse(SOAPMessage soapResponse) throws Exception {
		TransformerFactory transformerFactory = TransformerFactory.newInstance();
		Transformer transformer = transformerFactory.newTransformer();
		Source sourceContent = soapResponse.getSOAPPart().getContent();
		System.out.print("\nResponse SOAP Message = ");
        StreamResult result = new StreamResult(System.out);
        transformer.transform(sourceContent, result);
	}

}
