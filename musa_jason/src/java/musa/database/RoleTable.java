package musa.database;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

import musa.model.Entity;
import musa.model.RoleEntity;

public class RoleTable extends Table {

	public RoleTable() {
		super();
	}

	public RoleTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_role";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		RoleEntity response = new RoleEntity();
		
		response.setId( set.getInt("id") );
		response.setName( set.getString("name") );
		response.setAgent( set.getString("agent") );	
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		RoleEntity elem = (RoleEntity) entity;
		String update = "INSERT INTO "+getTableName()+" (name, agent) VALUES ('"+elem.getName()+"' , '"+elem.getAgent()+"' )";
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		// TODO Auto-generated method stub
		return null;
	}

}
