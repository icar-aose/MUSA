package musa.database;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedList;
import java.util.List;

import musa.model.Entity;
import musa.model.ValueEntity;

public class ValueTable extends Table {

	public ValueTable() {
		super();
	}

	public ValueTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_value";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		ValueEntity response = new ValueEntity();
		set.first();
		
		response.setId( set.getInt("id") );
		response.setType( set.getString("type") );
		response.setValue( set.getString("value") );
		response.setProjectRef( set.getInt("project_ref"));
		response.setUpdated( set.getTimestamp("updated"));
		response.setAgent( set.getString("agent"));
		
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		ValueEntity elem = (ValueEntity) entity;
		
		String values = "('"+elem.getType()+"','"+elem.getValue()+"','"+elem.getProjectRef()+"','"+elem.getAgent()+"')";
		String fields = " type, value, project_ref, agent";
		
		String update = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		ValueEntity elem = (ValueEntity) entity;
		
		String primary = "id = '"+elem.getId()+"'";
		String fields = " type='"+elem.getType()+"', value='"+elem.getValue()+"', project_ref='"+elem.getProjectRef()+"', agent='"+elem.getAgent()+"'";
		
		String update = "UPDATE "+getTableName()+" SET "+fields+" WHERE "+primary;
		
		return update;
	}

	public List<ValueEntity> getAllValues(int project) {
		List<ValueEntity> response = new LinkedList<ValueEntity>();
		
		String query = "SELECT * FROM "+getTableName()+" WHERE project_ref='"+project+"'";
		//System.out.println(query);
		
		try {
			Connection conn = getConnection();
			Statement statement = conn.createStatement();
			ResultSet resultSet = statement.executeQuery(query);
			if (resultSet != null)	{
				resultSet.beforeFirst();
				while (resultSet.next()) {
					ValueEntity data = new ValueEntity(); 
					
					data.setId( resultSet.getInt("id") );
					data.setType(resultSet.getString("type"));
					data.setValue(resultSet.getString("value"));
					data.setUpdated(resultSet.getTimestamp("updated"));
					data.setAgent( resultSet.getString("agent") );
					data.setProjectRef( resultSet.getInt("project_ref") );
					
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
	
	/**
	 * 
	 * @author davide
	 * @param ParName
	 * @param AgName
	 * @param project
	 * @return
	 */
	public ValueEntity getParameterByType(String ParName, String AgName, int project)
	{
//		System.out.println("Getting for project: "+project);
		List<ValueEntity> response = getAllValues(project);	//get all the records in "adw_value" table
//		System.out.println("Cerco parametro "+ParName+"  ag: "+AgName+" project: "+project);
		for(ValueEntity val : response)
		{
//			System.out.println("id: "+val.getId()+" type:"+val.getType()+" value:"+val.getValue()+" AGENT:"+val.getAgent()+" project:"+val.getProjectRef());
			if( val.getAgent().equals(AgName) && val.getType().equals(ParName) )
			{
				return val;
			}
		}
		
		return null;
	}
	
	/**
	 * 
	 * @author davide
	 * @param Type
	 * @param AgName
	 * @param project
	 * @throws SQLException
	 */
	public int removeByType(String Type,  String AgName, int project) throws SQLException
	{
		String query = "DELETE FROM `"+getTableName()+"` WHERE `type` = ? AND `project_ref` = ? AND `agent` = ?";
		PreparedStatement statement = getConnection().prepareStatement(query);
		
		statement.setString(1, Type);
		statement.setString(2, AgName);
		statement.setInt(3, project);

		return statement.executeUpdate();
	}
	

}
