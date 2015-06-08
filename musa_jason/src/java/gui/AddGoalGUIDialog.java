package gui;

import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.ItemSelectable;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.Scanner;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JSeparator;
import javax.swing.JTextField;

@SuppressWarnings("serial")
/**
 * GUI for submitting new goals.
 * 
 * @author Davide Guastella
 */
public class AddGoalGUIDialog extends JFrame 
{
	private JTextField nameTextField;
	private JTextField packTextField;
	private JTextField descriptionTextField;
	private JButton btnSubmit, btnInjectSelection, btnInjectGoalPack;
	
	@SuppressWarnings("rawtypes")
	private JComboBox goalsInDBComboBox;
	
	/** The name of the goal selected in the combobox control. */
	private String selectedGoalName;
	
	/** The pack name of the goal selected in the combobox control. */
	private String selectedGoalPack;
	
	/** The description of the goal selected in the combobox control. */
	private String selectedGoalDescription;
	
	/**
	 * Return the text of the selected item in the combobox control.
	 */
	static private String selectedString(ItemSelectable is) 
	{
	    Object selected[] = is.getSelectedObjects();
	    return ((selected.length == 0) ? "" : (String) selected[0]);
	}
	
	/**
	 * Create the frame and initialize all controls.
	 */
	@SuppressWarnings("rawtypes")
	public AddGoalGUIDialog() 
	{
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 464, 322);
		getContentPane().setLayout(null);
		
		JLabel lblNewLabel = new JLabel("Goals in Database");
		lblNewLabel.setBounds(0, 0, 450, 32);
		getContentPane().add(lblNewLabel);
		
		
		goalsInDBComboBox = new JComboBox();
		goalsInDBComboBox.setBounds(0, 30, 450, 22);
		goalsInDBComboBox.addItemListener(new ItemListener() 
		{	
			public void itemStateChanged(ItemEvent itemEvent) 
			{
				String selectedItem = selectedString(itemEvent.getItemSelectable());		//Get the selected goal
				Scanner sc = new Scanner(selectedItem);
				sc.useDelimiter("\\S*(ID:|name:|pack:|description:)\\S*");					//Get the goal data (name,pack,description and id)
				
				sc.next();				 	//Ignore ID 
				selectedGoalName 			= sc.next();
				selectedGoalPack 			= sc.next();
				selectedGoalDescription 	= sc.next();
				
				sc.close();
				
				//Remove white spaces
				selectedGoalName.replaceAll("\\s", "");

				//TODO trovare una soluzione pi� ragionevole...
				String s = "";
				for(int i=0;i<selectedGoalPack.length(); i++)
				{
					if(selectedGoalPack.charAt(i) != (char)32)
						s = s + selectedGoalPack.charAt(i);
				}
				selectedGoalPack = s;
			}
		});
		getContentPane().add(goalsInDBComboBox);
		
		JSeparator separator = new JSeparator();
		separator.setBounds(0, 97, 450, 12);
		separator.setMaximumSize(new Dimension(200, 10));
		getContentPane().add(separator);
		
		JLabel lblNewLabel_1 = new JLabel("Submit new goal");
		lblNewLabel_1.setBounds(0, 97, 450, 32);
		getContentPane().add(lblNewLabel_1);
		
		JPanel dataPanel = new JPanel();
		dataPanel.setBounds(0, 130, 450, 76);
		getContentPane().add(dataPanel);
		GridLayout gl_dataPanel = new GridLayout(3, 2);
		gl_dataPanel.setVgap(4);
		dataPanel.setLayout(gl_dataPanel);
		
		JLabel lblNewLabel_2 = new JLabel("Name");
		dataPanel.add(lblNewLabel_2);
		
		nameTextField = new JTextField();
		dataPanel.add(nameTextField);
		nameTextField.setColumns(10);
		
		JLabel lblNewLabel_4 = new JLabel("Pack");
		dataPanel.add(lblNewLabel_4);
		
		packTextField = new JTextField();
		dataPanel.add(packTextField);
		packTextField.setColumns(10);
		
		JLabel lblNewLabel_3 = new JLabel("Description");
		dataPanel.add(lblNewLabel_3);
		
		descriptionTextField = new JTextField();
		dataPanel.add(descriptionTextField);
		descriptionTextField.setColumns(10);
		
		JPanel btnPanel = new JPanel();
		btnPanel.setBounds(0, 212, 450, 31);
		getContentPane().add(btnPanel);
		btnPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
		
		btnSubmit = new JButton("Submit to system");
		btnPanel.add(btnSubmit);
		
		JPanel panel = new JPanel();
		panel.setBounds(0, 58, 450, 32);
		getContentPane().add(panel);
		
		btnInjectSelection = new JButton("Inject selection");
		panel.add(btnInjectSelection);
		
		btnInjectGoalPack = new JButton("Inject goal pack");
		panel.add(btnInjectGoalPack);
		
		JButton btnGoalInfo = new JButton("Goal Information");
		btnGoalInfo.addActionListener(new ActionListener() 
		{
			public void actionPerformed(ActionEvent arg0) 
			{
				showSelectedGoalInfo();
			}
		});
		panel.add(btnGoalInfo);
		
		JButton btnQuit = new JButton("Quit");
		btnQuit.setBounds(361, 254, 89, 23);
		getContentPane().add(btnQuit);
		btnQuit.addActionListener(new ActionListener() 
		{	
			public void actionPerformed(ActionEvent arg0) 
			{
				System.exit(0);	
			}
		});
		
		JSeparator separator_1 = new JSeparator();
		separator_1.setBounds(0, 246, 450, 12);
		getContentPane().add(separator_1);
	}
	
	@SuppressWarnings("rawtypes")
	public JComboBox getGoalsComboBox()
	{
		return goalsInDBComboBox;
	}
	
	public JButton getSubmitButton()
	{
		return btnSubmit;
	}
	

	public JButton getInjectGoalButton()
	{
		return btnInjectSelection;
	}
	

	public JButton getInjectGoalPackButton()
	{
		return btnInjectGoalPack;
	}
	
	
	/** Return the name of the last submitted goal.*/
	public String getNewGoalName()
	{
		return nameTextField.getText();
	}
	
	/** Return the pack of the last submitted goal.*/
	public String getNewGoalPack()
	{
		return packTextField.getText();
	}
	
	/** Return the description of the last submitted goal.*/
	public String getNewGoalDescription()
	{
		return descriptionTextField.getText();
	}
	
	/**
	 * Return the name of the goal selected in the combobox control of this window.
	 */
	public String getSelectedGoalName()
	{
		return this.selectedGoalName;
	}
	
	/**
	 * Return the pack name of the goal selected in the combobox control of this window.
	 */
	public String getSelectedGoalPack()
	{
		return this.selectedGoalPack;
	}
	
	/**
	 * Return the description of the goal selected in the combobox control of this window.
	 */
	public String getSelectedGoalDescription()
	{
		return this.selectedGoalDescription;
	}
	
	/**
	 * Show a dialog window where are printed the informations about the current selected goal.
	 */
	private void showSelectedGoalInfo()
	{
		String s = "Name: "+ selectedGoalName+"\nPack: "+selectedGoalPack+"\nDescription: "+selectedGoalDescription;
		JOptionPane.showMessageDialog(this, s);
	}
}
