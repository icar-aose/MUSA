// CArtAgO artifact code for project musa_jason

package ids.artifact;

import java.awt.event.ActionEvent;
import java.util.HashMap;

import gui.AddGoalGUIDialog;
import gui.HandleCapabilityFailure;

import javax.swing.JFrame;

import cartago.*;
import cartago.tools.GUIArtifact;

public class HandleCapabilityFailureGUIartifact extends GUIArtifact 
{
	private HashMap<String,String> capabilitySet;
	private HandleCapabilityFailure frame = null;
	
	public void setup()
	{
		frame = new HandleCapabilityFailure();
		capabilitySet = new HashMap<String,String>();
		
		//Link the GUI buttons click events to jason plans 
		linkActionEventToOp(frame.getButton(), 			"submitCapabilityFailure");
	
		//Show the dialog window
		frame.setVisible(true);
	}
	
	
	/**
	 * This is called when submit goal JButton has been clicked. It acts like a "bridge" between the JButton click event and the corresponding Jason event.
	 * @param ev
	 */
	@INTERNAL_OPERATION 
	void submitCapabilityFailure(ActionEvent ev)
	{
//		String capability 	= frame.getcapabilityComboBox().getSelectedItem().toString();
//		String failure 		= frame.getFailureComboBox().getSelectedItem().toString();
//		System.out.println("SELEZIONATA CAPABILITY "+capability);
		
		signal("submitCapabilityFailure");
	}
	
	
	@OPERATION
	void addCapabilityToFailureGUI(String agent,String capability)
	{
		System.out.println("Adding cap "+capability);
		capabilitySet.put(capability, agent);
		frame.getcapabilityComboBox().addItem(capability);
		
	}
	
	
	@OPERATION
	void getFailureCapabilityInfo(OpFeedbackParam<String> agent, OpFeedbackParam<String> capability, OpFeedbackParam<Boolean> failure)
	{
		String cap_name 	= frame.getcapabilityComboBox().getSelectedItem().toString();
		String fail 		= frame.getFailureComboBox().getSelectedItem().toString();
		String ag_name		= capabilitySet.get(cap_name);
		
		capability.set(cap_name);
		agent.set(ag_name);
		failure.set(Boolean.parseBoolean(fail));
	}
}

