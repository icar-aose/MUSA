// CArtAgO artifact code for project adaptive_workflow

package ids.artifact;

import ids.database.BlacklistTable;
import ids.database.DepartmentTable;
import ids.database.EntryPointTable;
import ids.database.IPAddressTable;
import ids.database.JobTable;
import ids.database.ProjectTable;
import ids.database.RoleTable;
import ids.database.StateTable;
import ids.database.Table;
import ids.database.UserTable;
import ids.database.ValueTable;
import ids.model.BlacklistEntity;
import ids.model.DepartmentEntity;
import ids.model.Entity;
import ids.model.IPAddressEntity;
import ids.model.JobEntity;
import ids.model.ProjectEntity;
import ids.model.RoleEntity;
import ids.model.StateEntity;
import ids.model.UserEntity;
import ids.model.ValueEntity;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import workflow_property.MusaProperties;
import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

public class Database extends Artifact 
{
	private boolean debug = false;

	void init() 
	{
	}
	
	
	
	@OPERATION
	void updateFailureRate(String capabilityName){
		//faccio query ad DB per aggiornare il valore del campo failure_rate
		
		//TODO
		// se tale valore è 0 allora la elimino dal database e imposto come valore di ritorno false
		// in questo modo l'agente rimuove dalla black list la capability
		
	}
	
	@OPERATION
	void deleteUncompletedProjects(int dept) throws SQLException
	{
		ProjectTable project_table 	= new ProjectTable();
		List<ProjectEntity> toDelete = project_table.getUncompleteProjects(dept);
		
		for(ProjectEntity p : toDelete)
		{
			project_table.deleteOneByID(p.getId());
		}
		
	}
	
	
	@OPERATION
	void readWorkflowUsers() {
		execInternalOp("retrieve_users");
	}

