package gui;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.HashMap;
import java.util.Vector;

import javax.swing.DefaultListModel;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JTextField;

import cartago.OPERATION;

public class goalSPECparameterGUI {

	private JFrame frame;
	private HashMap<String,String> goalSPECparamTable;
//	/**
//	 * Launch the application.
//	 */
//	public static void main(String[] args) {
//		EventQueue.invokeLater(new Runnable() {
//			public void run() {
//				try {
//					goalSPECparameterGUI window = new goalSPECparameterGUI();
//					window.frame.setVisible(true);
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//		});
//	}

	/**
	 * Create the application.
	 */
	public goalSPECparameterGUI() 
	{
		goalSPECparamTable = new HashMap<String,String>();
		goalSPECparamListModel = new DefaultListModel();
		initialize();
		
	}
	
	public void show()
	{
		if(frame != null)
		{
		
			frame.setVisible(true);
		}
	}
	
	public void close()
	{
		frame.setVisible(false);
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setBounds(100, 100, 491, 370);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		goalSPECparamList = new JList();
		goalSPECparamList.setBounds(12, 39, 459, 97);
		frame.getContentPane().add(goalSPECparamList);
		
		addParamBtn = new JButton("Add parameter");
		addParamBtn.setBounds(23, 238, 216, 25);
		addParamBtn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				addGoalSPECparameter();
			}
		});
		frame.getContentPane().add(addParamBtn);
		
		removeParamBtn = new JButton("Remove parameter");
		removeParamBtn.setBounds(255, 238, 216, 25);
		removeParamBtn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				removeGoalSPECparameter();
			}
		});
		frame.getContentPane().add(removeParamBtn);
		
		JLabel lblGoalParameters = new JLabel("Goal parameters");
		lblGoalParameters.setBounds(12, 12, 255, 15);
		frame.getContentPane().add(lblGoalParameters);
		
		injectBtn = new JButton("Inject");
		injectBtn.setBounds(354, 294, 117, 25);
		frame.getContentPane().add(injectBtn);
		
		cancelBtn = new JButton("Cancel");
		cancelBtn.setBounds(225, 294, 117, 25);
		cancelBtn.addActionListener(new ActionListener() 
		{			
			@Override
			public void actionPerformed(ActionEvent e) {
				frame.setVisible(false);
				frame.dispose();
			}
		});
		frame.getContentPane().add(cancelBtn);
		
		JLabel lblVanName = new JLabel("Parameter name");
		lblVanName.setBounds(12, 164, 161, 15);
		frame.getContentPane().add(lblVanName);
		
		JLabel lblVarValue = new JLabel("Parameter value");
		lblVarValue.setBounds(12, 191, 133, 15);
		frame.getContentPane().add(lblVarValue);
		
		paramNameTextField = new JTextField();
		paramNameTextField.setBounds(208, 162, 263, 19);
		frame.getContentPane().add(paramNameTextField);
		paramNameTextField.setColumns(10);
		
		paramValTextField = new JTextField();
		paramValTextField.setBounds(208, 189, 263, 19);
		frame.getContentPane().add(paramValTextField);
		paramValTextField.setColumns(10);
	}
	
	
	private void addGoalSPECparameter()
	{
		String var_name 	= paramNameTextField.getText();
		String var_value 	= paramValTextField.getText();

		if(var_name.isEmpty() || var_value.isEmpty())
			return;
		
		goalSPECparamTable.put(var_name, var_value);
		goalSPECparamListModel.addElement("Var ["+var_name+"],Value ["+var_value+"]");
		goalSPECparamList.setModel(goalSPECparamListModel);
		
		paramNameTextField.setText("");
		paramValTextField.setText("");
	}
	
	/**
	 * Remove a selected parameter for a goalSPEC goal.
	 * 
	 * @param goals
	 */
	private void removeGoalSPECparameter()
	{
		int selected_index = -1;
		if( (selected_index = goalSPECparamList.getSelectedIndex()) < 0)
			return;
					
		//Parse the JList selected item to gather the var name
		String itemToRemove 	= goalSPECparamListModel.getElementAt(selected_index).toString();
		String[] splittedItem 	= itemToRemove.split(",");
		
		for(String s : splittedItem)
		{
			if(!(s.startsWith("Var [")))
				continue;
			
			String var_name = s.substring("Var [".length(), s.length()-1);
			
			//Remove from the param hashmap
			goalSPECparamTable.remove(var_name);
			break;
		}
		
		//Remove from the JList control
		goalSPECparamListModel.removeElementAt(selected_index);
		goalSPECparamList.setModel(goalSPECparamListModel);
	}
	
	public HashMap<String,String> getParams()
	{
		return this.goalSPECparamTable;
	}
	
	public JButton getInjectBtn() 
	{
		return injectBtn;
	}
	
	private JButton cancelBtn;
	private JButton addParamBtn;
	private JButton removeParamBtn;
	private JButton injectBtn;
	

	private JTextField paramNameTextField;
	private JTextField paramValTextField;
	private JList goalSPECparamList;
	private DefaultListModel	goalSPECparamListModel;
	
	
}
