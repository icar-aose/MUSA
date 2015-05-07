package cnr.icar.db.hibernate;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;

public class CloudServices implements Serializable {
	 
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@EmbeddedId
	 private CloudServicePK cloudServicePK;

	 @Column(name="accessToken")  
	 private String accessToken;

	public CloudServicePK getCloudServicePK() {
		return cloudServicePK;
	}

	public void setCloudServicePK(CloudServicePK cloudServicePK) {
		this.cloudServicePK = cloudServicePK;
	}

	public String getAccessToken() {
		return accessToken;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}  
	
	
	 
	 
	 
}
