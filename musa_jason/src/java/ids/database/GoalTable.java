package ids.database;

import ids.model.Entity;
import ids.model.GoalEntity;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * Control class that interfaces to the database table "adw_goal".
 * 
 * @author Davide Guastella
 */
public class GoalTable extends Table 
{
	public GoalTable() 
	{
		super();
	}

	public GoalTable(InputStream stream) 
	{
		super(stream);
	}
	
	
	/**
	 * Return the name of the table this class interface to.
	 */
	@Override
	protected String getTableName() 
	{
		return "adw_goal";
	}

	/**
	 * Fill the entity class with the data from a given dataset
	 * 
	 *  @param set 
	 */
	@Override
	protected Entity fillEntity(ResultSet set) throws SQLException 
	{
		GoalEntity response = new GoalEntity();
		
		response.setID( set.getInt("id") );
		response.setPack( set.getString("pack") );
		response.setName( set.getString("name") );
		response.setGoalDescription( set.getString("goal_description") );
		
		return response;
	}

	/**
	 *  Return a SQL <u><i>insert</i></u> statement for the table "adw_goal".
	 *  
	 *  @param entity the entity for which the insert statement must be built.
	 */
	@Override
	protected String getInsertString(Entity entity) 
	{
		GoalEntity elem = (GoalEntity) entity;
		
		String values = "('"+elem.getPack()+"','"+elem.getName()+"','"+elem.getGoalDescription()+"')";
		String fields = " pack, name, goal_description";
		String update = "INSERT INTO "+getTableName()+" ( "+fields+" ) VALUES "+values;
		
		return update;
	}

	/**
	 *  Return a SQL <u><i>update</i></u> statement for the table "adw_goal".
	 *  
	 *  @param entity the entity for which the update statement must be built.
	 */
	@Override
	protected String getUpdateStringByPrimary(Entity entity) 
	{
		GoalEntity elem = (GoalEntity) entity;
		
		String primary 	= "id = '"+elem.getID()+"'";
		String fields 	= " pack, name, goal_description";
		fields 			= " name='"+elem.getName()+"', pack='"+elem.getPack()+"', goal_description='"+elem.getGoalDescription()+"'";
		String update 	= "UPDATE "+getTableName()+" SET "+fields+" WHERE "+primary;
		
		return update;
	}
	
	
	/**
	 * Return a list containing all the goals into the database.
	 */
	public List<GoalEntity> getAllGoals() 
	{
		List<GoalEntity> response = new LinkedList<GoalEntity>();
		
		String query = "SELECT * FROM "+getTableName();
		System.out.println("Executing query: "+query+"\n");
		
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
					GoalEntity data = new GoalEntity(); 
					
					data.setID( resultSet.getInt("id") );
					data.setName( resultSet.getString("name") );
					data.setPack( resultSet.getString("pack") );
					data.setGoalDescription( resultSet.getString("goal_description") );

				    response.add(data);
				}
			}
		} catch (SQLException e) {

		}
		
		return response;
	}
	
	
	//Use it only for test purpose...
	public static void main(String args[])
	{		
		GoalTable table = new GoalTable();
		List<GoalEntity> list = table.getAllGoals();
		Iterator<GoalEntity> it = list.iterator();
		
		while (it.hasNext()) 
		{
			GoalEntity entity = it.next();
			System.out.println("Goal '"+entity.getName()+"' data:\nID:"+entity.getID()+"\npack:"+entity.getPack()+"\ndescription:"+entity.getGoalDescription()+"\n--------------\n");
		}
		
		
	}

}
