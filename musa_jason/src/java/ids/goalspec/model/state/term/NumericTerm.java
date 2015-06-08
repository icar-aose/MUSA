/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.state.term;

import ids.goalspec.model.state.Predicate;

import java.util.Iterator;
import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class NumericTerm extends TermPredicate {
    private int value;

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {

    }
    
    @Override
    public String toString() {
        return new Integer(value).toString();
    }
    
    public boolean isGround() {
        return false;
    }

	@Override
	public String getPredicate() {
		return ""+value;
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
