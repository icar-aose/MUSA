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

import occp.model.ProductEntity;

/**
 * 
 * @author davide
 *
 */
public class ProductTable extends DynamicTable 
{
	public ProductTable(String ip_address, String port, String database, String user, String password) 
	{
		super(ip_address, port, database, user, password);
	}
	
	public ProductTable() throws FileNotFoundException 
	{
		super(new FileInputStream(new File("config_occp.properties")));
	}

	@Override
	protected String getTableName() 
	{
		return "Prodotti";
	}

	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException 
	{
		ProductEntity response = new ProductEntity();
		
		response.set_id( set.getInt("id") );
		response.set_denominazione( set.getString("denominazione") );
		response.set_descrizione( set.getString("descrizione") );
		response.set_disponibilita(set.getInt("disponibilita"));
		response.set_prezzo( set.getInt("prezzo") );
		response.set_tipologia( set.getString("tipologia") );
			
		return response;
	}
	
	@Override
	protected String getInsertString(Entity entity) 
	{
		ProductEntity elem = (ProductEntity) entity;
		
		String descrizione 		= elem.get_descrizione().replace("'", "\'");
		String denominazione 	= elem.get_denominazione().replace("'", "\'");
		
		String update = String.format("INSERT INTO %s (id, denominazione, descrizione, prezzo, tipologia, disponibilita) VALUES (%d, \"%s\", \"%s\", %d, \'%f\', \"%s\", %d);", getTableName(), elem.get_id(),denominazione,descrizione,elem.get_prezzo(),elem.get_tipologia(),elem.get_disponibilita());
		return update;
	}

	@Override
	protected String getUpdateStringByPrimary(Entity entity) 
	{
		ProductEntity elem = (ProductEntity) entity;
		
		String prezzo = String.valueOf(elem.get_prezzo());
		System.out.println("Prezzo: "+prezzo);
		prezzo = prezzo.replace(',', '.');
		
		String descrizione = "";
		String denominazione = "";
		if(elem.get_descrizione() != null)
			descrizione = elem.get_descrizione().replace("'", "\'");
		
		if(elem.get_denominazione() != null)
			denominazione = elem.get_denominazione().replace("'", "\'");
		
		String update = String.format("UPDATE %s  SET denominazione=\"%s\", descrizione=\"%s\", prezzo=%s, tipologia=\"%s\", disponibilita=%d WHERE id=%d;", getTableName(),denominazione,descrizione,prezzo,elem.get_tipologia(), elem.get_disponibilita(), elem.get_id());
		
		System.out.println("Executing query "+update);
		return update;
	}
	
	
	public ProductEntity getProduct(int product_id)
	{
		String query = "SELECT * FROM "+getTableName()+" WHERE id="+String.format("%d", product_id)+";";
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
					ProductEntity data = new ProductEntity(); 
					
					data.set_id(resultSet.getInt("id"));
					data.set_denominazione(resultSet.getString("denominazione"));
					data.set_descrizione(resultSet.getString("descrizione"));
					data.set_disponibilita(resultSet.getInt("disponibilita"));
					data.set_prezzo(resultSet.getFloat("prezzo"));
					data.set_tipologia(resultSet.getString("tipologia"));

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
