package cnr.icar.db.hibernate;

import java.io.Serializable;

import javax.persistence.Embeddable;
@Embeddable
public class DettaglioOrdinePK implements Serializable{
	 protected Integer idOrdine;
	    protected Integer idProdotto;

	    public DettaglioOrdinePK() {}

	    public DettaglioOrdinePK(Integer idOrdine, Integer idProdotto) {
	        this.idOrdine = idOrdine;
	        this.idProdotto = idProdotto;
	    }

		public Integer getIdOrdine() {
			return idOrdine;
		}

		public void setIdOrdine(Integer idOrdine) {
			this.idOrdine = idOrdine;
		}

		public Integer getIdProdotto() {
			return idProdotto;
		}

		public void setIdProdotto(Integer idProdotto) {
			this.idProdotto = idProdotto;
		}
	    
	    

}
