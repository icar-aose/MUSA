package ids.database;

import ids.model.DepartmentEntity;
import ids.model.Entity;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

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

}
