package musa.model;

import java.sql.Timestamp;

/**
 * 
 * @author davide
 */
public class BlacklistEntity extends Entity
{
	private int id;
	private String capability;
	private String agent;
	private int failure_rate;
	private Timestamp updated;
	private int project_ref;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCapability() {
		return capability;
	}
	public void setCapability(String capability) {
		this.capability = capability;
	}
	public int getFailure_rate() {
		return failure_rate;
	}
	public void setFailure_rate(int failure_rate) {
		this.failure_rate = failure_rate;
	}
	public String getAgent() {
		return agent;
	}
	public void setAgent(String agent) {
		this.agent = agent;
	}
	public Timestamp getUpdated() {
		return updated;
	}
	public void setUpdated(Timestamp updated) {
		this.updated = updated;
	}
	public int getProject_ref() {
		return project_ref;
	}
	public void setProject_ref(int project_ref) {
		this.project_ref = project_ref;
	}
	
	
}
