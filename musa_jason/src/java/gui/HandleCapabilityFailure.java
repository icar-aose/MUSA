package gui;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import com.jgoodies.forms.layout.FormLayout;
import com.jgoodies.forms.layout.ColumnSpec;
import com.jgoodies.forms.layout.RowSpec;
import com.jgoodies.forms.factories.FormFactory;
import javax.swing.JLabel;
import javax.swing.JComboBox;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;

public class HandleCapabilityFailure extends JFrame {

	private JPanel contentPane;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					HandleCapabilityFailure frame = new HandleCapabilityFailure();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public HandleCapabilityFailure() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 585, 316);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblCay = new JLabel("Capability");
		lblCay.setBounds(42, 42, 71, 15);
		contentPane.add(lblCay);
		
		capabilityComboBox = new JComboBox();
		capabilityComboBox.setBounds(122, 38, 339, 24);
		contentPane.add(capabilityComboBox);
		
		JLabel lblFallisci = new JLabel("Fallisci");
		lblFallisci.setBounds(65, 73, 48, 15);
		contentPane.add(lblFallisci);
		
		comboBox_1 = new JComboBox();
		comboBox_1.setBounds(122, 69, 339, 24);
		comboBox_1.setModel(new DefaultComboBoxModel(new String[] {"true", "false"}));
		comboBox_1.setSelectedIndex(1);
		contentPane.add(comboBox_1);
		
		btnButton = new JButton("Set failure");
		btnButton.setBounds(353, 115, 108, 25);
		contentPane.add(btnButton);
	}
	
	
	public JButton getButton()
	{
		return this.btnButton;
	}
	
	public JComboBox getcapabilityComboBox()
	{
		return this.capabilityComboBox;
	}
	
	public JComboBox getFailureComboBox()
	{
		return this.comboBox_1;
	}
	
	private JButton btnButton;
	private JComboBox capabilityComboBox;
	private JComboBox comboBox_1;
}
