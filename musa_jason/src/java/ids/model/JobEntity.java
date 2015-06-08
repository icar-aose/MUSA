package ids.model;

import java.util.Date;

public class JobEntity extends Entity {
	private int id;
	
	private String service;
	
	private String label;
	
	private int user;
	
	private int role;

	private int project;
	
	private String agent;

	private Date created;

	private Date closed;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getService() {
		return service;
	}

	public void setService(String service) {
		this.service = service;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public int getUserRef() {
		return user;
	}

	public void setUserRef(int user) {
		this.user = user;
	}

	public int getRoleRef() {
		return role;
	}

	public void setRoleRef(int role) {
		this.role = role;
	}

	public int getProject() {
		return project;
	}

	public void setProject(int project) {
		this.project = project;
	}

	public String getAgent() {
		return agent;
	}

	public void setAgent(String agent) {
		this.agent = agent;
	}

	public Date getCreated() {
		return created;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	public Date getClosed() {
		return closed;
	}

	public void setClosed(Date closed) {
		this.closed = closed;
	}


	
}
