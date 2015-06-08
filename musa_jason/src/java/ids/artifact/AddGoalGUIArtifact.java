package ids.artifact;

import gui.AddGoalGUIDialog;
import ids.database.GoalTable;
import ids.model.Entity;
import ids.model.GoalEntity;

import java.awt.event.ActionEvent;
import java.sql.SQLException;
import java.util.List;

import javax.swing.JOptionPane;

import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import cartago.tools.GUIArtifact;

/**
 * The artifact for the new goal dialog window. This dialog let the user to add a new goal to the database and communicate it to employees agents.
 * 
 * @author Davide Guastella
 */
public class AddGoalGUIArtifact extends GUIArtifact 
{
	private AddGoalGUIDialog frame = null;
	
	/**
	 * Inject all the goals contained by the pack which contains the current selected goal (in the combobox control).
	 */
	@OPERATION
	private void injectGoalPack()
	{
		String packName = frame.getSelectedGoalPack();
		GoalTable testTable = new GoalTable();
		boolean atLeastOneGoalInPack = false;
		
		try 
		{
			//Retrieve the goals from the db
			List<Entity> goals = testTable.getAll();
			
			//populate the combobox
			for(Entity e : goals)
			{
				String currentPack = ((GoalEntity)e).getPack();		//get the pack of the current goal
				
				//The selected goal parsing process could add whitespaces into the pack name...
				if(!packName.contains(currentPack))
					continue;
				
				atLeastOneGoalInPack 	= true;
				String goalName 		= ((GoalEntity)e).getName();
				String goalDescription 	= ((GoalEntity)e).getGoalDescription();
				
				//Define an observable property for the goal to inject.
				defineObsProperty("goalToInject", goalName, currentPack, goalDescription);
			}
			//At this point, all the goals within the specified pack have been injected.
			
			//If at least one goal is contained by the specified pack, proceed creating the department
			if(atLeastOneGoalInPack)
				defineObsProperty("createDepartmentForInjectedGoalPack", packName);
		} 
		catch (SQLException e) 
		{
			showMessage("New goal","An error occurred. (Error: "+e.getMessage()+")");
			e.printStackTrace();
		}	
	}
	
	/**
	 * Return the current goal pack name.
	 */
	@OPERATION
	private void getSelectedPackName(OpFeedbackParam<String> PackName)
	{
		PackName.set(frame.getSelectedGoalPack());
	}
	
	/**
	 * Load all the goals from the table "adw_goal" into the database, and for each record
	 * insert a row into the goal's combo box control containing its data. 
	 */
	@SuppressWarnings("unchecked")
	private void loadGoalsFromDB() 
	{
		GoalTable testTable = new GoalTable();
		try 
		{
			//Retrieve the goals from the db
			List<Entity> goals = testTable.getAll();
			
			//populate the combobox
			for(Entity e : goals)
			{
				GoalEntity g = (GoalEntity)e;
				String comboboxEntry = "ID: "+g.getID()+" name: "+g.getName()+" pack: "+g.getPack()+" description: "+g.getGoalDescription();
				
				frame.getGoalsComboBox().addItem(comboboxEntry);
				
			}
		} 
		catch (SQLException e) 
		{
			showMessage("New goal","An error occurred. (Error: "+e.getMessage()+")");
			e.printStackTrace();
		}
	}
	
	/**
	 * Get the data of the goal that has to be submitted to the database.
	 * 
	 * @param name the name of the last submitted goal
	 * @param pack the pack of the last submitted goal
	 * @param description the description of the last submitted goal
	 */
	@OPERATION 
	void newGoalToSubmitToDatabase_Data(OpFeedbackParam<String> name, OpFeedbackParam<String> pack, OpFeedbackParam<String> description)
	{
		if(frame == null)
			return;
		
		name.set( frame.getNewGoalName() );
		pack.set( frame.getNewGoalPack() );
		description.set( frame.getNewGoalDescription() );
	}
	
