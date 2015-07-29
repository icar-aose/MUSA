/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model;

import musa.goalspec.model.condition.Condition;
import musa.goalspec.model.state.State;

import java.util.LinkedList;
import java.util.List;


/**
 *
 * @author luca
 */
public abstract class AbstractGoalEntity extends Entity {
    private String name;
    private String namespace;
    private Condition triggering_condition;
    private State final_state;

    
    
    public AbstractGoalEntity() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNamespace() {
        return namespace;
    }

    public void setNamespace(String namespace) {
        this.namespace = namespace;
    }

    public Condition getTriggeringCondition() {
        return triggering_condition;
    }

    public void setTriggeringCondition(Condition triggering_condition) {
        this.triggering_condition = triggering_condition;
    }

    public State getFinalState() {
        return final_state;
    }

    public void setFinalState(State final_state) {
        this.final_state = final_state;
    }

    public abstract void addBelief(LinkedList belief_base);

    public abstract String getPredicate();
    
    
}
