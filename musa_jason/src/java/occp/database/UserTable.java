package occp.database;

import ids.database.DynamicTable;
import ids.model.Entity;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import occp.model.UserEntity;

/**
 * 
 * @author davide
 *
 */
public class UserTable extends DynamicTable 
{
	public UserTable(String ip_address, String port, String database, String user, String password) 
	{
		super(ip_address, port, database, user, password);
	}
	
	public UserTable() throws FileNotFoundException 
	{
		super(new FileInputStream(new File("config_occp.properties")));
	}

	@Override
	protected String getTableName() 
	{
		return "Utenti";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException 
	{
		UserEntity response = new UserEntity();
		
		response.set_id( set.getInt("id") );
		response.set_nome( set.getString("nome") );
		response.set_cognome( set.getString("cognome") );
		response.set_email( set.getString("email") );
		response.set_telefono( set.getInt("telefono") );
		response.set_partita_iva( set.getInt("partitaIVA") );
		response.set_username( set.getString("username") );
		response.set_password( set.getString("password") );
		response.set_amministratore( set.getBoolean("amministratore") );
		response.set_infocloud( set.getString("infocloud") );
		
		return response;
	}
	
	@Override
	protected String getInsertString(Entity entity) 
	{
		UserEntity elem = (UserEntity) entity;
		
		String update = String.format("INSERT INTO %s (id, nome, cognome, email, telefono, partitaIVA, username, password, amministratore, infocloud) VALUES (%d, \'%s\', \'%s', \'%s\', %d, %d, \'%s\', \'%s\', \'%s\', \'%s\');", 
												getTableName(), elem.get_id(),elem.get_nome(),elem.get_cognome(),elem.get_email(),elem.get_telefono(),elem.get_partita_iva(), elem.get_username(), elem.get_password(), elem.get_amministratore() ? "true" : "false", elem.get_infocloud());
		
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) 
	{
		UserEntity elem = (UserEntity) entity;
		
		String update = String.format("UPDATE %s SET nome=\'%s\', cognome=\'%s\', email=\'%s\', telefono=%d, partitaIVA=%d, username=\'%s\', password=\'%s\', amministratore=\'%s\', infocloud=\'%s\' WHERE id=%d;", 
									   getTableName(), elem.get_nome(),elem.get_cognome(),elem.get_email(),elem.get_telefono(),elem.get_partita_iva(), elem.get_username(), elem.get_password(), elem.get_amministratore() ? "true" : "false", elem.get_infocloud(), elem.get_id());
		
		return update;
	}
	
	public UserEntity getUser(int user_id)
	{
		String query = "SELECT * FROM "+getTableName()+" WHERE id="+String.format("%d", user_id)+";";
		//System.out.println("Executing query: "+query+"\n");
		
		try 
		{
			Connection conn = getConnection();
			Statement statement = conn.createStatement();
			ResultSet resultSet = statement.executeQuery(query);
			
			if (resultSet != null)	
			{
				resultSet.beforeFirst();
				while (resultSet.next()) 
				{
					UserEntity data = new UserEntity(); 
					
					data.set_id(resultSet.getInt("id"));
					data.set_nome(resultSet.getString("nome"));
					data.set_cognome(resultSet.getString("cognome"));
					data.set_email(resultSet.getString("email"));
					data.set_telefono(resultSet.getInt("telefono"));
					data.set_partita_iva(resultSet.getInt("partitaIVA"));
					data.set_username(resultSet.getString("username"));
					data.set_password(resultSet.getString("password"));
					data.set_amministratore(resultSet.getBoolean("amministratore"));
					data.set_infocloud(resultSet.getString("infocloud"));
					
				    return data;
				}
			}
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		return null;
	}
}
