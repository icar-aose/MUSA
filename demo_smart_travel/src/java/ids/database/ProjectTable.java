package ids.database;

import ids.model.ProjectEntity;
import ids.model.Entity;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

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
		} catch (SQLException e) {

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
