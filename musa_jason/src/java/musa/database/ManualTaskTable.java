package musa.database;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

import musa.model.ContextEntity;
import musa.model.Entity;
import musa.model.ManualTaskEntity;
import musa.model.UserEntity;

public class ManualTaskTable extends Table {

	public ManualTaskTable() {
		super();
	}

	public ManualTaskTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_manual_task";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		ManualTaskEntity response = new ManualTaskEntity();
		set.first();
		
		response.setId( set.getInt("id") );
		response.setLabel( set.getString("label"));
		response.setDescription( set.getString("description"));
		response.setUser( retrieveUser( set.getInt("user_ref")) );
		response.setContext( retrieveContext( set.getInt("session_ref")) );	
		response.setCreated( set.getDate("created") );
		response.setClosed( set.getDate("closed") );		
		response.setProgress( set.getInt("progress") );	
		response.setService( set.getString("service"));
		
		return response;
	}
	
	private UserEntity retrieveUser(int ref) {
		UserTable user_table = new UserTable();
		UserEntity response = null;
		try {
			response = (UserEntity) user_table.findOneByID(ref);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return response;
	}

	private ContextEntity retrieveContext(int ref) {
		ProjectTable context_table = new ProjectTable();
		ContextEntity response = null;
		try {
			response = (ContextEntity) context_table.findOneByID(ref);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		ManualTaskEntity elem = (ManualTaskEntity) entity;
		String values = "("+elem.getLabel()+","+elem.getDescription()+","+elem.getUser().getId()+","+elem.getContext().getId()+",0,"+elem.getService()+")";
		String update = "INSERT INTO "+getTableName()+" ( label,description,user_ref,session_ref,progress,service ) VALUES "+values;
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		// TODO Auto-generated method stub
		return null;
	}

}
