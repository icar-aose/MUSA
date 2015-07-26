package ids.database;

import ids.model.CapabilityStatusEntity;
import ids.model.Entity;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 
 * @author davide
 *
 */
public class CapabilityStatusTable extends Table 
{

	public CapabilityStatusTable() 
	{
		super();
	}

	public CapabilityStatusTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_capability_status";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException 
	{
		CapabilityStatusEntity response = new CapabilityStatusEntity();
		response.setId( set.getInt("id") );
		response.setCapability( set.getString("capability") );
		response.setStatus( set.getString("status") );
//		response.setActivated( set.getString("status") );
//		response.setTerminated( set.getString("status") );
		
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) 
	{
		CapabilityStatusEntity elem = (CapabilityStatusEntity) entity;
		
		String values = "('"+elem.getCapability()+"','"+elem.getStatus()+"')";
		String fields = " capability, status ";
		String update = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) 
	{
		CapabilityStatusEntity elem = (CapabilityStatusEntity)entity;
		
		String primary = "id = '"+elem.getId()+"'";
		String fields = " capability='"+elem.getCapability()+"', status='"+elem.getStatus()+"'";
		String update = "UPDATE "+getTableName()+" SET "+fields+" WHERE "+primary;
		
		return update;
	}
	
}
