/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.state;

import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class NOTState extends State {
    private State negative;

    public State getNegative() {
        return negative;
    }

    public void setNegative(State negative) {
        this.negative = negative;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        String neg_id = negative.getId(name);
        
        belief_base.add("state_definition("+cond_id+", neg( "+neg_id+" ) )[pack("+namespace+")]");
        negative.addBelief(belief_base, name,namespace);
    }

	@Override
	public String getPredicate() {
		return "not("+negative.getPredicate()+")";
	}

	@Override
	public String getPredicateWithinAND() {
		return getPredicate();
	}

	@Override
	public String getPredicateWithinOR() {
		return getPredicate();
	}
}
