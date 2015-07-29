package musa.database;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import musa.model.Entity;
import musa.model.ProjectEntity;

public class ProjectTable extends Table {

	public ProjectTable() {
		super();
	}

	public ProjectTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_project";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		ProjectEntity response = new ProjectEntity();
		set.first();
		
		response.setId( set.getInt("id") );
		response.setName( set.getString("name") );
		response.setDepartmentRef( set.getInt("dept_ref"));
		response.setStart( set.getTimestamp("start_timestamp"));
		response.setEnd( set.getTimestamp("end_timestamp"));
		response.setCoordinator( set.getString("coordinator"));
		response.setContracts( set.getString("contracts"));
		
		return response;
	}
	
	public List<ProjectEntity> getUncompleteProjects(int detp) {
		List<ProjectEntity> response = new LinkedList<ProjectEntity>();
		
		String query = "SELECT * FROM "+getTableName()+" WHERE dept_ref='"+detp+"' AND end_timestamp IS NULL ";
		//System.out.println(query);
		
		try {
			Connection conn = getConnection();
			Statement statement = conn.createStatement();
			ResultSet resultSet = statement.executeQuery(query);
			if (resultSet != null)	{
				resultSet.beforeFirst();
				while (resultSet.next()) {
					ProjectEntity data = new ProjectEntity(); 
					
					data.setId( resultSet.getInt("id") );
					data.setName( resultSet.getString("name") );
					data.setDepartmentRef( resultSet.getInt("dept_ref"));
					data.setStart( resultSet.getTimestamp("start_timestamp"));
					data.setEnd( resultSet.getTimestamp("end_timestamp"));
					data.setCoordinator( resultSet.getString("coordinator"));
					data.setContracts( resultSet.getString("contracts"));

				    response.add(data);
				}
			}
		}
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		
		return response;
	}
	
	/*davide*/
	public List<ProjectEntity> getAllProjects() {
		List<ProjectEntity> response = new LinkedList<ProjectEntity>();
		
		String query = "SELECT * FROM "+getTableName();
//		System.out.println(query);
		
		try {
			Connection conn = getConnection();
			Statement statement = conn.createStatement();
			ResultSet resultSet = statement.executeQuery(query);
			if (resultSet != null)	{
				resultSet.beforeFirst();
				while (resultSet.next()) {
					ProjectEntity data = new ProjectEntity(); 
					
					data.setId( resultSet.getInt("id") );
					data.setName( resultSet.getString("name") );
					data.setDepartmentRef( resultSet.getInt("dept_ref"));
					data.setStart( resultSet.getTimestamp("start_timestamp"));
					data.setEnd( resultSet.getTimestamp("end_timestamp"));
					data.setCoordinator( resultSet.getString("coordinator"));
					data.setContracts( resultSet.getString("contracts"));

				    response.add(data);
				}
			}
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		ProjectEntity elem = (ProjectEntity) entity;
		String values="";
		String fields="";
		
		if (elem.getEnd()==null) {
			values = "('"+elem.getName()+"','"+elem.getDepartmentRef()+"','"+elem.getCoordinator()+"','"+elem.getContracts()+"')";
			fields = " name, dept_ref, coordinator, contracts";
		} else {
			values = "('"+elem.getName()+"','"+elem.getDepartmentRef()+"','"+elem.getEnd()+"','"+elem.getCoordinator()+"','"+elem.getContracts()+"')";
			fields = " name, dept_ref, end_timestamp, coordinator, contracts";
		}
		
		String update = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		ProjectEntity elem = (ProjectEntity) entity;

		String primary = "id = '"+elem.getId()+"'";
		String fields="";
		if (elem.getEnd()==null) {
			fields = " name='"+elem.getName()+"', dept_ref='"+elem.getDepartmentRef()+"', coordinator='"+elem.getCoordinator()+"', contracts='"+elem.getContracts()+"'";
		} else {
			fields = " name='"+elem.getName()+"', dept_ref='"+elem.getDepartmentRef()+"', end_timestamp='"+elem.getEnd()+"', coordinator='"+elem.getCoordinator()+"', contracts='"+elem.getContracts()+"'";
		}
		
		String update = "UPDATE "+getTableName()+" SET "+fields+" WHERE "+primary;
		
		return update;
	}

	/**
	 * Return the id of a project.
	 * 
	 * @param projectName The name of the project to search
	 * @return The id of the specified project, or -1 if the project is not found.
	 */
	public int getProjectId(String projectName)
	{
		ProjectTable table = new ProjectTable();
		List<ProjectEntity> list = table.getAllProjects();
		
		for(ProjectEntity entity : list)
		{
//			System.out.println("Project ->"+entity.getName());
			if(entity.getName().equals(projectName))
				return entity.getId();
		}
		
		return -1;
	}
	
	public static void main(String args[]) {
		/*
		Properties prop = new Properties();
        File file = new File( "config.properties" );
        
		prop.setProperty("ip_address","194.119.214.121");
		prop.setProperty("port","3306");
		prop.setProperty("database","ids_workflow");
		prop.setProperty("user","ids_root");
		prop.setProperty("password","root");		

        FileOutputStream fis;
		try {
			fis = new FileOutputStream(file);
			prop.store( fis, null );			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		*/
		
		
		ProjectTable table = new ProjectTable();
		List<ProjectEntity> list = table.getUncompleteProjects(205);
		Iterator<ProjectEntity> it = list.iterator();
		while (it.hasNext()) {
			ProjectEntity entity = it.next();
			//System.out.println("Project "+entity.getName());
		}
	}
}
