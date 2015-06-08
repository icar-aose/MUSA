/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.condition;

import ids.goalspec.model.Entity;

import java.util.LinkedList;

/**
 *
 * @author luca
 */
abstract public class Condition extends Entity {
    private static int id_counter = 0;
    private int id;

    public Condition() {
        id = id_counter;
        id_counter++;
    }

    public String getId(String pre) {
        return pre+"_"+id+"e";
    }
    
    public abstract String getPredicate();
    public abstract String getPredicateWithinAND();
    public abstract String getPredicateWithinOR();
    
    public abstract void addBelief(LinkedList belief_base, String name, String namespace);
    
}
