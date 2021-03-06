package musa.database;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

import musa.model.Entity;
import musa.model.RouteEntity;

public class RouteTable extends Table {

	public RouteTable() {
		super();
	}

	public RouteTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_route";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		RouteEntity response = new RouteEntity();
		set.first();
		
		response.setId( set.getInt("id") );
		response.setAgent( set.getString("agent") );
		response.setService_path( set.getString("service") );	
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		RouteEntity elem = (RouteEntity) entity;
		String update = "INSERT INTO "+getTableName()+" (service_path, agent) VALUES ('"+elem.getService_path()+"' , '"+elem.getAgent()+"' )";
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		// TODO Auto-generated method stub
		return null;
	}
	
}
