/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model;

import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author luca
 */
public class ActorEntity extends Entity {
    private String actor;

    public String getActor() {
        return actor;
    }

    public void setActor(String actor) {
        this.actor = actor;
    }

    void addBeliefForSystemGoal(LinkedList belief_base, String process_name, String pack_name) {
        belief_base.add("goal_owner("+process_name+", "+actor+")[pack("+pack_name+")]");
    }

    
}
