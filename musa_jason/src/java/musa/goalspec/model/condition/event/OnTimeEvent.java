/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.condition.event;

import java.util.Date;
import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class OnTimeEvent extends Event {
    private Date start_data;

    public Date getStartData() {
        return start_data;
    }

    public void setStartData(Date start_data) {
        this.start_data = start_data;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        
        belief_base.add("event_occur_on_time("+cond_id+", date(0,0,0,0,1,30) )[pack("+namespace+")]");
    }
    
	@SuppressWarnings("deprecation")
	@Override
	public String getPredicate() {
		return "on_date("+start_data.getYear()+","+start_data.getMonth()+","+start_data.getDay()+","+start_data.getHours()+","+start_data.getMinutes()+","+start_data.getSeconds()+")";
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
