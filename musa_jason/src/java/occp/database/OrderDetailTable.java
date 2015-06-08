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
import java.util.LinkedList;
import java.util.List;

import occp.logger.musa_logger;
import occp.model.OrderDetailEntity;

/**
 * 
 * @author davide
 */
public class OrderDetailTable extends DynamicTable 
{
	public OrderDetailTable(String ip_address, String port, String database, String user, String password) 
	{
		super(ip_address, port, database, user, password);
	}
	
	public OrderDetailTable() throws FileNotFoundException 
	{
		super(new FileInputStream(new File("config_occp.properties")));
	}
	
	@Override
	protected String getTableName() 
	{
		return "DettaglioOrdine";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException 
	{
		OrderDetailEntity response = new OrderDetailEntity();
		
		response.set_idOrdine(set.getInt("idOrdine"));
		response.set_idProdotto(set.getInt("idProdotto"));
		response.set_quantita(set.getInt("quantita"));

		return response;
	}
	
	@Override
	protected String getInsertString(Entity entity) 
	{
		OrderDetailEntity elem = (OrderDetailEntity) entity;

		String update = String.format("INSERT INTO %s (idOrdine, idProdotto, quantita) VALUES (%d, %d, %d)", getTableName(), elem.get_idOrdine(), elem.get_idProdotto(), elem.get_quantita());
		
		System.out.println(update);
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) 
	{
		return null;
	}
	
	
	public List<OrderDetailEntity> getOrderDetail(int order_id)
	{
		List<OrderDetailEntity> response = new LinkedList<OrderDetailEntity>();
		
		String query = "SELECT * FROM "+getTableName()+" WHERE idOrdine="+String.format("%d", order_id)+";";
		musa_logger.get_instance().info("Executing query: "+query+"\n");
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
					OrderDetailEntity data = new OrderDetailEntity(); 
					
					data.set_idOrdine( resultSet.getInt("idOrdine") );
					data.set_idProdotto( resultSet.getInt("idProdotto") );
					data.set_quantita( resultSet.getInt("quantita") );
					
				    response.add(data);
				}
			}
		} 
		catch (SQLException e) {e.printStackTrace();}
		
		return response;
	}
	
}
