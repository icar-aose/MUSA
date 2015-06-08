package ids.database;

import ids.model.Entity;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;

import workflow_property.WorkflowProperties;

/**
 * An interface to a generic external database(mysql) table.
 * 
 * @author davide
 */
public abstract class DynamicTable 
{
	private String ip_address = null;// "ids_workflow";//"workflow";
	private String port = null;// "ids_workflow";//"workflow";
	private String database = null; // "ids_workflow";//"workflow";
	private String user = null; // "ids_root";// "workflow";
	private String password = null; // "root";//"workflow";

	private  Connection connection = null;
	
	public DynamicTable(InputStream stream) 
	{
		configure(stream);
		create_connection();
	}
	
	public DynamicTable() 
	{
		if (System.getProperty("java.class.path").contains("org.eclipse.equinox.launcher"))
//		if(WorkflowProperties.getExecutionEnvironment().equals("run"))
		{
			try 
	        {
				FileInputStream file_stream = new FileInputStream(new File( "config.properties" ));
				configure(file_stream);
				create_connection();
			} 
	        catch (FileNotFoundException e) 
	        {
				e.printStackTrace();
			}
		}
		else
		{
			InputStream is = DynamicTable.class.getResourceAsStream("/config.properties");
			configure(is);
			create_connection();
		}
	}
	
