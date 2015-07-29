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
public class ManyGoalsEntity extends Entity {
    private List<AbstractGoalEntity> goals;

    public ManyGoalsEntity() {
        goals = new LinkedList<AbstractGoalEntity>();
    }

    public List<AbstractGoalEntity> getGoals() {
        return goals;
    }

    public void setGoals(List<AbstractGoalEntity> goals) {
        this.goals = goals;
    }
    
    
    
}
