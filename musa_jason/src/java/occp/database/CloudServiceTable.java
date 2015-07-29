package occp.database;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedList;
import java.util.List;

import musa.database.DynamicTable;
import musa.model.Entity;
import occp.model.CloudServiceEntity;

public class CloudServiceTable extends DynamicTable 
{
	public CloudServiceTable(String ip_address, String port, String database, String user, String password) 
	{
		super(ip_address, port, database, user, password);
	}
	
	public CloudServiceTable() throws FileNotFoundException 
	{
		super(new FileInputStream(new File("config_occp.properties")));
	}
	
	@Override
	protected String getTableName() 
	{
		return "CloudServices";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException 
	{
		CloudServiceEntity response = new CloudServiceEntity();
		
		response.set_idUtente(set.getInt("idUtente"));
		response.set_accessToken(set.getString("accessToken"));
		response.set_tipoServizio(set.getString("tipoServizio"));

		return response;
	}
	
	@Override
	protected String getInsertString(Entity entity) 
	{
		CloudServiceEntity elem = (CloudServiceEntity) entity;

		String update = String.format("INSERT INTO %s (idUtente, accessToken, tipoServizio) VALUES (%d, %s, %d);", getTableName(), elem.get_idUtente(), elem.get_accessToken(), elem.get_tipoServizio());
		
		System.out.println(update);
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) 
	{
		CloudServiceEntity elem = (CloudServiceEntity) entity;

		String update = String.format("UPDATE %s SET accessToken=\'%s\', tipoServizio=%d WHERE idUtente=%d;", getTableName(), elem.get_accessToken(), elem.get_tipoServizio(), elem.get_idUtente());
		
		System.out.println(update);
		
		return update;
	}
	
	
	public List<CloudServiceEntity> getUserCloudServices(int user_id)
	{	
		List<CloudServiceEntity> response = new LinkedList<CloudServiceEntity>();
		
		String query = "SELECT * FROM "+getTableName()+" WHERE idUtente="+String.format("%d", user_id)+";";
		
		try 
		{
			Connection conn 		= getConnection();
			Statement statement 	= conn.createStatement();
			ResultSet resultSet 	= statement.executeQuery(query);
			if (resultSet != null)	
			{
				resultSet.beforeFirst();
				while (resultSet.next()) 
				{
					CloudServiceEntity data = new CloudServiceEntity(); 
					
					data.set_idUtente(resultSet.getInt("idUtente"));
					data.set_accessToken(resultSet.getString("accessToken"));
					data.set_tipoServizio(resultSet.getString("tipoServizio"));
					
				    response.add(data);
				}
			}
		} 
		catch (SQLException e) {e.printStackTrace();}
		
		return response;
	}

}
