package musa.database;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedList;
import java.util.List;

import musa.model.DepartmentEntity;
import musa.model.Entity;

public class DepartmentTable extends Table {

	public DepartmentTable() {
		super();
	}

	public DepartmentTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_department";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		DepartmentEntity response = new DepartmentEntity();
		set.first();
		
		response.setId( set.getInt("id") );
		response.setName( set.getString("name") );
		response.setManager( set.getString("manager") );	
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		DepartmentEntity elem = (DepartmentEntity) entity;
		
		String values = "('"+elem.getName()+"','"+elem.getManager()+"')";
		String fields = " name, manager ";
		
		String update = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		DepartmentEntity elem = (DepartmentEntity) entity;
		
		String primary = "id = '"+elem.getId()+"'";
		String fields = " name='"+elem.getName()+"', manager='"+elem.getManager()+"'";
		
		String update = "UPDATE "+getTableName()+" SET "+fields+" WHERE "+primary;
		
		return update;
	}
	
	/**
	 * Return a list containing all the goals into the database.
	 */
	public String getDeptManagerName(String deptName) 
	{
		List<DepartmentEntity> response = new LinkedList<DepartmentEntity>();
		
		String query = "SELECT * FROM "+getTableName();
//		System.out.println("Executing query: "+query+"\n");
		
		try 
		{
			Connection conn = getConnection();
			Statement statement = conn.createStatement();
			ResultSet resultSet = statement.executeQuery(query);
			if (resultSet != null)	
			{
				resultSet.beforeFirst();
				while (resultSet.next()) 
				{
					if(resultSet.getString("name").equals(deptName))
						return resultSet.getString("manager"); 
				}
			}
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		
		return null;
	}

}
