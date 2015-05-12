package ids.database;

import ids.model.ProjectEntity;
import ids.model.ValueEntity;
import ids.model.Entity;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedList;
import java.util.List;

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

				    response.add(data);
				}
			}
		} catch (SQLException e) {

		}
		
		return response;
	}

}