	public DynamicTable(String ip_address, String port, String database, String user, String password)
	{
		this.ip_address 	= ip_address;
		this.port 			= port;
		this.database 		= database;
		this.user 			= user;
		this.password 		= password;
		
		create_connection();
	}
	
	
	private void configure(InputStream stream) {
		Properties prop = new Properties();
		try {
			prop.load( stream );
			
			ip_address 	= prop.getProperty("ip_address");
			port 		= prop.getProperty("port");
			database 	= prop.getProperty("database");
			user 		= prop.getProperty("user");
			password 	= prop.getProperty("password");
			
			System.out.println("------------------>Opening db "+database);
			
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
	}

	private void create_connection() {
		if (ip_address!=null && port!= null && user!=null && password != null) {
			try {
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				
				String parameters = "jdbc:mysql://"+ip_address+":"+port+"/"+database;		
				connection = DriverManager.getConnection(parameters,user,password);
				
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
	}
	
	public Connection getConnection() {
		if (connection==null) {
			create_connection();
		}
			return connection;
	}

	public void closeConnection() throws SQLException {
		if (connection!=null) {
			connection.close();
		}
		connection = null;
	}

	
	protected abstract String getTableName();
	protected abstract Entity fillEntity(ResultSet set) throws SQLException;
	protected abstract String getInsertString(Entity entity);
	protected abstract String getUpdateStringByPrimary(Entity entity);

	public void deleteOneByID(int id) throws SQLException {
		String query = "DELETE FROM `"+getTableName()+"` WHERE `id` = ?";
		PreparedStatement statement = getConnection().prepareStatement(query);
		statement.setInt(1, id);
		//System.out.println(statement.toString());
		int rows = statement.executeUpdate();
		//System.out.println("deleted "+rows+" rows");
	}

	public void deleteAll() throws SQLException {
		PreparedStatement st = getConnection().prepareStatement("DELETE FROM "+getTableName() );
		st.executeUpdate();
	}
	
	public Entity findOneWhere(String where) throws SQLException {
		Entity response = null;
		Connection conn = getConnection();

		String query = "SELECT * FROM "+getTableName()+" WHERE "+where;
		ResultSet resultSet = getResultSet(query);
		return getOne(resultSet);
	}

	public Entity findOneByID(int id) throws SQLException {
		String query = "SELECT * FROM "+getTableName()+" WHERE id = '"+id+"'";
		ResultSet resultSet = getResultSet(query);
		return getOne(resultSet);
	}

	public Entity findOneBy(String column, String filter) throws SQLException {
		Entity response = null;
		Connection conn = getConnection();
		if (conn != null) {
			PreparedStatement st = conn.prepareStatement("SELECT * FROM "+getTableName()+" WHERE "+column+"=?");
			st.setString(1,filter);
			ResultSet resultSet = st.executeQuery();
			response = getOne(resultSet);
		}
		return response;
	}
	
	public Entity findOneBy(Hashtable filter_map) throws SQLException {
		Entity response = null;
		Connection conn = getConnection();
		boolean first=true;
		String filter="";
		
		Iterator it = filter_map.keySet().iterator();
		while (it.hasNext()) {
			String key = (String) it.next();
			String value = (String) filter_map.get(key);
			if (first) {
				filter += " WHERE "+key+"='"+value+"'";
				first = false;
			} else {
				filter += " AND "+key+"='"+value+"'";
			}
		}
		
		if (conn != null) {
			
			PreparedStatement st = conn.prepareStatement("SELECT * FROM "+getTableName()+filter);
			ResultSet resultSet = st.executeQuery();
			response = getOne(resultSet);
		}
		return response;
	}
	

	public Entity findOneBy(String column1, String filter1,String column2, String filter2) throws SQLException {
		PreparedStatement st = getConnection().prepareStatement(
				"SELECT * FROM " + getTableName() + " WHERE " + column1
						+ "=? AND " + column2 + "=?");
		st.setString(1, filter1);
		st.setString(2, filter2);
		ResultSet resultSet = st.executeQuery();
		return getOne(resultSet);
	}

	public Entity findOneBy(String column1, String filter1,String column2, String filter2,String column3, String filter3) throws SQLException {
		PreparedStatement st = getConnection().prepareStatement(
				"SELECT * FROM " + getTableName() + " WHERE " + column1
						+ "=? AND " + column2 + "=? AND " + column3 + "=?");
		st.setString(1, filter1);
		st.setString(2, filter2);
		st.setString(3, filter3);
		ResultSet resultSet = st.executeQuery();
		return getOne(resultSet);
	}

	public Entity findMostRecentBy(Hashtable filter_map,String data_field) throws SQLException {
		Entity response = null;
		Connection conn = getConnection();
		boolean first=true;
		String filter="";

		Iterator it = filter_map.keySet().iterator();
		while (it.hasNext()) {
			String key = (String) it.next();
			String value = (String) filter_map.get(key);
			if (first) {
				filter += " WHERE "+key+"='"+value+"'";
				first = false;
			} else {
				filter += " AND "+key+"='"+value+"'";
			}
		}

		if (conn != null) {

			Timestamp ts = null;
			Statement st = conn.createStatement(  );
			st.execute( "SELECT max("+data_field+") FROM "+getTableName()+filter );
			ResultSet resultSet = st.getResultSet();

			while ( resultSet.next() ){
				ts = resultSet.getTimestamp(1);
			}
			
			if (ts != null) {
				filter += " AND "+data_field+"='"+ts.toString()+"'";
			}
		}
		
		

		if (conn != null) {

			PreparedStatement st = conn.prepareStatement("SELECT * FROM "+getTableName()+filter);
			ResultSet resultSet = st.executeQuery();
			response = getOne(resultSet);
		}
		return response;
	}

	
	public Entity findOneBy(String column1, String filter1,String column2, String filter2,String column3, String filter3,String column4, String filter4) throws SQLException {
		PreparedStatement st = getConnection().prepareStatement(
				"SELECT * FROM " + getTableName() + " WHERE " + column1
						+ "=? AND " + column2 + "=? AND " + column3 + "=? AND " + column4 + "=?");
		st.setString(1, filter1);
		st.setString(2, filter2);
		st.setString(3, filter3);
		st.setString(4, filter4);
		ResultSet resultSet = st.executeQuery();
		return getOne(resultSet);
	}

	public List<Entity> getAll() throws SQLException {
		PreparedStatement st = getConnection().prepareStatement("SELECT * FROM "+getTableName() );
		ResultSet resultSet = st.executeQuery();
		LinkedList<Entity> results = new LinkedList<Entity>();
		while (resultSet.next()) {
			Entity elem = fillEntity(resultSet);
			results.add(elem);
		}		
		return results;
	}

	public List<Entity> getAllWhere(String column, String filter) throws SQLException {
		PreparedStatement st = getConnection().prepareStatement("SELECT * FROM "+getTableName()+" WHERE "+column+"=?");
		st.setString(1,filter);
		ResultSet resultSet = st.executeQuery();
		LinkedList<Entity> results = new LinkedList<Entity>();
		while (resultSet.next()) {
			Entity elem = fillEntity(resultSet);
			results.add(elem);
		}
		return results;
	}

	public void insertElement(Entity entity) throws SQLException {		
		String insert_string = getInsertString(entity);
		Statement statement = getConnection().createStatement();
		statement.executeUpdate(insert_string);
	}	

	public void updateElementByPrimary(Entity entity) throws SQLException {		
		String update_string = getUpdateStringByPrimary(entity);
		//System.out.println("SQL: "+update_string);
		Statement statement = getConnection().createStatement();
		statement.executeUpdate(update_string);
	}	

	private ResultSet getResultSet(String query) throws SQLException {
		ResultSet resultSet=null;
		Statement statement;
		try {
			Connection conn = getConnection();
			statement = conn.createStatement();
			resultSet = statement.executeQuery(query);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	private Entity getOne(ResultSet resultSet) throws SQLException {
		Entity response = null;
		if (resultSet != null)	{
			resultSet.last();
			if (resultSet.getRow()>0) {
				resultSet.first();
				response = fillEntity(resultSet);
			}
		}
		return response;
	}
}
