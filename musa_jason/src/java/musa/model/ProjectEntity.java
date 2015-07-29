package musa.model;

import java.sql.Timestamp;

public class ProjectEntity extends Entity {

	private int id;
	
	private int department_ref;
	
	private String name;
	
	private Timestamp start;
	
	private Timestamp end;

	private String coordinator;
	
	private String contracts;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getDepartmentRef() {
		return department_ref;
	}

	public void setDepartmentRef(int department_ref) {
		this.department_ref = department_ref;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Timestamp getStart() {
		return start;
	}

	public void setStart(Timestamp start) {
		this.start = start;
	}

	public Timestamp getEnd() {
		return end;
	}

	public void setEnd(Timestamp end) {
		this.end = end;
	}

	public String getCoordinator() {
		return coordinator;
	}

	public void setCoordinator(String coordinator) {
		this.coordinator = coordinator;
	}

	public String getContracts() {
		return contracts;
	}

	public void setContracts(String contracts) {
		this.contracts = contracts;
	}
	
	
}
