/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.condition.event;

import ids.goalspec.model.condition.Condition;

import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class DelayEvent extends Event {
    private Condition pre_condition;
    private int delay;

    public Condition getPre_condition() {
        return pre_condition;
    }

    public void setPre_condition(Condition pre_condition) {
        this.pre_condition = pre_condition;
    }

    public int getDelay() {
        return delay;
    }

    public void setDelay(int delay) {
        this.delay = delay;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        String pre_id = pre_condition.getId(name);
        
        belief_base.add("event_occur_after("+cond_id+", delay(0,0,0,0,1,30), "+pre_id+")[pack("+namespace+")]");
        pre_condition.addBelief(belief_base, name, namespace);
    }

	@Override
	public String getPredicate() {
		return "after("+", delay(0,0,0,0,1,30), "+pre_condition.getPredicate()+")";
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
