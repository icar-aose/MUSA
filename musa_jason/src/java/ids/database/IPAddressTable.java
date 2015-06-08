package ids.database;

import ids.model.Entity;
import ids.model.IPAddressEntity;

import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

public class IPAddressTable extends Table {

	public IPAddressTable() {
		super();
	}

	public IPAddressTable(InputStream stream) {
		super(stream);
	}

	@Override
	protected String getTableName() {
		return "adw_ip_address";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException {
		IPAddressEntity response = new IPAddressEntity();
		response.setName(set.getString("name"));
		response.setAddress( set.getString("address"));
		return response;
	}

	@Override
	protected String getInsertString(Entity entity) {
		IPAddressEntity elem = (IPAddressEntity) entity;
		String values = "('"+elem.getName()+"','"+elem.getAddress()+"')";
		String fields = " name, address ";
		
		String insert_string = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		return insert_string;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) {
		IPAddressEntity elem = (IPAddressEntity) entity;
		String primary = "name = '"+elem.getName()+"'";
		
		String fields="";
		fields = " address='"+elem.getAddress()+"'";
		
		String update = "UPDATE "+getTableName()+" SET "+fields+" WHERE "+primary;
		
		return update;
	}

}
