package gui;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;

public class InjectGoalPack {

	private JFrame frame;

//	/**
//	 * Launch the application.
//	 */
//	public static void main(String[] args) {
//		EventQueue.invokeLater(new Runnable() {
//			public void run() {
//				try {
//					InjectGoalPack window = new InjectGoalPack();
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
	public InjectGoalPack() {
		list_model = new DefaultListModel<String>();
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setBounds(100, 100, 463, 347);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		JLabel lblSelectAGoal = new JLabel("Select a goal pack");
		lblSelectAGoal.setBounds(12, 12, 197, 15);
		frame.getContentPane().add(lblSelectAGoal);
		
		packList = new JList<String>();
		packList.setBounds(12, 39, 424, 202);
		frame.getContentPane().add(packList);
		
		injectPackBtn = new JButton("Inject Pack");
		injectPackBtn.setBounds(319, 275, 117, 25);
		frame.getContentPane().add(injectPackBtn);
		
		cancelBtn = new JButton("Cancel");
		cancelBtn.setBounds(190, 275, 117, 25);
		cancelBtn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				frame.setVisible(false);
				
			}
		});
		frame.getContentPane().add(cancelBtn);
	}
	
	public JButton getInjectPackBtn() {
		return injectPackBtn;
	}

	public JList<String> getPackList() {
		return packList;
	}

	public JButton getCancelBtn() {
		return cancelBtn;
	}

	public DefaultListModel<String> getList_model() {
		return list_model;
	}
	
	public void addGoalPack(String packName)
	{
		if(list_model.contains(packName))
			return;
		
		this.list_model.addElement(packName);
		this.packList.setModel(list_model);
	}
	
	public void show()
	{
		frame.setVisible(true);
	}
	
	public String getSelectedPack()
	{
		if(packList.getSelectedIndex() < 0)
			return null;
		
		return list_model.getElementAt(packList.getSelectedIndex());
	}
	
	
	public void close()
	{
		frame.setVisible(false);
	}
	
	
	
	private JButton injectPackBtn;
	private JList<String> packList;
	private JButton cancelBtn;
	private DefaultListModel<String> list_model;
}
