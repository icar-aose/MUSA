/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.condition.event;

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
    
}
