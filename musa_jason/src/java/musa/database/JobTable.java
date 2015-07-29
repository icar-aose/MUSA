package musa.database;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import musa.model.ContextEntity;
import musa.model.Entity;
import musa.model.JobEntity;
import musa.model.UserEntity;

public class JobTable extends Table {

	public JobTable() {
		super();
	}

	public JobTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_job";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		JobEntity response = new JobEntity();
		//set.first();
		
		response.setId( set.getInt("id") );
		response.setService( set.getString("service"));
		response.setLabel( set.getString("label"));
		response.setUserRef( set.getInt("user_ref") );
		response.setRoleRef( set.getInt("role_ref") );
		response.setProject( set.getInt("project") );	
		response.setAgent( set.getString("owner_agent"));
		response.setCreated( set.getDate("created") );
		
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		JobEntity elem = (JobEntity) entity;
		
		//Timestamp ts = new Timestamp(elem.getCreated().getTime());
		String values = "('"+elem.getService()+"','"+elem.getLabel()+"','"+elem.getUserRef()+"','"+elem.getRoleRef()+"','"+elem.getProject()+"','"+elem.getAgent()+"')";
		String fields = " service, label, user_ref, role_ref, project, owner_agent ";
		
		String update = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		//System.out.println(update);
		
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		// TODO Auto-generated method stub
		return null;
	}

}
