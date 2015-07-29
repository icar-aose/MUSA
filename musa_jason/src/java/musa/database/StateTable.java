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
import musa.model.StateEntity;

public class StateTable extends Table {

	public StateTable() {
		super();
	}

	public StateTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_state";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		StateEntity response = new StateEntity();
		set.first();
		
		response.setId( set.getInt("id") );
		response.setAssertion( set.getString("belief") );
		response.setProjectRef( set.getInt("project_ref"));
		response.setUpdated( set.getTimestamp("updated"));
		response.setAgent( set.getString("agent"));
		
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		StateEntity elem = (StateEntity) entity;
		
		String values = "('"+elem.getAssertion()+"','"+elem.getProjectRef()+"','"+elem.getAgent()+"')";
		String fields = " belief, project_ref, agent";
		
		String update = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		StateEntity elem = (StateEntity) entity;
		
		String primary = "id = '"+elem.getId()+"'";
		String fields = " belief='"+elem.getAssertion()+"', project_ref='"+elem.getProjectRef()+"', agent='"+elem.getAgent()+"'";
		
		String update = "UPDATE "+getTableName()+" SET "+fields+" WHERE "+primary;
		
		return update;
	}

	public List<StateEntity> getAllStates(int project) {
		List<StateEntity> response = new LinkedList<StateEntity>();
		
		String query = "SELECT * FROM "+getTableName()+" WHERE project_ref='"+project+"'";
		//System.out.println(query);
		
		try {
			Connection conn = getConnection();
			Statement statement = conn.createStatement();
			ResultSet resultSet = statement.executeQuery(query);
			if (resultSet != null)	{
				resultSet.beforeFirst();
				while (resultSet.next()) {
					StateEntity data = new StateEntity(); 
					
					data.setId( resultSet.getInt("id") );
					data.setAssertion( resultSet.getString("belief") );
					data.setProjectRef(resultSet.getInt("project_ref"));
					data.setAgent( resultSet.getString("agent") );
					data.setUpdated(resultSet.getTimestamp("updated"));
						

				    response.add(data);
				}
			}
		} catch (SQLException e) {

		}
		
		return response;
	}
	
	
	public int removeBelief(String belief,  String AgName, int project) throws SQLException
	{
		String query = "DELETE FROM `"+getTableName()+"` WHERE `belief` = ? AND `project_ref` = ? AND `agent` = ?";
		PreparedStatement statement = getConnection().prepareStatement(query);
		
		
		statement.setString(1, belief);
		statement.setInt(2, project);
		statement.setString(3, AgName);
		

		System.out.println(statement.toString());
		
		return statement.executeUpdate();
	}
}
