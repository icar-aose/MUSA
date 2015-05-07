package cnr.icar.db.hibernate;

import java.io.Serializable;

public class CloudServicePK implements Serializable{
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected Integer idUtente;
	    protected String tipoServizio;

	    public CloudServicePK() {}

	    public CloudServicePK(Integer idUtente, String tipoServizio) {
	        this.idUtente = idUtente;
	        this.tipoServizio = tipoServizio;
	    }

		public Integer getIdUtente() {
			return idUtente;
		}

		public void setIdUtente(Integer idUtente) {
			this.idUtente = idUtente;
		}

		public String getTipoServizio() {
			return tipoServizio;
		}

		public void setTipoServizio(String tipoServizio) {
			this.tipoServizio = tipoServizio;
		}

	    
	    
}
