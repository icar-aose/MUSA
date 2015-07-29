package musa.artifact;

import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;

import musa.database.DepartmentTable;
import cartago.*;

public class Organization extends Artifact {
	private String head;
	private Members employee_set = new Members();
	private Hashtable<String, Department> dpt_table = new Hashtable<String, Department>();
	
	private class Members extends HashSet<String> implements c4jason.ToProlog {

		public String getAsPrologStr() {
			String string_list = new String();
			Iterator<String> it = this.iterator();
			string_list += "[";
			int i=0;
			while (it.hasNext()) {
				if (i>0) {
					string_list += ",";
				}
				string_list += it.next();
				
				i++;
			}
			string_list += "]";
			return string_list;
		}
		
	}
	
	private class Department {
		private String name = null;
		private String pack = null;
		
		private String manager = null;
		private Members employee_set = new Members();
		
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getPack() {
			return pack;
		}
		public void setPack(String pack) {
			this.pack = pack;
		}
		public String getManager() {
			return manager;
		}
		public boolean setManager(String manager) {
			boolean op = true;
			
			// first come...
			if (this.manager == null)
				this.manager = manager;
			else
				op=false;
			
			return op;
		}
		public Members getEmployeeSet() {
			return employee_set;
		}

	
	}
	
	void init(String myname) {
		System.out.println("Organization created by: "+myname);
		head = myname;
	}
	
	@OPERATION
	void subscribe(String myname) {
		employee_set.add(myname);
		//System.out.println("New member: "+myname);
	}

	@OPERATION
	void unsubscribe(String myname) {
		employee_set.remove(myname);
		//System.out.println("Deleted member: "+myname);
	}

	@OPERATION
	void getHead(OpFeedbackParam<String> thehead) {
		thehead.set(head);
	}

	@OPERATION
	void getEmployees(OpFeedbackParam<Members> employees) {
		employees.set(employee_set);
	}
	
	
	@OPERATION
	void createDepartment(String dpt_name, String goal_pack) {
		Department dpt = new Department();
		dpt.setName(dpt_name);
		dpt.setPack(goal_pack);
		
		dpt_table.put(goal_pack, dpt);	//Create a new department
		System.out.println("New dept: "+dpt_name+" for "+goal_pack);
		
		signal("call_for_manager",dpt_name,goal_pack);
	}
	
	@OPERATION
	void applyAsDptManager(String myname, String goal_pack, OpFeedbackParam result) {
		Department dpt = dpt_table.get(goal_pack);
		if (dpt != null) {				
			boolean res = dpt.setManager(myname);
			if (res) {
				System.out.println(goal_pack+" Dpt got a manager: "+myname);
				signal("nominate_manager",myname,goal_pack);
				result.set(true);
			} else {
				System.out.println(" Dpt application error (type1): dpt already has a manager");
				result.set(false);
			}
		} else {
			System.out.println(" Dpt application error (type2): "+goal_pack+" does not exist");
			result.set(false);
		}
	}
	
	@OPERATION
	void subscribeDpt(String myname, String goal_pack) {
		Department dpt = dpt_table.get(goal_pack);
		if (dpt != null) {	
			dpt.getEmployeeSet().add(myname);
			//System.out.println("New "+goal_pack+" DPT member: "+myname);
		}
	}
	
	@OPERATION
	void getDptManager(String dept_name,OpFeedbackParam<String> themanager) 
	{
		/*
		int lenght = dept_name.length()-5;
		String goal_pack = dept_name.substring(0,lenght);
		Department dpt = dpt_table.get(goal_pack);
		if (dpt != null) {
			
			themanager.set(dpt.getManager());
		}
		*/
		themanager.set(new DepartmentTable().getDeptManagerName(dept_name));
		
		
	}

	@OPERATION
	void getDptEmployees(String dept_name,OpFeedbackParam<Members> employees) 
	{
		int lenght = dept_name.length()-5;
		String goal_pack = dept_name.substring(0,lenght);
		Department dpt = dpt_table.get(goal_pack);
		if (dpt != null) {
			employees.set(dpt.getEmployeeSet());
		}
	}
	
}

