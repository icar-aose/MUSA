// CArtAgO artifact code for project musa_jason

package ids.artifact;

import gui.InjectGoalPack;
import gui.MusaConfigGUI;
import gui.goalSPECparameterGUI;
import ids.database.GoalTable;
import ids.model.Entity;
import ids.model.GoalEntity;
import jason.architecture.AgArch;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Term;
import jason.asSyntax.parser.ParseException;
import jason.mas2j.AgentParameters;
import jason.mas2j.ClassParameters;
import jason.mas2j.MAS2JProject;

import java.awt.Dimension;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.swing.ImageIcon;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.UIManager;
import javax.swing.event.ListSelectionEvent;

import workflow_property.MusaProperties;
import c4jason.CartagoEnvironment;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import cartago.tools.GUIArtifact;

/**
 * 
 * @author Davide Guastella
 */
public class MusaConfigGUIArtifact extends GUIArtifact
{
	private MusaConfigGUI gui;
//	private HashMap<String,String> goalSPECparamTable;
	private ListTerm injectedJasonGoals;
	private boolean database_is_configured = false;
	private goalSPECparameterGUI paramGui;
	private InjectGoalPack injectPackGUI;
	
	
	@OPERATION
	void setDatabaseIsConfigured(Boolean v)
	{
		database_is_configured = v;
	}
	
