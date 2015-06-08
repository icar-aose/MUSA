package ids.model;

import java.sql.Timestamp;

public class StateEntity extends Entity {

	private int id;
	
	private int project_ref;
	
	private String assertion;
	
	private Timestamp updated;
	
	private String agent;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getProjectRef() {
		return project_ref;
	}

	public void setProjectRef(int project_ref) {
		this.project_ref = project_ref;
	}

	public Timestamp getUpdated() {
		return updated;
	}

	public void setUpdated(Timestamp updated) {
		this.updated = updated;
	}

	public String getAgent() {
		return agent;
	}

	public void setAgent(String agent) {
		this.agent = agent;
	}

	public String getAssertion() {
		return assertion;
	}

	public void setAssertion(String assertion) {
		this.assertion = assertion;
	}

	
}
