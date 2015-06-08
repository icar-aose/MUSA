/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author luca
 */
public class ManyActorsEntity extends Entity {
    private List<ActorEntity> actor_list;

    public ManyActorsEntity() {
        this.actor_list = new LinkedList<ActorEntity>();
    }
    
    
    public List<ActorEntity> getActorList() {
        return actor_list;
    }

    public void setActorList(List<ActorEntity> actor_list) {
        this.actor_list = actor_list;
    }

    void addBeliefForSocialGoal(LinkedList belief_base,String process_name) {
        Iterator it = actor_list.iterator();
        while (it.hasNext()) {
            ActorEntity part = (ActorEntity) it.next();
            belief_base.add("participant("+process_name+", "+part.getActor()+")[pack("+process_name+")]");
        }
    }

}
