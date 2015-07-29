/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.state.term;

import java.util.Iterator;
import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class AtomTerm extends TermPredicate {
    private String atom;

    public String getAtom() {
        return atom;
    }

    public void setAtom(String term) {
        this.atom = term;
    }
    
    public boolean isGround() {
        return false;
    }

    @Override
    public String toString() {
        return atom;
    }

    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {

    }

	@Override
	public String getPredicate() {
		return atom;
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