	/**
	 * This is called when inject goal JButton has been clicked. It acts like a "bridge" between the JButton click event and the corresponding Jason event.
	 * @param ev
	 */
	@INTERNAL_OPERATION 
	void injectGoal(ActionEvent ev)
	{
		defineObsProperty("goalToInject", frame.getSelectedGoalName(), frame.getSelectedGoalPack(), frame.getSelectedGoalDescription());
	}
	
	/**
	 * This is called when inject goal pack JButton has been clicked. It acts like a "bridge" between the JButton click event and the corresponding Jason event.
	 * @param ev
	 */
	@INTERNAL_OPERATION 
	void injectGoalPack(ActionEvent ev)
	{
		injectGoalPack();
	}
	
	/** 
	 * Setup this artifact. 
	 */
	public void setup()
	{
		frame = new AddGoalGUIDialog();
		
		//Read the 
		loadGoalsFromDB();
		
		//Link the GUI buttons click events to jason plans 
		linkActionEventToOp(frame.getSubmitButton(), 			"submitGoalToDB_Event");
		linkActionEventToOp(frame.getInjectGoalButton(), 		"injectGoal");
		linkActionEventToOp(frame.getInjectGoalPackButton(), 	"injectGoalPack");
	
		//Show the dialog window
		frame.setVisible(true);
	}
	
	
	/**
	 * Show a message dialog box.
	 * 
	 * @param windowTitle the title of the dialog window.
	 * @param msg the message to print within the dialog.
	 */
	private void showMessage(String windowTitle, String msg)
	{
        JOptionPane.showMessageDialog(frame, msg);
	}
	
	/**
	 * This is called when submit goal JButton has been clicked. It acts like a "bridge" between the JButton click event and the corresponding Jason event.
	 * @param ev
	 */
	@INTERNAL_OPERATION 
	void submitGoalToDB_Event(ActionEvent ev)
	{
		signal("submitGoalToDB");
	}
	
	/**
	 * Add a goal into the workflow database table "adw_goal". 
	 *
	 * @param name the name of the goal
	 * @param pack the pack of the goal
	 * @param description the description of the goal
	 */
	@SuppressWarnings("unchecked")
	@OPERATION
	void submitGoalToDatabase(String name, String pack, String description)
	{
		//Do nothing if user didn't write the necessary informations
		if( name.isEmpty() && pack.isEmpty() && description.isEmpty() )
		{
			showMessage("New goal","Can't submit an empty goal.");
			return;
		}
		
		//Create a new goal entity
		GoalEntity entity = new GoalEntity();
		entity.setPack( name );
		entity.setName( pack );
		entity.setGoalDescription( description );
		
		//Return if the entity is already in the database
		if( goalExistsInDatabase(entity) )
		{
			showMessage("Submit goal", "This goal has been already submitted to database.");
			return;
		}
		
		try 
		{
			GoalTable testTable = new GoalTable();
			
			//Insert the new goal into the database
			testTable.insertElement(entity);
			
			//Update the combo box with the new entity data
			String comboboxEntry = "ID: "+((GoalEntity)entity).getID()+" name: "+((GoalEntity)entity).getName()+
								   " pack: "+((GoalEntity)entity).getPack()+" description: "+((GoalEntity)entity).getGoalDescription();
			
			frame.getGoalsComboBox().addItem(comboboxEntry);
			
			//show an information message
			showMessage("New goal","Goal submitted!");
		} 
		catch (SQLException e) 
		{
			showMessage("New goal","An error occurred. (Error: "+e.getMessage()+")");
			e.printStackTrace();
		}
	}
	
	/**
	 * Check if the database contains the specified goal.
	 * 
	 * @return true if the database contains a record corresponding to the specified goal, false otherwise.
	 */
	private boolean goalExistsInDatabase(GoalEntity goal)
	{
		GoalTable testTable = new GoalTable();
		
		//Retrieve the goals from the db
		List<GoalEntity> goals = testTable.getAllGoals();
		
		//populate the combobox
		for(GoalEntity e : goals)
		{
			if(e.equals(goal))
				return true;
		}
		return false;
	}
	
}

