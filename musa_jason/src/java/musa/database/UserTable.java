package musa.database;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import musa.model.Entity;
import musa.model.UserEntity;

public class UserTable extends Table {

	public UserTable() {
		super();
	}

	public UserTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_user";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		UserEntity response = new UserEntity();
		//set.first();
		
		response.setId( set.getInt("id") );
		response.setUsername( set.getString("username") );
		response.setEmail( set.getString("email") );	
		response.setRole_ref( set.getInt("role_ref") );	
		return response;
	}
	
	@Override
	protected String getInsertString(Entity entity) {
		UserEntity elem = (UserEntity) entity;
		String update = "INSERT INTO "+getTableName()+" (username, email, role_ref) VALUES ('"+elem.getUsername()+"' , '"+elem.getEmail()+" , "+elem.getRole_ref()+"' )";
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		// TODO Auto-generated method stub
		return null;
	}

}
