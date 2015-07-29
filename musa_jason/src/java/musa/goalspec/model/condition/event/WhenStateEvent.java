/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.condition.event;

import musa.goalspec.model.state.State;

import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class WhenStateEvent extends Event {
    private State state;

    public State getState() {
        return state;
    }

    public void setState(State state) {
        this.state = state;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        String state_id = state.getId(name);
        
        belief_base.add("event_occur_when_state_true("+cond_id+", "+state_id+")[pack("+namespace+")]");
        state.addBelief(belief_base, name, namespace);
    }

	@Override
	public String getPredicate() {
		return state.getPredicate();
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
