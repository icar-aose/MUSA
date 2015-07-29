/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.state.term;

import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class StringTerm extends TermPredicate {
    private String string;

    public String getString() {
        return string;
    }

    public void setString(String string) {
        this.string = string;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {

    }
    
    @Override
    public String toString() {
        return "\""+string+"\"";
    }

    public boolean isGround() {
        return false;
    }

	@Override
	public String getPredicate() {
		return "\""+string+"\"";
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
