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
public class Specification extends Entity {
    private ManyGoalsEntity goals = new ManyGoalsEntity();

    public ManyGoalsEntity getGoals() {
        return goals;
    }

    public void setGoals(ManyGoalsEntity goals) {
        this.goals = goals;
    }

    
    
    public List getBeliefList() {
        LinkedList belief_base = new LinkedList();
        
        Iterator<AbstractGoalEntity> it = goals.getGoals().iterator();
        while (it.hasNext()) {
            AbstractGoalEntity goal = it.next();
            goal.addBelief(belief_base);
        }
        
        return belief_base;
    }
    
    
}
