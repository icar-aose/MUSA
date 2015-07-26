package ids.model;

import java.sql.Timestamp;

/**
 * 
 * @author davide
 *
 */
public class CapabilityStatusEntity extends Entity
{
	private int id;
	private String capability;
	private String status;
	private Timestamp activated;
	private Timestamp terminated;
	
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getActivated() {
		return activated;
	}
	public void setActivated(Timestamp activated) {
		this.activated = activated;
	}
	public Timestamp getTerminated() {
		return terminated;
	}
	public void setTerminated(Timestamp terminated) {
		this.terminated = terminated;
	}
	
}