	/**
	 * Load all the goals from the table "adw_goal" into the database, and for each record
	 * insert a row into the goal's combo box control containing its data. 
	 */
	@SuppressWarnings("unchecked")
	private void loadGoalSPECFromDB() 
	{
		gui.clearGoalSPEClist();
		
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
				
				gui.addGoalSPEC(comboboxEntry);				
			}
		} 
		catch (SQLException e) {e.printStackTrace();}
	}
	
	/**
	 * This is called when inject goal JButton has been clicked. It acts like a "bridge" between the JButton click event and the corresponding Jason event.
	 * @param ev
	 */
	@OPERATION 
	void injectGoalSPEC(ActionEvent ev)
	{
		if( 	gui.getSelectedGoalName() 			== null 		||
				gui.getSelectedGoalPack()  			== null 		||
				gui.getSelectedGoalDescription() 	== null)
			{
				return;
			}
		
		paramGui.show();
		
		
		
	}
	
	@OPERATION
	private void onInjectGoalSPEC(ActionEvent ev)
	{
		HashMap<String,String> params 	= paramGui.getParams();
		Iterator<String> it 			= params.keySet().iterator();		
		StringBuilder stringBuilder 	= new StringBuilder();
		stringBuilder.append("parlist([");
		
		while (it.hasNext()) 
		{
			String key = it.next();
			String value = params.get(key);
			
			stringBuilder.append("par(");
			stringBuilder.append(key);
			stringBuilder.append(",");
			stringBuilder.append(value);
			stringBuilder.append(")");
			
			if(it.hasNext())
				stringBuilder.append(",");
		}
		
		stringBuilder.append("])");		
		String paramListString = stringBuilder.toString();
		
		//Add a new belief to the observer agent to inform him about a goal that must be injected
		defineObsProperty("goalToInject", gui.getSelectedGoalName(), gui.getSelectedGoalPack(), gui.getSelectedGoalDescription(), paramListString);
		
		paramGui.close();
	}
	
	/**
	 * Remove the current selected goal in combobox (goalSPEC tab)
	 */
	@INTERNAL_OPERATION 
	void removeSelectedGoal(ActionEvent ev)
	{
		String name 		= gui.getSelectedGoalName();
		String pack 		= gui.getSelectedGoalPack();
		GoalTable goaltable = new GoalTable();
		
		try 
		{
			Entity e =  goaltable.findOneBy("pack", pack, "name", name);
			
			if (e == null)
				return;
			
			goaltable.deleteOneByID( ((GoalEntity)e).getID() );
			
			gui.removeSelectedGoalSPEC();
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * Show a dialog window where are printed the informations about the current selected goal.
	 */
	@INTERNAL_OPERATION 
	void showSelectedGoalInfo(ActionEvent ev)
	{
		gui.showCurrentSelectedGoalInfo();
	}
	
	/**
	 * Inject a goal pack
	 */
	@INTERNAL_OPERATION 
	void injectGoalPack(ActionEvent ev)
	{
		//....
		
	}
	
	/**
	 * Load the MUSA database configuration from a file. 
	 */
	public static void setDBfromConfigFile(String configFileName)
	{
		FileInputStream file_stream = null;
		
		try 								{file_stream = new FileInputStream(configFileName);} 
		catch (FileNotFoundException e1) 	{e1.printStackTrace();}
		
		if(file_stream == null)
		{
			JOptionPane.showMessageDialog(null, "Error loading file: "+configFileName);
			return;
		}
		
		Properties prop = new Properties();
		try 
		{
			prop.load( file_stream );

			MusaProperties.setWorkflow_db_ip(prop.getProperty("ip_address"));
			MusaProperties.setWorkflow_db_port(prop.getProperty("port"));
			MusaProperties.setWorkflow_db_name(prop.getProperty("database"));
			MusaProperties.setWorkflow_db_user(prop.getProperty("user"));
			MusaProperties.setWorkflow_db_userpass(prop.getProperty("password"));	
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}
	
	private String chooseFile()
	{
		JFileChooser fileChooser = new JFileChooser();
        int returnValue = fileChooser.showOpenDialog(null);
        
        if (returnValue == JFileChooser.APPROVE_OPTION) 
        {
        	File selectedFile = fileChooser.getSelectedFile();
        	return selectedFile.getAbsolutePath();
        }
        else
        	return null;
	}
	
	@OPERATION
	void setGuiDbTextFieldToCurrentConfiguration()
	{
		gui.getDbIptextField().setText(MusaProperties.getWorkflow_db_ip());
		gui.getDbPortTextField().setText(MusaProperties.getWorkflow_db_port());
		gui.getDbNameTextField().setText(MusaProperties.getWorkflow_db_name());
		gui.getDbUserTextField().setText(MusaProperties.getWorkflow_db_user());
		gui.getDbPasswordTextField().setText(MusaProperties.getWorkflow_db_userpass());
	}
	
	
	/**
	 * Load the default database configuration (from ~./musa/config.properties),
	 * if the configuration file exists.
	 */
	@OPERATION
	void loadDefaultDatabaseConfiguration(OpFeedbackParam<Boolean> success)
	{
		String currentUsersHomeDir 	= System.getProperty("user.home");
		String musa_tmp_folder 		= currentUsersHomeDir + File.separator + ".musa";
		String config_filename 		= musa_tmp_folder+File.separator+"config.properties";
		File config_file 			= new File(config_filename);
		
		if(config_file.exists())
		{
			setDBfromConfigFile(config_filename);
			
			setGuiDbTextFieldToCurrentConfiguration();
			
//			database_is_configured = true;
			success.set(true);
			System.out.println("Loaded default db configuration.");
			
			loadGoalSPECFromDB();
		}
		else
		{
			success.set(false);
			System.out.println("No default configuration file found.");
		}
	}
	
	@OPERATION
	void loadHardCodedDatabaseConfiguration(String User, String port, String pass, String dbName, String database_ip)
	{
		MusaProperties.setWorkflow_db_user(User);
		MusaProperties.setWorkflow_db_port(port);
		MusaProperties.setWorkflow_db_userpass(pass);
		MusaProperties.setWorkflow_db_name(dbName);
		MusaProperties.setWorkflow_db_ip(database_ip);
		
		setGuiDbTextFieldToCurrentConfiguration();	
//		database_is_configured = true;
		
		loadGoalSPECFromDB();
		System.out.println("Loaded default (hard-coded) db configuration.");		
	}
	
	
	/**
	 * Configure the MUSA database using the user specified data into the GUI.
	 */
	@INTERNAL_OPERATION 
	void setDBConfigAsDefault(ActionEvent ev)
	{
		String currentUsersHomeDir 	= System.getProperty("user.home");
		String musa_tmp_folder 		= currentUsersHomeDir + File.separator + ".musa";
		
		File dir = new File(musa_tmp_folder);
		dir.mkdir();
		
		StringBuilder configFileStringBuilder = new StringBuilder();
		configFileStringBuilder.append("#"+getCurrentTimestamp()+"\n");
		configFileStringBuilder.append("user="+ MusaProperties.getWorkflow_db_user()+"\n");
		configFileStringBuilder.append("port="+ MusaProperties.getWorkflow_db_port()+"\n");
		configFileStringBuilder.append("password="+ MusaProperties.getWorkflow_db_userpass()+"\n");
		configFileStringBuilder.append("database="+ MusaProperties.getWorkflow_db_name()+"\n");
		configFileStringBuilder.append("ip_address="+ MusaProperties.getWorkflow_db_ip());
		
		byte[] cfgFileContent = configFileStringBuilder.toString().getBytes();
		
		String outFileName = musa_tmp_folder+File.separator+"config.properties";
		
		try 
		{
			FileOutputStream out = new FileOutputStream(outFileName);
			out.write(cfgFileContent);
			out.close();

			JOptionPane.showMessageDialog(gui, "Default database configuration saved to ~/.musa/config.properties");
		} 
		catch (IOException e) {e.printStackTrace();}		
	}
	
	
	
	private String getCurrentTimestamp()
	{
		Calendar calendar = Calendar.getInstance();
		java.util.Date now = calendar.getTime();
		return new java.sql.Timestamp(now.getTime()).toString();
	}
	
	
	/**
	 * Let the user choose a database configuration file from the local machine.
	 * 
	 * @param ev
	 */
	@INTERNAL_OPERATION 
	void ChooseConfigFile(ActionEvent ev)
	{
		String filename = chooseFile();
		
		if(filename != null)
		{
			gui.getConfigFilePathTextField().setText(filename);
			setDBfromConfigFile(filename);

			setGuiDbTextFieldToCurrentConfiguration();
			
			JOptionPane.showMessageDialog(gui, "Database configured from file");
		}
	}
	
	/**
	 * Start MUSA
	 */
	@INTERNAL_OPERATION 
	void startMUSA(ActionEvent ev)
	{
//		if(!database_is_configured)
//		{
//			JOptionPane.showMessageDialog(gui, "Please configure MUSA database first.");
//			return;
//		}
		UIManager.put("OptionPane.minimumSize",new Dimension(650,80)); 
		String s = (String)JOptionPane.showInputDialog("Please insert parameters list", "[param(user_message,\"Fallito\"),param(userAccessToken,\"poS0fEDTJ1AAAAAAAAAAPlo48ljrLSP-uRtjHE2zva9z3yY1rH9SsFkOXYwefliR\"),param(idOrder,\"0\"),param(mailUser,\"musa.customer.service@gmail.com\"),param(idUser,\"116\")]");		
		
		if(s != null)
			signal("start_musa_organization", s);
	}
	
	/**
	 * Stop MUSA
	 */
	@INTERNAL_OPERATION 
	void stopMUSA(ActionEvent ev)
	{
		//....
		
		
	}
	
	/**
	 * 
	 */
	@INTERNAL_OPERATION 
	void launchGoalFusionUI(ActionEvent ev)
	{
		//[TODO, non ora...]
	}
	
	
	/**
	 * Configure the MUSA database using the user specified data into the GUI.
	 */
	@INTERNAL_OPERATION
	void submitDBconfiguration(ActionEvent ev)
	{
		String ip 			= gui.getDbIptextField().getText();
		String port 		= gui.getDbPortTextField().getText();
		String db_name 		= gui.getDbNameTextField().getText();
		String user 		= gui.getDbUserTextField().getText();
		String pass 		= gui.getDbPasswordTextField().getText();
		
		MusaProperties.setWorkflow_db_ip(ip);
		MusaProperties.setWorkflow_db_port(port);
		MusaProperties.setWorkflow_db_name(db_name);
		MusaProperties.setWorkflow_db_user(user);
		MusaProperties.setWorkflow_db_userpass(pass);

		//TODO
//		loadGoalsFromDB();
		
		signal("updateLocalHost");
		
		database_is_configured = true;
		JOptionPane.showMessageDialog(gui, "Database configured.");
	}
	
	/**
	 * Parse the jason goals written by user into the specific text area in "Jason" tab
	 * in this window. Each goal found is parsed and added into a global ListTerm container.
	 * 
	 * @param ev
	 * @throws ParseException
	 */
	@OPERATION
	private void injectJasonGoalPack(ActionEvent ev)
	{
		String lines[] 		= gui.getJasonBeliefTextArea().getText().split("\\r?\\n");
		String belief 		= "";
		Term beliefTerm 	= null;
		
		for(String line : lines)
		{
			if(line.length()!=0 && !line.startsWith("//"))
			{
				belief = line.substring(0,line.length()-1);
				try 
				{
					beliefTerm = ASSyntax.parseTerm(belief);
				} 
				catch (ParseException e) 
				{
					System.out.println("\""+belief+"\" cannot be parsed.");
					beliefTerm = null;
				}
				
				if(beliefTerm != null)
				{
					if(!injectedJasonGoals.contains(beliefTerm))					
						injectedJasonGoals.add(beliefTerm);
				}
			}
			
		}
		//Add a belief to the observer agent. The plan triggered is responsible
		//for gathering the parsed goals and communicating to all agents.
//		this.defineObsProperty("injectJasonGoals");
		signal("injectJasonGoals", injectedJasonGoals );
		
		JOptionPane.showMessageDialog(gui, "Goals injected correctly");
	}
	
	
	/**
	 * Return the list of parsed jason goals
	 * 
	 * @param goals
	 */
	@OPERATION
	private void getInjectedJasonGoals(OpFeedbackParam<ListTerm> goals)
	{
		goals.set(this.injectedJasonGoals);
	}
	
	
	/**
	 * Check if the database contains the specified goal.
	 * 
	 * @return true if the database contains a record corresponding to the specified goal, false otherwise.
	 */
	private boolean goalExistsInDatabase(GoalEntity goal)
	{
		System.out.println("eccomi");
		
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
	
	/**
	 * Add a user specified GoalSPEC goal into the MUSA database.
	 */
	@OPERATION
	void addGoalSPECGoalToDB(ActionEvent evt)
	{
		System.out.println("ECCOMI");
		String name 		= gui.getGoalNameTextField().getText();
		String pack 		= gui.getGoalPackTextField().getText();
		String description	= gui.getGoalDescriptionTextField().getText();
		
		//Do nothing if user didn't write the necessary informations
		if( name.isEmpty() && pack.isEmpty() && description.isEmpty() )
		{
			JOptionPane.showMessageDialog(gui, "Goal cannot be injected: missing informations.");
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
			JOptionPane.showMessageDialog(gui, "Goal "+name+" is already in database.");
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
			
			
			gui.addGoalSPEC(comboboxEntry);
			//gui.getGoalsComboBox().addItem(comboboxEntry);			
			JOptionPane.showMessageDialog(gui, "Goal ["+name+"] added in database");
		} 
		catch (SQLException e) 
		{
			JOptionPane.showMessageDialog(gui,"An error occurred. (Error: "+e.getMessage()+")");
			e.printStackTrace();
		}
	}
	
	/**
	 * Load a goal pack from a file and put it into the text area for jason goals 
	 * in this window.
	 * 
	 * @param ev
	 */
	@OPERATION
	private void loadJasonPackFromFile(ActionEvent ev)
	{
		BufferedReader in 	= null;
		String str			= null;
		String filename 	= chooseFile();
		
		if(filename == null)
			return;
		
		try 
		{
			gui.clearJasonGoalsTextArea();
			in = new BufferedReader(new FileReader(filename));
			
			while ((str = in.readLine()) != null)
				gui.getJasonBeliefTextArea().append(str+"\n");
		} 
		catch (IOException e) {e.printStackTrace();} 
		finally 
		{    
			try { in.close(); } catch (Exception ex) {ex.printStackTrace(); }
		}
	}
	
	
	/**
	 * Show a message dialog containing various informations about MUSA.
	 * 
	 * @param ev
	 */
	@OPERATION
	private void showMUSAinfo(ActionEvent ev)
	{
		String msg = 	"<html>"+
						"<center>"+
						"<b>~~~ MUSA ~~~</b><br><br>"+
						"MUSA control panel developed by Davide Guastella<br>"+
						"MUSA workflow management system developed by<br>"+
						"Davide Guastella and Luca Sabatucci (ICAR-CNR)<br>"+
						"under the supervision of Massimo Cossentino (ICAR-CNR)<br><br>"+
						"Contacts: <i>sabatucci<b>_AT_</b>pa.icar.cnr.it</i>, <i>cossentino<b>_AT_</b>pa.icar.cnr.it</i>,<br> <i>davide.guastella90<b>_AT_</b>gmail.com</i>"+
						"</center>"+
						"</html>";
		
		java.net.URL imgUrl = ClassLoader.getSystemResource("img/MUSA_LOGO.png");
		ImageIcon icon = new ImageIcon(imgUrl);
		
		JLabel label = new JLabel(msg);
        label.setFont(new Font("Arial", Font.PLAIN, 14));
        JOptionPane.showMessageDialog(gui, label, "About MUSA", JOptionPane.INFORMATION_MESSAGE, icon);
	}
	
	/**
	 * Let the user to choose a goal pack to merge with another one (Goal fusion tab)
	 */
	@OPERATION
	private void loadGoalPackA(ActionEvent ev)
	{
		BufferedReader in 	= null;
		String filename 	= chooseFile();
		String str;
		
		if(filename == null)
			return;
		
		try 
		{
			in = new BufferedReader(new FileReader(filename));
			
			while ((str = in.readLine()) != null)
				gui.getGoalTextArea_A().append(str+"\n");
		} 
		catch (IOException e) {e.printStackTrace();} 
		finally 
		{    
			try { in.close(); } catch (Exception ex) {ex.printStackTrace(); }
		}
	}
	
	/**
	 * Let the user to choose a goal pack to merge with another one (Goal fusion tab)
	 */
	@OPERATION
	private void loadGoalPackB(ActionEvent ev)
	{
		BufferedReader in 	= null;
		String filename 	= chooseFile();
		String str;
		
		if(filename == null)
			return;
		
		try 
		{
			in = new BufferedReader(new FileReader(filename));
			
			while ((str = in.readLine()) != null)
				gui.getGoalTextArea_B().append(str+"\n");
		} 
		catch (IOException e) {e.printStackTrace();} 
		finally 
		{    
			try { in.close(); } catch (Exception ex) {ex.printStackTrace(); }
		}
	}
	
	@OPERATION
	private void mergeGoalPacksAndInject(ActionEvent ev)
	{
		
	}
	
	@OPERATION
	private void mergeGoalPacksAndSaveToFile(ActionEvent ev)
	{
		
	}
	
	@OPERATION
	void quitMUSA(ActionEvent ev)
	{
		System.exit(0);
	}
	
	
	/**
	 * Inject a goalSPEC goal pack
	 * @param evt
	 */
	@OPERATION
	void injectGoalSPECPack(ActionEvent evt)
	{
		GoalTable table = new GoalTable();
		
		try 
		{
			List<Entity> goals = table.getAll();
			for(Entity e : goals)
				injectPackGUI.addGoalPack( ((GoalEntity)e).getPack() );
			
			injectPackGUI.show();
		} 
		catch (SQLException e) {e.printStackTrace();}	
	}
	
	/**
	 * Auxiliary method for injectGoalSPECPack([...]) method. This inject
	 * a goalSPEC pack into MUSA
	 * @param ev
	 */
	@OPERATION
	void doInjectGoalSPECPack(ActionEvent ev)
	{
		String selectedPack = injectPackGUI.getSelectedPack();
		GoalEntity g;
		
		if(selectedPack == null)
			return;
		
		try 
		{
			for(Entity goal : new GoalTable().getAll())
			{
				g = ((GoalEntity)goal);

				if(g.getPack().equals(selectedPack))
					defineObsProperty("goalToInject", g.getName(), g.getPack(), g.getGoalDescription(), "parlist([])");
			}
			defineObsProperty("createDepartmentForInjectedGoalPack", selectedPack);
		} 
		catch (SQLException e1) {e1.printStackTrace();}
		
		injectPackGUI.close();
	}
	
	/**
	 * Method invoked when the button "Add new agent" is clicked. This
	 * lets the user to add a new agent into MUSA.
	 * 
	 * @param evt
	 */
	@OPERATION
	void addNewAgent(ActionEvent evt)
	{
		String filename_path	= chooseFile();
		
		if(filename_path == null)
			return;
		
		File f 					= new File(filename_path);
		String agName 			= f.getName().substring(0, f.getName().lastIndexOf("."));
		gui.addAgent(agName);
		CartagoEnvironment ce = new CartagoEnvironment();
		
		defineObsProperty("addNewAgent", agName, filename_path );	
	}
	
	
	private List <String> getAgentList() 
	{
		List < String > names = new ArrayList < String > ();
		InputStream is = null;
		try 
		{
			is = ClassLoader.getSystemResource("musa_jason.mas2j").openStream();
		} 
		catch (IOException e) {e.printStackTrace();}

		jason.mas2j.parser.mas2j parser = new jason.mas2j.parser.mas2j(is);
		MAS2JProject project;
		
		try 
		{
			project = parser.mas();
			
			// get the names from the project
			for (AgentParameters ap: project.getAgents()) 
			{
				String agName = ap.name;

				for (int cAg = 0; cAg < ap.getNbInstances(); cAg++) 
				{
					String numberedAg = agName;
					if (ap.getNbInstances() > 1) numberedAg += (cAg + 1);

					names.add(numberedAg);
				}
			}

		} 
		catch (jason.mas2j.parser.ParseException e) 
		{
			e.printStackTrace();
		}

		return names;
	}
	
	
	/**
	 * This method is invoked when an agent is selected from the agent JList control
	 * in MUSA startup panel
	 * @param evt
	 */
	@OPERATION
	void AgentSelectedFromList(ListSelectionEvent evt)
	{
		gui.clearCapabilityList();
		String ag = (String) gui.getAgentList().getSelectedValue();
		signal("request_for_agent_capability", ag);
	}
	
	
	/**
	 * Add the capability set of the selected agent into the capability list.
	 * 
	 * This operation is invoked from the boss agent who has collected the capability list for the
	 * agent selected in the agent list (in MUSA startup panel).
	 * 
	 * @param CS_str
	 */
	@OPERATION
	void set_cs_into_configuration_gui(String CS_str)
	{
		ListTerm CS = ListTermImpl.parseList(CS_str);
		for (Term t : CS)
			gui.addCapability(t.toString());
		
		gui.refreshCapabilityList();
	}
	
	/**
	 * Link the controls events to the operation that must be invoked 
	 */
	private void linkGUIControlEvents()
	{
		//Goal Jason tab
		linkActionEventToOp(gui.getInjectJasonBtn(), "injectJasonGoalPack");
		linkActionEventToOp(gui.getLoadJasonFromFileBtn(), "loadJasonPackFromFile");
		
		
		//goalSPEC tab
		linkActionEventToOp(gui.getInjectGoalBtn(), "injectGoalSPEC");
		linkActionEventToOp(gui.getRemoveGoalBtn(), "removeSelectedGoal");
		linkActionEventToOp(gui.getGoalInfoBtn(), "showSelectedGoalInfo");
		linkActionEventToOp(gui.getInjectPackBtn(), "injectGoalSPECPack");
		linkActionEventToOp(gui.getAddGoalToDbbtn(), "addGoalSPECGoalToDB");
		
		//Database tab
		linkActionEventToOp(gui.getsubmitDBconfigBtn(), "submitDBconfiguration");
		linkActionEventToOp(gui.getSetDBconfigAsDefault(), "setDBConfigAsDefault");
		linkActionEventToOp(gui.getChooseCfgFileBtn(), "ChooseConfigFile");
		
		
		//MUSA startup tab
		linkActionEventToOp(gui.getStartMUSABtn(), "startMUSA");
		linkActionEventToOp(gui.getStopMUSABtn(), "stopMUSA");
		
		//Goal fusion
		linkActionEventToOp(gui.getLoadPackABtn(), "loadGoalPackA");
		linkActionEventToOp(gui.getLoadPackBBtn(), "loadGoalPackB");
		linkActionEventToOp(gui.getMergeAndInjectGoalsBtn(), "mergeGoalPacksAndInject");
		linkActionEventToOp(gui.getMergeAndSaveBtn(), "mergeGoalPacksAndSaveToFile");
		
		//Main window
		linkActionEventToOp(gui.getAboutMUSAbtn(), "showMUSAinfo");
		linkActionEventToOp(gui.getQuitBtn(), "quitMUSA");
		
		
		linkActionEventToOp(gui.getAddNewAgentBtn(), "addNewAgent");
		linkListSelectionEventToOp(gui.getAgentList(), "AgentSelectedFromList");
		
		linkActionEventToOp(paramGui.getInjectBtn(), "onInjectGoalSPEC");
	}
	
	/**
	 * Setup this artifact
	 */
	public void setup()
	{
		getAgentList();
		gui = new MusaConfigGUI();
		injectedJasonGoals = new ListTermImpl();
//		goalSPECparamTable = new HashMap<String,String>();
		paramGui = new goalSPECparameterGUI();
		
		injectPackGUI = new InjectGoalPack();
		linkActionEventToOp(injectPackGUI.getInjectPackBtn(), "doInjectGoalSPECPack");
		
		
		List<String> agents = getAgentList();
		for(String s : agents)
		{
			gui.addAgent(s);
		}
		
		
		linkGUIControlEvents();
		
		gui.setVisible(true);
	}

	
	
}