	@OPERATION
	void clear() 
	{
		DepartmentTable dpt_table 	= new DepartmentTable();
		ProjectTable project_table 	= new ProjectTable();
		ValueTable value_table 		= new ValueTable();
		StateTable state_table 		= new StateTable();
		
		try 
		{
			state_table.deleteAll();
			value_table.deleteAll();
			project_table.deleteAll();
			dpt_table.deleteAll();
		} 
		catch (SQLException e) 
		{
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

	/**
	 * Clear adw_state and adw_value tables.
	 */
	@OPERATION
	void clearStatesAndValues() 
	{
		try 
		{
			new StateTable().deleteAll();
			new ValueTable().deleteAll();
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * Remove all the blacklist entries from the database
	 * 
	 * @author davide
	 */
	@OPERATION
	void clearBlacklist()
	{
		BlacklistTable tt 		= new BlacklistTable();
		try 					{tt.deleteAll();} 
		catch (SQLException e) 	{e.printStackTrace();}
	}
	
	
	/**
	 * Insert a capability into the database blacklist table. If the capability is already 
	 * in the blacklist, its failure rate is incremented.
	 *  
	 * @param capabilityName
	 * @param agent
	 * @author davide
	 */
	@OPERATION
	void insertOrUpdateCapabilityIntoBlacklist(String capabilityName, String agent)
	{
		BlacklistTable tt 		= new BlacklistTable();
		BlacklistEntity elem 	= null;
		
		try 
		{
			elem = (BlacklistEntity)tt.findOneBy("capability", capabilityName , "agent", agent);
			if(elem != null)
			{
				elem.setFailure_rate(elem.getFailure_rate()+1);
				tt.updateElementByPrimary(elem);
			}
			else
			{
				elem = new BlacklistEntity();
				elem.setAgent(agent);
				elem.setCapability(capabilityName);
				elem.setFailure_rate(1);
				
				tt.insertElement(elem);
			}
			
		} 
		catch (SQLException e) {e.printStackTrace();}
	}
	
	/**
	 * Remove a capability from the blacklist
	 * 
	 * @param capabilityName
	 * @param agent
	 * @author davide
	 */
	@OPERATION
	void removeCapabilityFromBlacklist(String capabilityName, String agent)
	{
		BlacklistTable tt 		= new BlacklistTable();
		BlacklistEntity elem 	= null;
		
		try 
		{
			elem = (BlacklistEntity)tt.findOneBy("capability", capabilityName , "agent", agent);
			
			if(elem != null)
				tt.deleteOneByID(elem.getId());		
		} 
		catch (SQLException e) {e.printStackTrace();}
	}
	
	/**
	 * Get the failure rate of a blacklisted capability. If the input capability
	 * is not blacklisted, -1 is returned.
	 * 
	 * @param result
	 * @author davide
	 */
	@OPERATION
	void getBlacklistedCapabilityTimestamp(String capabilityName, String agent, OpFeedbackParam result)
	{
		BlacklistTable tt 		= new BlacklistTable();
		BlacklistEntity elem 	= null;
		
		try 
		{
			elem = (BlacklistEntity)tt.findOneBy("capability", capabilityName , "agent", agent);
			
			if(elem != null)	{result.set(this.convertTimeStamp(elem.getUpdated()));}
			else				{result.set("no_timestamp");}
		} 
		catch (SQLException e) {e.printStackTrace();}
	}
	
	/**
	 * Get the failure rate of a blacklisted capability. If the input capability
	 * is not blacklisted, -1 is returned.
	 * 
	 * @param result
	 * @author davide
	 */
	@OPERATION
	void getBlacklistedCapabilityFailureRate(String capabilityName, String agent, OpFeedbackParam result)
	{
		BlacklistTable tt 		= new BlacklistTable();
		BlacklistEntity elem 	= null;
		
		try 
		{
			elem = (BlacklistEntity)tt.findOneBy("capability", capabilityName , "agent", agent);
			
			if(elem != null)	{result.set(elem.getFailure_rate());}
			else				{result.set(-1);}
		} 
		catch (SQLException e) {e.printStackTrace();}
	}
	
	/**
	 * Get the failure rate of a blacklisted capability. If the input capability
	 * is not blacklisted, -1 is returned.
	 * 
	 * @param result
	 * @author davide
	 */
	@OPERATION
	void checkIfCapabilityIsBlacklisted(String capabilityName, String agent, OpFeedbackParam result)
	{
//		System.out.println("Entering checkIfCapabilityIsBlacklisted");
		BlacklistTable tt 		= new BlacklistTable();
		BlacklistEntity elem 	= null;
		
		try 
		{
			elem = (BlacklistEntity)tt.findOneBy("capability", capabilityName , "agent", agent);
			
			if(elem != null)	{result.set(true);}
			else				{result.set(false);}
		} 
		catch (SQLException e) {e.printStackTrace();}
//		System.out.println("Exiting checkIfCapabilityIsBlacklisted");
	}
	
	/**
	 * Retrieve the blacklisted capability set from the database and creates,
	 * for each one, a predicate of type
	 * <br/><br/>
	 * <b>capability_blacklist(Agent,CapName,Timestamp)</b>
	 * <br/><br/>
	 * that is inserted into the result list.
	 * 
	 * @param result a JASON list of predicates.
	 * @author davide
	 */
	@OPERATION
	void getBlacklistedCapabilitySet(String project, OpFeedbackParam list)
	{
		BlacklistTable tt 			= new BlacklistTable();
		List<Entity> blacklistedCap;
		String belief = "[";
		boolean first = true;
		
		try 
		{
			blacklistedCap = tt.getAll();
			
			Iterator<Entity> it = blacklistedCap.iterator();
			while (it.hasNext()) {
				
				BlacklistEntity blacklistedCapability = (BlacklistEntity) it.next();
					
				if (!first) 	{belief += ",";} 
				else 			{first = false;}
				
				belief += "capability_blacklist("+blacklistedCapability.getAgent()+","+blacklistedCapability.getCapability()+","+this.convertTimeStamp(blacklistedCapability.getUpdated())+")";
			}
			belief += "]";
			list.set(belief);
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
	}
	
	
	/**
	 * Return the current timestamp of the machine in which the database server is installed
	 * 
	 * @author davide
	 */
	@OPERATION
	void getDatabaseSystemCurrentTimeStamp(OpFeedbackParam result)
	{
		Timestamp TS = null;
		Connection connection = null;
		String ip_address 	= MusaProperties.get_workflow_db_ip();
		String port 		= MusaProperties.get_workflow_db_port();
		String database 	= MusaProperties.get_workflow_db_name();
		String user 		= MusaProperties.get_workflow_db_user();
		String password 	= MusaProperties.get_workflow_db_userpass();
		
		if (ip_address!=null && port!= null && user!=null && password != null) 
		{
			try 
			{
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				String parameters = "jdbc:mysql://"+ip_address+":"+port+"/"+database;	
				connection = DriverManager.getConnection(parameters,user,password);
			} 
			catch (ClassNotFoundException e) 	{e.printStackTrace();} 
			catch (SQLException e) 				{e.printStackTrace();} 
			catch (InstantiationException e) 	{e.printStackTrace();} 
			catch (IllegalAccessException e) 	{e.printStackTrace();}
			
			try 
			{
				Statement statement = connection.createStatement();
				ResultSet rs = statement.executeQuery("SELECT NOW()as TS");
				
				if (rs.first()) 
			        TS = rs.getTimestamp("TS");
			} 
			catch (SQLException e) {e.printStackTrace();}
		}
				
//		Calendar calendar = Calendar.getInstance();
//		calendar.setTime(TS);
//		String formatted = String.format("ts(%d,%d,%d,%d,%d,%d)", calendar.get(calendar.YEAR), calendar.get(calendar.MONTH), calendar.get(calendar.DAY_OF_MONTH), calendar.get(calendar.HOUR_OF_DAY), calendar.get(calendar.MINUTE), calendar.get(calendar.SECOND));
		result.set(convertTimeStamp(TS));
	}

	
	/**
	 * Check if a parameter exists within the context (that is, the table adw_value).
	 * 
	 * @author davide
	 * @param parName the name of the parameter to search
	 * @param agName the name of the agent that calls this operation 
	 * @param project
	 * @param result the output boolean value that indicates whether the parameter has been found.
	 * 
	 * DA SPOSTAREs
	 */
	@OPERATION
	void existsParameter(String parName, String agName, int project, OpFeedbackParam<Boolean> result)
	{
		 result.set(new ValueTable().getParameterByType(parName, agName, project) != null);
	}
	
	@OPERATION
	void updateLocalHost(/*String address*/) 
	{
		
		String address = null;
		try {
			address = InetAddress.getLocalHost().getHostAddress();
		} catch (UnknownHostException e1) {
			e1.printStackTrace();
		}
		
		
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		System.out.println("~~~~~~~~~~~~~MUSA~~~~~~~~~~~~~");
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		System.out.println("local ip address: "+address);
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		System.out.println("workflow ip: "+MusaProperties.get_workflow_db_ip());
		System.out.println("workflow port: "+MusaProperties.get_workflow_db_port());
		System.out.println("workflow user: "+MusaProperties.get_workflow_db_user());
		System.out.println("workflow pass: "+MusaProperties.get_workflow_db_userpass());
		System.out.println("demo ip: "+MusaProperties.get_demo_db_ip());
		System.out.println("demo port: "+MusaProperties.get_demo_db_port());
		System.out.println("demo user: "+MusaProperties.get_demo_db_user());
		System.out.println("demo pass: "+MusaProperties.get_demo_db_userpass());
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			
		
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
	
	/**
	 * Given a name of a project, this operation returns the corresponding ID.
	 * 
	 * @param projectName the name of a project
	 * @param ID the output project ID
	 * @author davide
	 */
	@OPERATION
	void getProjectID(String projectName, OpFeedbackParam<Integer> ID)
	{
		ID.set(new ProjectTable().getProjectId(projectName));
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


	/**
	 * Store a new project to database.
	 * 
	 * @param name	project name
	 * @param dept department name
	 * @param coordinator project coordinator name
	 * @param contracts 
	 * @param date_string
	 */
	@OPERATION
	void addProject(String name, String dept, String coordinator, Object contracts, String date_string) 
	{
		Timestamp end = null;
		if (date_string.equals("current")) 
		{
			java.util.Date now = new java.util.Date();
			end = new Timestamp( now.getTime() );
		}
		
		
		DepartmentTable dept_table = new DepartmentTable();
		try 
		{
			DepartmentEntity department =  (DepartmentEntity) dept_table.findOneBy("name", dept);
			
			ProjectEntity project = new ProjectEntity();
			project.setName(name);
			project.setDepartmentRef(department.getId());
			project.setCoordinator(coordinator);
			project.setContracts(contracts.toString());
			project.setEnd(end);
			
			ProjectTable project_table = new ProjectTable();
			project_table.insertElement(project);
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
	}

	@OPERATION
	void updateProject(String name, String coordinator, Object contracts, String date_string) 
	{
		Timestamp end = null;
		
		if (date_string.equals("current")) 
		{
			java.util.Date now = new java.util.Date();
			end = new Timestamp( now.getTime() );
		}
		
		ProjectTable project_table = new ProjectTable();
		
		try 
		{
			ProjectEntity project = (ProjectEntity) project_table.findOneBy("name", name);
			boolean existing_project = (project != null);
			
			//If project doesn't exist, project is null. In this case, create a new ProjectEntity object instance.
			if(!existing_project)
				project = new ProjectEntity();
			
			project.setCoordinator(coordinator);
			project.setContracts(contracts.toString());
			project.setEnd(end);
			
			//Update or insert new project into the database project table
			if(existing_project)
				project_table.updateElementByPrimary(project);
			else
				project_table.insertElement(project);
			
		} 
		catch (SQLException e) 
		{
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
			System.out.println("exception "+e);
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
		} catch (SQLException e) 
		{
			e.printStackTrace();
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
			e.printStackTrace();
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
//		int year = (1900+t.getYear());
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("ts(");
//		stringBuilder.append(year);
//		stringBuilder.append(",");
//		stringBuilder.append(t.getMonth());
//		stringBuilder.append(",");
//		stringBuilder.append(t.getDate());
//		stringBuilder.append(",");
//		stringBuilder.append(t.getHours());
//		stringBuilder.append(",");
//		stringBuilder.append(t.getMinutes());
//		stringBuilder.append(",");
//		stringBuilder.append(t.getSeconds());
//		stringBuilder.append(")");
		
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(t);
		stringBuilder.append(calendar.get(calendar.YEAR));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(calendar.MONTH+1));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(calendar.DAY_OF_MONTH));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(calendar.HOUR_OF_DAY));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(calendar.MINUTE));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(calendar.SECOND));
		stringBuilder.append(")");
		
		String ts = stringBuilder.toString();
		return ts;
	}
	
	/**
	 * Remove a belief from the context (that is, the table adw_state).
	 * 
	 * @author davide
	 * @param belief the belief to remove
	 * @param AgName the agent who holds the belief in its belief base
	 * @param project the reference project.
	 */
	@OPERATION
	void remove_belief_from_context(String belief, String AgName, int project)
	{
		try 
		{
			new StateTable().removeBelief(belief, AgName, project);
		} 
		catch (SQLException e) 
		{
			System.out.println("Error removing belief '"+belief+"' from context.");
			e.printStackTrace();
		}
	}
	
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

