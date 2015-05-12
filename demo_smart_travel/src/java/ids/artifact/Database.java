// CArtAgO artifact code for project adaptive_workflow

package ids.artifact;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import ids.database.DepartmentTable;
import ids.database.EntryPointTable;
import ids.database.IPAddressTable;
import ids.database.JobTable;
import ids.database.ProjectTable;
import ids.database.RoleTable;
import ids.database.StateTable;
import ids.database.UserTable;
import ids.database.ValueTable;
import ids.model.DepartmentEntity;
import ids.model.Entity;
import ids.model.IPAddressEntity;
import ids.model.JobEntity;
import ids.model.ProjectEntity;
import ids.model.RoleEntity;
import ids.model.StateEntity;
import ids.model.UserEntity;
import ids.model.ValueEntity;
import cartago.*;

public class Database extends Artifact {
	private boolean debug = false;

	void init() {
		
	}
	
	@OPERATION
	void readWorkflowUsers() {
		execInternalOp("retrieve_users");
	}

	@OPERATION
	void clear() {
		DepartmentTable dpt_table = new DepartmentTable();
		ProjectTable project_table = new ProjectTable();
		ValueTable value_table = new ValueTable();
		StateTable state_table = new StateTable();
		
		try {
			state_table.deleteAll();
			value_table.deleteAll();
			project_table.deleteAll();
			dpt_table.deleteAll();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@OPERATION
	void clearJobsAndEntries() {
		JobTable job_table = new JobTable();
		EntryPointTable entry_table = new EntryPointTable();
		
		try {
			job_table.deleteAll();
			entry_table.deleteAll();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@OPERATION
	void updateLocalHost(String address) {
		IPAddressTable ip_address_table = new IPAddressTable();
		try {
			IPAddressEntity entity = (IPAddressEntity) ip_address_table.findOneBy("name", "proxy");
			entity.setAddress(address);
			ip_address_table.updateElementByPrimary(entity);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	
	@OPERATION
	void addDepartment(String name, String owner) {
		DepartmentEntity department = null;//new DepartmentEntity();
		
		DepartmentTable dept_table = new DepartmentTable();
		
		try {
			department = (DepartmentEntity) dept_table.findOneBy("name", name);
			if (department==null) {	
				department = new DepartmentEntity();
				department.setName(name);
				department.setManager(owner);
				dept_table.insertElement(department);
			} else {
				department.setManager(owner);
				dept_table.updateElementByPrimary(department);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@OPERATION
	void getProjects(String dept, OpFeedbackParam list) {
		DepartmentTable dept_table = new DepartmentTable();
		String belief = "[";
		boolean first = true;
		
		try {
			DepartmentEntity department =  (DepartmentEntity) dept_table.findOneBy("name", dept);
			System.out.println("Dpt: "+department.getId());
			
			ProjectTable project_table = new ProjectTable();
		
			List<ProjectEntity> projects = project_table.getUncompleteProjects(department.getId());
			Iterator it = projects.iterator();
			while (it.hasNext()) {
				ProjectEntity entity = (ProjectEntity) it.next();
				if (!first) {
					belief += ",";
				} else {
					first = false;
				}
				belief += "project( \""+entity.getName()+"\","+entity.getCoordinator()+","+entity.getContracts()+")";
			}
			belief += "]";
			
			list.set(belief);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


	@OPERATION
	void addProject(String name, String dept, String coordinator, Object contracts, String date_string) {
/*		System.out.println("name ",name);
		System.out.println("dept ",dept);
		System.out.println("name ",name);
		System.out.println("name ",name);*/
		
		Timestamp end = null;
		if (date_string.equals("current")) {
			java.util.Date now = new java.util.Date();
			end = new Timestamp( now.getTime() );
		}
		
		
		DepartmentTable dept_table = new DepartmentTable();
		try {
			DepartmentEntity department =  (DepartmentEntity) dept_table.findOneBy("name", dept);
			
			ProjectEntity project = new ProjectEntity();
			project.setName(name);
			project.setDepartmentRef(department.getId());
			project.setCoordinator(coordinator);
			project.setContracts(contracts.toString());
			project.setEnd(end);
			
			ProjectTable project_table = new ProjectTable();
		
			project_table.insertElement(project);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@OPERATION
	void updateProject(String name, String coordinator, Object contracts, String date_string) {
		Timestamp end = null;
		if (date_string.equals("current")) {
			java.util.Date now = new java.util.Date();
			end = new Timestamp( now.getTime() );
		}
		ProjectTable project_table = new ProjectTable();
		try {
			ProjectEntity project = (ProjectEntity) project_table.findOneBy("name", name);
			project.setCoordinator(coordinator);
			project.setContracts(contracts.toString());
			project.setEnd(end);
			project_table.updateElementByPrimary(project);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@OPERATION
	void closeProject(String name, String date_string) {
		Timestamp end = null;
		if (date_string.equals("current")) {
			java.util.Date now = new java.util.Date();
			end = new Timestamp( now.getTime() );
		} else {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			try {
				Date parsedDate = dateFormat.parse(date_string);
				end = new Timestamp(parsedDate.getTime());
			} catch (ParseException e) {
			}
		}
		ProjectTable project_table = new ProjectTable();
		try {
			ProjectEntity project = (ProjectEntity) project_table.findOneBy("name", name);
			project.setEnd(end);
			project_table.updateElementByPrimary(project);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	//NEW
	@OPERATION
	void registerValue(String type, Object value, String project_name, String agent_name) {
		ProjectTable project_table = new ProjectTable();
		try {
			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);			
			ValueEntity entity = new ValueEntity();
			entity.setType(type);
			entity.setValue(value.toString());
			entity.setProjectRef(project.getId());
			entity.setAgent(agent_name);
			ValueTable value_table = new ValueTable();		
			value_table.insertElement(entity);
		} catch (SQLException e) {
		}
	}
	@OPERATION
	void updateValue(String type, Object value, String project_name, String agent_name) {
		ProjectTable project_table = new ProjectTable();
		ValueTable value_table = new ValueTable();
		try {
			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);			
			
			ValueEntity entity = (ValueEntity) value_table.findOneBy("type", type, "project_ref", ""+project.getId());
			entity.setValue(value.toString());
			entity.setAgent(agent_name);

			value_table.updateElementByPrimary(entity);
		} catch (SQLException e) {
		}
	}
	@OPERATION
	void readValue(String type, OpFeedbackParam value, String project_name, OpFeedbackParam timestamp) {
		ProjectTable project_table = new ProjectTable();
		try {
			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);			
			ValueTable value_table = new ValueTable();
			ValueEntity entity = (ValueEntity) value_table.findOneBy("type", type,"project_ref",""+project.getId());
			if (entity!=null) {
				value.set( entity.getValue() );
				timestamp.set( convertTimeStamp(entity.getUpdated()) );
			} else {
				value.set("undefined_type");
				timestamp.set("no_timestamp");
			}			
		} catch (SQLException e) {
		}		
	}

	@OPERATION
	void getJob(String service_name, OpFeedbackParam agent_name) {
		JobTable jobtable = new JobTable();

		try {
			JobEntity job = (JobEntity) jobtable.findOneBy("service", service_name);
			if (job != null) {
				
				agent_name.set(job.getAgent());
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
	@OPERATION
	void readAllValues(String project_name, String dept_name, OpFeedbackParam list) {
		ProjectTable project_table = new ProjectTable();
		String context = "project_context(\""+dept_name+"\",\""+project_name+"\")";
		String belief = "[";
		boolean first = true;
		try {
			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);			
			ValueTable value_table = new ValueTable();
			List<ValueEntity> entities = value_table.getAllValues(project.getId());
			Iterator it = entities.iterator();
			while (it.hasNext()) {
				ValueEntity entity = (ValueEntity) it.next();
				if (!first) {
					belief += ",";
				} else {
					first = false;
				}
				belief += "context_data( "+entity.getType()+","+entity.getValue()+","+context+","+convertTimeStamp(entity.getUpdated())+")";
				//context_data(TypeIN,ValueTerm,ContextIN,TimeStampTerm)
			}
			belief += "]";
			
			list.set(belief);
		} catch (SQLException e) {
		}		
		
	}
	@OPERATION
	void registerState(String predicate, String project_name, String agent_name) {
		ProjectTable project_table = new ProjectTable();
		try {
			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);			
			StateEntity entity = new StateEntity();
			entity.setAssertion(predicate);
			entity.setProjectRef(project.getId());
			entity.setAgent(agent_name);
			StateTable state_table = new StateTable();		
			state_table.insertElement(entity);
		} catch (SQLException e) {
		}
	}
	@OPERATION
	void isStateTrue(String predicate, OpFeedbackParam truth, String project_name, OpFeedbackParam timestamp) {
		ProjectTable project_table = new ProjectTable();
		try {
			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);			
			StateTable state_table = new StateTable();
			//StateEntity entity = (StateEntity) state_table.findOneBy("belief", predicate,"project_ref",""+project.getId());
			
			Hashtable filter_map = new Hashtable();
			filter_map.put("belief", predicate);
			filter_map.put("project_ref", ""+project.getId());
			StateEntity entity = (StateEntity) state_table.findMostRecentBy(filter_map, "updated");
			if (entity!=null) {
				truth.set( true );
				timestamp.set( convertTimeStamp(entity.getUpdated()) );
			} else {
				truth.set( false );
				timestamp.set("no_timestamp");
			}			
		} catch (SQLException e) {
		}		
	}
	@OPERATION
	void isStateTrueAfter(String base_ts, String predicate, OpFeedbackParam truth, String project_name, OpFeedbackParam timestamp) {
		ProjectTable project_table = new ProjectTable();
		try {
			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);			
			StateTable state_table = new StateTable();
			String where = " belief = '"+ predicate+"' AND project_ref = '"+ project.getId()+"' AND updated > '"+base_ts+"'";//convertTStoDatabase(base_ts);
			//System.out.println(where);
			StateEntity entity = (StateEntity) state_table.findOneWhere(where);
			if (entity!=null) {
				truth.set( true );
				timestamp.set( convertTimeStamp(entity.getUpdated()) );
			} else {
				truth.set( false );
				timestamp.set("no_timestamp");
			}			
		} catch (SQLException e) {
		}		
	}
	@OPERATION
	void readAllStates(String project_name, String dept_name, OpFeedbackParam list) {
		ProjectTable project_table = new ProjectTable();
		String context = "project_context(\""+dept_name+"\",\""+project_name+"\")";
		String belief = "[";
		boolean first = true;
		try {
			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);			
			StateTable state_table = new StateTable();
			List<StateEntity> entities = state_table.getAllStates(project.getId());
			Iterator it = entities.iterator();
			while (it.hasNext()) {
				StateEntity entity = (StateEntity) it.next();
				if (!first) {
					belief += ",";
				} else {
					first = false;
				}
				belief += "context_state( "+entity.getAssertion()+","+context+","+convertTimeStamp(entity.getUpdated())+")";
				//context_state(Predicate,Context,TimeStampTerm)
			}
			belief += "]";
			
			list.set(belief);
		} catch (SQLException e) {
		}		
		
	}

	
	private String convertTStoDatabase(String predicate ) {
		// ts(YY,MM,DD,HH,M,SS)
		// '2013-07-17 10:11:42'
		
		return null;
	}
	
	private String convertTimeStamp(Timestamp t) {
		int year = (1900+t.getYear());
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("ts(");
		stringBuilder.append(year);
		stringBuilder.append(",");
		stringBuilder.append(t.getMonth());
		stringBuilder.append(",");
		stringBuilder.append(t.getDate());
		stringBuilder.append(",");
		stringBuilder.append(t.getHours());
		stringBuilder.append(",");
		stringBuilder.append(t.getMinutes());
		stringBuilder.append(",");
		stringBuilder.append(t.getSeconds());
		stringBuilder.append(")");
		String ts = stringBuilder.toString();
		return ts;
	}
	
	
	//OLD
	@OPERATION
//	void addValue(String type, Object value_string, String project_name, String agent) {
//		ProjectTable project_table = new ProjectTable();
//		//System.out.println("adding "+type+" , "+value_string.toString()+" , "+project_name+" , "+agent);
//		try {
//			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);
//			
//			ValueEntity value = new ValueEntity();
//			value.setType(type);
//			value.setValue(value_string.toString());
//			value.setProjectRef(project.getId());
//			value.setAgent(agent);
//			
//			ValueTable value_table = new ValueTable();
//		
//			value_table.insertElement(value);
//		} catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}
//
//	@OPERATION
//	void updateValue(String type, Object value_string, String project_name, String agent) {
//		ProjectTable project_table = new ProjectTable();
//
//		
//		try {
//			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);
//			
//			ValueTable value_table = new ValueTable();
//			ValueEntity value = (ValueEntity) value_table.findOneBy("type", type,"project_ref",""+project.getId());
//			
//			value.setValue(value_string.toString());
//			value.setAgent(agent);
//			
//			value_table.updateElementByPrimary(value);
//			
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//		
//	}
//
//	@OPERATION
//	void getValue(String type, String project_name, String dpt_name, OpFeedbackParam result) {
//		ProjectTable project_table = new ProjectTable();
//
//		try {
//			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);
//			
//			ValueTable value_table = new ValueTable();
//			ValueEntity value = (ValueEntity) value_table.findOneBy("type", type,"project_ref",""+project.getId());
//			if (value!=null) {
//				Timestamp t = value.getUpdated();
//			
//				@SuppressWarnings("deprecation")
//				int year = (1900+t.getYear());
//				String ts = "ts("+year+","+t.getMonth()+","+t.getDate()+","+t.getHours()+","+t.getMinutes()+","+t.getSeconds()+")";
//			
//				String belief = "context_data(project_context(\""+dpt_name+"\",\""+project_name+"\"),value("+value.getType()+","+value.getValue()+"))[timestamp("+ts+")]";
//				//System.out.println(belief);
//				
//				result.set(belief);
//			} else {
//				result.set("error");
//			}
//			
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//		
//	}
//
//	
//	@OPERATION
//	void addState(String belief, String project_name, String agent) {
//		ProjectTable project_table = new ProjectTable();
//		try {
//			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);
//			
//			StateEntity state = new StateEntity();
//			state.setAssertion(belief);
//			state.setProjectRef(project.getId());
//			state.setAgent(agent);
//			
//			StateTable state_table = new StateTable();
//		
//			state_table.insertElement(state);
//		} catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}
//
//	@OPERATION
//	void getState(String claim, String project_name, String dpt_name, OpFeedbackParam result) {
//		ProjectTable project_table = new ProjectTable();
//
//		try {
//			ProjectEntity project =  (ProjectEntity) project_table.findOneBy("name", project_name);
//			
//			StateTable state_table = new StateTable();
//			StateEntity state = (StateEntity) state_table.findOneBy("belief", claim,"project_ref",""+project.getId());
//			if (state!=null) {
//				Timestamp t = state.getUpdated();
//			
//				@SuppressWarnings("deprecation")
//				int year = (1900+t.getYear());
//				String ts = "ts("+year+","+t.getMonth()+","+t.getDate()+","+t.getHours()+","+t.getMinutes()+","+t.getSeconds()+")";
//			
//				String belief = "context_data(project_context(\""+dpt_name+"\",\""+project_name+"\"),"+state.getAssertion()+")[timestamp("+ts+")]";
//			
//				result.set(belief);
//			} else {
//				result.set("error");
//			}
//			
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//		
//	}

	@INTERNAL_OPERATION
	void retrieve_users() {
		if (debug) System.out.println("read all users");
		UserTable user_table = new UserTable();
		RoleTable role_table = new RoleTable();

		try {
			List<Entity> users = user_table.getAll();

			Iterator<Entity> it = users.iterator();
			while (it.hasNext()) {
				
				UserEntity user = (UserEntity) it.next();
				RoleEntity role = (RoleEntity) role_table.findOneByID( user.getRole_ref() );
				signal("user",user.getUsername(),role.getAgent());
			}
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

