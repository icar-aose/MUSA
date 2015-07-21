package ids.model;

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
	
}
