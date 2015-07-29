/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.condition;

import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class NOTCondition extends Condition {
    private Condition negative;

    public Condition getNegative() {
        return negative;
    }

    public void setNegative(Condition negative) {
        this.negative = negative;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        String neg_id = negative.getId(name);
        
        belief_base.add("event_definition("+cond_id+", neg( "+neg_id+" ) )[pack("+namespace+")]");
        negative.addBelief(belief_base, name, namespace);
        
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
