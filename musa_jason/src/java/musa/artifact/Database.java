// CArtAgO artifact code for project adaptive_workflow

package musa.artifact;

import java.io.File;
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

import musa.database.BlacklistTable;
import musa.database.CapabilityStatusTable;
import musa.database.DepartmentTable;
import musa.database.EntryPointTable;
import musa.database.IPAddressTable;
import musa.database.JobTable;
import musa.database.ProjectTable;
import musa.database.RoleTable;
import musa.database.StateTable;
import musa.database.UserTable;
import musa.database.ValueTable;
import musa.model.BlacklistEntity;
import musa.model.CapabilityStatusEntity;
import musa.model.DepartmentEntity;
import musa.model.Entity;
import musa.model.IPAddressEntity;
import musa.model.JobEntity;
import musa.model.ProjectEntity;
import musa.model.RoleEntity;
import musa.model.StateEntity;
import musa.model.UserEntity;
import musa.model.ValueEntity;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import workflow_property.MusaProperties;
import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

public class Database extends Artifact 
{
	private final boolean debug = false;
	private final boolean printIPaddressesAtStartup = true;

	void init() 
	{
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
			MusaConfigGUIArtifact.setDBfromConfigFile(config_filename);			
			success.set(true);
		}
		else
		{
			System.out.println("No db config found at ~./musa/config.properties\nSetting default MUSA db configuration...");
			success.set(false);
		}
	}
	
	/**
	 * Set the database connection parameters
	 * 
	 */
	@OPERATION
	void set_default_database(String User, String port, String pass, String dbName, String database_ip)
	{
		MusaProperties.setWorkflow_db_user(User);
		MusaProperties.setWorkflow_db_port(port);
		MusaProperties.setWorkflow_db_userpass(pass);
		MusaProperties.setWorkflow_db_name(dbName);
		MusaProperties.setWorkflow_db_ip(database_ip);
	}
	
	/**
	 * Print a startup message
	 */
	void printStartupMessageInfo(String localIPAddress)
	{
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		System.out.println("~~~~~~~~~~~~~~~~~~~~~MUSA~~~~~~~~~~~~~~~~~~~~~~");
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		System.out.println("local ip address: "+localIPAddress);
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		System.out.println("workflow ip: "+MusaProperties.getWorkflow_db_ip());
		System.out.println("workflow port: "+MusaProperties.getWorkflow_db_port());
		System.out.println("workflow user: "+MusaProperties.getWorkflow_db_user());
		System.out.println("workflow pass: "+MusaProperties.getWorkflow_db_userpass());
		/*System.out.println("demo ip: "+MusaProperties.getDemo_db_ip());
		System.out.println("demo port: "+MusaProperties.getDemo_db_port());
		System.out.println("demo user: "+MusaProperties.getDemo_db_user());
		System.out.println("demo pass: "+MusaProperties.getDemo_db_userpass());*/
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	}
	
	/**
	 * Update the status of a capability in the database
	 * 
	 * @param CapName
	 * @param Status
	 */
	@OPERATION
	void set_capability_status(String CapName, String Status)
	{
		CapabilityStatusTable table = new CapabilityStatusTable();
		
		try 
		{
			CapabilityStatusEntity ee = (CapabilityStatusEntity) table.findOneBy("capability", CapName);
			
			if(ee == null)	
			{
				ee = new CapabilityStatusEntity();
				ee.setCapability(CapName);
				ee.setStatus(Status);
				table.insertElement(ee);
			}
			else			
			{
				ee.setStatus(Status);
				table.updateElementByPrimary(ee);
			}
		} 
		catch (SQLException e) {e.printStackTrace();}
	}
	
	
	
	@OPERATION
	void set_capability_activation_timestamp(String TS)
	{
		CapabilityStatusTable table = new CapabilityStatusTable();
		
		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy/MM/dd HH:mm:ss");
		DateTime dt 				= formatter.parseDateTime(TS);
		
		
	}
	
	
	@OPERATION
	void set_capability_termination_timestamp(String TS)
	{
		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy/MM/dd HH:mm:ss");
		DateTime dt 				= formatter.parseDateTime(TS);
	}

	
	
	
	
	
	
	@OPERATION
	void updateFailureRate(String capabilityName)
	{
		//faccio query ad DB per aggiornare il valore del campo failure_rate
		
		//TODO
		// se tale valore è 0 allora la elimino dal database e imposto come valore di ritorno false
		// in questo modo l'agente rimuove dalla black list la capability
		
	}
	
	/**
	 * Delete all uncompleted projects in database
	 * 
	 */
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

	/**
	 * Clear the following tables in the MUSA database:
	 * 
	 * - Department table
	 * - Project table
	 * - Value table
	 * - State table
	 */
	@OPERATION
	void clear() 
	{
//		DepartmentTable dpt_table 	= new DepartmentTable();
//		ProjectTable project_table 	= new ProjectTable();
		ValueTable value_table 		= new ValueTable();
		StateTable state_table 		= new StateTable();
		CapabilityStatusTable cap_status_table = new CapabilityStatusTable();
		
		try 
		{
			state_table.deleteAll();
			value_table.deleteAll();
//			project_table.deleteAll();
//			dpt_table.deleteAll();
			cap_status_table.deleteAll();
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
	void insertOrUpdateCapabilityIntoBlacklist(String capabilityName, String failureTimestamp, String agent)
	{
		BlacklistTable tt 		= new BlacklistTable();
		BlacklistEntity elem 	= null;

		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy/MM/dd HH:mm:ss");
		DateTime dt 				= formatter.parseDateTime(failureTimestamp);
		
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
				elem.setUpdated(new Timestamp(dt.getMillis()));
				
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
		BlacklistTable tt 		= new BlacklistTable();
		BlacklistEntity elem 	= null;
		
		try 
		{
			elem = (BlacklistEntity)tt.findOneBy("capability", capabilityName , "agent", agent);
			
			if(elem != null)	{result.set(true);}
			else				{result.set(false);}
		} 
		catch (SQLException e) {e.printStackTrace();}
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
		String belief = "[";
		boolean first = true;
		
		try 
		{
			Iterator<Entity> it = new BlacklistTable().getAll().iterator();
			while (it.hasNext()) 
			{
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
	 * DEPRECATA
	 * 
	 * @author davide
	 */
	@OPERATION
	void getDatabaseSystemCurrentTimeStamp(OpFeedbackParam result)
	{
		Timestamp TS = null;
		Connection connection = null;
		String ip_address 	= MusaProperties.getWorkflow_db_ip();
		String port 		= MusaProperties.getWorkflow_db_port();
		String database 	= MusaProperties.getWorkflow_db_name();
		String user 		= MusaProperties.getWorkflow_db_user();
		String password 	= MusaProperties.getWorkflow_db_userpass();
		
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
	
	/**
	 * Set/Update the MUSA host address in the database. 
	 */
	@OPERATION
	void updateLocalHost() 
	{
		String address = null;
		try	 								{address = InetAddress.getLocalHost().getHostAddress();} 
		catch (UnknownHostException e1) 	{e1.printStackTrace();}
		
		if(printIPaddressesAtStartup) printStartupMessageInfo(address);
		
		IPAddressTable ip_address_table = new IPAddressTable();
		try {
			IPAddressEntity entity = (IPAddressEntity) ip_address_table.findOneBy("name", "proxy");
			entity.setAddress(address);
			ip_address_table.updateElementByPrimary(entity);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	/**
	 * Add a new department
	 * 
	 * @param name
	 * @param owner
	 */
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
	
	/**
	 * Get the list of projects 
	 * 
	 * @param dept
	 * @param list
	 */
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
	 * Add a new project
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

	/**
	 * Convert a timestamp into a string of the following form:
	 * 
	 * ts(YYYY,MM,DD,HH,mm,dd)
	 * 
	 */
	private String convertTimeStamp(Timestamp t) 
	{
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("ts(");

		Calendar calendar = Calendar.getInstance();
		calendar.setTime(t);
		
		stringBuilder.append(calendar.get(Calendar.YEAR));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(Calendar.MONTH)+1);	//Calendar.MONTH starts from 0
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(Calendar.DAY_OF_MONTH));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(Calendar.HOUR_OF_DAY));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(Calendar.MINUTE));
		stringBuilder.append(",");
		stringBuilder.append(calendar.get(Calendar.SECOND));
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

