// Internal action code for project adaptive_workflow

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

import org.json.JSONArray;
import org.json.JSONObject;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class invokeOptionService extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        ts.getAg().getLogger().info("executing internal action 'st.invokeOptionService'");

        StringTerm service_arg = (StringTerm) args[0];
        
        ListTerm return_opts = new ListTermImpl();
        
        try{
	        SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
	        SOAPConnection soapConnection = soapConnectionFactory.createConnection();
	        
	        String url = "http://localhost:13749/TravelServices/services/Options";
	        SOAPMessage soapRequest = createSOAPRequest(service_arg.getString());
	        SOAPMessage soapResponse = soapConnection.call(soapRequest, url);

	        String reply_message = getReplyMessageContent(soapResponse);
	        //System.out.println(reply_message);	        

	        JSONObject object = new JSONObject(reply_message);
	        JSONArray opts = object.getJSONArray("options");
	        
	        for (int i=0; i<opts.length(); i++) {
	        	String opt = opts.optString(i);
	        	//System.out.println(opt);
	        	return_opts.add(new StringTermImpl(opt));
	        }
	        
	        soapConnection.close();
        } catch (Exception e) {
        	e.printStackTrace();
        }
        // everything ok, so returns true
        return un.unifies(return_opts,args[1]);
    }

    private SOAPMessage createSOAPRequest(String service_arg) throws SOAPException {
		MessageFactory messageFactory = MessageFactory.newInstance();
		SOAPMessage soapMessage = messageFactory.createMessage();
		SOAPPart soapPart = soapMessage.getSOAPPart();
		
		String serverURI = "http://localhost:13749/";
		
		SOAPEnvelope envelope = soapPart.getEnvelope();
		
		SOAPBody soapBody = envelope.getBody();
		SOAPElement soapBodyElem = soapBody.addChildElement("getGreetingsOption", "", "http://cnr.icar.pa");
		SOAPElement soapBodyElem1 = soapBodyElem.addChildElement("name");
		soapBodyElem1.addTextNode(service_arg);
		
		MimeHeaders headers = soapMessage.getMimeHeaders();
		headers.addHeader("SOAPAction", serverURI  + "getOptions");
		
		soapMessage.saveChanges();
		
		return soapMessage;
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
	        	if (elem_name.getLocalName().equals("getGreetingsOptionResponse")) {
	        		//System.out.println("helloNameResponse");
	        		Iterator it2 = soapBodyElem.getChildElements();
	        		
	        		while (it2.hasNext()) {
	    	        	SOAPElement soapElem = (SOAPElement) it2.next();
	    	        	Name elem_name2 = soapElem.getElementName();
	    	        	if (elem_name2.getLocalName().equals("getGreetingsOptionReturn")) {
	    	        		//System.out.println("helloNameReturn");
	    	        		resp = soapElem.getTextContent();
	    	        	}
	        		}
	        	}
	        }
		} catch (SOAPException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return resp;
	}

}
