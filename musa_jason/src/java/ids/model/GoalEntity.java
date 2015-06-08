package ids.model;

/**
 * Entity class that contains data from the table "adw_goal".
 * 
 * <br/>Created: 2014/10/23
 * @author Davide Guastella
 */
public class GoalEntity extends Entity 
{
	/** The ID of a goal */
	private int id;
	
	/** The pack name of a goal */
	private String pack;
	
	/** The name of a goal */
	private String name;
	
	/** The description of a goal*/
	private String goal_description;

	
	//-----------
	//GET METHODS
	//-----------
	/**
	 * Return the <b>id</b> of this goal.
	 */
	public int getID()
	{
		return id;
	}
	
	/**
	 * Return the <b>pack</b> of this goal.
	 */
	public String getPack()
	{
		return pack;
	}
	
	/**
	 * Return the <b>name</b> of this goal.
	 */
	public String getName()
	{
		return name;
	}
	
	/**
	 * Return the <b>description</b> of this goal.
	 */
	public String getGoalDescription()
	{
		return goal_description;
	}
	
	//-----------
	//SET METHODS
	//-----------
	
	/**
	 * Set the <b>id</b> of this goal.
	 */
	public void setID(int ID)
	{
		this.id = ID;
	}
	
	/**
	 * Set the <b>pack</b> of this goal.
	 */
	public void setPack(String pack)
	{
		this.pack = pack;
		
	}
	
	/**
	 * Set the <b>name</b> of this goal.
	 */
	public void setName(String name)
	{
		this.name = name;
		
	}
	
	/**
	 * Set the <b>description</b> of this goal.
	 */
	public void setGoalDescription(String goalDescription)
	{
		this.goal_description = goalDescription;
	}	
	
	
	@Override
	public boolean equals(Object obj) 
	{
		GoalEntity entity = (GoalEntity)obj;
		
		if( this.getName().equals(entity.getName()) && 
			this.getPack().equals(entity.getPack()) &&
			this.getGoalDescription().equals(entity.getGoalDescription()) )
			return true;
		
		return false;
	}
	
}
