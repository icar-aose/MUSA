package musa.model;

import java.sql.Timestamp;

public class ValueEntity extends Entity {

	private int id;
	private int project_ref;
	private String type;
	private String value;
	private Timestamp updated;
	private String agent;
	private String TaskTC;
	private String TaskFS;
	
	
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
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
	
	public String getTaskFS() {
		return TaskFS;
	}

	public void setTaskFS(String taskFS) {
		TaskFS = taskFS;
	}

	public String getTaskTC() {
		return TaskTC;
	}

	public void setTaskTC(String taskTC) {
		TaskTC = taskTC;
	}

	
}
