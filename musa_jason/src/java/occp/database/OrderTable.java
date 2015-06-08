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
import java.text.SimpleDateFormat;

import occp.model.OrderEntity;

/**
 * 
 * @author davide
 */
public class OrderTable extends DynamicTable 
{	
	public OrderTable(String ip_address, String port, String database, String user, String password) 
	{
		super(ip_address, port, database, user, password);
	}
	
	
	public OrderTable() throws FileNotFoundException 
	{
		super(new FileInputStream(new File("config_occp.properties")));
	}
	
	@Override
	protected String getTableName() 
	{
		return "Ordini";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException 
	{
		OrderEntity response = new OrderEntity();
		
		response.set_billing_id( set.getInt("id_fattura") );
		response.set_amount( set.getInt("importo") );
		response.set_issue_date( set.getDate("data_emissione") );
		response.set_expedition_date( set.getDate("data_evasione") );
		response.set_user_id( set.getInt("id_cliente") );
		response.set_order_success( set.getBoolean("evaso") );

		return response;
	}
	
	@Override
	protected String getInsertString(Entity entity) 
	{
		OrderEntity elem = (OrderEntity) entity;
		SimpleDateFormat sdf = new SimpleDateFormat();
		
		sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
		String issue_date = sdf.format(elem.get_issue_date());
		
		//String update = String.format("INSERT INTO %s (id_fattura, importo, data_emissione, data_evasione, id_cliente) VALUES (%d, %d, \'%s\', \'%s\', %d)", getTableName(), elem.get_billing_id(), elem.get_amount(), issue_date, expedition_date, elem.get_user_id());
		String insert = String.format("INSERT INTO %s (id_fattura, importo, data_emissione, id_cliente, evaso) VALUES (%d, %d, \'%s\', %d, \'%s\')", getTableName(), elem.get_billing_id(), elem.get_amount(), issue_date, elem.get_user_id(), elem.get_order_success() ? "true" : "false");
		System.out.println(insert);
		return insert;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) 
	{
		OrderEntity elem 		= (OrderEntity) entity;
		SimpleDateFormat sdf 	= new SimpleDateFormat();
		sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
		
		String expedition_date 	= sdf.format(elem.get_expedition_date());
		String issue_date 		= sdf.format(elem.get_issue_date());
		
		String update = String.format("UPDATE %s SET data_evasione='%s', data_emissione='%s', id_cliente=%d, importo=%d, evaso=%s WHERE id_fattura=%d", getTableName(), expedition_date, issue_date, elem.get_user_id(), elem.get_amount(), elem.get_order_success() ? "true" : "false", elem.get_billing_id());
		System.out.println(update);
		return update;
	}
	
	public OrderEntity getOrder(int order_id)
	{
		String query = "SELECT * FROM "+getTableName()+" WHERE id_fattura="+String.format("%d", order_id)+";";
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
					OrderEntity data = new OrderEntity(); 
					
					data.set_amount(resultSet.getInt("importo"));
					data.set_billing_id(resultSet.getInt("id_fattura"));
					data.set_issue_date(resultSet.getDate("data_emissione"));
					data.set_expedition_date(resultSet.getDate("data_evasione"));
					data.set_user_id(resultSet.getInt("id_cliente"));
					data.set_order_success(resultSet.getBoolean("evaso"));

				    return data;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}	
}
