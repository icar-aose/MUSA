package musa.database;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

import musa.model.BlacklistEntity;
import musa.model.DepartmentEntity;
import musa.model.Entity;

/**
 * 
 * @author davide
 */
public class BlacklistTable extends Table 
{
	public BlacklistTable() {
		super();
	}

	public BlacklistTable(InputStream stream) {
		super(stream);
	}
	@Override
	protected String getTableName()
	{
		return "adw_blacklist";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException 
	{
		BlacklistEntity response = new BlacklistEntity();
//		set.first();
		
		response.setId( set.getInt("id") );
		response.setCapability( set.getString("capability") );
		response.setAgent( set.getString("agent") );
		response.setFailure_rate( set.getShort("failure_rate") );
		response.setUpdated( set.getTimestamp("updated") );
		response.setProject_ref( set.getInt("project_ref") );
		
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) 
	{
		BlacklistEntity elem = (BlacklistEntity)entity;
		
		String values = "('"+elem.getCapability()+"','"+elem.getAgent()+"','"+elem.getFailure_rate()+"')";
		String fields = " capability, agent, failure_rate ";
		String update = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		
		
		System.out.println("insert: "+update);
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) 
	{
		BlacklistEntity elem = (BlacklistEntity)entity;
		String primary = "id = '"+elem.getId()+"'";
		String fields = " capability='"+elem.getCapability()+"', agent='"+elem.getAgent()+ "', failure_rate= "+String.format("%d", elem.getFailure_rate());
		
		String update = "UPDATE "+getTableName()+" SET "+fields+" WHERE "+primary;
		
		System.out.println("update: "+update);
		return update;
	}
	
}
